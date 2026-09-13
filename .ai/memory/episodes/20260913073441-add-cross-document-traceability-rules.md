# Add cross-document traceability rules

Date: 2026-09-13
Feature: project-init

## Context

User flow, schema, API, frontend, SPEC, and PLAN templates existed, but their
cross-document references and schema-impact triggers were not required as one
explicit contract.

## Goal

Complete TASK-0049 by linking user flows, approved schema entities, API/shared contracts, frontend surfaces, SPECs, and PLANs with schema-impact review.

## Why

Prevent API or UI work from inventing persistence behavior and make changes
propagate through the correct review gates before implementation.

## Outcome

Added the traceability reference, SPEC/PLAN template fields, API/frontend/shared-contract rules, prompt guidance, routed links, and a disposable contract test.

## Current State

TASK-0049 is complete. The traceability reference defines required links and
schema-impact categories; templates and API/frontend/shared-contract rules
carry those requirements into new project documents.

## Important Findings

- `USER_FLOW.md` should remain technology-neutral, while SPEC/PLAN and contract
  documents carry the exact anchors and approved entity references.
- A frontend surface should normally trace persisted data through API/shared
  contracts rather than inventing database fields directly.

## Decisions

- Required traceability fields include user-flow references, approved schema
  entities or an explicit not-applicable/unresolved state, API/shared-contract
  references, frontend surfaces, and schema impact.
- Any impact beyond none or confirmed read-only use requires schema-impact
  review before implementation planning continues.
- Changes propagate from flow/schema/API/contract edits to affected SPEC, PLAN,
  frontend, migration, and compatibility reviews.

## Failed Approaches

- The first combined validation command used markdownlint option placement that
  caused the CLI to print usage; the focused checks were rerun with the
  repository's documented `--disable ... -- files` syntax.

## Validation

- Red -> Green: the traceability contract test first failed because the
  reference was absent, then passed after the reference and template/rule
  guidance were added.
- Targeted Markdown lint, routed-reference validation, Bash syntax,
  ShellCheck, and the aggregate disposable suite pass.

## Open Questions

- Existing projects may use different document names or anchors; reconciliation
  must preserve their established source-of-truth layout.

## Next Steps

- Continue with TASK-0050: document and test the final application-output
  boundary for project-init.

## Relevant Files

- `skills/project-init/references/traceability.md`
- `skills/project-init/templates/docs/templates/SPEC.md`
- `skills/project-init/templates/docs/templates/PLAN.md`
- `skills/project-init/templates/docs/rules/API.md`
- `skills/project-init/templates/docs/rules/FRONTEND.md`
- `skills/project-init/templates/docs/rules/CONTRACTS.md`
- `skills/project-init/tests/test-traceability-contract.sh`
