# Align known old skill contracts

Date: 2026-09-26
Feature: project-init prompt-v3 reconciliation

## Context

Prompt-v3 section 42 required remaining contracts to stop using the retired
PLAN/project-planning lifecycle and align with SPEC/task execution.

## Goal

Review the old-contract matrix, fix concrete gaps, and add regression coverage
without changing unrelated user work or committing changes.

## Why

Stale PLAN terminology or ambiguous handoffs could route work through the
retired workflow or blur approval and completion boundaries.

## Outcome

Aligned the affected contracts with the SPEC/task lifecycle. Fixed a
duplicate-word typo in `review-diff` and strengthened the cross-skill contract
test for session continuity, exact SPEC/task review scope, read-only review,
and repository-research handoff boundaries.

## Current State

Section 42 is complete. `SESSION_STATE.md` records section 43 as the next
review target. No commit was created.

## Important Findings

- Feature lifecycle references now resolve to SPEC/task workflows; design work
  routes through `spec-workflow`, and review/completion boundaries remain
  non-approving unless explicitly requested.
- The cross-skill contract test guards updated wording in `session-state`,
  `code-review`, `review-diff`, and `repository-research`.

## Decisions

- Preserve the user-directed retired-plan state; do not resurrect plan skills
  while reviewing the remaining prompt sections.
- Keep the fix minimal and enforce the contract with repository-local
  assertions rather than broad rewrites.

## Failed Approaches

- An initial Markdownlint invocation targeted the shell test script and produced
  irrelevant Markdown diagnostics. The script was instead validated with Bash
  syntax and ShellCheck; Markdownlint was run only on the changed Markdown.

## Validation

- Passed the focused cross-skill contract test, Bash syntax, ShellCheck, and
  Markdownlint for `review-diff`.
- Passed the full prompt-v3 contract suite, `validate-skills.sh`, all requested
  Markdownlint and Bash/ShellCheck checks, and `git diff --check`.

## Open Questions

- Prompt-v3 section 43 still contains a plan-skill preservation statement that
  conflicts with the user-directed no-plan workflow; reconcile it without
  resurrecting retired skills.

## Next Steps

- Review section 43, preserving the current no-plan decision and fixing any
  remaining contract gaps.

## Relevant Files

- `skills/review-diff/SKILL.md`
- `skills/spec-workflow/tests/test-cross-skill-contract.sh`
- `SESSION_STATE.md`
