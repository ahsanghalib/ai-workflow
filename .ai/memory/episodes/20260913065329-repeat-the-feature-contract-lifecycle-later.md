# Repeat the feature contract lifecycle later

Date: 2026-09-13
Feature: project-init

## Context

TASK-0033 applies the feature lifecycle to later requests after a project has
already started.

## Goal

Complete TASK-0033 for later feature requests such as adding income details.

## Why

Requests such as “create a SPEC for adding income details” should not bypass
the existing user-flow, schema, review, and approval contracts or change
unrelated project documents.

## Outcome

Later requests are classified as new feature, SPEC revision, or approved task; only the requested SPEC changes, and the same flow repeats through review, PLAN, and explicit approval.

## Current State

TASK-0001 through TASK-0033 are complete. TASK-0034, implementation/review/
verification/session handoffs, is next. No later feature SPEC or PLAN was
created by this task.

## Important Findings

- A later request may be a new feature, a revision to an existing SPEC, or an
  already-approved implementation task; classification comes first.
- Contract reading and schema-impact traceability remain required for later
  features.
- The same review and approval sequence must repeat, with unrelated files left
  unchanged.

## Decisions

- Use the income-details example as a routing example only, not approved scope.
- Change only the requested SPEC or planning artifact after the relevant gate.
- Keep the feature lifecycle consistent from initial map through later work.

## Failed Approaches

No implementation approach failed; this was documentation-only lifecycle
guidance with no meaningful runnable behavior seam.

## Validation

- Markdown lint and focused inspection of feature classification, example
  routing, contract reading, traceability, and repeated review gates passed.

## Open Questions

Each later request still needs classification and the user's explicit scope
before its SPEC is created or revised.

## Next Steps

Implement TASK-0034 and define the handoff from approved plans to implementation
and post-change review/verification.

## Relevant Files

- `skills/project-init/SKILL.md` — later-feature routing.
- `skills/project-init/references/feature-lifecycle.md` — repeated lifecycle.
- `skills/project-init/templates/.ai/prompts/create-spec.md` — later-feature
  prompt.
- `IMPLEMENTATION_PLAN.md` — task order and evidence.
