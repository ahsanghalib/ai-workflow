# Adopt workmux for managed worktrees

Date: 2026-11-11
Feature: worktree-workflow

## Context

The repo's shared worktree guidance still centered on custom helpers. The user
installed workmux and added local snapshots of its help and full README.

## Goal

Align agent guidance with the user's workmux-first workflow without changing
their Git safety policy or local workmux configuration.

## Why

The user intends to use workmux for worktree and terminal-window management.

## Outcome

Updated `GLOBAL_AGENTS.md`, `git-worktree-workflow`, README, and the Pi
worktree prompt. Workmux is primary for creation, opening, status, and closing
windows; the guarded helper remains for final branch/worktree cleanup.

## Current State

`worktree-new` remains as a fallback and both helper links remain in
`scripts/script.sh`. Existing nested skill-link changes and user-added
`workmux-help.md`, `workmux-docs.md`, and `skills/workmux-skills/` remain in the
working tree. No personal workmux config was read or changed.

## Important Findings

- `workmux close` only closes its window. `workmux remove` also removes the
  worktree and branch; its force and `--gone` options have broader effects.
- The custom `worktree-close` checks ignored files and merge evidence, with an
  exact branch-tip match for its GitHub PR fallback.
- Workmux merge/rebase flows conflict with the repository's Git policy, which
  reserves those operations to the user.

## Decisions

- Use workmux for normal worktree and window management, but retain guarded
  final cleanup and the legacy creation fallback.
- Do not change user-level workmux configuration or delete existing helper
  code without a separate decision.

## Failed Approaches

- Local `workmux --help` panicked while initializing its log appender in the
  read-only environment. Used the supplied help/README snapshots and upstream
  GitHub README instead; local config and runtime behavior remain unverified.

## Validation

- `bash scripts/validate-skills.sh` — passed.
- `git diff --check` — passed.
- Automated tests and local workmux runtime checks were not run.

## Open Questions

- Whether to retire `worktree-new` and its linker entry later.
- Whether to remove `worktree-close` only after replacing its cleanup checks.
- Whether a project-specific `.workmux.yaml` is wanted; none was created.

## Next Steps

- Review the full worktree before staging or committing.
- Revisit helper removal only if the user accepts equivalent cleanup safeguards.

## Relevant Files

- `GLOBAL_AGENTS.md` — global worktree policy.
- `skills/git-worktree-workflow/SKILL.md` — detailed workmux-first procedure.
- `README.md` and `pi/agent/prompts/worktree-plan.md` — repo and Pi guidance.
- `bin/worktree-new`, `bin/worktree-close`, `scripts/script.sh` — retained
  compatibility helpers and linker integration.
- https://github.com/raine/workmux — upstream command and lifecycle docs.
