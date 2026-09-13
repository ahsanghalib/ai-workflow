# Preserve existing source-of-truth layouts

Date: 2026-09-13
Feature: project-init

## Context

TASK-0023 defines source-of-truth detection after the safe existing-project
inventory.

## Goal

Complete TASK-0023 by defining candidate detection, source selection, preservation, and conflict reporting for existing project documents.

## Why

Existing projects may use `PLANS.md`, a custom architecture path, nested
instructions, or generated documents. Creating the bundled names beside them
would split ownership and make later work ambiguous.

## Outcome

Added source-of-truth reference and routing: enumerate instruction, planning, architecture, user-flow, schema, and repository candidates; preserve established names; report conflicts and generator ownership; never create duplicate trees silently.

## Current State

TASK-0001 through TASK-0023 are complete. TASK-0024, populating missing
Markdown from confirmed evidence and labelling inferences, is next. No
existing source-of-truth file was changed.

## Important Findings

- Candidate detection must cover instruction, planning, architecture,
  user-flow, persisted-data, and repository/operations groups.
- A candidate is evidence, not automatic authority; multiple candidates need a
  conflict report and user decision.
- Generated outputs require generator ownership detection so reconciliation
  updates the generator rather than editing generated output directly.

## Decisions

- Preserve established names and locations when one source clearly owns a
  document type.
- Never create a second planning, architecture, schema, user-flow, or
  instruction tree silently.
- Treat missing-file creation and existing-file revision as separate approvals.

## Failed Approaches

No implementation approach failed; this was documentation-only source-of-truth
and conflict-routing work with no meaningful runnable behavior seam.

## Validation

- Markdown lint and focused inspection of candidate groups, precedence,
  preservation, conflict, generator, and approval rules passed.

## Open Questions

Each existing project may still need a user decision when multiple plans,
architectures, schemas, or instruction sources conflict.

## Next Steps

Implement TASK-0024 and ensure newly generated Markdown distinguishes confirmed
evidence from inference, recommendation, assumption, and unknown.

## Relevant Files

- `skills/project-init/references/source-of-truth.md` — candidate and selection
  rules.
- `skills/project-init/SKILL.md` — reconciliation routing.
- `skills/project-init/references/workflow.md` — evidence boundaries.
- `skills/project-init/templates/.ai/prompts/reconcile-existing-project.md` —
  helper prompt.
- `IMPLEMENTATION_PLAN.md` — task order and evidence.
