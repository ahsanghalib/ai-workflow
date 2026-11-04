# Add dedicated Git worktree workflow skill

Date: 2026-10-19
Feature: git-worktree-workflow skill routing

## Context

The repository already had `worktree-new` and `worktree-close` helpers, concise
global worktree rules, and a separate `github-cli-workflow` skill. The user
requested a dedicated skill for the local worktree lifecycle.

## Goal

Document when and how to create, use, and safely close isolated worktrees
without coupling generic `AGENTS.md` templates or `implement-next` to branch
creation.


## Why

Worktree setup is a distinct local Git/filesystem workflow. GitHub issue and PR
operations belong to `github-cli-workflow`, while SPEC task execution belongs to
`implement-next` after a checkout has already been selected.

## Outcome

Added `skills/git-worktree-workflow/SKILL.md`, routed it from
`GLOBAL_AGENTS.md`, and listed it in `README.md`. The skill covers isolation
decisions, helper preflight, ignored-file behavior, `.env` copy disclosure,
implementation handoff, cleanup approval, network checks, and GitHub-skill
routing.


## Current State

The skill and documentation are updated and the repository skill validator and
diff whitespace check pass. No commit, push, or external mutation was done.

## Important Findings

- `implement-next` must start inside an already-prepared checkout because it
  explicitly does not create branches or worktrees.
- `worktree-close` can fetch a named remote and may query GitHub for merge
  evidence, so cleanup guidance must include network-policy and approval
  boundaries.
- `.env` is copied by the helper unless excluded, even though its contents are
  never read or printed by the workflow.

## Decisions

- Keep `git-worktree-workflow` separate from `github-cli-workflow`: the former
  owns local checkout lifecycle, while the latter owns remote GitHub actions.
- Keep `implement-next` and the generic project-init `AGENTS.md` template
  unchanged; route isolation as an optional pre-implementation step.
- Keep the skill local-only and out of the curated ChatGPT web bundle because
  it depends on Git, Bash, and repository-local helper binaries.

## Failed Approaches

- The first skill draft did not explicitly disclose default `.env` copying,
  cleanup network activity, or the pre-`implement-next` handoff; review found
  those gaps and the skill was revised.

## Validation

- `bash scripts/validate-skills.sh` passed after the skill was added and after
  the review fixes.
- `git diff --check` passed.
- Read-only review found no remaining actionable issues after the fixes.

## Open Questions

- None for the current scope. Future changes may add project-specific examples
  without changing the skill's lifecycle boundary.

## Next Steps

- Review the complete uncommitted diff and commit only the intended changes when
  the human is ready; do not push without a separate request.

## Relevant Files

- `skills/git-worktree-workflow/SKILL.md` — local worktree lifecycle guidance.
- `GLOBAL_AGENTS.md` — routing for the skill during isolated implementation.
- `README.md` — lifecycle sequence and skill index.
- `skills/implement-next/SKILL.md` — preserved task-execution boundary.
- `skills/github-cli-workflow/SKILL.md` — separate remote GitHub workflow.
