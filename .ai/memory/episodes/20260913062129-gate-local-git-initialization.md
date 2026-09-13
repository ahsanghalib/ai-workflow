# Gate local Git initialization

Date: 2026-09-13
Feature: project-init

## Context

TASK-0015 follows the safe documentation copier and adds the separately
approved local Git step needed by a new project bootstrap.

## Goal

Complete TASK-0015 with an explicit local Git initialization handoff that never commits or creates remotes.

## Why

Git initialization changes repository metadata and must be visible as its own
operation. A documentation scaffold must not silently create commits, remotes,
or other Git state.

## Outcome

The initializer leaves Git unchanged by default, accepts --init-git only as a documented post-approval handoff, preserves existing .git metadata, and passes disposable tests.

## Current State

TASK-0001 through TASK-0015 are complete. TASK-0016, empty-folder inspection
and proposal behavior, is next. No user project was initialized and no commit
or remote operation was performed.

## Important Findings

- A non-interactive helper cannot infer conversational approval. An explicit
  `--init-git` flag is therefore the narrow handoff from the approved agent
  proposal to the local mutation.
- The absence of that flag must be a no-op for Git state, including when the
  documentation target is otherwise empty.
- Existing `.git` metadata must be preserved rather than reinitialized when
  the flag is passed.

## Decisions

- Keep local Git initialization opt-in with `--init-git` and document that the
  caller must approve the exact canonical target first.
- Run only `git -C TARGET init --quiet`; do not create commits, remotes,
  branches, pushes, or other Git operations.
- Treat any existing `.git` entry, including a symlink or worktree metadata
  file, as existing state to preserve.

## Failed Approaches

The first Red test passed `--init-git` to the previous flag parser, which
rejected it as an extra argument. Extending the parser and adding the explicit
Git handoff made the test pass.

## Validation

- `bash skills/project-init/tests/test-init-project.sh` passed, including
  default no-Git, explicit initialization, no-commit/no-remote, and existing
  metadata preservation cases.
- `shellcheck skills/project-init/scripts/init-project.sh
  skills/project-init/tests/test-init-project.sh` passed.
- `bash -n skills/project-init/scripts/init-project.sh` passed.
- `git diff --check` passed.

## Open Questions

The new-project orchestration still needs to inspect an empty target and show a
complete proposal before selecting `--init-git` and the documentation writes.

## Next Steps

Implement TASK-0016 and keep Git initialization separate from the empty-folder
proposal and copy approval.

## Relevant Files

- `skills/project-init/scripts/init-project.sh` — explicit Git handoff.
- `skills/project-init/tests/test-init-project.sh` — disposable Git coverage.
- `skills/project-init/SKILL.md` — approval state and invocation rule.
- `skills/project-init/references/workflow.md` — script and Git boundaries.
- `README.md` — user-facing initializer option.
- `IMPLEMENTATION_PLAN.md` — task order and acceptance evidence.
