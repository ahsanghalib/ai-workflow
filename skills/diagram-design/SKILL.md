---
name: diagram-design
description: Create generic branded architecture, IT current-state, flowchart, sequence, state machine, ER/data model, timeline, swimlane, quadrant, radar/spider, polar chart (polar/radial lollipop), loop/flywheel, nested, tree, org chart, layer stack, Venn, pyramid/funnel, treemap, bar, waterfall, line, Gantt and scatter charts, high-level, process, medallion, data flow, DP integration, DP security matrix, Sankey, fishbone, Wardley map, kanban, user journey, deployment, dependency graph, UML class, story map, or database schema diagrams as standalone HTML/SVG/PNG. Redraw .drawio/.drawio.png/.drawio.svg, Mermaid .mmd, or Excalidraw .excalidraw sources at a chosen size/detail; onboard brand tokens from a website; add semantic patterns, callouts, accessible motion, or sketchy/hand-drawn styling. For explicit Archify typed-IR or renderer requests, use archify when available and this skill only as the stated fallback.
license: MIT
metadata:
  version: "2.6"
  compatibility: harness-neutral; optional local Python/browser adapters
---

# Diagram Design

Create visual diagrams as self-contained HTML files with inline SVG and CSS, following an opinionated editorial design system.

Forty visual types. Semantic patterns describe behavior independently; type references describe layout. Details load from `references/` only when selected.

## Repository compatibility

This directory contains the portable references, templates, examples, icons,
import extractors, and self-check script needed by the shared workflow. The
core workflow is harness-neutral and can be used by any runtime that supports
`SKILL.md`.

The specialized geometry, motion, skin, documentation, and package verifiers
mentioned in some references are maintainer-checkout tools from the upstream
source and are not bundled here. Run a checker only when the file exists in
the resolved installation; otherwise use the bundled `scripts/self_check.py`
where applicable, perform the documented manual checks, and report the
specialized result as unverified.

Some detailed references retain optional adapter examples for particular
harnesses, browsers, or plugin command surfaces. Treat those examples as
conditional documentation only: use them only when the active harness exposes
the named capability and the user has authorized the operation. Otherwise use
the equivalent local file operation or the source-only fallback below. Never
install dependencies, fetch a website, or export an image merely because a
reference mentions it.

Generated files and temporary extraction output must stay inside the user's
authorized workspace. If a renderer, browser, or export dependency is
unavailable, deliver the self-contained HTML/SVG source and report that PNG or
visual verification was not run; do not claim an export or visual result.

When the user explicitly names Archify or requests its typed JSON and
renderer-backed delivery, use [`archify`](../archify/SKILL.md) when that runtime
or adapter is available. This skill remains the generic diagram fallback when
Archify is unavailable, and must state that no Archify schema, delivery, export,
or visual evidence was produced.

For diagram content/design principles, load
[`references/principles-and-style.md`](references/principles-and-style.md).
For pattern/type selection, final taste checks, or source import, load
[`references/workflow-selection-and-import.md`](references/workflow-selection-and-import.md).
For diagnostics, load [`references/doctor.md`](references/doctor.md). For
long-form block metadata and fidelity sidecars, load
[`references/export-registry.md`](references/export-registry.md).

---

## 0. First-time setup — style guide gate

**Before generating your first diagram in a new project, verify the effective style guide and onboarding destination.**

Don't silently ship default-skinned diagrams into a branded project.

First check the project root for a `.diagram-design` marker and resolve it per [`references/profiles.md`](references/profiles.md). A valid marker whose profile exists selects that file directly and skips this gate; `profile: default` also skips it. A malformed or missing-profile marker follows the visible failure handling in that reference. Never copy a marker-selected profile over the installed working copy.

If no marker selects a customized profile and the installed working copy still has the shipped defaults (paper `#f5f5f5`, ink `#2d3142`, accent `#eb6c36` atomic-tangerine), **pause and ask the user**:

> _"This is your first diagram in this project. The style guide is still at the default (neutral white-smoke + atomic-tangerine). Do you want to customize it to match your brand first? Options: (a) pull from your website URL, (b) extract from an installed skill, (c) extract from a local folder / design-system directory, (d) paste tokens manually, (e) proceed with the default for now, (f) load a saved client profile."_

Then branch per the matching section of [`references/onboarding.md`](references/onboarding.md); custom methods **(a)–(d)** must first select a valid named profile destination as described there. For **(f)** follow [`references/profiles.md`](references/profiles.md).

**Once the style guide has been customized** (or the user explicitly opted for default), skip this gate on subsequent runs. A leading profile header names the copied-in active profile. Without a header, any semantic-role value or typography family differing from shipped defaults means **custom-unsaved**: skip the gate and offer to save it as a profile. All-default tokens with no marker/header trigger the gate. Custom onboarding writes only the selected profile; it never edits the installed `references/style-guide.md`. To use the result as the markerless working copy, the user must explicitly invoke `load`/`switch` per `references/profiles.md`. At the end of every onboarding method, offer to save the result as a named client profile per `references/profiles.md`.

---

## 2. When to Use

Use for any of the 40 visual types (§3) when a reader will learn more from a visual than from prose, a table, or a bulleted list.

**Don't use for:**

- Quick Unicode diagrams → use **wiretext** when the active harness exposes a compatible capability; otherwise write a plain-text/Unicode fallback directly in the response.
- Lists of things → table or bullets.
- Simple before/after → table.
- One-shape "diagrams" → just write the sentence.

Before drawing, ask: _Would the reader learn more from this than from a well-written paragraph?_ If no, don't draw.

---

## 6. Core SVG Primitives

Universal building blocks. Type-specialized primitives (lifeline, activation bar, region) live in the relevant type reference linked in the guide. Optional primitives:

- Editorial callouts → [primitive-annotation.md](references/primitive-annotation.md)
- Hand-drawn variant → [primitive-sketchy.md](references/primitive-sketchy.md)
- Icon set (laptop, server, DB, K8s, Docker, AWS, …) → [primitive-icons.md](references/primitive-icons.md). Browse the gallery at [`assets/icons.html`](assets/icons.html).
- Terminal / CLI-window variant → [primitive-terminal.md](references/primitive-terminal.md)
- Optional explanatory motion → [animation.md](references/animation.md)

### Background

**Default: clean paper, no dot pattern.** Single `<rect>` filled with `paper`. Don't wrap the diagram in a secondary container background — the diagram sits directly on the page.

```svg
<rect width="100%" height="100%" fill="#f5f5f5"/>
```

**Optional: dotted paper variant.** When a long-form editorial diagram benefits from textured ground (essays, hero diagrams on a dedicated page), opt in by adding the `dots` pattern and a second rect:

```svg
<defs>
  <pattern id="dots" width="22" height="22" patternUnits="userSpaceOnUse">
    <circle cx="1" cy="1" r="0.9" fill="rgba(45,49,66,0.10)"/>
  </pattern>
</defs>
<rect width="100%" height="100%" fill="#f5f5f5"/>
<rect width="100%" height="100%" fill="url(#dots)" opacity="0.6"/>
```

Don't use the dot pattern when the diagram sits inside a product page, slide, or card — the texture compounds with surrounding chrome and reads as noise.

### Arrow markers (define all three, always)

```svg
<marker id="arrow" markerWidth="8" markerHeight="6" refX="7" refY="3" orient="auto">
  <polygon points="0 0, 8 3, 0 6" fill="#4f5d75"/>
</marker>
<marker id="arrow-accent" markerWidth="8" markerHeight="6" refX="7" refY="3" orient="auto">
  <polygon points="0 0, 8 3, 0 6" fill="#eb6c36"/>
</marker>
<marker id="arrow-link" markerWidth="8" markerHeight="6" refX="7" refY="3" orient="auto">
  <polygon points="0 0, 8 3, 0 6" fill="#2e5aa8"/>
</marker>
```

| Arrow     | Stroke                               | When                             |
| --------- | ------------------------------------ | -------------------------------- |
| Default   | muted `#4f5d75`                      | Internal, generic                |
| Accent    | coral `#eb6c36`                      | Primary / highlighted / headline |
| Link-blue | `#2e5aa8`                            | HTTP/API calls, external systems |
| Dashed    | `stroke-dasharray="5,4"` + any color | Optional, passive, return, async |

**Draw arrows before boxes** so z-order puts lines behind nodes.

### Mandatory connector rules

These six rules are **non-negotiable**. Run the pre-output checklist (§9) to verify before producing any diagram.

1. **Rounded right-angle (orthogonal) connectors are mandatory.** Never use diagonal `<line>` or straight slanted paths between nodes that don't share an x or y axis. Every bend must be a quarter-arc with `r=8` (or `r=6` minimum for tight layouts). See `references/type-architecture.md` for the elbow-path formula. Reserve plain straight `<line>` only for connections whose endpoints share the same x or y coordinate. Diagonal connectors are an automatic fail.

2. **Label-to-connector margin: 6–10px gap, always.** A label must never sit _on_ its arrow — the connector must remain visible. Place the label centered above (or beside, for vertical segments) the line with a **minimum 6px gap** between the bottom of the label's mask rect and the connector stroke. The opaque mask rect prevents the arrow from bleeding through, but the _visible_ gap between mask edge and line preserves the reader's ability to trace the connection. If the label is large enough that 6px feels cramped, push it to 8–10px. Never let the mask rect touch or overlap the stroke.

3. **No overlapping connectors.** Two connectors must never share the same stroke path, run parallel on top of each other, or be drawn on top of each other for any segment. When two orthogonal arrows must cross at a single point, apply the **bridge / hop** primitive (see `references/type-architecture.md` § Crossing arrows). When two arrows naturally want to overlap, offset their routing by ≥12px so each line is independently traceable. If you find yourself stacking connectors, redesign the layout — it means two nodes are too close, or the diagram is over budget (split into overview + detail).

4. **Shared edge → fan the attach points.** When two or more connectors enter or exit the _same edge_ of a box, each must have its own distinct attach point along that edge — **no two connectors may share a single point on a box**. Spread the attach points evenly along the edge with **≥12px** between adjacent points (8px minimum for very small boxes). Routing rules:
   - For N connectors on an edge of length L, attach point `k` (1..N) sits at offset `L * k / (N + 1)` from the edge's leading corner.
   - When the connectors fan out to destinations on different sides, route each one orthogonally from its own attach point — no merging strokes near the box.
   - When two parallel connectors run in the same direction, keep them ≥12px apart along their entire length, not just at the attach point. Each arrow must remain independently traceable end-to-end.

   No connector may hide another. If you can't tell two arrows apart at a glance, the layout has failed.

5. **A connector must not pass behind a box that isn't its source or destination — except when the box is geometrically unavoidable on a direct orthogonal path.** Reroute around intervening boxes by default. The only legitimate exception is when a cross-cutting node (e.g., a footer service, a horizontal layer bar) physically sits between the connector's source and destination on the only straight path between them. In that exception:
   - The stroke must be **dashed** (e.g., `stroke-dasharray="4,3"`) to signal "transit, not interaction" — it tells the reader the intervening box is not an endpoint.
   - The label sits at the **visible end** of the connector (typically near the source) so it doesn't fall behind the intervening box.
   - No marker (arrowhead) may land on the intervening box's edge — the marker resolves at the true destination only.

   When in doubt, reroute. The exception exists for the narrow case where rerouting is geometrically impossible, not as a shortcut to avoid layout work.

6. **A label mask must not overlap a node drawn after it.** Rule 2 keeps the label off its own connector; this one keeps it off the boxes. Because nodes are painted after labels, a mask that lands partly inside a node is covered by the node fill and the text renders as a fragment sitting on the node border. Place the label on a segment of the connector that runs through open canvas — for a connector leaving a node's right edge, that means clearing the node's `x + width` before the mask starts. A mask fully _inside_ a node is a badge chip and is fine; a mask overlapping a zone container is fine too, since zones are painted first. If a geometry verifier is available in the resolved installation, run it; otherwise perform this check manually and report geometry verification as unverified.

### Node box — full pattern

```svg
<!-- 1. Opaque paper mask — prevents arrows bleeding through transparent fills -->
<rect x="X" y="Y" width="W" height="H" rx="6" fill="#f5f5f5"/>
<!-- 2. Styled box -->
<rect x="X" y="Y" width="W" height="H" rx="6" fill="FILL" stroke="STROKE" stroke-width="1"/>
<!-- 3. Rectangular type tag (rx=2, NOT a pill) -->
<rect x="X+8" y="Y+6" width="28" height="12" rx="2" fill="transparent" stroke="STROKE@0.40" stroke-width="0.8"/>
<text x="X+22" y="Y+15" fill="STROKE@0.8" font-size="7" font-family="'Geist Mono', monospace"
      text-anchor="middle" letter-spacing="0.08em">API</text>
<!-- 4. Node name (Geist sans — human-readable) -->
<text x="CX" y="CY+2" fill="#2d3142" font-size="12" font-weight="600"
      font-family="'Geist', sans-serif" text-anchor="middle">Node Name</text>
<!-- 5. Technical sublabel (Geist Mono) -->
<text x="CX" y="CY+18" fill="#4f5d75" font-size="9"
      font-family="'Geist Mono', monospace" text-anchor="middle">tech:port</text>
```

### Arrow labels — always mask, always with margin

Every arrow label needs an opaque rect behind it. Without one it bleeds through the line. **And the label must sit with a visible gap above the connector — never on top of it.**

```svg
<!-- Mask sits 14px above the arrow (8px text height + 6px gap). Stroke is at ARROW_Y. -->
<rect x="MID_X-18" y="ARROW_Y-20" width="36" height="12" rx="2" fill="#f5f5f5"/>
<text x="MID_X" y="ARROW_Y-11" fill="#7a8399" font-size="8"
      font-family="'Geist Mono', monospace" text-anchor="middle" letter-spacing="0.06em">WRITE</text>
```

Rules:

- ≤14 characters, all-caps, centered on segment midpoint.
- **Mandatory 6–10px gap** between the bottom of the mask rect and the arrow stroke. The connector must remain visible — a label that hides its own arrow is a hard fail.
- Never `writing-mode` vertical.
- For vertical segments, place the label to the side (not on the line) with the same 6–10px horizontal gap.

### Legend — horizontal strip at the bottom

**Never put the legend inside the diagram area.** Place as a horizontal strip after all nodes, with a hairline separator:

```svg
<line x1="30" y1="LEGEND_Y-8" x2="VIEWBOX_W-30" y2="LEGEND_Y-8"
      stroke="rgba(45,49,66,0.10)" stroke-width="0.8"/>
<text x="30" y="LEGEND_Y+8" fill="#4f5d75" font-size="8" font-family="'Geist Mono', monospace"
      letter-spacing="0.14em">LEGEND</text>
<!-- Items — horizontal row, ~160px apart -->
```

Expand SVG `viewBox` height by ~60px.

---

## 7. Layout & Spacing

### 4px grid

**All values — font sizes, padding, node dimensions, gaps, x/y coords — divisible by 4.** Non-negotiable.

| Category             | Allowed values                                           |
| -------------------- | -------------------------------------------------------- |
| Font sizes           | 8, 12, 16, 20, 24, 28, 32, 40                            |
| Node width / height  | 80, 96, 112, 120, 128, 140, 144, 160, 180, 200, 240, 320 |
| x / y coordinates    | multiples of 4                                           |
| Gap between nodes    | 20, 24, 32, 40, 48                                       |
| Padding inside boxes | 8, 12, 16                                                |
| Border radius        | 4, 6, 8                                                  |

Exempt: stroke widths (0.8, 1, 1.2), opacity values, and the 22×22 dot-pattern.

Quick check: if a coordinate ends in 1, 2, 3, 5, 6, 7, 9 — fix it.

### Complexity budget (per diagram)

| Limit                                       | Rule                                                                                         |
| ------------------------------------------- | -------------------------------------------------------------------------------------------- |
| Max nodes                                   | 9                                                                                            |
| Max arrows / transitions                    | 12                                                                                           |
| Max coral elements                          | 2                                                                                            |
| Max lifelines (sequence)                    | 5                                                                                            |
| Max combined fragments (sequence)           | 1 (default); 2 only if each is single-region `opt`/`loop`                                    |
| Max `alt` regions (sequence)                | 2                                                                                            |
| Max fragment nesting (sequence)             | 1                                                                                            |
| Max lanes (swimlane)                        | 5                                                                                            |
| Max items (quadrant)                        | 12                                                                                           |
| Max entities (ER)                           | 8                                                                                            |
| Max nesting levels (nested)                 | 6                                                                                            |
| Max tree depth                              | 4                                                                                            |
| Max org chart depth                         | 4                                                                                            |
| Max org chart nodes                         | 12                                                                                           |
| Max layers (layer stack)                    | 6                                                                                            |
| Max circles (venn)                          | 3                                                                                            |
| Max layers (pyramid)                        | 6                                                                                            |
| Max radar axes                              | 5                                                                                            |
| Max radar series                            | 5                                                                                            |
| Max focal radar series                      | 1                                                                                            |
| Max polar categories                        | 8                                                                                            |
| Max polar series                            | 1                                                                                            |
| Max focal polar categories                  | 1                                                                                            |
| Max bars (bar chart)                        | 8                                                                                            |
| Max bars (waterfall)                        | 8 incl. totals, 1 subtotal                                                                   |
| Max cells (treemap)                         | 8                                                                                            |
| Max series (line chart)                     | 5                                                                                            |
| Max tasks (Gantt)                           | 12                                                                                           |
| Max points (scatter plot)                   | 30                                                                                           |
| Max stages / nodes / flows (sankey)         | 3 / 8 / 12                                                                                   |
| Max categories (fishbone)                   | 6 bones, 3 sub-causes each                                                                   |
| Max components / links (wardley)            | 9 / 12, 2 movement arrows                                                                    |
| Max columns / cards (kanban)                | 5 / 12 total, 4 per column                                                                   |
| Max stages / rows (user journey)            | 6 / 3, 2 pain markers                                                                        |
| Max zones / nodes / paths (deployment)      | 3 / 6 / 8, 9 artifacts                                                                       |
| Max nodes / edges (dependency)              | 9 / 14, 4 ranks, 1 cycle                                                                     |
| Max classes / relationships (UML class)     | 7 / 8, 5 members per compartment                                                             |
| Max activities / slices / cards (story map) | 5 / 3 / 12                                                                                   |
| Max tables / columns / FKs (db schema)      | 5 / 8 shown / 6                                                                              |
| Max annotation callouts                     | 2                                                                                            |
| Max motion (optional)                       | 8 steps, 12 marked items, 2 simultaneous items — see [animation.md](references/animation.md) |

If you exceed, split into two diagrams (overview + detail).

### Page layout

1. **Header** — eyebrow (Geist Mono), title (Instrument Serif), optional subtitle (Geist muted).
2. **Diagram container** — default: **clean, borderless**, no background — the SVG sits directly on the page paper. Optional _framed_ variant (for card-heavy layouts or hero placements): `paper-2` bg + 1px `rule` border + 8px radius + `1.5rem` padding + `overflow-x: auto`.
3. **Summary cards** — 2–3 col grid with _varied_ widths (e.g., `1.1fr 1fr 0.9fr`).
4. **Footer** — colophon in Geist Mono, muted, hairline top border.

---

## 8. Summary Card Pattern

Don't use 3 identical generic cards. Vary the treatment:

```html
<div class="card">
  <p class="eyebrow">SECTION LABEL</p>
  <div class="card-header">
    <span class="card-dot coral"></span>
    <h3>Card Title</h3>
  </div>
  <ul>
    <li>Item</li>
  </ul>
</div>
```

Rules:

- `background: #ffffff` (not paper — slight lift without shadow)
- `border: 1px solid rgba(45,49,66,0.12)`
- `border-radius: 6px`, `padding: 1.25rem`
- **No `box-shadow`**
- Card dots: 7px, `border-radius: 50%` — ink / muted / coral / link / soft variants

---

## 10. Templates & Variants

Every diagram ships in three variants (see `assets/`):

| Variant                                | File pattern                                            | When to use                                                                                                                         |
| -------------------------------------- | ------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| **Minimal light** (default)            | `assets/template.html`, `example-<type>.html`           | Screenshot-ready. Diagram + title. Warm paper.                                                                                      |
| **Minimal dark**                       | `assets/template-dark.html`, `example-<type>-dark.html` | Dark mode sites, slides, high-contrast posts.                                                                                       |
| **Full editorial**                     | `assets/template-full.html`, `example-<type>-full.html` | Long-form posts where the diagram is the hero.                                                                                      |
| **Consultant special** (quadrant only) | `example-quadrant-consultant.html`                      | BCG/McKinsey-style 2×2 scenario matrix. See [type-quadrant.md](references/type-quadrant.md#consultant-special-2x2-scenario-matrix). |

**Sketchy variant** (optional, applied to any of the above) — see [primitive-sketchy.md](references/primitive-sketchy.md). SVG turbulence filter wobbles strokes for a hand-drawn feel. Good for essays, not for technical docs.

**Terminal variant** (optional, replaces any of the above) — see [primitive-terminal.md](references/primitive-terminal.md). Start from `assets/template-terminal.html`; terminal examples use the `example-<type>-terminal.html` naming pattern. Charcoal CLI-window chrome, monospace, one red-orange accent. Good for dev-tool posts; not brand-tokenized, so skip it for onboarded output.

**Animation** (optional presentation layer) — see [animation.md](references/animation.md). Modes are `none` (default), `reveal`, `step`, and `loop`; motion never changes the static meaning or raises the complexity budget.

### To create a new diagram

1. Copy the variant closest to what you want (`assets/template.html` for minimal, `assets/template-full.html` for cards, `assets/template-motion.html` only when motion is requested).
2. If behavior is load-bearing, choose a semantic pattern; then load the matching type reference linked in the visual-type guide.
3. Replace the eyebrow, h1, and SVG body. Replace `[diagram-slug]` with the file slug and fill `<title>` / `<desc>`.
4. If motion is requested, load `animation.md`; otherwise keep mode `none` and no script.
5. Run the §9 taste gate.

---

## 12. Output

The format dial controls the user-facing primary artifact. HTML is always the
authoritative source built first; it is an intermediate when the requested
primary output is SVG or PNG, and it is retained only when the format includes
`html`:

| Format | Primary output | HTML source handling |
|---|---|---|
| `html` | one self-contained `.html` file | retain and deliver it; do not export automatically |
| `svg` | one `.svg` file containing the diagram `<svg>` | build HTML as the source, export SVG, and deliver SVG; retain HTML only if requested |
| `png` | one `.png` file of the diagram `<svg>` bounds | build HTML as the source, export PNG, and deliver PNG; retain HTML only if requested |
| `html+png` | the `.html` source and its `.png` export | retain and deliver both |

For `svg`, `png`, and `html+png`, load [`references/export.md`](references/export.md)
and run the export only because that format was explicitly requested. If the
approved renderer is unavailable, stop at the HTML source, report the requested
export as unfulfilled, and do not claim the primary non-HTML artifact exists.

Every retained HTML source is self-contained:

- Embedded CSS (remote Google Fonts are optional enhancement only; system
  fallbacks must remain usable offline)
- Inline SVG (no external images)
- Static by default; minimal inline JavaScript only for explicit animation controls/state

Renders correctly in any modern browser. Motion-enabled output must render its complete meaning without JavaScript; under `prefers-reduced-motion: reduce` it shows the complete static frame and hides/disables playback controls.

### Accessible SVG contract

Every diagram is an accessible figure by default:

1. Its `<svg>` carries `role="img"` and `aria-labelledby` naming the diagram's `<title>` and `<desc>`.
2. `<title>` is the first child of `<svg>`, before `<defs>`. Assistive technology may ignore a title placed later.
3. The IDs are prefixed per diagram and variant: `<slug>-title` / `<slug>-desc`, where the slug matches the file (`loop`, `loop-dark`, `loop-full`). Bare `title` / `desc` IDs are banned — two inline diagrams would otherwise share one ID, and the second could be announced with the first's name.
4. `<title>` is the short name of the subject — roughly the page `<h1>`, and about 60 characters or fewer.
5. `<desc>` is one sentence stating what the diagram shows in terms a reader needs without the image. Describe the content, not the geometry: “Org chart showing a command center routing work to specialist agents and escalation owners,” not “A box at the top with five boxes below it.” A shape-by-shape narration is worse than no useful description.
6. Decorative-only SVG, such as the specimen glyphs in `assets/icons.html`, carries `aria-hidden="true"` instead.

### Exporting to PNG / SVG

When the user asks to export, save, rasterize, or convert a generated diagram to `.png` or `.svg`, load [`references/export.md`](references/export.md) and follow the procedure there. Both formats deliver the diagram only (the `<svg>` node) — editorial wrappers like cards and headers are dropped by design. Export is **manual** — never produce export files unless the format or request explicitly asks for them.

For an imported diagram, pixel dimensions come from the `viewBox` × scale factor, so its size decision belongs to §11, not to export. For any diagram that needs an exact frame (an OG card or a slide image), see [`export.md` § Sizing the export](references/export.md).

## Routed diagram references
- [style guide](references/style-guide.md) — resolved skin tokens and typography.

After reading `workflow-selection-and-import.md`, open only the selected type, pattern, or import guide:

- [animation](references/animation.md)
- [import drawio](references/import-drawio.md)
- [import excalidraw](references/import-excalidraw.md)
- [import mermaid](references/import-mermaid.md)
- [output spec](references/output-spec.md)
- [primitive annotation](references/primitive-annotation.md)
- [semantic patterns](references/semantic-patterns.md)
- [type architecture](references/type-architecture.md)
- [type bar](references/type-bar.md)
- [type data flow](references/type-data-flow.md)
- [type db schema](references/type-db-schema.md)
- [type dependency](references/type-dependency.md)
- [type deployment](references/type-deployment.md)
- [type dp integration](references/type-dp-integration.md)
- [type dp security matrix](references/type-dp-security-matrix.md)
- [type er](references/type-er.md)
- [type fishbone](references/type-fishbone.md)
- [type flowchart](references/type-flowchart.md)
- [type gantt](references/type-gantt.md)
- [type high level](references/type-high-level.md)
- [type it state](references/type-it-state.md)
- [type journey](references/type-journey.md)
- [type kanban](references/type-kanban.md)
- [type layers](references/type-layers.md)
- [type line](references/type-line.md)
- [type loop](references/type-loop.md)
- [type medallion](references/type-medallion.md)
- [type nested](references/type-nested.md)
- [type org chart](references/type-org-chart.md)
- [type polar](references/type-polar.md)
- [type process](references/type-process.md)
- [type pyramid](references/type-pyramid.md)
- [type quadrant](references/type-quadrant.md)
- [type radar](references/type-radar.md)
- [type sankey](references/type-sankey.md)
- [type scatter](references/type-scatter.md)
- [type sequence](references/type-sequence.md)
- [type state](references/type-state.md)
- [type story map](references/type-story-map.md)
- [type swimlane](references/type-swimlane.md)
- [type timeline](references/type-timeline.md)
- [type tree](references/type-tree.md)
- [type treemap](references/type-treemap.md)
- [type uml class](references/type-uml-class.md)
- [type venn](references/type-venn.md)
- [type wardley](references/type-wardley.md)
- [type waterfall](references/type-waterfall.md)

Load [principles-and-style.md](references/principles-and-style.md) for density, anti-patterns, or design tokens.
