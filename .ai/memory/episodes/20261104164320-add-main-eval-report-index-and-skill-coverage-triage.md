# Add main eval report index and skill coverage triage

Date: 2026-11-04
Feature: evals

## Context

SPEC-0001 was a Draft plan for a global-instruction eval, selected skill
coverage, score reporting, and per-run HTML. The user asked to add one main
index page and to check the skill catalog for further evaluation candidates.

## Goal

Refine the local evaluation SPEC to cover one index.html for archived and future reports and prioritize evals across the full skill catalog.

## Why

The user wants one easy local starting point for both archived and future eval
reports, plus a practical order for evaluating a repository with 56 skills.
They need a careful review before approving implementation.

## Outcome

Reviewed all 56 skill entrypoints at trigger/workflow level and inspected
high-risk approval, trust, state, browser, Git, and LinkedIn boundaries. Added
a risk-based triage, one `evals/reports/index.html` catalog, archive status
metadata, and link/security requirements to the Draft SPEC. No implementation
or model calls.

## Current State

SPEC-0001 remains Draft and is pending explicit user approval. Review finds the
contract ready after clarifying denominator rules, masked assertions, archive
validity labels, and the main index behavior.

## Important Findings

- The catalog must include existing Markdown reports, recognized historical
  run summaries/traces, and future per-run HTML; historical, dry-run, ungraded,
  contaminated, and masked evidence must not be presented as scored results.
- The existing paired runner's common guardrails can repeat the policy being
  evaluated. Case-level overlap checks must mark masked assertions unverified
  and exclude them from percentages.
- Proposal-only tests cannot establish that a real action was executed. Any
  actual action-safety claim needs observable evidence and an approved local
  sandbox protocol.
- Coverage is selective: behavior tests for consequential and observable
  workflows, routing tests for collision families, and human rubrics for
  subjective writing/design. Avoid shallow evals for all 56 skills.

## Decisions

- Use `evals/reports/index.html` as the one generated, ignored local catalog;
  `report.html` remains a detail page within each run directory.
- Keep JSON traces and separate grade records as source data; HTML must be
  offline, escaped, and limited to safe relative links.
- Keep the model scope Codex with GPT-6 Luna at medium; Claude/OpenCode remain
  excluded. Do not add an LLM judge in v1.

## Failed Approaches

- No new failed implementation. Earlier archived comparisons from a runner
  that leaked candidate instructions remain invalid and must not be scored.

## Validation

- Confirmed all 56 skill names appear in the coverage triage; the Draft SPEC has
  20 unique, ordered unchecked tasks and no approval evidence.
- Confirmed the SPEC link from `evals/README.md` resolves and `git diff --check`
  passes. No behavior tests or model calls were appropriate for this planning
  change.

## Open Questions

- Explicit user approval of SPEC-0001 before implementation.

## Next Steps

- If approved, first define grade/report schemas and test prompt isolation,
  then implement and pilot the `GLOBAL_AGENTS.md` suite. Build per-run reports
  and the archive-aware main index after review needs are clear.

## Relevant Files

- `docs/specs/SPEC-0001-evaluation-benchmarks-and-html-reports.md` — Draft
  contract, full skill triage, index requirement, and 20-task plan.
- `evals/README.md` — Current eval workflow and pending index notice.
- `evals/reports/archive/historical-reports/SKILL_EVALUATION_RESULTS.md` —
  legacy results and invalid-comparison notice.
- `GLOBAL_AGENTS.md` — First planned instruction target.
