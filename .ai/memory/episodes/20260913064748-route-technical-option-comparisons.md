# Route technical option comparisons

Date: 2026-09-13
Feature: project-init

## Context

TASK-0029 adds the technical-option comparison handoff after reconciliation
and technical-question collection.

## Goal

Complete TASK-0029 by routing architecture options and current behavior verification to the specialized skills.

## Why

Project-init should coordinate decisions without pretending a recommendation is
approval. Version-sensitive framework and API behavior also needs current
authoritative verification.

## Outcome

Added technical-options reference: bounded comparisons cover shape, stack, persistence, ORM/query-builder/raw-SQL, migrations, auth, local development, quality, and delivery; options stay proposed until approval.

## Current State

TASK-0001 through TASK-0029 are complete. TASK-0030, recording approved stack
and local-development details, is next. No technical option was selected by
this task.

## Important Findings

- `technical-design` owns bounded architecture and trade-off comparison.
- `source-driven-development` owns current documented behavior verification for
  frameworks, libraries, runtimes, APIs, and providers.
- ORM/query-builder/raw-SQL and migration ownership need to be compared as one
  persistence decision, not isolated tool preferences.

## Decisions

- Keep all options proposed until the user explicitly approves one.
- Include evidence, trade-offs, risk, reversibility, operational impact, and
  validation needs in the comparison.
- Do not install packages, scaffold code, create migrations, access remotes, or
  inspect `.env` values during comparison.

## Failed Approaches

No implementation approach failed; this was documentation-only routing and
comparison-contract work with no meaningful runnable behavior seam.

## Validation

- Markdown lint and focused inspection of the technical-options reference,
  skill routing, required decision coverage, and proposal status passed.

## Open Questions

Each project still needs a real bounded comparison and explicit user approval
before its selected options can be recorded.

## Next Steps

Implement TASK-0030 with approved choices only and record them at the owning
document boundaries.

## Relevant Files

- `skills/project-init/references/technical-options.md` — comparison contract.
- `skills/project-init/SKILL.md` — routing.
- `skills/project-init/references/workflow.md` — handoff.
- `skills/project-init/templates/.ai/prompts/choose-technical-direction.md` —
  question entrypoint.
- `IMPLEMENTATION_PLAN.md` — task order and evidence.
