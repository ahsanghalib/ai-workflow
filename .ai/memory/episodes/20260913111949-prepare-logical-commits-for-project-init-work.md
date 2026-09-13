# Prepare logical commits for project-init work

Date: 2026-09-13
Feature: logical commit preparation

## Context

The project-init implementation, review repairs, README rewrite, memory
history, and derived-index policy are all present in one dirty worktree after
several approved sessions.

## Goal

Update session continuity and prepare local logical commits without including
the ignored session state, derived SQLite index, or unreferenced assets.

## Why

The user wants the completed work grouped by concern so each commit is
reviewable and the derived FTS database is not treated as source history.

## Outcome

`SESSION_STATE.md` records the active commit-preparation handoff. The intended
scopes are functional project-init/schema-design work, README documentation,
agent-memory ignore policy, and reviewed episodic Markdown history. No staging
or commit had occurred when this capsule was created.

## Current State

The worktree is intentionally dirty. `SESSION_STATE.md` is ignored. The
tracked `.ai/memory/memory.sqlite` remains out of scope despite its modified
working-tree state, and `assets/` remains unreferenced and out of scope.

## Important Findings

- `skills/project-init/templates/.gitignore.template` is the source for
  generated project ignore policy and must carry the exact database rule.
- Episode Markdown is reviewable source history; `memory.sqlite` is only a
  derived FTS index and should not be staged.
- The completed functional scope includes many untracked project-init
  references, scripts, templates, and tests; `git add -A` would also capture
  unrelated assets and derived state.

## Decisions

- Keep functional project-init/schema-design changes together.
- Keep README documentation separate from functional skill changes.
- Keep `.gitignore` plus agent-memory policy as a focused derived-index policy
  change, while the project-init ignore template travels with project-init.
- Record episodic Markdown in a separate memory-history scope if approved;
  leave the SQLite index unstaged.

## Failed Approaches

- No commit attempt or broad staging command was made. Avoid `git add -A`.

## Validation

- The project-init and agent-memory disposable tests passed before this
  handoff. Skill validation, agent-memory quick validation, memory tests,
  ignore-rule resolution, and `git diff --check` passed for the ignore-policy
  update.

## Open Questions

- Whether the user wants the reviewed episodic Markdown history committed in
  its own commit or left for a later history-only commit.

## Next Steps

- Stage each approved logical scope explicitly, inspect `git diff --cached`,
  run staged-scope validation, and commit locally without pushing.

## Relevant Files

- `SESSION_STATE.md`
- `.gitignore`
- `skills/agent-memory/SKILL.md`
- `skills/project-init/templates/.gitignore.template`
- `skills/project-init/`
- `skills/schema-design/SKILL.md`
- `README.md`
- `.ai/memory/episodes/`
