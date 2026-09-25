#!/usr/bin/env python3
"""Render LinkedIn carousel pages from the one-time Figma SVG exports.

The script is intentionally offline after the SVG exports are present. It
keeps the Figma geometry and module backgrounds, removes sample copy, adds
source-grounded content from a JSON brief, and optionally converts the pages
to one PDF when CairoSVG and pypdf are available.
"""

from __future__ import annotations

import argparse
import json
import secrets
import shutil
import sys
import subprocess
import tempfile
import textwrap
from pathlib import Path
from typing import Any
from xml.etree import ElementTree as ET


SVG_NS = "http://www.w3.org/2000/svg"
ET.register_namespace("", SVG_NS)
NS = f"{{{SVG_NS}}}"

TEMPLATE_NAMES = {
    "cover": "linkedin-7-page-01-cover.svg",
    "chat": "linkedin-7-page-02-chat.svg",
    "table": "linkedin-7-page-03-table.svg",
    "grid-4": "linkedin-7-page-04-grid-4.svg",
    "steps-5": "linkedin-7-page-05-steps-5.svg",
    "diagram": "linkedin-7-page-06-diagram.svg",
    "closing": "linkedin-7-page-07-closing.svg",
}

FIVE_PAGE_ORDER = ["cover", "chat", "table", "grid-4", "closing"]
SEVEN_PAGE_ORDER = [
    "cover",
    "chat",
    "table",
    "grid-4",
    "steps-5",
    "diagram",
    "closing",
]

SCHEMES = {
    "Lime Signal": {
        "paper": "#F4F4EE",
        "surface": "#FEFEFA",
        "ink": "#161A1D",
        "muted": "#4B555C",
        "grid": "#D6DAD5",
        "primary": "#2A60D4",
        "accent": "#F1F36D",
    },
    "Blue Blueprint": {
        "paper": "#EEF3F7",
        "surface": "#FFFFFF",
        "ink": "#0E1B2A",
        "muted": "#526274",
        "grid": "#CFD8E2",
        "primary": "#2056A6",
        "accent": "#BFD5FF",
    },
    "Amber Paper": {
        "paper": "#FBF3E8",
        "surface": "#FFFDF8",
        "ink": "#211A17",
        "muted": "#6A5B51",
        "grid": "#DED0C2",
        "primary": "#B6532A",
        "accent": "#F3C47A",
    },
    "Violet Signal": {
        "paper": "#F4F1FA",
        "surface": "#FEFCFF",
        "ink": "#211A35",
        "muted": "#635D78",
        "grid": "#D8D1E8",
        "primary": "#6E57C7",
        "accent": "#D4CBFF",
    },
    "Mint Relay": {
        "paper": "#EDF7F1",
        "surface": "#FBFFFC",
        "ink": "#13251B",
        "muted": "#547064",
        "grid": "#CFDFD3",
        "primary": "#147A5B",
        "accent": "#AEE6C7",
    },
}

DEFAULT_COLOR_MAP = {
    "#F4F4EE": "paper",
    "#FEFEFA": "surface",
    "#161A1D": "ink",
    "#4B555C": "muted",
    "#D6DAD5": "grid",
    "#2A60D4": "primary",
    "#F1F36D": "accent",
    "#1E1E1E": "ink",
}

DYNAMIC_EXACT_IDS = {
    "Author name",
    "Author website",
    "Role",
    "Pagination",
    "Cover title",
    "Cover eyebrow",
    "Cover subtitle",
    "Cover thesis label",
    "Cover thesis placeholder",
    "Cover metadata",
    "Cover bottom note",
    "Chat eyebrow",
    "Chat heading",
    "Table eyebrow",
    "Table heading",
    "Table note",
    "Grid eyebrow",
    "Grid heading",
    "Grid note",
    "Steps eyebrow",
    "Steps heading",
    "Diagram eyebrow",
    "Diagram heading",
    "Diagram caption",
    "Closing eyebrow",
    "Closing heading",
    "Closing takeaway text",
    "Closing source label",
    "Closing source text",
    "Closing CTA",
}

DYNAMIC_PREFIXES = (
    "Tab label ",
    "Chat speaker ",
    "Chat message ",
    "Table header text ",
    "Table cell text ",
    "Grid-4 number ",
    "Grid-4 title ",
    "Grid-4 description ",
    "Steps-5 number ",
    "Steps-5 title ",
    "Steps-5 description ",
    "Diagram node label ",
    "Diagram node body ",
)


def template_dir() -> Path:
    return Path(__file__).resolve().parents[1] / "references" / "templates"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", type=Path, required=True, help="JSON carousel brief")
    parser.add_argument(
        "--output",
        type=Path,
        required=True,
        help="PDF path, or output directory when --format svg is used",
    )
    parser.add_argument("--format", choices=("svg", "pdf", "both"), default="both")
    parser.add_argument("--scheme", help="Scheme name, or random; default reuses metadata when present")
    parser.add_argument("--page-count", type=int, choices=(5, 7), help="Override the brief page count")
    parser.add_argument(
        "--overwrite",
        action="store_true",
        help="Replace existing generated output files or page SVGs",
    )
    return parser.parse_args()


def load_brief(path: Path) -> dict[str, Any]:
    with path.open(encoding="utf-8") as handle:
        brief = json.load(handle)
    if not isinstance(brief, dict):
        raise ValueError("The input JSON must contain an object.")
    return brief


def choose_scheme(brief: dict[str, Any], requested: str | None, metadata_path: Path) -> str:
    candidate = requested or brief.get("color_scheme") or brief.get("scheme")
    if (not candidate or str(candidate).lower() == "random") and metadata_path.exists():
        with metadata_path.open(encoding="utf-8") as handle:
            saved = json.load(handle)
        candidate = saved.get("color_scheme")
    if not candidate or str(candidate).lower() == "random":
        return secrets.choice(list(SCHEMES))
    if candidate not in SCHEMES:
        choices = ", ".join(SCHEMES)
        raise ValueError(f"Unknown color scheme {candidate!r}. Choose: {choices}")
    return str(candidate)


def output_targets(output: Path, output_format: str) -> list[Path]:
    targets = [output]
    if output_format == "both":
        targets.append(output.with_name(output.stem + "-pages"))
    targets.append(output.with_name(output.stem + ".meta.json"))
    return targets


def ensure_outputs_available(output: Path, output_format: str, overwrite: bool) -> None:
    if overwrite:
        return
    conflicts = [path for path in output_targets(output, output_format) if path.exists()]
    if conflicts:
        joined = ", ".join(str(path) for path in conflicts)
        raise FileExistsError(
            f"Generated output already exists: {joined}. Use --overwrite only when replacement is intentional."
        )


def prepare_svg_directory(directory: Path, overwrite: bool) -> None:
    if directory.exists() and not directory.is_dir():
        raise RuntimeError(f"SVG output target is not a directory: {directory}")
    directory.mkdir(parents=True, exist_ok=True)
    if overwrite:
        for page in directory.glob("page-*.svg"):
            if page.is_file() or page.is_symlink():
                page.unlink()


def default_pages(page_count: int) -> list[dict[str, Any]]:
    kinds = FIVE_PAGE_ORDER if page_count == 5 else SEVEN_PAGE_ORDER
    defaults: dict[str, dict[str, Any]] = {
        "cover": {
            "eyebrow": "TOPIC / YOUR CATEGORY",
            "title": "YOUR TITLE\nGOES HERE",
            "subtitle": "A short, specific promise that tells the reader why this carousel matters.",
            "thesis": "State the main idea in one clear sentence. Keep this block concise.",
            "meta": "TECHNICAL NOTE",
            "bottom": "SWIPE FOR THE SYSTEM →",
        },
        "chat": {
            "eyebrow": "CONVERSATION",
            "title": "Let the disagreement expose the idea.",
            "bubbles": [
                {"label": "QUESTION", "text": "What changes if we remove this assumption?"},
                {"label": "REPLY", "text": "The result becomes harder to trust."},
                {"label": "FOLLOW-UP", "text": "So the missing context is part of the output contract."},
                {"label": "TAKEAWAY", "text": "Make the hidden tradeoff visible."},
            ],
        },
        "table": {
            "eyebrow": "COMPARISON TABLE",
            "title": "Make the tradeoff readable at a glance.",
            "columns": ["CHOICE", "STRENGTH", "COST", "WHEN TO USE"],
            "rows": [
                ["FAST PATH", "Easy to explain", "Less nuance", "Early exploration"],
                ["CONTROLLED", "Clear constraints", "More setup", "Production systems"],
                ["ADAPTIVE", "Handles change", "Harder to test", "Uncertain inputs"],
                ["HUMAN CHECK", "Trustworthy edge cases", "Needs review", "High-impact output"],
            ],
            "note": "Use the source ledger to support every factual comparison.",
        },
        "grid-4": {
            "eyebrow": "FOUR CHECKS",
            "title": "Four boxes. One decision the reader can make.",
            "cards": [
                {"number": "01", "title": "SIGNAL", "text": "What should be noticed first?"},
                {"number": "02", "title": "CONTEXT", "text": "What information changes the reading?"},
                {"number": "03", "title": "TRADEOFF", "text": "What becomes harder or more expensive?"},
                {"number": "04", "title": "TEST", "text": "What can be checked before shipping?"},
            ],
        },
        "steps-5": {
            "eyebrow": "FIVE STEPS",
            "title": "Turn the method into an ordered path.",
            "steps": [
                {"number": "01", "title": "NAME THE SIGNAL", "text": "Start with the observable problem."},
                {"number": "02", "title": "SET THE CONTEXT", "text": "State what the reader needs to know."},
                {"number": "03", "title": "SHOW THE MECHANISM", "text": "Make the moving parts explicit."},
                {"number": "04", "title": "CHECK THE TRADEOFF", "text": "Name what the solution does not solve."},
                {"number": "05", "title": "LEAVE A TEST", "text": "Give the reader a next action."},
            ],
        },
        "diagram": {
            "eyebrow": "SYSTEM MAP",
            "title": "Show the mechanism behind the claim.",
            "nodes": [
                {"label": "INPUT", "text": "source"},
                {"label": "CONTEXT", "text": "retrieval"},
                {"label": "DECISION", "text": "evaluation"},
                {"label": "OUTPUT", "text": "response"},
            ],
            "caption": "READ LEFT TO RIGHT / REPLACE WITH APPROVED MODEL",
        },
        "closing": {
            "eyebrow": "TAKEAWAY",
            "title": "Make the final slide useful on its own.",
            "takeaway": "One memorable sentence the reader can repeat.",
            "source": "Add the evidence link, caveat, or approved question that completes the post.",
            "cta": "SAVE THIS  •  SHARE WITH YOUR TEAM  •  DISCUSS BELOW",
        },
    }
    return [{"template": kind, **defaults[kind]} for kind in kinds]


def ensure_pages(brief: dict[str, Any], page_count_override: int | None) -> tuple[int, list[dict[str, Any]]]:
    page_count = page_count_override or int(brief.get("page_count", 7))
    if page_count not in (5, 7):
        raise ValueError("page_count must be 5 or 7.")
    pages = brief.get("pages") or default_pages(page_count)
    if not isinstance(pages, list) or len(pages) != page_count:
        raise ValueError(f"Expected exactly {page_count} page objects.")
    normalized: list[dict[str, Any]] = []
    for index, page in enumerate(pages):
        if not isinstance(page, dict):
            raise ValueError(f"Page {index + 1} must be an object.")
        item = dict(page)
        item.setdefault("template", (FIVE_PAGE_ORDER if page_count == 5 else SEVEN_PAGE_ORDER)[index])
        if item["template"] not in TEMPLATE_NAMES:
            raise ValueError(f"Unsupported page template: {item['template']}")
        normalized.append(item)
    return page_count, normalized


def is_dynamic(identifier: str) -> bool:
    return identifier in DYNAMIC_EXACT_IDS or identifier.startswith(DYNAMIC_PREFIXES)


def strip_dynamic_copy(root: ET.Element) -> None:
    for parent in root.iter():
        for child in list(parent):
            identifier = child.attrib.get("id", "")
            if is_dynamic(identifier):
                parent.remove(child)
            else:
                strip_dynamic_copy(child)


def strip_figma_tabs(root: ET.Element) -> None:
    for parent in root.iter():
        for child in list(parent):
            identifier = child.attrib.get("id", "")
            if identifier.startswith("Tab ") and identifier != "Tab strip":
                parent.remove(child)


def replace_default_colors(svg_text: str, scheme: dict[str, str]) -> str:
    for source, role in DEFAULT_COLOR_MAP.items():
        svg_text = svg_text.replace(source, scheme[role])
    return svg_text


def wrap_lines(value: str, width: float, size: float) -> list[str]:
    max_chars = max(8, int(width / max(size * 0.52, 1)))
    lines: list[str] = []
    for paragraph in str(value).splitlines() or [""]:
        lines.extend(textwrap.wrap(paragraph, width=max_chars) or [""])
    return lines


def add_text(
    root: ET.Element,
    value: str,
    x: float,
    baseline: float,
    width: float,
    size: float,
    color: str,
    *,
    weight: int = 400,
    line_height: float | None = None,
    anchor: str = "start",
    identifier: str | None = None,
) -> None:
    element = ET.SubElement(
        root,
        f"{NS}text",
        {
            "id": identifier or "generated-copy",
            "x": f"{x:g}",
            "y": f"{baseline:g}",
            "fill": color,
            "font-family": "Inter, DejaVu Sans, sans-serif",
            "font-size": f"{size:g}px",
            "font-weight": str(weight),
            "text-anchor": anchor,
        },
    )
    lines = wrap_lines(value, width, size)
    leading = line_height or size * 1.18
    for index, line in enumerate(lines):
        tspan = ET.SubElement(
            element,
            f"{NS}tspan",
            {"x": f"{x:g}", "dy": "0" if index == 0 else f"{leading:g}"},
        )
        tspan.text = line


def add_rect(root: ET.Element, x: float, y: float, width: float, height: float, fill: str, stroke: str) -> None:
    ET.SubElement(
        root,
        f"{NS}rect",
        {
            "x": f"{x:g}",
            "y": f"{y:g}",
            "width": f"{width:g}",
            "height": f"{height:g}",
            "fill": fill,
            "stroke": stroke,
        },
    )


def add_tabs(root: ET.Element, page_index: int, page_count: int, scheme: dict[str, str]) -> None:
    x0, y, total_width, height = 54.5, 125.5, 972.0, 39.0
    slot_width = total_width / page_count
    for index in range(page_count):
        active = index == page_index
        left = x0 + index * slot_width
        add_rect(
            root,
            left,
            y,
            slot_width,
            height,
            scheme["ink"] if active else scheme["paper"],
            scheme["ink"] if active else scheme["grid"],
        )
        ordinal = "1st" if index == 0 else "2nd" if index == 1 else "3rd" if index == 2 else f"{index + 1}th"
        add_text(
            root,
            ordinal,
            left + 14,
            y + 25,
            slot_width - 28,
            13,
            scheme["surface"] if active else scheme["muted"],
            weight=600,
            identifier=f"generated-tab-{index + 1}",
        )


def add_chrome(root: ET.Element, page_index: int, page_count: int, scheme: dict[str, str]) -> None:
    add_text(root, "M. Ahsan Izhar", 26, 43, 430, 18, scheme["ink"], weight=600, identifier="generated-author")
    add_text(root, "ahsanizhar.com", 1054, 43, 264, 18, scheme["primary"], weight=500, anchor="end", identifier="generated-domain")
    add_text(root, "Senior Software Engineer", 26, 1296, 460, 16, scheme["muted"], weight=500, identifier="generated-role")
    add_text(root, f"{page_index + 1}/{page_count}", 1054, 1294, 134, 18, scheme["ink"], weight=600, anchor="end", identifier="generated-pagination")
    add_tabs(root, page_index, page_count, scheme)


def add_cover_content(root: ET.Element, page: dict[str, Any], scheme: dict[str, str]) -> None:
    add_text(root, page.get("eyebrow", "TOPIC / YOUR CATEGORY"), 56, 272, 500, 14, scheme["primary"], weight=600, identifier="generated-cover-eyebrow")
    add_text(root, page.get("title", "YOUR TITLE\nGOES HERE"), 56, 354, 760, 58, scheme["ink"], weight=700, line_height=68, identifier="generated-cover-title")
    add_text(root, page.get("subtitle", ""), 56, 518, 670, 24, scheme["muted"], line_height=34, identifier="generated-cover-subtitle")
    add_text(root, "THESIS / ONE SENTENCE", 82, 640, 440, 14, scheme["muted"], weight=600, identifier="generated-cover-label")
    add_text(root, page.get("thesis", ""), 82, 690, 690, 30, scheme["ink"], weight=500, line_height=40, identifier="generated-cover-thesis")
    add_text(root, page.get("meta", "TECHNICAL NOTE"), 82, 782, 700, 14, scheme["primary"], weight=600, identifier="generated-cover-meta")
    add_text(root, page.get("bottom", "SWIPE FOR THE SYSTEM →"), 56, 1194, 700, 14, scheme["ink"], weight=600, identifier="generated-cover-bottom")


def add_chat_content(root: ET.Element, page: dict[str, Any], scheme: dict[str, str]) -> None:
    add_text(root, page.get("eyebrow", "CONVERSATION"), 56, 272, 600, 14, scheme["primary"], weight=600, identifier="generated-chat-eyebrow")
    add_text(root, page.get("title", "Let the disagreement expose the idea."), 56, 338, 820, 42, scheme["ink"], weight=700, line_height=52, identifier="generated-chat-title")
    bubbles = page.get("bubbles", [])
    for index, bubble in enumerate(bubbles[:4]):
        y = 418 + index * 142
        x = 56 if index % 2 == 0 else 214
        color = scheme["surface"] if index < 3 else scheme["ink"]
        add_text(root, bubble.get("label", "NOTE"), x + 22, y + 34, 300, 14, scheme["accent"] if index == 3 else scheme["primary"], weight=600, identifier=f"generated-chat-label-{index}")
        add_text(root, bubble.get("text", ""), x + 22, y + 72, 720, 20, scheme["surface"] if index == 3 else scheme["ink"], weight=600 if index == 3 else 400, line_height=28, identifier=f"generated-chat-text-{index}")


def add_table_content(root: ET.Element, page: dict[str, Any], scheme: dict[str, str]) -> None:
    add_text(root, page.get("eyebrow", "COMPARISON TABLE"), 56, 272, 600, 14, scheme["primary"], weight=600, identifier="generated-table-eyebrow")
    add_text(root, page.get("title", "Make the tradeoff readable at a glance."), 56, 338, 820, 42, scheme["ink"], weight=700, line_height=52, identifier="generated-table-title")
    columns = page.get("columns", [])
    rows = page.get("rows", [])
    widths = [210, 252, 210, 296]
    x = 56
    for index, column in enumerate(columns[:4]):
        add_text(root, str(column), x + 16, 460, widths[index] - 32, 13, scheme["surface"], weight=600, identifier=f"generated-table-header-{index}")
        x += widths[index]
    for row_index, row in enumerate(rows[:4]):
        x = 56
        baseline = 532 + row_index * 112
        for column_index, cell in enumerate(row[:4]):
            add_text(root, str(cell), x + 16, baseline, widths[column_index] - 32, 15 if column_index == 0 else 16, scheme["primary"] if column_index == 0 else scheme["ink"], weight=600 if column_index == 0 else 400, line_height=23, identifier=f"generated-table-cell-{row_index}-{column_index}")
            x += widths[column_index]
    add_text(root, page.get("note", ""), 56, 1068, 820, 18, scheme["muted"], line_height=26, identifier="generated-table-note")


def add_grid_content(root: ET.Element, page: dict[str, Any], scheme: dict[str, str]) -> None:
    add_text(root, page.get("eyebrow", "FOUR CHECKS"), 56, 272, 600, 14, scheme["primary"], weight=600, identifier="generated-grid-eyebrow")
    add_text(root, page.get("title", "Four boxes. One decision the reader can make."), 56, 338, 820, 42, scheme["ink"], weight=700, line_height=52, identifier="generated-grid-title")
    for index, card in enumerate(page.get("cards", [])[:4]):
        x = 56 + (index % 2) * 494
        y = 420 + (index // 2) * 238
        add_text(root, card.get("number", f"0{index + 1}"), x + 22, y + 54, 64, 26, scheme["primary"], weight=700, identifier=f"generated-grid-number-{index}")
        add_text(root, card.get("title", "CARD"), x + 22, y + 104, 410, 14, scheme["ink"], weight=600, identifier=f"generated-grid-title-{index}")
        add_text(root, card.get("text", ""), x + 22, y + 152, 410, 18, scheme["muted"], line_height=26, identifier=f"generated-grid-text-{index}")
    add_text(root, "FOUR BOXES / KEEP EACH ONE SCANNABLE", 56, 944, 820, 14, scheme["primary"], weight=600, identifier="generated-grid-note")


def add_steps_content(root: ET.Element, page: dict[str, Any], scheme: dict[str, str]) -> None:
    add_text(root, page.get("eyebrow", "FIVE STEPS"), 56, 272, 600, 14, scheme["primary"], weight=600, identifier="generated-steps-eyebrow")
    add_text(root, page.get("title", "Turn the method into an ordered path."), 56, 338, 820, 42, scheme["ink"], weight=700, line_height=52, identifier="generated-steps-title")
    for index, step in enumerate(page.get("steps", [])[:5]):
        y = 420 + index * 112
        add_text(root, step.get("number", f"0{index + 1}"), 76, y + 54, 58, 24, scheme["primary"], weight=700, identifier=f"generated-steps-number-{index}")
        add_text(root, step.get("title", "STEP"), 164, y + 46, 360, 14, scheme["ink"], weight=600, identifier=f"generated-steps-title-{index}")
        add_text(root, step.get("text", ""), 164, y + 74, 780, 17, scheme["muted"], line_height=23, identifier=f"generated-steps-text-{index}")


def add_diagram_content(root: ET.Element, page: dict[str, Any], scheme: dict[str, str]) -> None:
    add_text(root, page.get("eyebrow", "SYSTEM MAP"), 56, 272, 600, 14, scheme["primary"], weight=600, identifier="generated-diagram-eyebrow")
    add_text(root, page.get("title", "Show the mechanism behind the claim."), 56, 338, 820, 42, scheme["ink"], weight=700, line_height=52, identifier="generated-diagram-title")
    for index, node in enumerate(page.get("nodes", [])[:4]):
        x = 82 + index * 236
        add_text(root, node.get("label", "NODE"), x + 16, 608, 156, 14, scheme["ink"], weight=600, identifier=f"generated-diagram-label-{index}")
        add_text(root, node.get("text", ""), x + 16, 646, 156, 18, scheme["muted"], line_height=24, identifier=f"generated-diagram-text-{index}")
    add_text(root, page.get("caption", "READ LEFT TO RIGHT / REPLACE WITH APPROVED MODEL"), 82, 774, 850, 14, scheme["muted"], weight=600, identifier="generated-diagram-caption")


def add_closing_content(root: ET.Element, page: dict[str, Any], scheme: dict[str, str]) -> None:
    add_text(root, page.get("eyebrow", "TAKEAWAY"), 56, 272, 600, 14, scheme["primary"], weight=600, identifier="generated-closing-eyebrow")
    add_text(root, page.get("title", "Make the final slide useful on its own."), 56, 338, 820, 42, scheme["ink"], weight=700, line_height=52, identifier="generated-closing-title")
    add_text(root, page.get("takeaway", ""), 82, 524, 890, 30, scheme["ink"], weight=600, line_height=40, identifier="generated-closing-takeaway")
    add_text(root, "SOURCE / LIMITATION / DISCUSSION", 80, 730, 860, 14, scheme["muted"], weight=600, identifier="generated-closing-source-label")
    add_text(root, page.get("source", ""), 80, 766, 880, 20, scheme["muted"], line_height=30, identifier="generated-closing-source")
    add_text(root, page.get("cta", ""), 56, 944, 900, 14, scheme["primary"], weight=600, identifier="generated-closing-cta")


def render_page(template_path: Path, page: dict[str, Any], page_index: int, page_count: int, scheme: dict[str, str]) -> str:
    raw = template_path.read_text(encoding="utf-8")
    root = ET.fromstring(replace_default_colors(raw, scheme))
    strip_dynamic_copy(root)
    strip_figma_tabs(root)
    add_chrome(root, page_index, page_count, scheme)

    kind = page["template"]
    if kind == "cover":
        add_cover_content(root, page, scheme)
    elif kind == "chat":
        add_chat_content(root, page, scheme)
    elif kind == "table":
        add_table_content(root, page, scheme)
    elif kind == "grid-4":
        add_grid_content(root, page, scheme)
    elif kind == "steps-5":
        add_steps_content(root, page, scheme)
    elif kind == "diagram":
        add_diagram_content(root, page, scheme)
    elif kind == "closing":
        add_closing_content(root, page, scheme)
    else:
        raise ValueError(f"Unsupported template: {kind}")
    return ET.tostring(root, encoding="unicode")


def write_pdf(svg_pages: list[str], output: Path) -> None:
    try:
        import cairosvg  # type: ignore
        from pypdf import PdfReader, PdfWriter  # type: ignore
    except ImportError:
        cairosvg = None
        PdfReader = None
        PdfWriter = None

    if cairosvg is None or PdfReader is None or PdfWriter is None:
        rsvg = shutil.which("rsvg-convert")
        pdfunite = shutil.which("pdfunite")
        if not rsvg or not pdfunite:
            raise RuntimeError(
                "PDF output requires cairosvg+pypdf or the rsvg-convert+pdfunite "
                "system tools; use --format svg when neither is available."
            )
        with tempfile.TemporaryDirectory(prefix="linkedin-carousel-") as temporary_dir:
            temporary_root = Path(temporary_dir)
            page_paths: list[Path] = []
            for index, svg in enumerate(svg_pages):
                svg_path = temporary_root / f"page-{index + 1}.svg"
                pdf_path = temporary_root / f"page-{index + 1}.pdf"
                svg_path.write_text(svg, encoding="utf-8")
                subprocess.run(
                    [rsvg, "--format", "pdf", "--output", str(pdf_path), str(svg_path)],
                    check=True,
                )
                page_paths.append(pdf_path)
            subprocess.run(
                [pdfunite, *(str(page) for page in page_paths), str(output)],
                check=True,
            )
        return

    temporary_pdfs: list[Path] = []
    try:
        for index, svg in enumerate(svg_pages):
            temporary = output.with_name(f".{output.stem}-page-{index + 1}.pdf")
            cairosvg.svg2pdf(bytestring=svg.encode("utf-8"), write_to=str(temporary))
            temporary_pdfs.append(temporary)
        writer = PdfWriter()
        for temporary in temporary_pdfs:
            reader = PdfReader(str(temporary))
            for page in reader.pages:
                writer.add_page(page)
        with output.open("wb") as handle:
            writer.write(handle)
    finally:
        for temporary in temporary_pdfs:
            temporary.unlink(missing_ok=True)


def main() -> int:
    args = parse_args()
    brief = load_brief(args.input)
    page_count, pages = ensure_pages(brief, args.page_count)
    metadata_path = args.output.with_name(args.output.stem + ".meta.json")
    ensure_outputs_available(args.output, args.format, args.overwrite)
    scheme_name = choose_scheme(brief, args.scheme, metadata_path)
    scheme = SCHEMES[scheme_name]
    templates = template_dir()
    svg_pages: list[str] = []
    for index, page in enumerate(pages):
        template_path = templates / TEMPLATE_NAMES[page["template"]]
        if not template_path.exists():
            raise FileNotFoundError(f"Missing exported template: {template_path}")
        svg_pages.append(render_page(template_path, page, index, page_count, scheme))

    if args.format in ("svg", "both"):
        svg_dir = args.output if args.format == "svg" else args.output.with_name(args.output.stem + "-pages")
        prepare_svg_directory(svg_dir, args.overwrite)
        for index, svg in enumerate(svg_pages):
            (svg_dir / f"page-{index + 1:02d}.svg").write_text(svg, encoding="utf-8")

    if args.format in ("pdf", "both"):
        args.output.parent.mkdir(parents=True, exist_ok=True)
        write_pdf(svg_pages, args.output)

    metadata = {
        "page_count": page_count,
        "color_scheme": scheme_name,
        "templates": [page["template"] for page in pages],
        "source": args.input.name,
    }
    metadata_path.parent.mkdir(parents=True, exist_ok=True)
    metadata_path.write_text(json.dumps(metadata, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"output": str(args.output), **metadata}, indent=2))
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (FileExistsError, FileNotFoundError, ValueError, RuntimeError) as error:
        print(f"render_carousel: error: {error}", file=sys.stderr)
        raise SystemExit(2)
