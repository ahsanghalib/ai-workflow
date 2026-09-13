# Ask bounded technical project questions

Date: 2026-09-13
Feature: project-init

## Context

TASK-0018 turns the technical-decision requirements into a reusable question
set after the product-direction draft.

## Goal

Complete TASK-0018 with structured questions before recording stack, persistence, authentication, and local-development decisions.

## Why

Project-init must capture enough information to build the right Markdown
contracts without silently choosing a repository shape, database access model,
authentication boundary, or local environment.

## Outcome

Added a reusable technical questionnaire and expanded technical-direction routing to ask project shape, stack, data access, migration, auth, local, testing, environment, and delivery questions without inventing answers.

## Current State

TASK-0001 through TASK-0018 are complete. TASK-0019, recording approved
technical decisions in the project documents, is next. No stack or persistence
choice was made by this task.

## Important Findings

- The technical questionnaire needs to distinguish unanswered questions from
  recommendations and confirmed decisions.
- ORM, query-builder, raw-SQL, and migration ownership must be asked together
  because they define the database contract and later implementation boundary.
- Environment setup must record variable names and safe instructions only; it
  must never request or inspect secret values.

## Decisions

- Ask only decision groups that affect the requested artifacts, while covering
  project shape, language/runtime, persistence, access style, migrations, auth,
  local development, testing, and delivery constraints when relevant.
- Allow `unknown`, `not applicable`, and `recommend options` answers.
- Route option comparisons to `technical-design` and current behavior checks to
  `source-driven-development`.

## Failed Approaches

No implementation approach failed; this was documentation-only routing and
questionnaire work with no meaningful runnable behavior seam.

## Validation

- Markdown lint and focused inspection of the questionnaire sections, answer
  labels, secret boundary, and helper-prompt routing passed.

## Open Questions

The user must provide or approve the technical answers before the documents can
  record them as confirmed decisions.

## Next Steps

Implement TASK-0019 with explicit approval and source-of-truth boundaries for
  each selected technical decision.

## Relevant Files

- `skills/project-init/references/technical-questionnaire.md` — question set.
- `skills/project-init/references/workflow.md` — interview routing.
- `skills/project-init/templates/.ai/prompts/choose-technical-direction.md` —
  helper prompt.
- `IMPLEMENTATION_PLAN.md` — task order and evidence.
