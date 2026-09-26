# Test final SPEC completion transition

Date: 2026-09-26
Feature: prompt-v3 §55 completion

## Context

Prompt-v3 §55 required completion tests beyond static wording. The repository
already described final verification, but no fixture exercised the transition
from completed tasks to `SPEC → Completed`.

## Goal

Add a disposable completion contract that distinguishes narrow task evidence
from the final SPEC-level verification gate.

## Why

Static assertions could pass while a future workflow change treated checked
task boxes or task validation as sufficient completion evidence.

## Outcome

Added fixture-based checks for completed tasks without final verification,
successful final verification, failed verification, partial verification, and
an incomplete task with a successful final result. Only the fully complete
fixture with `Final verification: verified` reaches `Completed`.

## Current State

The §55 changes remain uncommitted for user review. The review cursor is now
prompt-v3 §56, and the broader user-directed reconciliation remains intact.

## Important Findings

- Task validation is necessary evidence for a task but cannot close the SPEC.
- Failed or partial final verification must leave the SPEC out of `Completed`.
- The completion fixture can remain local to the existing design/completion
  contract test; no new dependency or standalone runner is needed.

## Decisions

- Keep completion behavior covered in the existing focused shell contract test
  so the current CI path exercises it.
- Model a successful final result as `verified`, matching the
  verification-before-completion reporting vocabulary.
- Preserve the no-commit boundary and unrelated worktree changes.

## Failed Approaches

None. The focused fixture and ShellCheck pass on the first implementation.

## Validation

- Passed `test-design-completion-contract.sh` with all completion fixtures.
- Passed Bash syntax and ShellCheck for the changed test.
- Passed the available SPEC/project-init contract suite and `validate-skills.sh`.
- Passed Markdownlint and `git diff --check`; memory verification remains to
  be run after this entry is filled.

## Open Questions

None for §55. Live SPEC execution through an external harness was not run.

## Next Steps

- Continue with prompt-v3 §56 when the user requests the next section.

## Relevant Files

- `skills/spec-workflow/tests/test-design-completion-contract.sh`
- `skills/spec-workflow/SKILL.md`
- `skills/verification-before-completion/SKILL.md`
- `todo.md`
- `SESSION_STATE.md`
