# Separate Git approval and support no-Git bootstrap

Date: 2026-09-13
Feature: project-init

## Context

The initializer already separated `--init-git` from documentation copying, but
its capability failure could occur after creating the target. The workflow also
needed a clear no-Git path.

## Goal

Complete TASK-0046 by making local git init exact-target and separate, with a safe documentation-only fallback when Git is unavailable or declined.

## Why

Users should be able to bootstrap project-control Markdown without Git, while
an approved local Git operation must be exact, predictable, and free of bundled
history or remote mutations.

## Outcome

Added the Git approval/fallback contract, updated user-facing and generated guidance, and made the initializer preflight Git capability before writing when --init-git is selected.

## Current State

TASK-0046 is complete. `--init-git` is preflighted before writes when Git is
needed; no-Git documentation bootstrap is explicitly supported and reported.

## Important Findings

- A test with only selected core utilities on `PATH` demonstrated that the
  previous implementation could write before reporting missing Git.
- Existing `.git` metadata is preserved even when the Git executable is not
  available; it is not repaired or replaced.

## Decisions

- Local `git init` requires separate approval for the exact canonical target.
- No-Git fallback may create approved documentation, but must report that
  branch, history, and Git-state validation are unavailable.
- Commits, branches, remotes, pushes, fetches, and other Git operations remain
  outside the initializer's authorization boundary.

## Failed Approaches

- The first disposable no-Git test did not isolate Git correctly because the
  restricted `PATH` also hid required shell utilities; the test was corrected
  to expose only the utilities needed to reach the Git capability check.

## Validation

- Red -> Green: the no-Git `--init-git` case first exposed a partial-write
  failure, then passed after the preflight was added.
- Initializer tests and ShellCheck pass.
- Targeted documentation updates include the Git approval/fallback reference,
  README, generated AGENTS template, and bootstrap prompt.

## Open Questions

- Live behavior with a user-specific Git installation or alternate VCS was not
  exercised; alternate VCS is outside this workflow.

## Next Steps

- Continue with TASK-0047: add the harness capability matrix and safe manual
  fallbacks.

## Relevant Files

- `skills/project-init/references/git-approval.md`
- `skills/project-init/scripts/init-project.sh`
- `skills/project-init/scripts/inspect-project.sh`
- `skills/project-init/tests/test-init-project.sh`
- `README.md`
- `skills/project-init/templates/AGENTS.md`
- `skills/project-init/templates/.ai/prompts/bootstrap-project.md`
