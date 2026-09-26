# Harden bounded implement-next execution

Date: 2026-09-26
Feature: implement-next prompt-v3 task execution contract

## Context

Prompt-v3 §51 covers the executor's exact SPEC/task gate, lifecycle and
approval checks, dependency-ready selection, TDD, validation, blocker, session,
and completion boundaries.

## Goal

Find and fix gaps between the implement-next instructions and the focused
regression contract.

## Why

The executor must not invent work or imply SPEC completion. A successful task
needs explicit completion evidence, while blocked or incomplete work must stay
visible for the next handoff.

## Outcome

Added an explicit rule to mark only the selected task complete after successful
task-level validation and added contract assertions for exact SPEC identity,
task-list ownership, and stop-after-one-task behavior. The checklist and
session handoff were updated.

## Current State

Section 51 is complete and the worktree remains uncommitted for user review.
The next prompt-v3 section to review is §52.

## Important Findings

- Existing lifecycle fixtures covered statuses, approval, tasks, and blockers,
  but the written completion rule only said to update a checkbox.
- `implement-next` is an instruction contract without a bundled executor, so
  the regression test validates gates and ownership phrases rather than
  claiming runtime task orchestration.

## Decisions

- Keep task decomposition in `spec-workflow` and add no new task-list runtime.
- State successful-task completion explicitly while preserving red-test and
  blocked-task exceptions.

## Failed Approaches

- The first new assertion searched for a sentence split across Markdown lines;
  it was corrected to assert the two stable fragments separately.

## Validation

- `bash skills/spec-workflow/tests/test-lifecycle-contract.sh` — passed.
- Full contract suites, project-init tests, skill validation, Bash syntax,
  ShellCheck, targeted Markdownlint, memory verification, and
  `git diff --check` — passed.

## Open Questions

- Live harness execution and actual task-file mutation remain untested because
  no bundled implement-next runtime exists.

## Next Steps

- Review prompt-v3 §52, fix concrete gaps, and rerun focused plus full checks.

## Relevant Files

- `skills/implement-next/SKILL.md` — bounded task execution contract.
- `skills/spec-workflow/tests/test-lifecycle-contract.sh` — lifecycle and
  executor gate assertions.
- `skills/project-init/tests/test-safeguards-contract.sh` — cross-skill safety
  regression checks.
- `SESSION_STATE.md` — current section and validation handoff.
- `todo.md` — temporary prompt-v3 checklist.
