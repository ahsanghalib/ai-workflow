#!/usr/bin/env python3
"""Run routing-only cases using Codex; expected routes remain grader-only."""

from __future__ import annotations
import argparse
from datetime import datetime, timezone
import hashlib
import importlib.util
import json
from pathlib import Path
import subprocess
import sys
import uuid

REPORT_SCRIPT = Path(__file__).resolve().parent / "eval-reports.py"
SPEC = importlib.util.spec_from_file_location("eval_reports", REPORT_SCRIPT)
reports = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(reports)
ROOT = Path(__file__).resolve().parents[2]
INSTRUCTION_SPEC = importlib.util.spec_from_file_location("evaluate_instructions", Path(__file__).resolve().parent / "evaluate-instructions.py")
INSTRUCTIONS = importlib.util.module_from_spec(INSTRUCTION_SPEC)
INSTRUCTION_SPEC.loader.exec_module(INSTRUCTIONS)


def build_prompt(query: str, skill_names: list[str]) -> str:
    return ("Select the primary shared skill for this user request, or ask a concise clarification if the request is ambiguous. "
            "Reply as JSON with keys primary_skill (string or null), clarification (string or null), and rationale (string). "
            "Do not use tools. Available skill names: " + ", ".join(skill_names) + "\n\nUser request:\n" + query)


def file_hash(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run(root: Path, run_id: str, model: str, effort: str, dry: bool, codex: str) -> Path:
    queries = json.loads((root / "evals/cases/routing/queries.json").read_text(encoding="utf-8"))["cases"]
    queries_path = root / "evals/cases/routing/queries.json"
    graders = json.loads((root / "evals/cases/routing/evals.json").read_text(encoding="utf-8"))["cases"]
    query_ids = [case.get("id") for case in queries]
    grader_ids = [case.get("id") for case in graders]
    if any(not isinstance(item, str) or not reports.SAFE_ID.fullmatch(item) for item in query_ids + grader_ids):
        raise ValueError("routing case IDs must be safe identifiers")
    if len(query_ids) != len(set(query_ids)) or len(grader_ids) != len(set(grader_ids)):
        raise ValueError("routing case IDs must be unique")
    by_id = {case["id"]: case for case in graders}
    if set(by_id) != {case["id"] for case in queries}:
        raise ValueError("routing prompt IDs and grader IDs differ")
    skill_names = sorted(p.parent.name for p in (root / "skills").glob("*/SKILL.md"))
    if not skill_names:
        raise ValueError("no skills found")
    run_dir = reports.create_run_directory(root / "evals/reports", run_id)
    cli_version = None
    if not dry:
        cli_version = subprocess.run([codex, "--version"], capture_output=True, text=True, timeout=15, check=True).stdout.strip()
    records = []
    for case in queries:
        expected = by_id[case["id"]]
        prompt = build_prompt(case["query"], skill_names)
        case_dir = run_dir / "routing" / case["id"]
        case_dir.mkdir(parents=True)
        (case_dir / "prompt.txt").write_text(prompt, encoding="utf-8")
        stdout, returncode = "", None
        tool_events, complete, failed = [], False, False
        if not dry:
            cmd = [codex, "exec", "--ephemeral", "--ignore-user-config", "--strict-config", "--sandbox", "read-only", "--skip-git-repo-check", "--json", "-c", "project_doc_max_bytes=0", "-c", "skills.bundled.enabled=false", "-c", "model_reasoning_effort=" + json.dumps(effort), "--model", model, "-"]
            proc = subprocess.run(cmd, input=prompt, capture_output=True, text=True, timeout=120, cwd=case_dir)
            stdout, returncode = proc.stdout, proc.returncode
            tool_events, complete, failed = INSTRUCTIONS.inspect_events(stdout)
            (case_dir / "events.jsonl").write_text(stdout, encoding="utf-8")
        record = {"schema_version": 1, "run_id": run_id, "suite": "routing-v1", "case_id": case["id"], "query": case["query"], "mode": "single", "model": model, "reasoning_effort": effort, "cli_version": cli_version, "prompt_snapshot": str((case_dir / "prompt.txt").relative_to(run_dir)), "sources": [{"path": "evals/cases/routing/queries.json", "sha256": file_hash(queries_path)}], "stdout": stdout, "returncode": returncode, "tool_events": tool_events, "observed_tool_invocation": bool(tool_events), "valid_for_grading": not dry and returncode == 0 and complete and not failed and not tool_events, "expected_route_exposed": False}
        (case_dir / "result.json").write_text(json.dumps(record, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
        assertions = [{"id": "route-selection", "criterion": "Select expected primary skill or ask for clarification."}]
        grade = {"schema_version": 1, "case_id": case["id"], "arm": "single", "reviewer": {"type": "human", "id": ""}, "assertions": [{"id": "route-selection", "status": "unverified", "evidence": "Awaiting human review."}], "unsafe_proposals": [], "safety_findings": []}
        (case_dir / "grade-template.json").write_text(json.dumps(grade, indent=2) + "\n", encoding="utf-8")
        (case_dir / "grader.json").write_text(json.dumps(expected, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
        records.append(record)
    summary = {"schema_version": 1, "run_id": run_id, "suite": "routing-v1", "suite_type": "routing", "model": model, "reasoning_effort": effort, "cli_version": cli_version, "dry_run": dry, "graded": False, "records": len(records), "valid_for_grading": sum(r["valid_for_grading"] for r in records), "limitations": "Routing is inferred from a proposed response; runtime skill loading and actual dispatch are not measured."}
    (run_dir / "summary.json").write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")
    reports.generate_run_report(run_dir, root / "evals/reports")
    return run_dir


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--model", choices=("gpt-6-luna",), required=True)
    parser.add_argument("--reasoning-effort", choices=("medium",), default="medium")
    parser.add_argument("--run-id", default=datetime.now(timezone.utc).strftime("routing-%Y%m%dT%H%M%SZ-") + uuid.uuid4().hex[:6])
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--codex", default="codex")
    parser.add_argument("--root", type=Path, default=ROOT)
    args = parser.parse_args(argv)
    try:
        print(run(args.root.resolve(), args.run_id, args.model, args.reasoning_effort, args.dry_run, args.codex))
        return 0
    except (OSError, ValueError, subprocess.SubprocessError, json.JSONDecodeError) as error:
        print(f"evaluate-routing: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
