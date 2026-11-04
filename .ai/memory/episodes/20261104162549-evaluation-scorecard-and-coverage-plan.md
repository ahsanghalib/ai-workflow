# Evaluation scorecard and coverage plan

Date: 2026-11-04
Feature: evals

## Context

The repository's eval artifacts were centralized under `evals/`. The current
Codex-only runner prepares paired proposal responses for six synthetic cases,
but has no grade-record workflow or HTML scorecard. Routing cases are stored
separately and do not have a tracked active runner.

## Goal

Plan a local, auditable evaluation program that starts with GLOBAL_AGENTS.md and produces evidence-based HTML reports.

## Why

The user wants to understand percentages and benchmarks, inspect reports in
HTML, and build a prioritized eval backlog beginning with `GLOBAL_AGENTS.md`.
The plan must distinguish a completed model call from a graded pass and avoid
claiming that a small local suite is an industry benchmark.

## Outcome

Centralized eval artifacts under evals/, created and reviewed draft SPEC-0001, and preserved the plan pending explicit approval.

## Current State

Draft SPEC-0001 is ready for explicit user approval. No implementation or new
model evaluation has started. Prior run artifacts remain under ignored
`evals/reports/archive/`.

## Important Findings

- OpenAI guidance distinguishes public model benchmarks from task-specific
  application evals; it recommends task-specific cases, human calibration,
  and metrics alongside judgment. The hosted Evals platform is scheduled to
  close 2026-11-30, so local artifacts should remain usable without it.
- The current runner injects shared guardrails into both arms. A global-rule
  suite must audit those common prompts for policy leakage before comparing
  `GLOBAL_AGENTS.md`.
- A proposal-only response cannot prove that an external action was actually
  executed. Report unsafe proposals separately from observed action violations.
- Percentage reports need explicit numerators, denominators, unverified counts,
  model settings, source hashes, and small-sample caveats.

## Decisions

- Keep reports local and ignored; JSON traces and grade records remain the
  source data, with one self-contained offline HTML report for review.
- Start with six proposal-only global-instruction scenarios, then prioritize
  other skills by impact, frequency, fragility, and observability instead of
  requiring shallow evals for all 56.
- Use deterministic checks and human review in v1; do not add an LLM grader.
- Use Codex with GPT-6 Luna at medium reasoning for new model evals. Claude and
  OpenCode remain excluded.

## Failed Approaches

- No new failure. Preserve the historical record that an older runner leaked
  candidate guidance into baseline prompts; those comparison artifacts are
  marked historical and invalid, not suitable for benchmark scoring.

## Validation

- Official OpenAI evaluation best-practices and Agent Skills evaluation pages
  reviewed 2026-11-04.
- SPEC structure and acceptance criteria reviewed locally; readiness verdict
  is ready, but approval is pending.
- No code tests or model calls were run in this planning turn.

## Open Questions

- User approval of SPEC-0001 is required before implementation.

## Next Steps

- If approved, implement the measurement schema and prompt-isolation tests,
  then build the global-instruction pilot before expanding skill coverage.
- Add separate grade records and the offline HTML report after the first pilot
  exposes which fields reviewers need.

## Relevant Files

- `docs/specs/SPEC-0001-evaluation-benchmarks-and-html-reports.md` — reviewed
  contract and ordered TODO plan.
- `evals/README.md` — current runner and report limitations.
- `evals/scripts/evaluate-skills.py` — current paired behavior runner.
- `GLOBAL_AGENTS.md` — first instruction target for the planned suite.
