# Order user flow before conditional schema

Date: 2026-09-13
Feature: project-init

## Context

TASK-0020 completes the ordering and conditional persistence contract for the
new-project bootstrap.

## Goal

Complete TASK-0020 with technology-neutral user-flow review before approved persisted-data schema design.

## Why

User behavior determines what data the product needs, while the schema is the
first technical contract that later APIs and frontend work must follow. A
schema placeholder for a non-persistent project would create false direction.

## Outcome

Made USER_FLOW first, DB_SCHEMA conditional on persistence approval, and routed schema design and access/migration decisions to schema-design without generating implementation artifacts.

## Current State

TASK-0001 through TASK-0020 are complete. TASK-0021, reporting created files,
assumptions, unresolved decisions, validation, and next review action, is next.
No migrations, models, tables, routes, or UI were created.

## Important Findings

- `docs/USER_FLOW.md` can identify data needs without selecting tables, routes,
  frameworks, or storage.
- `docs/DB_SCHEMA.md` should be created or populated only after persistence is
  approved and the user flow is reviewed.
- Database engine, ORM/query-builder/raw-SQL or mixed access, and migration
  ownership belong in the schema design contract and need `schema-design`.

## Decisions

- Preserve the sequence `MASTER_PLAN -> USER_FLOW -> approved DB_SCHEMA -> API
  and frontend contracts` when persistence is in scope.
- Keep schema work design-only in project-init.
- Leave the schema document absent or proposed when persistence is not approved.

## Failed Approaches

No implementation approach failed; this was documentation-only sequencing and
routing work with no meaningful runnable behavior seam.

## Validation

- Markdown lint and focused inspection of the user-flow template, schema
  template, conditional-copy rule, schema-design prompt, and implementation
  boundary passed.

## Open Questions

Each project still needs a reviewed user flow and an explicit persistence
  decision before its schema can be approved.

## Next Steps

Implement TASK-0021 and make the bootstrap handoff report complete, reviewable,
and precise about validation and unresolved work.

## Relevant Files

- `skills/project-init/SKILL.md` — user-flow/schema order and boundary.
- `skills/project-init/references/workflow.md` — conditional schema workflow.
- `skills/project-init/templates/docs/USER_FLOW.md` — behavior contract.
- `skills/project-init/templates/docs/DB_SCHEMA.md` — persisted-data contract.
- `skills/project-init/templates/.ai/prompts/design-database-schema.md` —
  schema-design routing.
- `IMPLEMENTATION_PLAN.md` — task order and evidence.
