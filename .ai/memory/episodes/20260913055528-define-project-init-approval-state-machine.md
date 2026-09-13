# Define project-init approval state machine

Date: 2026-09-13
Feature: project-init

## Context

TASK-0003 of the approved project-init implementation plan follows the
empty-versus-existing mode contract. The project-control workflow needed one
explicit lifecycle for documentation writes and local Git initialization.

## Goal

Define proposal, review, approval, write, blocked, and handoff states with
operation-scoped approvals.

## Why

The initializer must not write files or mutate Git state while the user is
still reviewing a proposal. A broad approval must not accidentally authorize
revisions to existing files or a local `git init`.

## Outcome

Added a shared state sequence to the project-init skill and workflow reference:
Detected → Proposed → Awaiting review → Approved → Writing → Handoff, with a
Blocked state for unavailable capabilities or approvals. The plan and session
handoff now record TASK-0003 complete and TASK-0004 next.

## Current State

TASK-0001 through TASK-0003 are complete. No application code, dependency,
remote, commit, branch, or Git mutation was performed. The next task is
TASK-0004, which covers explicit `.env` exclusion and tracked `.ai/` behavior.

## Important Findings

- Proposal review must happen before any write or Git mutation.
- Missing-file creation, existing-file revision, and local `git init` are
  independent approval scopes.
- Handoff must report created, changed, preserved, skipped, blocked, and
  unresolved items, plus the next exact action.

## Decisions

- Use the same named state sequence in the entrypoint and detailed workflow
  reference to avoid contradictory approval behavior.
- A changed or rejected proposal returns to Proposed; unavailable approval or
  capability stops in Blocked without partial writes.
- `git init` remains local and exact-target-only; commits, remotes, branches,
  pushes, and other Git actions are never bundled.

## Failed Approaches

The first combined plan/session patch did not match the current session-state
wording and was split into smaller patches. No incorrect repository content
was left behind.

## Validation

- `markdownlint skills/project-init/SKILL.md
  skills/project-init/references/workflow.md IMPLEMENTATION_PLAN.md
  SESSION_STATE.md` passed.
- `bash validate-skills.sh` passed.
- `git diff --check` passed.
- Focused inspection confirmed the named state sequence and separate approval
  scopes are present in both project-init documents.
- Runtime interaction and disposable-directory tests remain unexercised.

## Open Questions

No new design questions. Runtime fixture coverage remains future work.

## Next Steps

Implement only TASK-0004 next: make `.env` exclusion and tracked `.ai/`
behavior explicit.

## Relevant Files

- `IMPLEMENTATION_PLAN.md` — approved task order and activity evidence.
- `skills/project-init/SKILL.md` — public lifecycle contract.
- `skills/project-init/references/workflow.md` — detailed approval sequence.
- `SESSION_STATE.md` — current short-term handoff state.
