# Derive proposed feature maps and SPECs

Date: 2026-09-13
Feature: project-init

## Context

TASK-0031 starts the feature lifecycle after product direction, user flow, and
technical/schema context are reviewed.

## Goal

Complete TASK-0031 with a review-gated feature map and SPEC-generation lifecycle.

## Why

The user wanted later requests such as “add income details” to follow the same
SPEC -> review -> PLAN path. A feature map must remain a proposal and must not
turn examples into approved scope.

## Outcome

Added feature-lifecycle reference and prompt routing: candidates derive from reviewed direction/flows/schema, the user selects one, SPECs remain Proposed, data traces to schema, and planning waits for review.

## Current State

TASK-0001 through TASK-0031 are complete. TASK-0032, SPEC review, PLAN creation,
plan-index update, and explicit approval gates, is next. No SPEC was created for
a real feature in this task.

## Important Findings

- Candidate features must derive from reviewed `MASTER_PLAN.md`,
  `docs/USER_FLOW.md`, and approved schema context when persistence matters.
- The user selects a candidate before its SPEC is created.
- SPECs must remain `Proposed` and trace persisted data to approved schema
  entities; PLAN work waits for review.

## Decisions

- Keep feature maps proposed with goals, flow references, data dependencies,
  ordering, risks, and open decisions.
- Create only the selected SPEC using the existing path and naming convention.
- Route SPEC review to `spec-review` and stop before implementation planning.

## Failed Approaches

No implementation approach failed; this was documentation-only lifecycle work
with no meaningful runnable behavior seam.

## Validation

- Markdown lint and focused inspection of feature derivation, user selection,
  SPEC status, traceability, later-feature behavior, and review routing passed.

## Open Questions

Each project still needs the user to choose a proposed feature before a SPEC is
created.

## Next Steps

Implement TASK-0032 with stable SPEC/PLAN IDs and explicit review/approval
status transitions.

## Relevant Files

- `skills/project-init/references/feature-lifecycle.md` — feature and SPEC
  contract.
- `skills/project-init/templates/.ai/prompts/create-spec.md` — SPEC prompt.
- `skills/project-init/templates/docs/templates/SPEC.md` — SPEC template.
- `skills/project-init/SKILL.md` and `references/workflow.md` — routing.
- `IMPLEMENTATION_PLAN.md` — task order and evidence.
