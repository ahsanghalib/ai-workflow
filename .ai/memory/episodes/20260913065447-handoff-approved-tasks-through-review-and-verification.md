# Handoff approved tasks through review and verification

Date: 2026-09-13
Feature: project-init

## Context

TASK-0034 closes the planning workflow by defining the handoff after explicit
PLAN approval.

## Goal

Complete TASK-0034 with bounded implementation, review, verification, and continuity handoffs.

## Why

Project-init owns project-control documents, not application implementation. The
handoff must preserve bounded task scope, TDD, review, verification, and
continuity without bypassing approvals.

## Outcome

Added lifecycle and prompt rules to hand only the next approved task to implement-next plus backend/frontend skills, then route review, verification, session-state, and memory without project-init implementing code.

## Current State

TASK-0001 through TASK-0034 are complete. TASK-0035, root README coverage for
the full workflow, is next. No implementation task was run.

## Important Findings

- Only the next approved task should be handed to `implement-next` and the
  relevant backend/frontend skill.
- Completed work needs `code-review` or `review-diff` plus
  `verification-before-completion` before a success claim.
- `SESSION_STATE.md` and project memory are continuity artifacts, not a reason
  to broaden implementation scope.

## Decisions

- Keep project-init implementation-free.
- Use manual handoff reporting when a named capability is unavailable.
- Update session state and memory after meaningful work or before handoff.

## Failed Approaches

No implementation approach failed; this was documentation-only handoff work
with no meaningful runnable behavior seam.

## Validation

- Markdown lint and focused inspection of implementation, review, verification,
  session-state, and memory routing passed.

## Open Questions

Actual implementation work remains dependent on a user-approved PLAN and the
relevant project-specific repository context.

## Next Steps

Implement TASK-0035 by aligning the root README with the completed project-init
workflow and user-facing commands.

## Relevant Files

- `skills/project-init/references/feature-lifecycle.md` — approved handoff.
- `skills/project-init/SKILL.md` — validation and companion routing.
- `skills/project-init/templates/.ai/prompts/create-plan.md` — plan handoff.
- `IMPLEMENTATION_PLAN.md` — task order and evidence.
