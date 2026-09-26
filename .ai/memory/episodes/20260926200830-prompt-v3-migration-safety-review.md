# Prompt v3 migration safety review

Date: 2026-09-26
Feature: project-init migration safety

## Context

The public `ai-workflow` repository is being reconciled with prompt-v3 while
retiring mandatory plan-era artifacts. Section 60 requires a non-destructive
workflow refactor that preserves existing user-owned repositories and history.

## Goal

Audit and close migration-safety gaps for new bootstrap output, existing legacy
artifacts, uncertain ownership, generated obsolete files, and Git history.

## Why

The new workflow must stop depending on old ceremony without deleting useful
repository material or making a public shared repository unsafe for existing
users.

## Outcome

Updated the existing-repository safety reference to state the non-destructive
migration boundary, the conditions for removing clearly generated obsolete
artifacts, the uncertain-ownership fallback, and the explicit history-
preservation rule. Expanded the initializer fixture to preserve legacy plan
and review directories, a root rule file, generated-looking content, and a
pre-existing Git commit. Added prompt-v3 §60 tracking and session handoff
updates. No commit or external mutation was performed.

## Current State

Section 60 is complete and the worktree remains intentionally uncommitted.
Section 61 is the next review target. Temporary `prompt-v3.md` and `todo.md`
remain untracked by design.

## Important Findings

- The initializer has no migration/removal operation for legacy artifacts; it
  is copy-if-missing and preserves existing paths.
- A disposable history fixture initially inherited the host's global SSH
  commit-signing configuration, so the test must disable signing locally for
  its temporary commit without changing user or repository configuration.

## Decisions

- Preserve ambiguous or user-owned legacy artifacts and remove workflow
  dependence instead of attempting automatic cleanup.
- Treat generated-looking content as removable only after ownership, safety,
  and information-loss conditions are all demonstrably satisfied; this pass
  does not perform such removal.

## Failed Approaches

- The first focused run attempted a temporary test commit with inherited SSH
  signing and failed because the environment could not unlock the configured
  private key. The fixture was corrected with `commit.gpgSign=false` on that
  disposable command only.

## Validation

- Passed all project-init and spec-workflow shell tests, `validate-skills.sh`,
  Bash syntax checks, ShellCheck, and `git diff --check`.
- Targeted Markdownlint passed after wrapping the new `todo.md` lines. Bash
  test files were not sent to Markdownlint because its Markdown rules treat a
  shebang as an invalid heading; their shell validation is covered separately.
- Memory index verification remains part of the final pass.

## Open Questions

- None for §60. Live remote GitHub behavior and fresh-harness discovery remain
  outside this local validation.

## Next Steps

- Review prompt-v3 §61, preserve the no-commit boundary, and re-run the
  relevant focused checks after any next-section edits.

## Relevant Files

- `skills/project-init/references/existing-repository-safety.md` — migration
  and preservation contract.
- `skills/project-init/tests/test-init-project.sh` — legacy artifact and Git
  history regression fixture.
- `skills/project-init/tests/test-safeguards-contract.sh` — static safety
  assertions.
- `todo.md` and `SESSION_STATE.md` — section tracking and handoff state.
