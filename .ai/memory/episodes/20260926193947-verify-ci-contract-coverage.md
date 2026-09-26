# Verify CI contract coverage

Date: 2026-09-26
Feature: prompt-v3 §58 CI

## Context

Prompt-v3 §58 requires inspecting the existing CI workflow and ensuring the
refactored tests run without creating duplicate CI. The repository already had
`.github/workflows/validate.yml` with the main contract commands.

## Goal

Guard the existing CI/test-runner coverage and the aggregate project-init suite
with a local, credential-free contract test.

## Why

CI can silently regress when a new contract test is added but omitted from the
workflow, duplicated, or bypassed by an aggregate runner that no longer invokes
one of its child tests.

## Outcome

Added `test-ci-contract.sh` and wired it into `test-project-init.sh`. It checks
that every required CI command appears exactly once and that all project-init
child tests, including the CI contract itself, are invoked by the aggregate
runner. No second workflow was created.

## Current State

The §58 changes remain uncommitted for user review. The review cursor is now
prompt-v3 §59, and no remote CI run or external mutation was performed.

## Important Findings

- The existing workflow already ran the refactored project-init, SPEC, cross-
  skill, lifecycle, and design/completion tests.
- The missing protection was a local assertion against future omission or
  duplicate command entries, not an absent CI workflow.
- The aggregate project-init runner is the correct single CI entrypoint for
  its subordinate disposable tests.

## Decisions

- Extend the existing aggregate test runner rather than adding a new workflow
  or duplicate CI job.
- Keep the CI contract test read-only with respect to the repository and free
  of credentials, network calls, and remote workflow execution.
- Preserve unrelated worktree changes and do not commit.

## Failed Approaches

None. The focused CI contract and aggregate project-init suite passed on the
first implementation.

## Validation

- Passed `test-ci-contract.sh` and `test-project-init.sh`.
- Passed Bash syntax and ShellCheck for the new test.
- Passed the full available repository checks, Markdownlint, memory-index
  verification, and `git diff --check`.

## Open Questions

None for §58. Hosted GitHub Actions execution was not run locally.

## Next Steps

- Continue with prompt-v3 §59 when the user requests the next section.

## Relevant Files

- `.github/workflows/validate.yml`
- `skills/project-init/tests/test-ci-contract.sh`
- `skills/project-init/tests/test-project-init.sh`
- `todo.md`
- `SESSION_STATE.md`
