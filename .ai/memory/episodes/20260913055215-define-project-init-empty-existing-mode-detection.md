# Define project-init empty-existing mode detection

Date: 2026-09-13
Feature: project-init

## Context

The approved `IMPLEMENTATION_PLAN.md` is being implemented one dependency-
ordered task at a time. TASK-0001 already enabled the simple project-init
request; TASK-0002 covers target mode classification.

## Goal

Define deterministic, safe rules for distinguishing a new/empty target from an
existing project that must be reconciled.

## Why

The first prompt should work without requiring internal mode names, while
existing files must never be treated as disposable bootstrap material. The
classification must also respect the repository's secret and approval
boundaries.

## Outcome

Updated the project-init skill and workflow reference with explicit rules for
empty targets, `.git`-only targets, and all other non-empty targets. The
initializer script was intentionally left unchanged because it remains a
deterministic copier rather than the mode-detection owner.

## Current State

TASK-0001 and TASK-0002 are complete. TASK-0003, which defines proposal,
review, approval, write, and handoff states, is next. No application code,
framework, dependency, Git mutation, or remote operation was performed.

## Important Findings

- Immediate directory entries are sufficient for mode classification; file
  contents must not be opened for this decision.
- No entries means new/empty. Exactly one `.git` entry means new with existing
  Git metadata. Any other entry means existing/reconciliation.
- Hidden files, symlinks, `.gitignore`, `.env`, and secret-looking files all
  make a target non-empty, but their contents must not be read or printed.
- Mode classification is separate from Git state; `.git`-only targets must not
  receive a second `git init` proposal.

## Decisions

- Reconcile every non-empty target rather than rejecting incomplete projects.
- Keep Git initialization as a separate approval-gated operation after mode
  classification.
- Keep the copier deterministic; orchestration owns inspection and proposal
  behavior.

## Failed Approaches

No implementation approach failed. The initial memory-command invocation used
an inline shell assignment whose variable expansion was empty; it was rerun
with the explicit authorized project path and succeeded without repository
mutation.

## Validation

- `markdownlint skills/project-init/SKILL.md
  skills/project-init/references/workflow.md IMPLEMENTATION_PLAN.md
  SESSION_STATE.md` passed.
- `bash validate-skills.sh` passed.
- `git diff --check` passed.
- Focused inspection confirmed only TASK-0001 and TASK-0002 are marked complete.
- Disposable runtime behavior is not yet exercised; it is covered by later
  implementation/test tasks.

## Open Questions

No new design questions. Runtime fixture coverage remains future work.

## Next Steps

Implement only TASK-0003 next: define proposal, review, approval, write, and
handoff states for documentation and local Git initialization.

## Relevant Files

- `IMPLEMENTATION_PLAN.md` — approved task order and acceptance criteria.
- `skills/project-init/SKILL.md` — public project-init behavior contract.
- `skills/project-init/references/workflow.md` — detailed mode-detection and
  approval workflow.
- `SESSION_STATE.md` — current short-term handoff state.
