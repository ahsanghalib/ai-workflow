# Preserve existing workflow safeguards

Date: 2026-09-26
Feature: project-init prompt-v3 reconciliation

## Context

Prompt-v3 section 45 required the workflow refactor to retain safety and
quality safeguards while removing obsolete planning ceremony.

## Goal

Compare the listed safeguards with current skill contracts and tests, then add
regression coverage for any unprotected cross-skill boundary.

## Why

The individual skills documented inspection, approval, TDD, validation, review,
continuity, and safety rules, but a later refactor could weaken one boundary
without a single test asserting their preservation together.

## Outcome

Added `test-safeguards-contract.sh` and wired it into the project-init aggregate
suite. It checks inspection and approval, source-of-truth and capability
detection, one-task/TDD execution, validation, review, continuity, secret/Git
safety, blockers, and remote-mutation limits.

## Current State

Section 45 is complete and section 46 is the next review target. No commit was
created.

## Important Findings

- The safeguards were present across existing skills; the gap was regression
  coverage spanning their handoff boundaries.
- Project-init aggregate validation is already part of CI, so wiring the new
  test there protects the repository without adding a separate CI path.

## Decisions

- Add focused contract assertions rather than duplicate runtime behavior tests;
  existing disposable project-init scenarios continue to cover filesystem and
  preservation behavior.
- Keep the safeguards distributed among their owning skills and use the new
  test only as a cross-skill preservation check.

## Failed Approaches

- The first test draft asserted phrases from the wrong owning file and used
  wording that did not match the current contracts. Exact repository wording
  was inspected and the assertions were corrected before validation.

## Validation

- Passed all SPEC and project-init contract suites, including the new
  safeguards contract, `validate-skills.sh`, Bash syntax, ShellCheck,
  Markdownlint, memory verification, and `git diff --check`.
- Live harness reload and application/runtime behavior were not exercised.

## Open Questions

- None for §45. Section 46 remains to be reviewed.

## Next Steps

- Review §46 and continue evidence-led gap fixing.

## Relevant Files

- `skills/project-init/tests/test-safeguards-contract.sh`
- `skills/project-init/tests/test-project-init.sh`
- `SESSION_STATE.md`
- `todo.md`
