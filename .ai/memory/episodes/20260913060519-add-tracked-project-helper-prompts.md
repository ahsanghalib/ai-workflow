# Add tracked project helper prompts

Date: 2026-09-13
Feature: project-init

## Context

TASK-0006 adds the tracked `.ai/prompts/` helper library described by the
approved project-init plan.

## Goal

Provide concise, harness-neutral prompt entrypoints that route to existing
skills without becoming a second skill system.


## Why

Users need copyable prompts for the recurring project-control lifecycle, while
the repository must keep authority in the named skills and approval gates.

## Outcome

Added `.ai/prompts/README.md` plus helper prompts for bootstrap,
reconciliation, master-plan work, technical direction, schema design, SPEC and
PLAN creation/review, next-task implementation, and session handoff.


## Current State

TASK-0001 through TASK-0006 are complete. Prompt templates are tracked and
explicitly preserve `.env` and approval boundaries. TASK-0007 is next.

## Important Findings

- Helper prompts should route to skills rather than duplicate their full
  procedures.
- The prompt README must explain that `.ai/prompts/` is not automatic skill
  discovery or hidden authorization.
- Every prompt needs inspect-first, secret-safety, and stop-at-gate language.

## Decisions

- Keep the initial prompt inventory exactly as listed in the plan.
- Use Markdown-only prompts with no harness-specific commands or credentials.
- Keep prompt updates subject to normal project-control review.

## Failed Approaches

The initial prompt README table exceeded the repository Markdown line-length
rule; labels were shortened without changing the routing meaning.

## Validation

- `markdownlint skills/project-init/templates/.ai/prompts/*.md` passed.
- Focused inspection confirmed all planned prompt filenames exist and route to
  the intended skills.
- Runtime prompt discovery and harness behavior remain unexercised.

## Open Questions

No new design questions. Native harness loading remains covered by later
compatibility work.

## Next Steps

Continue with TASK-0007: update the generated master-plan template.
-

## Relevant Files

- `skills/project-init/templates/.ai/prompts/README.md` — prompt inventory and
  usage contract.
- `skills/project-init/templates/.ai/prompts/*.md` — helper entrypoints.
- `IMPLEMENTATION_PLAN.md` — task order and activity evidence.
- `SESSION_STATE.md` — current short-term handoff state.
