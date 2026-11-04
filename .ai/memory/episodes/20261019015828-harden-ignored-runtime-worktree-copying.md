# Harden ignored runtime worktree copying

Date: 2026-10-19
Feature: worktree-new ignored-file propagation

## Context

The repository already had hardened Git worktree helpers and a linker, with
uncommitted unrelated runtime-configuration changes in the working tree. The
task extended `worktree-new` so a new checkout can run using local ignored
runtime configuration without copying dependency or generated directories.

## Goal

Copy ignored files from the checkout where `worktree-new` is invoked, preserve
nested paths and symlinks safely, exclude package-manager/build state, and keep
rollback behavior reliable.


## Why

Worktrees start from a Git ref and do not inherit ignored local runtime files;
package managers should recreate their own dependency directories rather than
duplicating them.

## Outcome

Implemented the ignored-file copy policy, configurable extra exclusions,
sensitive-file default skips with explicit opt-in, collision and unsafe-parent
checks, temporary-list status validation, and rollback after copy failures.
Follow-up review fixes bind PR fallback queries to the selected remote's
repository, reject symlinked worktree output ancestors, and cover additional
OpenSSH private-key names. Documentation and regression coverage were updated.
`scripts/script.sh` links both helpers to the configurable user bin directory.


## Current State

The implementation and focused tests pass, and the final read-only review found
no actionable issues. No commit, push, GitHub query, or external mutation was
performed. The working tree still contains unrelated pre-existing changes.

## Important Findings

- `git ls-files --others --ignored --exclude-standard -z` must be materialized
  and checked explicitly; process substitution alone can hide enumeration
  failure.
- Copying ignored files can overwrite tracked base paths or follow tracked
  symlink/non-directory parents unless the destination is checked first.
- Broad ignored-file copying can duplicate credentials, so common credential
  files/directories are skipped by default; `WORKTREE_COPY_ALLOW_SENSITIVE=1`
  is an explicit opt-in.
- PR-based cleanup evidence must be tied to the repository identified by the
  selected merge remote; a generic `gh` repository context is unsafe with
  multiple remotes.

## Decisions

- Source ignored files from the invocation checkout, not an assumed main
  checkout, so worktree-local runtime state is preserved.
- Exclude common dependency, virtualenv, cache, and generated directories by
  default, including `node_modules`, `.venv`, `target`, `vendor`, and
  `packages`; allow colon-separated normalized repository-relative additions
  through `WORKTREE_COPY_EXCLUDE`.
- Reject destination collisions rather than overwriting the selected base, and
  attempt rollback while leaving artifacts for inspection only if cleanup
  itself is incomplete.
- Reject symlinked or non-directory ancestors in the adjacent worktree output
  path before invoking `git worktree add`.

## Failed Approaches

- An initial direct `cp` loop used process substitution for Git enumeration and
  could report success when the producer failed; it was replaced with a checked
  temporary NUL-delimited path list.
- A multiline shell `case` pattern without continuation escapes caused a syntax
  error; the pattern was corrected and rechecked with Bash and ShellCheck.

## Validation

- `bash tests/worktree-helpers.test.sh` passed, covering ignored-file copying,
  excluded directories, sensitive opt-in, normalized exclusions, copy and
  enumeration failure rollback, tracked collisions, symlink safety, remote
  repository binding, output-parent symlink rejection, and private-key names.
- `bash tests/script-linker.test.sh` passed.
- `bash -n scripts/*.sh bin/* tests/*.sh` and targeted ShellCheck passed.
- `bash scripts/validate-skills.sh` and `git diff --check` passed.
- No live GitHub or real user-home validation was performed.

## Open Questions

- The default exclusion list may need a project-specific addition when a
  language or package manager uses a nonstandard dependency directory.

## Next Steps

- Review the complete uncommitted diff and commit only the intended changes
  when the human is ready; do not push without a separate request.

## Relevant Files

- `bin/worktree-new` — ignored-file copy, filtering, safety checks, and rollback.
- `tests/worktree-helpers.test.sh` — helper regression fixtures.
- `scripts/script.sh` — user-level helper links.
- `README.md` — worktree helper behavior and environment variables.
- `SESSION_STATE.md` — current handoff state.
