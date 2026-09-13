# Add project user flow and database schema templates

Date: 2026-09-13
Feature: project-init

## Context

TASK-0005 of the approved project-init plan adds the durable project documents
that separate user behavior from persisted-data design.

## Goal

Provide reusable, technology-neutral `docs/USER_FLOW.md` and
`docs/DB_SCHEMA.md` templates without inventing product-specific scope.


## Why

The user flow explains how actors use the product, while the schema becomes
the first technical contract that dependent APIs and frontend work follow.

## Outcome

Added both templates under `skills/project-init/templates/docs/`. The user-flow
template covers actors, journeys, states, permissions, validation, failures,
accessibility, dependencies, and approvals. The schema template covers fields,
relationships, constraints, indexes, tenancy, concurrency, access strategy,
migrations, privacy, validation, and approvals.


## Current State

TASK-0001 through TASK-0005 are complete. No application entities, migrations,
services, routes, UI, dependencies, or Git mutations were created. TASK-0006
is next.

## Important Findings

- Both documents must clearly distinguish confirmed, proposed, assumed, and
  unresolved information.
- `DB_SCHEMA.md` is a design contract only; it must not be mistaken for DDL or
  migration output.
- `USER_FLOW.md` can describe data needs but must not silently define tables or
  API routes.

## Decisions

- Keep the two documents separate and link them through explicit dependencies.
- Keep placeholders technology-neutral and use inline code for template values
  so the templates pass Markdown lint.
- Include approval gates and non-goals in both templates.

## Failed Approaches

The first template lint run treated angle-bracket placeholders as HTML and
found an ambiguous nested list. Placeholders were converted to inline code,
comments were wrapped, and the list structure was corrected.

## Validation

- `markdownlint skills/project-init/templates/docs/DB_SCHEMA.md
  skills/project-init/templates/docs/USER_FLOW.md` passed.
- Runtime project initialization and downstream API/frontend traceability are
  not exercised yet; later tasks cover copying and routing.

## Open Questions

No new design questions. The initializer's conditional copy behavior remains
  a later task.

## Next Steps

Continue with TASK-0006: add the tracked `.ai/prompts/` helper-prompt library.

## Relevant Files

- `skills/project-init/templates/docs/DB_SCHEMA.md` — persisted-data template.
- `skills/project-init/templates/docs/USER_FLOW.md` — user-behavior template.
- `IMPLEMENTATION_PLAN.md` — task order and activity evidence.
- `SESSION_STATE.md` — current short-term handoff state.
