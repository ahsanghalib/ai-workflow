#!/usr/bin/env python3
"""Grade, summarize, and render local evaluation reports without dependencies."""

from __future__ import annotations

import argparse
from datetime import datetime, timezone
from html import escape
import json
from pathlib import Path, PurePosixPath
import re
import sys
from typing import Any

SCHEMA_VERSION = 1
SAFE_ID = re.compile(r"[A-Za-z0-9][A-Za-z0-9._-]{0,79}\Z")
STATUSES = {"pass", "fail", "unverified"}


def validate_grade(grade: dict[str, Any]) -> dict[str, Any]:
    if not isinstance(grade, dict) or grade.get("schema_version") != SCHEMA_VERSION:
        raise ValueError("grade schema_version must be 1")
    case_id = grade.get("case_id")
    assertions = grade.get("assertions")
    if not isinstance(case_id, str) or not SAFE_ID.fullmatch(case_id):
        raise ValueError("grade case_id must be a safe filename identifier")
    if grade.get("arm", grade.get("mode", "single")) not in {"baseline", "candidate", "single"}:
        raise ValueError("grade arm must be baseline, candidate, or single")
    if not isinstance(assertions, list) or not assertions:
        raise ValueError("grade requires at least one assertion")
    ids = set()
    for assertion in assertions:
        if not isinstance(assertion, dict):
            raise ValueError("assertion grades must be objects")
        assertion_id, status, evidence = assertion.get("id"), assertion.get("status"), assertion.get("evidence")
        if not isinstance(assertion_id, str) or not SAFE_ID.fullmatch(assertion_id) or assertion_id in ids:
            raise ValueError("assertion ids must be unique safe identifiers")
        ids.add(assertion_id)
        if status not in STATUSES or not isinstance(evidence, str) or not evidence.strip():
            raise ValueError("each assertion needs a valid status and evidence")
        if assertion.get("masked") and status != "unverified":
            raise ValueError("masked assertions must remain unverified")
    reviewer = grade.get("reviewer")
    if not isinstance(reviewer, dict) or reviewer.get("type") not in {"human", "deterministic"}:
        raise ValueError("reviewer.type must be human or deterministic")
    if not isinstance(reviewer.get("id"), str) or not reviewer["id"].strip():
        raise ValueError("reviewer.id must identify the reviewer or checker")
    findings = grade.get("safety_findings", [])
    if not isinstance(findings, list) or any(not isinstance(item, dict) for item in findings):
        raise ValueError("safety_findings must be a list of objects")
    grade.setdefault("unsafe_proposals", [])
    if not isinstance(grade["unsafe_proposals"], list):
        raise ValueError("unsafe_proposals must be a list")
    if any(not isinstance(item, (str, dict)) or (isinstance(item, str) and not item.strip()) for item in grade["unsafe_proposals"]):
        raise ValueError("unsafe proposals must include non-empty evidence descriptions")
    return grade


def case_status(grade: dict[str, Any] | None) -> str:
    if not grade:
        return "ungraded"
    assertions = grade.get("assertions")
    if not assertions:
        return "ungraded"
    if grade.get("safety_findings") or grade.get("unsafe_proposals") or any(a.get("status") == "fail" for a in assertions):
        return "fail"
    if any(a.get("status") == "unverified" for a in assertions):
        return "unverified"
    if all(a.get("status") == "pass" for a in assertions):
        return "pass"
    return "ungraded"


def _rate(passed: int, failed: int) -> dict[str, Any]:
    n = passed + failed
    return {"passed": passed, "failed": failed, "n": n,
            "percent": round(passed * 100 / n, 1) if n else None}


def aggregate(grades: list[dict[str, Any]]) -> dict[str, Any]:
    statuses = [case_status(g) for g in grades]
    passed_assertions = failed_assertions = unverified_assertions = 0
    for grade in grades:
        if not grade:
            continue
        for assertion in grade.get("assertions", []):
            status = assertion.get("status")
            if status == "pass":
                passed_assertions += 1
            elif status == "fail":
                failed_assertions += 1
            elif status == "unverified":
                unverified_assertions += 1
    fully_graded = sum(status in {"pass", "fail"} for status in statuses)
    fully_passed = sum(status == "pass" for status in statuses)
    by_mode = {}
    for mode in ("baseline", "candidate", "single"):
        selected = [grade for grade in grades if grade and grade.get("arm", grade.get("mode", "single")) == mode]
        if selected:
            case_pass = sum(case_status(g) == "pass" for g in selected)
            case_fail = sum(case_status(g) == "fail" for g in selected)
            by_mode[mode] = {
                "case_counts": {status: [case_status(g) for g in selected].count(status) for status in ("pass", "fail", "unverified", "ungraded")},
                "case_rate": _rate(case_pass, case_fail),
                "assertion_rate": _rate(sum(a.get("status") == "pass" for g in selected for a in g.get("assertions", [])), sum(a.get("status") == "fail" for g in selected for a in g.get("assertions", []))),
                "unverified_assertions": sum(a.get("status") == "unverified" for g in selected for a in g.get("assertions", [])),
            }
    return {
        "case_counts": {status: statuses.count(status) for status in ("pass", "fail", "unverified", "ungraded")},
        "case_rate": {"passed": fully_passed, "failed": fully_graded - fully_passed,
                      "n": fully_graded, "percent": round(fully_passed * 100 / fully_graded, 1) if fully_graded else None},
        "assertion_rate": _rate(passed_assertions, failed_assertions),
        "unverified_assertions": unverified_assertions,
        "safety_findings": sum(len(g.get("safety_findings", [])) for g in grades if g),
        "unsafe_proposals": sum(len(g.get("unsafe_proposals", [])) for g in grades if g),
        "by_mode": by_mode,
        "paired": {
            "eligible": len(
                {g["case_id"] for g in grades if g.get("arm") == "candidate" and case_status(g) in {"pass", "fail"}}
                & {g["case_id"] for g in grades if g.get("arm") == "baseline" and case_status(g) in {"pass", "fail"}}
            ),
            "baseline": sum(case_status(g) == "pass" for g in grades if g.get("arm") == "baseline"),
            "candidate": sum(case_status(g) == "pass" for g in grades if g.get("arm") == "candidate"),
        },
    }


def _e(value: Any) -> str:
    return escape(str(value if value is not None else ""), quote=True)


def _percentage(rate: dict[str, Any]) -> str:
    if rate["percent"] is None:
        return f"no score (n=0; passed={rate['passed']}, failed={rate['failed']})"
    return f"{rate['percent']:.1f}% ({rate['passed']}/{rate['n']}; n={rate['n']}; passed={rate['passed']}, failed={rate['failed']})"


def _safe_link(run_dir: Path, relative: str) -> str | None:
    if not isinstance(relative, str):
        return None
    path = PurePosixPath(relative)
    if path.is_absolute() or any(part in {"..", "."} for part in path.parts):
        return None
    target = (run_dir / Path(*path.parts)).resolve()
    try:
        target.relative_to(run_dir.resolve())
    except ValueError:
        return None
    if not target.is_file():
        return None
    return path.as_posix()


def _read_json_inside(root: Path, path: Path) -> Any:
    try:
        relative = path.relative_to(root).as_posix()
    except ValueError as error:
        raise ValueError("JSON input is outside its run/archive root") from error
    safe = _safe_link(root, relative)
    if safe is None:
        raise ValueError(f"JSON input is missing or escapes its root: {relative}")
    return json.loads((root / Path(*PurePosixPath(safe).parts)).read_text(encoding="utf-8"))


def render_report(data: dict[str, Any]) -> str:
    valid_run = data.get("valid_for_grading", True)
    grades = data.get("grades", []) if valid_run else []
    summary = aggregate(grades)
    pairs: dict[str, dict[str, dict[str, Any]]] = {}
    for record in data.get("records", []):
        pairs.setdefault(record.get("case_id", "unknown"), {})[record.get("mode", "single")] = record
    grade_by_case = {(grade["case_id"], grade.get("arm", grade.get("mode", "single"))): grade for grade in grades if isinstance(grade, dict) and grade.get("case_id")}
    output_modes = {mode for arms in pairs.values() for mode in arms}
    for mode in output_modes:
        mode_records = [arms[mode] for arms in pairs.values() if mode in arms]
        values = summary["by_mode"].setdefault(mode, {
            "case_counts": {"pass": 0, "fail": 0, "unverified": 0, "ungraded": 0},
            "case_rate": _rate(0, 0), "assertion_rate": _rate(0, 0), "unverified_assertions": 0,
        })
        graded_states = sum(values["case_counts"].values())
        values["case_counts"]["ungraded"] += max(0, len(mode_records) - graded_states)
    body = []
    case_ids = set(pairs) | {key[0] for key in grade_by_case}
    for case_id in sorted(case_ids):
        body.append(f'<section><h2>Case {_e(case_id)}</h2>')
        for arm_name in ("baseline", "candidate", "single"):
            grade = grade_by_case.get((case_id, arm_name))
            record = pairs.get(case_id, {}).get(arm_name)
            if not grade and not record:
                continue
            state = "invalid; not scored" if not valid_run else case_status(grade)
            body.append(f'<h3>{_e(arm_name.title())} grade — {_e(state)}</h3>')
            if not grade:
                continue
            body.append("<h3>Assertion grades</h3><ul>")
            for assertion in grade.get("assertions", []):
                body.append(f"<li><strong>{_e(assertion.get('id'))}: {_e(assertion.get('status'))}</strong> — {_e(assertion.get('evidence'))}</li>")
            body.append("</ul>")
            for category in ("unsafe_proposals", "safety_findings"):
                items = grade.get(category, [])
                if items:
                    body.append(f"<h3>{_e(category.replace('_', ' ').title())}</h3><ul>")
                    body.extend(f"<li>{_e(item)}</li>" for item in items)
                    body.append("</ul>")
            routing_record = pairs.get(case_id, {}).get("single", {})
            expected = routing_record.get("_expected_route")
            if expected and case_status(grade) in {"pass", "fail"}:
                body.append("<h3>Reviewed expected route</h3><pre>" + _e(json.dumps(expected, indent=2, ensure_ascii=False)) + "</pre>")
        arms = pairs.get(case_id, {})
        body.append('<div class="arms">')
        for arm in ("baseline", "candidate", "single"):
            record = arms.get(arm)
            if not record:
                continue
            body.append(f"<article><h3>{_e(arm.title())} output</h3><pre>{_e(record.get('stdout', record.get('response', 'No output saved.')))}</pre>")
            if record.get("prompt_sha256"):
                body.append(f"<p>Prompt SHA-256: <code>{_e(record['prompt_sha256'])}</code></p>")
            if record.get("suite") == "routing-v1":
                body.append(f"<p><strong>User request:</strong> {_e(record.get('query', 'not saved'))}</p>")
            run_root = data.get("_run_dir")
            if run_root:
                for link_field, label in (("prompt_snapshot", "Prompt snapshot"), ("_result_path", "Raw result record")):
                    link = _safe_link(Path(run_root), record.get(link_field))
                    if link:
                        body.append(f'<p><a href="{_e(link)}">{_e(label)}</a></p>')
                event_link = _safe_link(Path(run_root), record.get("_event_path"))
                if event_link:
                    body.append(f'<p><a href="{_e(event_link)}">Raw Codex event trace</a></p>')
            if record.get("sources"):
                body.append("<p>Sources: " + ", ".join(f"{_e(source.get('path'))} sha256 {_e(source.get('sha256'))}" for source in record["sources"]) + "</p>")
            body.append("</article>")
        body.append("</div></section>")
    expected_grade_keys = {(case_id, mode) for case_id, arms in pairs.items() for mode in arms}
    actual_grade_keys = set(grade_by_case)
    partial_grades = bool(actual_grade_keys) and not expected_grade_keys.issubset(actual_grade_keys)
    grade_label = "Dry run — not graded" if data.get("dry_run") else ("Invalid for grading" if not valid_run else ("Ungraded" if not grades else ("Partially graded pilot" if partial_grades else "Graded pilot")))
    paired = "baseline" in output_modes and "candidate" in output_modes
    paired_summary = "".join(f"<tr><th>{_e(mode.title())} assertion rate</th><td>{_e(_percentage(values['assertion_rate']))}</td></tr><tr><th>{_e(mode.title())} case rate</th><td>{_e(_percentage(values['case_rate']))}</td></tr>" for mode, values in summary["by_mode"].items())
    if paired:
        counts = summary["paired"]
        paired_summary += f"<tr><th>Matched pass cases</th><td>baseline {counts['baseline']}; candidate {counts['candidate']}; both fully graded {counts['eligible']}</td></tr>"
    for mode, values in summary["by_mode"].items():
        counts = values["case_counts"]
        paired_summary += f"<tr><th>{_e(mode.title())} case states</th><td>pass={counts['pass']}; fail={counts['fail']}; unverified={counts['unverified']}; ungraded={counts['ungraded']}</td></tr>"
    overall_rates = "" if paired else f"<tr><th>Case pass rate</th><td>{_e(_percentage(summary['case_rate']))}</td></tr><tr><th>Assertion pass rate</th><td>{_e(_percentage(summary['assertion_rate']))}</td></tr>"
    return """<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Eval report — """ + _e(data.get("run_id", "run")) + """</title><style>body{font:16px/1.5 system-ui,sans-serif;max-width:1100px;margin:2rem auto;padding:0 1rem;color:#18212b}table{border-collapse:collapse}th,td{border:1px solid #9aa7b2;padding:.5rem;text-align:left}section{border-top:2px solid #ccd4dc;padding:1rem 0}.arms{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:1rem}article{min-width:0}pre{white-space:pre-wrap;overflow-wrap:anywhere;background:#f2f5f7;padding:1rem}a{color:#0645ad}</style></head><body><main><h1>""" + grade_label + """ evaluation report</h1><dl><dt>Run</dt><dd>""" + _e(data.get("run_id")) + """</dd><dt>Model</dt><dd>""" + _e(data.get("model", "not recorded")) + """</dd><dt>Reasoning</dt><dd>""" + _e(data.get("reasoning_effort", "not recorded")) + """</dd><dt>Suite</dt><dd>""" + _e(data.get("suite", "not recorded")) + """</dd><dt>Limitations</dt><dd>""" + _e(data.get("context_limitations", "Small-sample task-specific pilot; not a standardized benchmark.")) + """</dd></dl><h2>Summary</h2><table><caption>Unverified items are excluded from rates</caption><tbody>""" + overall_rates + paired_summary + """<tr><th>Unverified assertions</th><td>""" + str(summary["unverified_assertions"]) + """</td></tr><tr><th>Unsafe proposals</th><td>""" + str(summary["unsafe_proposals"]) + """</td></tr><tr><th>Observed action findings</th><td>""" + str(summary["safety_findings"]) + """</td></tr></tbody></table><p>Proposal-only findings are not claims that an action occurred. System and host context may be inaccessible. No significance or general capability claim is made.</p>""" + ("<p>Raw outputs and grade records are shown below; use the catalog for archives.</p>" if pairs else "") + "".join(body) + "</main></body></html>"


def create_run_directory(results_root: Path, run_id: str) -> Path:
    if not isinstance(run_id, str) or not SAFE_ID.fullmatch(run_id):
        raise ValueError("run id must be a safe identifier")
    results_root.mkdir(parents=True, exist_ok=True)
    path = results_root / run_id
    path.mkdir(exist_ok=False)
    return path


def _archive_entries(root: Path) -> list[dict[str, str]]:
    manifest = root.parent / "archive-manifest.json"
    if not manifest.exists():
        manifest = root / "archive-manifest.json"
    if not manifest.exists():
        return []
    data = _read_json_inside(manifest.parent, manifest)
    if not isinstance(data, dict) or not isinstance(data.get("entries"), list):
        raise ValueError("archive manifest needs an entries list")
    entries = []
    seen = set()
    for item in data["entries"]:
        if not isinstance(item, dict):
            continue
        rel = item.get("path")
        label = item.get("label")
        title = item.get("title", rel)
        target = _safe_link(root, rel)
        if target is None or target in seen or not isinstance(label, str) or not isinstance(title, str):
            continue
        seen.add(target)
        entries.append({"path": target, "label": label, "title": title})
    return entries


def build_index(reports_root: Path) -> str:
    entries = _archive_entries(reports_root)
    seen = {entry["path"] for entry in entries}
    for summary_path in sorted(reports_root.glob("*/summary.json")):
        try:
            summary = _read_json_inside(reports_root, summary_path)
        except (OSError, ValueError, json.JSONDecodeError):
            continue
        run_dir = summary_path.parent
        report = run_dir / "report.html"
        for target in (report, summary_path):
            rel = target.relative_to(reports_root).as_posix()
            if target.is_file() and rel not in seen:
                state = summary.get("grade_state")
                status = "dry-run" if summary.get("dry_run") else ("invalid" if state == "invalid" or summary.get("valid_for_grading", summary.get("records", 0)) != summary.get("records", 0) else ("partially graded" if state == "partial" else ("ungraded" if summary.get("graded") is not True else "graded pilot")))
                entries.append({"path": rel, "label": status, "title": str(summary.get("run_id", run_dir.name)) + (" report" if target.name == "report.html" else " summary")})
                seen.add(rel)
    lines = ["<!doctype html><html lang=\"en\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><title>Evaluation report catalog</title><style>body{font:16px/1.5 system-ui,sans-serif;max-width:1000px;margin:2rem auto;padding:0 1rem}li{margin:.5rem 0}.label{color:#495866}</style></head><body><main><h1>Evaluation reports</h1><p>Local catalog of current runs and explicitly labeled archive evidence. Grades and reports are task-specific pilots, not standardized model benchmarks.</p><ul>"]
    for entry in entries:
        lines.append(f'<li><a href="{_e(entry["path"])}">{_e(entry["title"])}</a> <span class="label">({_e(entry["label"])})</span></li>')
    if not entries:
        lines.append("<li>No reports are indexed yet.</li>")
    lines.append("</ul></main></body></html>")
    return "\n".join(lines)


def load_run(run_dir: Path) -> dict[str, Any]:
    summary_path = run_dir / "summary.json"
    data = _read_json_inside(run_dir, summary_path)
    if not isinstance(data, dict) or data.get("schema_version") != SCHEMA_VERSION:
        raise ValueError("run summary must be an object with schema_version 1")
    data["_run_dir"] = str(run_dir.resolve())
    records = []
    seen_records = set()
    grades = []
    for result_path in sorted(run_dir.glob("**/result.json")):
        record = _read_json_inside(run_dir, result_path)
        if not isinstance(record, dict) or record.get("schema_version") != SCHEMA_VERSION:
            raise ValueError(f"result record must use schema_version 1: {result_path}")
        record["case_id"] = record.get("case_id") or result_path.parents[1].name
        record_mode = record.get("mode", "single")
        if record_mode not in {"baseline", "candidate", "single"}:
            raise ValueError(f"invalid result mode: {result_path}")
        record_key = (record["case_id"], record_mode)
        if record_key in seen_records:
            raise ValueError(f"duplicate result record for {record_key[0]}/{record_key[1]}")
        seen_records.add(record_key)
        record["_result_path"] = result_path.relative_to(run_dir).as_posix()
        event_path = result_path.with_name("events.jsonl")
        if event_path.is_file():
            record["_event_path"] = event_path.relative_to(run_dir).as_posix()
        grader_path = result_path.with_name("grader.json")
        if grader_path.is_file():
            grader = _read_json_inside(run_dir, grader_path)
            if isinstance(grader, dict) and ("expected_primary_skill" in grader or "expected_behavior" in grader):
                record["_expected_route"] = {key: grader[key] for key in ("expected_primary_skill", "expected_behavior", "acceptable_provisional_skills", "disallowed_primary_skills") if key in grader}
        records.append(record)
    data["valid_for_grading"] = bool(records) and all(record.get("valid_for_grading") is True for record in records)
    seen_grades = set()
    for grade_path in sorted(run_dir.glob("**/grade.json")):
        grade = validate_grade(_read_json_inside(run_dir, grade_path))
        arm = grade.get("arm", "single")
        key = (grade["case_id"], arm)
        if key in seen_grades:
            raise ValueError(f"duplicate grade record for {grade['case_id']}/{arm}")
        seen_grades.add(key)
        grader_path = grade_path.with_name("grader.json")
        if grader_path.is_file():
            expected = _read_json_inside(run_dir, grader_path)
            expected_assertions = expected.get("assertions")
            if expected_assertions and all(isinstance(item, dict) for item in expected_assertions):
                wanted = {item.get("id") for item in expected_assertions}
                actual = {item.get("id") for item in grade["assertions"]}
                if wanted != actual:
                    raise ValueError(f"grade assertion IDs do not match grader for {grade['case_id']}")
        grades.append(grade)
    data.update(records=records, grades=grades)
    return data


def generate_run_report(run_dir: Path, reports_root: Path) -> None:
    data = load_run(run_dir)
    (run_dir / "report.html").write_text(render_report(data), encoding="utf-8")
    summary = json.loads((run_dir / "summary.json").read_text(encoding="utf-8"))
    summary["graded"] = bool(data["grades"]) and data.get("valid_for_grading", True)
    result_keys = {(record.get("case_id"), record.get("mode", "single")) for record in data["records"]}
    grade_keys = {(grade.get("case_id"), grade.get("arm", "single")) for grade in data["grades"]}
    summary["grade_state"] = "dry-run" if summary.get("dry_run") else ("invalid" if not data.get("valid_for_grading", True) else ("ungraded" if not data["grades"] else ("partial" if not result_keys.issubset(grade_keys) else "graded")))
    summary["report_schema_version"] = SCHEMA_VERSION
    (run_dir / "summary.json").write_text(json.dumps(summary, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    (reports_root / "index.html").write_text(build_index(reports_root), encoding="utf-8")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--reports-root", type=Path, default=Path(__file__).resolve().parents[1] / "reports")
    parser.add_argument("--run", help="render a named run directory")
    parser.add_argument("--index-only", action="store_true")
    parser.add_argument("--validate-grades", action="store_true", help="validate every grade.json in a run")
    args = parser.parse_args(argv)
    root = args.reports_root.resolve()
    root.mkdir(parents=True, exist_ok=True)
    try:
        if args.run and not args.index_only:
            if not SAFE_ID.fullmatch(args.run):
                raise ValueError("unsafe run id")
            run_dir = (root / args.run).resolve()
            run_dir.relative_to(root)
            if args.validate_grades:
                data = load_run(run_dir)
                print(f"Validated {len(data['grades'])} grade records")
            generate_run_report(run_dir, root)
        (root / "index.html").write_text(build_index(root), encoding="utf-8")
        return 0
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as error:
        print(f"eval-reports: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
