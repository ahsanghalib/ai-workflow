# Draft master plan from confirmed product intent

Date: 2026-09-13
Feature: project-init

## Context

TASK-0017 defines the first durable product-direction artifact after safe
empty-folder inspection.

## Goal

Complete TASK-0017 by defining a safe initial MASTER_PLAN.md draft from the user request without invented scope or technical decisions.

## Why

An idea such as “build an expense-tracking app” is not enough evidence to
choose a stack, schema, screens, or implementation tasks. The draft must help
the user review direction without turning guesses into requirements.

## Outcome

Added explicit draft rules to project-init, workflow, and helper prompt: confirmed facts stay distinct, mentioned ideas are proposed, unknowns remain open, and creation or revision requires review.

## Current State

TASK-0001 through TASK-0017 are complete. TASK-0018, the bounded technical and
project-shape question set, is next. No application code, framework choice, or
technical decision was generated.

## Important Findings

- The existing `MASTER_PLAN.md` template already separates product direction,
  proposed features, assumptions, recommendations, open questions, and
  technical direction.
- A new master plan needs a missing-file approval; an existing plan or
  equivalent source-of-truth revision needs a separate approval.
- The plan status must remain `Draft` or `Proposed`; project-init cannot mark it
  approved for the user.

## Decisions

- Use only the user's request and confirmed answers for the initial draft.
- Put user-mentioned possibilities in proposed scope, never silently in
  confirmed requirements.
- Leave unknown users, priorities, stack, database, authentication, local
  development, and other technical decisions open.

## Failed Approaches

No implementation approach failed; this task was intentionally documentation
and behavior-contract work with no meaningful runnable behavior seam.

## Validation

- Markdown lint and focused inspection of the template sections, draft rules,
  status handling, and approval routing passed.

## Open Questions

The user still needs to answer the project-shape and technical questions before
those decisions can be recorded as confirmed.

## Next Steps

Implement TASK-0018 and keep the question set bounded to decisions that affect
the generated project-control documents.

## Relevant Files

- `skills/project-init/SKILL.md` — initial master-plan draft contract.
- `skills/project-init/references/workflow.md` — draft and approval sequence.
- `skills/project-init/templates/MASTER_PLAN.md` — evidence categories and
  status fields.
- `skills/project-init/templates/.ai/prompts/define-master-plan.md` — helper
  prompt routing.
- `IMPLEMENTATION_PLAN.md` — task order and validation exception.
