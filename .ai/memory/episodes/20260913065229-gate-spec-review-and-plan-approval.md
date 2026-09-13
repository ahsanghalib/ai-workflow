# Gate SPEC review and PLAN approval

Date: 2026-09-13
Feature: project-init

## Context

TASK-0032 completes the feature lifecycle after a proposed SPEC exists.

## Goal

Complete TASK-0032 with ordered SPEC review, PLAN creation, index update, separate reviews, and explicit user approval.

## Why

The user needs a reliable review sequence so implementation planning does not
start from incomplete behavior and no assistant action can silently approve the
plan.

## Outcome

Added lifecycle rules and prompts: reviewed SPEC before Proposed PLAN, stable IDs/index preservation, plan and consistency reviews, and no assistant approval or implementation.

## Current State

TASK-0001 through TASK-0032 are complete. TASK-0033, later-feature requests
such as income details, is next. No SPEC, PLAN, branch, or implementation was
created by this task.

## Important Findings

- `spec-review` must review the exact SPEC without approving or editing it.
- PLAN creation waits for accepted SPEC behavior, preserves the existing index,
  and allocates the next stable ID.
- `plan-review` and `plan-consistency-review` are separate read-only reviews;
  only the user changes the plan to Approved.

## Decisions

- Keep SPEC and PLAN statuses Proposed until user decisions explicitly change
  them.
- Do not create implementation tasks or branches before the PLAN approval gate.
- Treat index updates as part of plan creation while preserving unrelated rows.

## Failed Approaches

No implementation approach failed; this was documentation-only lifecycle and
approval routing work with no meaningful runnable behavior seam.

## Validation

- Markdown lint and focused inspection of SPEC/PLAN order, stable IDs, index
  preservation, review routing, and approval ownership passed.

## Open Questions

Each feature still needs a reviewed SPEC and user approval before its PLAN can
  become implementable.

## Next Steps

Implement TASK-0033 for later feature requests without bypassing the same
SPEC/review/PLAN/approval sequence.

## Relevant Files

- `skills/project-init/references/feature-lifecycle.md` — lifecycle order.
- `skills/project-init/templates/.ai/prompts/create-spec.md` — SPEC entrypoint.
- `skills/project-init/templates/.ai/prompts/create-plan.md` — PLAN entrypoint.
- `skills/project-init/templates/.ai/prompts/review-spec.md` and
  `review-plan.md` — read-only review routing.
- `IMPLEMENTATION_PLAN.md` — task order and evidence.
