# Harden SPEC review and approval scenarios

Date: 2026-09-26
Feature: spec-workflow prompt-v3 approval lifecycle

## Context

Prompt-v3 §49 requires tests for the boundary between SPEC readiness review,
explicit user approval, and execution eligibility. The repository already had
the lifecycle prose and broad contract checks.

## Goal

Close gaps where approval fixtures accepted a non-empty but undated approval
marker and did not explicitly exercise contract-change and execution-only
scenarios.

## Why

`ready` is only a review verdict. Execution must require durable, dated user
approval, while contract changes must invalidate old approval and execution-only
changes must not create a needless second gate.

## Outcome

The lifecycle test now validates the documented approval-date format, rejects
malformed evidence, checks the ready/not-ready and status-immutability rules,
models a contract-change Draft with cleared evidence, and preserves approval
for an execution-only update. The checklist and session handoff were updated.

## Current State

Section 49 is complete and the worktree remains uncommitted for user review.
The next prompt-v3 section to review is §50.

## Important Findings

- The existing lifecycle prose already defined the correct rules, but the test
  accepted any line beginning with the approval marker.
- The skills are instruction contracts rather than a runtime state machine, so
  fixture tests should validate observable file-state gates without pretending
  to execute an unavailable approval service.

## Decisions

- Require the canonical `Approval: Explicit user approval — YYYY-MM-DD` shape
  in the execution fixture gate.
- Keep the stronger scenarios in the existing lifecycle contract test so the
  aggregate project validation covers them without a new runner.

## Failed Approaches

- No implementation approach failed. The initial review identified a weak
  non-empty-marker assertion, which was tightened before the full validation.

## Validation

- `bash skills/spec-workflow/tests/test-lifecycle-contract.sh` — passed.
- SPEC/project-init contract suites, `validate-skills.sh`, Bash syntax,
  ShellCheck, Markdownlint, memory verification, and `git diff --check` —
  passed.

## Open Questions

- Live harness behavior and real user approval transport remain outside the
  repository-local contract tests.

## Next Steps

- Review prompt-v3 §50, fix concrete gaps, and rerun focused plus full checks.

## Relevant Files

- `skills/spec-workflow/tests/test-lifecycle-contract.sh` — approval fixtures
  and lifecycle assertions.
- `skills/spec-review/SKILL.md` — ready/not-ready and read-only review rules.
- `skills/spec-workflow/SKILL.md` — approval and contract-change workflow.
- `skills/spec-workflow/references/lifecycle-and-approval.md` — lifecycle
  state and approval evidence contract.
- `SESSION_STATE.md` — current section and validation handoff.
- `todo.md` — temporary prompt-v3 checklist.
