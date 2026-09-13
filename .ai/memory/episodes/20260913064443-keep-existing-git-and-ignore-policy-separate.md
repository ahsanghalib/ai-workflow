# Keep existing Git and ignore policy separate

Date: 2026-09-13
Feature: project-init

## Context

TASK-0027 applies the local Git and ignore-file rules to existing-project
reconciliation.

## Goal

Complete TASK-0027 with existing-project Git initialization and .gitignore proposal handling.

## Why

An existing project may intentionally have Git metadata and an ignore policy.
Reconciliation must add only what is missing after approval and never bundle
repository history or remote operations.

## Outcome

Documented separate exact-target Git approval, existing .git preservation, absent .gitignore proposal, byte-for-byte existing ignore preservation, and no bundled commit/remote/branch/push operations; existing-target tests pass.

## Current State

TASK-0001 through TASK-0027 are complete. TASK-0028, reconciliation prompts and
generated AGENTS routing, is next. No user project Git or ignore state was
changed.

## Important Findings

- The same explicit `--init-git` handoff can serve new and existing targets,
  provided the exact canonical target was separately approved.
- Existing `.git` metadata must be preserved and not reinitialized.
- Absent `.gitignore` is a missing-file proposal; existing `.gitignore` remains
  byte-for-byte unchanged while missing recommended rules are only reported.

## Decisions

- Keep local Git initialization, ignore-file creation, and existing-file
  revision as separate operation scopes.
- Never create a commit, remote, branch, push, or other Git operation here.
- Preserve `.env` rules and keep `.ai/` trackable in any future approved ignore
  change.

## Failed Approaches

No implementation approach failed; the existing-target behavior was covered by
the earlier disposable initializer test and this task hardened its workflow
documentation.

## Validation

- Existing-target `--init-git` and `.gitignore` preservation cases passed in
  `bash skills/project-init/tests/test-init-project.sh`.
- ShellCheck, Bash syntax, Markdown lint, and focused approval-boundary
  inspection passed.

## Open Questions

Each existing project still needs a user decision on whether to initialize Git
and whether to create an absent `.gitignore`.

## Next Steps

Implement TASK-0028 with explicit existing-project helper-prompt and generated
AGENTS routing.

## Relevant Files

- `skills/project-init/scripts/init-project.sh` — approved local Git handoff.
- `skills/project-init/tests/test-init-project.sh` — existing-target coverage.
- `skills/project-init/SKILL.md` — Git and ignore boundaries.
- `skills/project-init/references/workflow.md` — reconciliation rule.
- `skills/project-init/templates/.ai/prompts/reconcile-existing-project.md` —
  helper prompt.
- `IMPLEMENTATION_PLAN.md` — task order and evidence.
