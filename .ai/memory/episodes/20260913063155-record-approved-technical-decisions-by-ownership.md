# Record approved technical decisions by ownership

Date: 2026-09-13
Feature: project-init

## Context

TASK-0019 follows technical-question collection and defines how approved
answers propagate through project-control documents.

## Goal

Complete TASK-0019 by defining where approved technical decisions belong and keeping existing documents separately approval-gated.

## Why

Without ownership boundaries, one answer can be duplicated inconsistently in
the roadmap, architecture, and operational instructions, or be written before
approval.

## Outcome

Added ownership rules and a helper prompt: master plan for direction, architecture for boundaries and stack, AGENTS for operations, and DB_SCHEMA for persisted-data design.

## Current State

TASK-0001 through TASK-0019 are complete. TASK-0020, conditional schema
generation and user-flow-before-schema ordering, is next. No existing project
document was revised by this task.

## Important Findings

- `MASTER_PLAN.md` should carry high-level direction and rationale, not command
  details or table definitions.
- `docs/PROJECT_ARCHITECTURE.md` owns boundaries, stack, data flow, local
  architecture, and invariants.
- `AGENTS.md` owns commands, validation, environment-variable names,
  generated-file ownership, and routing; secret values remain excluded.
- Persistent entities, access style, and migration ownership belong in the
  approved database schema document.

## Decisions

- Record only explicitly approved technical decisions.
- Treat revisions to each existing document as a separate approval scope.
- Use a tracked helper prompt to route the recording workflow without making
  prompts automatic authority.

## Failed Approaches

No implementation approach failed; this was documentation-only ownership and
routing work with no meaningful runnable behavior seam.

## Validation

- Markdown lint and focused inspection of ownership language, approval gates,
  schema boundary, and helper-prompt map passed.

## Open Questions

The selected technical answers still need to be supplied and approved before
the ownership rules can be used to update a real project.

## Next Steps

Implement TASK-0020 and preserve the sequence USER_FLOW before DB_SCHEMA before
dependent API or frontend contracts.

## Relevant Files

- `skills/project-init/SKILL.md` — decision ownership contract.
- `skills/project-init/references/workflow.md` — recording rule.
- `skills/project-init/templates/.ai/prompts/record-technical-decisions.md` —
  helper prompt.
- `skills/project-init/templates/AGENTS.md` and `.ai/prompts/README.md` —
  routing map.
- `IMPLEMENTATION_PLAN.md` — task order and evidence.
