# Protect worktree root and nested targets

Date: 2026-09-13
Feature: project-init

## Context

Project-init can create files in a requested directory, so a path nested inside
the current Git worktree needs an explicit safety decision before creation.

## Goal

Complete TASK-0043 by making project-init report the enclosing worktree and prevent accidental nested initialization.

## Why

Prevent an accidental bootstrap inside the repository that owns the skill or
inside another active project while still supporting an intentionally selected
nested target.

## Outcome

Added worktree-root and nested-target reporting to inspection; initializer now refuses nested targets before creating them unless --allow-nested is explicitly supplied. Disposable Red -> Green tests cover existing and missing nested targets.

## Current State

TASK-0043 is complete. Inspection reports the enclosing worktree and whether
the target is nested. Initialization rejects nested targets before creating
missing directories unless the caller supplies `--allow-nested`.

## Important Findings

- The nested-target check must run before `mkdir -p` so a rejected missing
  target leaves no directory or generated files behind.
- Existing Git metadata is preserved; explicit `--init-git` remains separate
  from the nested-target override.

## Decisions

- Prefer the enclosing worktree root as the safe target boundary.
- Report the boundary in read-only inspection so the user can approve the
  exact nested target knowingly.
- Keep `--allow-nested` narrowly scoped to the exact initializer invocation.

## Failed Approaches

-

## Validation

- Red -> Green disposable tests cover existing nested targets and missing
  nested targets; the rejected missing target is confirmed uncreated.
- `bash -n`, ShellCheck, and the aggregate project-init test suite pass.
- Focused inspection confirms worktree-root and nested-target output.

## Open Questions

- Live discovery/reload behavior of an installed harness remains unverified.

## Next Steps

- Continue with TASK-0044: document native `/init` compatibility, AGENTS.md
  precedence, and fresh-session/reload handoff after instruction changes.

## Relevant Files

- `skills/project-init/scripts/inspect-project.sh`
- `skills/project-init/scripts/init-project.sh`
- `skills/project-init/tests/test-inspect-project.sh`
- `skills/project-init/tests/test-project-init.sh`
- `skills/project-init/SKILL.md`
- `skills/project-init/references/workflow.md`
