# Expand master plan project-control template

Date: 2026-09-13
Feature: project-init

## Context

TASK-0007 updates the generated `MASTER_PLAN.md` template after the schema,
user-flow, and approval prompt work.

## Goal

Make product direction and technical decisions reviewable without mixing them
with detailed user behavior or implementation planning.


## Why

The initial product prompt must produce a useful draft while clearly separating
confirmed scope from proposals, assumptions, recommendations, and unknowns.

## Outcome

Added status and review metadata, decision sections, technical direction
fields, references to `USER_FLOW.md` and `DB_SCHEMA.md`, and explicit approval
gates to the master-plan template.


## Current State

TASK-0001 through TASK-0007 are complete. The template remains product-level
and does not invent application entities or implementation tasks. TASK-0008 is
next.

## Important Findings

- `MASTER_PLAN.md` should point to detailed flow and schema documents rather
  than duplicate them.
- Proposed features and technical recommendations must not look like approved
  decisions.

## Decisions

- Keep the master plan high-level and add explicit status/approval fields.
- Preserve the design sequence: master plan, user flow, schema, then feature
  SPECs and PLANs.

## Failed Approaches

The first lint run found pre-existing placeholder and line-length issues in the
template. The template was corrected with inline-code placeholders and wrapped
comments without changing its intended structure.

## Validation

- `markdownlint skills/project-init/templates/MASTER_PLAN.md` passed.
- Focused inspection confirmed the status, decision, reference, and approval
  sections.

## Open Questions

No new design questions.

## Next Steps

Continue with TASK-0008: route generated agents to prompts, user flow, schema,
and the existing companion skills.
-

## Relevant Files

- `skills/project-init/templates/MASTER_PLAN.md` — generated product-direction
  template.
- `IMPLEMENTATION_PLAN.md` — task order and activity evidence.
- `SESSION_STATE.md` — current short-term handoff state.
