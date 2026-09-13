# Make project-init handoffs reviewable

Date: 2026-09-13
Feature: project-init

## Context

TASK-0021 closes the initial new-project bootstrap contract before existing
project reconciliation begins.

## Goal

Complete TASK-0021 with complete bootstrap and reconciliation handoff reporting.

## Why

Users need to know exactly what changed, what remains uncertain, and what they
must review next. A generic “initialized” message is not enough for an
approval-gated documentation workflow.

## Outcome

Handoffs now report target, every file outcome, assumptions, unresolved decisions, validation commands and results, next review action, and explicit no-code/no-secret/no-remote boundaries.

## Current State

TASK-0001 through TASK-0021 are complete. TASK-0022, safe existing-project
inventory and evidence classification, is next. No application source,
dependency, migration, secret, commit, or remote operation was created.

## Important Findings

- A handoff must distinguish created, changed, preserved, skipped, and blocked
  files; this is especially important when existing-file revisions need a
  separate approval.
- Validation commands/results and unresolved decisions belong in the handoff,
  while `SESSION_STATE.md` remains the continuity record.
- The no-application/no-secret/no-remote boundary should be explicit so the
  user does not confuse project-control bootstrap with app scaffolding.

## Decisions

- Require target, file outcomes, assumptions, unresolved decisions, validation,
  next review action, and no-code/no-secret/no-remote status in every handoff.
- Apply the same report shape to new-project bootstrap and existing-project
  reconciliation.

## Failed Approaches

No implementation approach failed; this was documentation-only handoff work
with no meaningful runnable behavior seam.

## Validation

- Markdown lint and focused inspection of the workflow, bootstrap prompt,
  reconciliation prompt, and state-update guidance passed.

## Open Questions

The reconciliation inventory still needs a safe evidence taxonomy and
source-of-truth detection rules.

## Next Steps

Implement TASK-0022 without opening `.env`, credentials, private keys, browser
state, or other secret values.

## Relevant Files

- `skills/project-init/SKILL.md` — handoff state.
- `skills/project-init/references/workflow.md` — handoff checklist.
- `skills/project-init/templates/.ai/prompts/bootstrap-project.md` — bootstrap
  report.
- `skills/project-init/templates/.ai/prompts/reconcile-existing-project.md` —
  reconciliation report.
- `IMPLEMENTATION_PLAN.md` — task order and evidence.
