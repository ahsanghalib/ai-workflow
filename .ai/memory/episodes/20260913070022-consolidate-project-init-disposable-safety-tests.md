# Consolidate project-init disposable safety tests

Date: 2026-09-13
Feature: project-init

## Context

TASK-0038 consolidates disposable tests for the project-init helper boundary.

## Goal

Complete TASK-0038 with temporary-directory Red/Green coverage for helper and output boundaries.

## Why

The workflow must prove safety in temporary directories: no secret content,
symlink traversal, unwanted overwrites, Git side effects, or application files.

## Outcome

Added aggregate disposable suite running inspector, inventory, initializer, and Markdown-only output checks; ShellCheck and Bash syntax pass, covering empty/existing, preservation, symlinks, spaces, Git/ignore, secrets, and no app files.

## Current State

TASK-0001 through TASK-0038 are complete. TASK-0039, focused semantic checks
for ignore, env, prompts, schema, and Git behavior, is next.

## Important Findings

- Existing Red -> Green evidence already covered the initializer's core
  behavior; an aggregate runner makes the complete disposable boundary easy to
  rerun before handoff.
- Separate inspector and inventory tests enforce no-write and no-secret-output
  behavior.
- The aggregate output test confirms explicit schema/Git selections still do
  not generate application files, commits, or remotes.

## Decisions

- Keep tests temporary-directory-only and avoid user-project mutation.
- Run focused helpers first, then the aggregate suite.
- Use ShellCheck and Bash syntax checks as part of the test handoff.

## Failed Approaches

No implementation approach failed in this task; earlier helper tests supplied
the Red -> Green evidence and the aggregate runner passed on first execution.

## Validation

- `shellcheck skills/project-init/scripts/*.sh
  skills/project-init/tests/*.sh` passed.
- `bash -n skills/project-init/scripts/*.sh` passed.
- `bash skills/project-init/tests/test-project-init.sh` passed, including all
  focused suites and Markdown-only output assertions.

## Open Questions

Interactive conversational no-write-before-approval behavior remains a manual
harness check, not a shell-test assertion.

## Next Steps

Implement TASK-0039 with focused semantic scans for ignore, `.env`, prompts,
schema selection, and Git behavior.

## Relevant Files

- `skills/project-init/tests/test-project-init.sh` — aggregate suite.
- `skills/project-init/tests/test-init-project.sh` — initializer coverage.
- `skills/project-init/tests/test-inspect-project.sh` — mode/no-write coverage.
- `skills/project-init/tests/test-inventory-project.sh` — evidence coverage.
- `IMPLEMENTATION_PLAN.md` — task order and evidence.
