# Centralize worktree helper output

Date: 2026-11-04
Feature: git-worktree-workflow

## Context
The shared `worktree-new` helper placed each repository's worktrees beside
its checkout in `<repo>.worktrees`. The user wants a centralized root configured
in their shell environment and requested an audit of both helpers and skills
that invoke them.

## Goal
Make helper-created worktrees land in the requested directory and keep the
create/use/close instructions consistent.


## Why
The user wants one location for all worktrees, including those created by
skills that call the installed binaries.

## Outcome
`worktree-new` requires `AI_WORKFLOW_WORKTREE_ROOT` to be an absolute path. If
the variable is unset it errors; if the directory is missing it asks before
creating it. New worktrees use `<root>/<repository>/<branch>`. `worktree-close`
already acts on the explicit path and needed no code change. README and the
shared workflow skill describe the contract.


## Current State
Implementation and local validation are complete. No real worktree was
created; test fixtures used a temporary root.

## Important Findings

- Only `skills/git-worktree-workflow/SKILL.md` directly invokes the helper;
  other worktree skill mentions do not create or close worktrees.
- Grouping by repository name avoids collisions when multiple repositories
  use the same branch name.
- `worktree-close` accepts the exact printed path and keeps its existing clean,
  merged, ignored-file and current-directory safeguards. Its explicit path
  handling works with a centralized root, so it needs no root-specific change.

## Decisions

- Keep the public utility free of machine-specific paths. Require the user's
  shell to configure the centralized root. Keep branch namespaces unchanged
  beneath a repository-name directory.

## Failed Approaches

- The first test run failed because global Git configuration attempted SSH
  commit signing in its temporary fixtures. Rerunning with a command-scoped
  `commit.gpgsign=false` setting passed; no credential files or key contents
  were inspected.

## Validation

- `bash tests/worktree-helpers.test.sh` passed with the scoped Git config
  override; it covers missing/relative variables and accepted/declined
  directory-creation prompts.
- `bash tests/script-linker.test.sh`, `bash scripts/validate-skills.sh`,
  `bash -n`, ShellCheck, and `git diff --check` passed.
- No live worktree creation or remote GitHub cleanup path was exercised.

## Open Questions

- No machine-specific root is stored; users must set the environment variable.

## Next Steps

- Review the full working-tree diff before any commit.

## Relevant Files

- `bin/worktree-new` — root selection and path layout.
- `bin/worktree-close` — explicit-target cleanup contract, unchanged.
- `skills/git-worktree-workflow/SKILL.md` — skill create and close examples.
- `README.md` — documented helper path.
- `tests/worktree-helpers.test.sh` — temporary-root coverage.
