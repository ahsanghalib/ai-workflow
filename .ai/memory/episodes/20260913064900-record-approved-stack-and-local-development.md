# Record approved stack and local development

Date: 2026-09-13
Feature: project-init

## Context

TASK-0030 defines the post-review recording step for selected stack and local
development decisions.

## Goal

Complete TASK-0030 by requiring review before recording stack and local-development decisions, while leaving unknowns open.

## Why

Technical suggestions and framework defaults are not user approval. Recording
them as confirmed would constrain later schema, API, frontend, and task work
without a deliberate decision.

## Outcome

Technical option and master-plan templates now require status, selected value, rationale, evidence, approval, boundaries, and verified commands; recommendations and defaults cannot become confirmed silently.

## Current State

TASK-0001 through TASK-0030 are complete. TASK-0031, initial feature-map and
SPEC-generation flow, is next. No stack or local-development value was selected
by this task.

## Important Findings

- A recorded decision needs status, selected value, rationale, evidence,
  approval, and boundary.
- Operational commands in `AGENTS.md` must be verified for the selected local
  toolchain before being treated as instructions.
- Unknown and proposed values must remain visibly unresolved.

## Decisions

- Record approved high-level direction in the master plan and architecture,
  operational details in AGENTS, and persistence details in DB_SCHEMA.
- Do not promote recommendations or defaults to confirmed choices.
- Keep existing-file revision approvals separate.

## Failed Approaches

No implementation approach failed; this was documentation-only decision-status
and recording work with no meaningful runnable behavior seam.

## Validation

- Markdown lint and focused inspection of status, approval, evidence, unknown,
  boundary, and command-verification language passed.

## Open Questions

Each project still needs the user's explicit technical selections and verified
local command set.

## Next Steps

Implement TASK-0031 by deriving a proposed feature map from reviewed product
direction and user flow without marking features approved.

## Relevant Files

- `skills/project-init/references/technical-options.md` — decision recording.
- `skills/project-init/templates/MASTER_PLAN.md` — status guidance.
- `skills/project-init/templates/.ai/prompts/record-technical-decisions.md` —
  recording prompt.
- `IMPLEMENTATION_PLAN.md` — task order and evidence.
