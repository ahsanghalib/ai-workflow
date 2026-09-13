# Test project-init copy and hidden prompt preservation

Date: 2026-09-13
Feature: project-init

## Context

TASK-0011 adds focused disposable-directory coverage for the existing
project-init copier after the tracked `.ai/prompts/` templates were added.

## Goal

Prove copy-if-missing, hidden-path, symlink-boundary, path-with-spaces, and
extra-argument behavior without changing the copier unnecessarily.


## Why

The initializer must preserve user files and safely copy hidden helper prompts
without turning this task into a broader bootstrap redesign.

## Outcome

Added `skills/project-init/tests/test-init-project.sh`. It checks hidden
prompt files, idempotent existing-file preservation, leaf and parent symlink
boundaries, paths with spaces, and extra-argument rejection.


## Current State

TASK-0001 through TASK-0011 are complete. TASK-0012 is next. The test exposed
that a symlinked target itself is canonicalized; that behavior remains scoped
to later TASK-0014 rather than being changed here.

## Important Findings

- Existing hidden `.ai/prompts/` files are copied by the current recursive
  template traversal.
- Existing ordinary files and symlinks are preserved.
- Parent symlinks are not followed by `ensure_parent_dir`.

## Decisions

- Keep this task focused on copy-if-missing and approved path boundaries.
- Leave selected-target symlink canonicalization to the later symlink-hardening
  task.

## Failed Approaches

The first fixture expected a symlinked target itself to remain untouched, but
the current script canonicalizes that target. The fixture was removed rather
than expanding TASK-0011 into TASK-0014 behavior.

## Validation

- `bash skills/project-init/tests/test-init-project.sh` passed.
- `shellcheck skills/project-init/tests/test-init-project.sh
  skills/project-init/scripts/init-project.sh` passed.
- Runtime coverage is disposable-directory only; no real project was used.

## Open Questions

Target-symlink handling remains for TASK-0014.
-

## Next Steps

Continue with TASK-0012: add conditional schema-template handling.
-

## Relevant Files

- `skills/project-init/tests/test-init-project.sh` — disposable copier tests.
- `skills/project-init/scripts/init-project.sh` — deterministic copier.
- `IMPLEMENTATION_PLAN.md` — task order and activity evidence.
- `SESSION_STATE.md` — current short-term handoff state.
