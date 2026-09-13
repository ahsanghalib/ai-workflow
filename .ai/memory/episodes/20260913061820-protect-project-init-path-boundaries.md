# Protect project-init path boundaries

Date: 2026-09-13
Feature: project-init

## Context

TASK-0014 hardens the bundled project-init copier after the scaffold and
optional-schema behavior were established.

## Goal

Complete TASK-0014 with safe symlink, canonical-path, idempotency, and argument handling.

## Why

Project initialization must not write through symlinked targets or parents, and
rerunning it must not replace files the user already owns.

## Outcome

The initializer rejects symlinked targets and parents, reports canonical paths, preserves existing files, and rejects extra arguments; disposable tests pass.

## Current State

TASK-0001 through TASK-0014 are complete. TASK-0015, approval-gated local Git
initialization, is next. No commit, branch, remote, or application-project
mutation was performed.

## Important Findings

- A target can be lexically inside a symlinked directory even when the target
  itself does not yet exist; checking every existing parent before `mkdir` is
  required.
- Canonicalizing the target after the parent check gives stable reporting while
  preserving the safety boundary.
- The disposable test is the right place to exercise accepted paths, because
  it avoids touching a user project while covering symlink and idempotency
  behavior.

## Decisions

- Reject symlinked targets and any symlinked existing parent before creating
  directories or copying templates.
- Keep copy-if-missing and extra-argument rejection unchanged.
- Treat canonical-path reporting as a safety and handoff aid, not permission to
  follow a symlink.

## Failed Approaches

The first Red test expected a symlinked target to be accepted. That exposed the
missing target-path boundary; the script was changed to reject it, after which
the test passed.

## Validation

- `bash skills/project-init/tests/test-init-project.sh` passed.
- `shellcheck skills/project-init/scripts/init-project.sh
  skills/project-init/tests/test-init-project.sh` passed.
- `bash -n skills/project-init/scripts/init-project.sh` passed.

## Open Questions

The Git-init operation still needs an explicit post-review invocation boundary
and must not create commits or remotes.

## Next Steps

Implement TASK-0015 and add disposable coverage for default no-Git behavior,
explicit local Git initialization, and preservation of existing Git metadata.

## Relevant Files

- `skills/project-init/scripts/init-project.sh` — path checks and copier.
- `skills/project-init/tests/test-init-project.sh` — disposable behavior tests.
- `IMPLEMENTATION_PLAN.md` — task order and acceptance criteria.
