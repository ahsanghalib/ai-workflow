# Implement eval scoring and HTML reports

Date: 2026-11-04
Feature: evaluation-benchmarks

## Context

Repository `/mnt/nvme0n1p3/repos/ai-workflow`; approved SPEC-0001
implementation in a checkout with other pre-existing worktree edits.

## Goal

Build the local eval workflow the user requested: scorecards, `GLOBAL_AGENTS.md`
pilot, selected skill/routing coverage, and an easy HTML report entry point.


## Why

The user is learning how evals work and needs a clear distinction between model
responses, reviewed grades, sample percentages, and archived historical runs.

## Outcome

Implemented versioned runner/grade records, human review, pass/fail/unverified
aggregation, masked assertion handling, safe offline reports, a tracked archive
manifest, and generated `evals/reports/index.html`. Added six global cases,
seven lifecycle skill cases, and 40 routing cases. Ran six global scenarios as
12 Codex GPT-6 Luna medium calls and manually graded both arms. Baseline had
11/11 graded assertions pass; candidate had 10/11 pass and one fail; one masked
assertion per arm stayed unverified; five cases were fully graded in both arms.


## Current State

SPEC-0001 implementation is complete and verified. Reports remain ignored
under `evals/reports/`; archive validity labels are tracked in
`evals/archive-manifest.json`. Lifecycle cases and 40 route cases are prepared
but were dry-run only. No Claude/OpenCode runs or external actions occurred.

## Important Findings

- The proposal-only prompt masks the global `no-send` action assertion; keep it
  unverified while grading the separate approval-content requirement.
- The candidate omitted exact recipient/content approval detail in one case;
  preserve the fail and avoid causal claims from this small pilot.
- An archive manifest placed under ignored reports would vanish on a clean
  checkout; keep the source manifest tracked and generated HTML ignored.
- Paired reports must show ungraded arms explicitly so one arm's percentage
  cannot be mistaken for the other arm's result.

## Decisions

- Restrict model CLI options to Codex GPT-6 Luna at medium reasoning, per user
  direction and the approved SPEC.
- Keep grade templates separate from `grade.json`; only reviewed grades affect
  scores. Do not use an LLM grader in v1.
- Use per-arm rates, explicit denominators, and no weighted overall score.

## Failed Approaches

- The first reporting test invocation failed during module loading because the
  new reporting module did not yet exist; after implementation, the suite was
  run successfully.
- Review found that routing expected routes were not rendered after grading,
  partial paired arms could imply a score, and the archive manifest was
  ignored. All three were corrected before final verification.

## Validation

- `python3 -m unittest discover -s evals/tests -p 'test_*.py'`: 35 passed.
- `bash scripts/validate-skills.sh` and
  `bash tests/validate-skills.test.sh`: passed.
- Python compilation, all eval JSON parsing, 40 query/grader ID matching,
  `git diff --check`, and ignored-report checks: passed.
- Final dry runs prepared global, routing, and all current skill cases. The
  generated report is offline/self-contained and includes escaped output,
  source hashes, and within-run evidence links.

## Open Questions

- Run a Codex Luna/medium routing pilot when a routing behavior score is useful;
  actual runtime skill dispatch still is not measured.
- Run new lifecycle behavior suites only when prioritized; no subjective
  writing/design examples are currently ready for review.
-

## Next Steps

- Open `evals/reports/index.html` locally. For a future run, copy each
  `grade-template.json` to `grade.json`, record evidence and review type, then
  regenerate the report with `eval-reports.py --run <run-id> --validate-grades`.
-

## Relevant Files

- `docs/specs/SPEC-0001-evaluation-benchmarks-and-html-reports.md` — approved
  implementation contract and evidence.
- `evals/scripts/eval-reports.py` — schema validation, aggregation, HTML.
- `evals/scripts/evaluate-instructions.py` — paired global-instruction runner.
- `evals/scripts/evaluate-routing.py` — routing runner with grader isolation.
- `evals/cases/global-instructions/evals.json` — six synthetic global cases.
- `evals/cases/routing/` — 40 blind routing prompts and separate labels.
- `evals/archive-manifest.json` — tracked historical artifact labels.
- `evals/reports/index.html` — ignored local catalog.
