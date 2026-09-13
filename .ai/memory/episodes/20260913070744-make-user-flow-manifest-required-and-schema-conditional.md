# Make user-flow manifest required and schema conditional

Date: 2026-09-13
Feature: project-init

## Context

TASK-0041 hardens the project-init template manifest after the scaffold and
conditional schema behavior exist.

## Goal

Complete TASK-0041 with a required/optional/preserve template manifest.

## Why

The user-flow contract is needed for every organized project, while a schema
document is only correct when persistence is approved. Existing project layouts
must not be duplicated by a generic manifest.

## Outcome

Added template-manifest reference: USER_FLOW is required, DB_SCHEMA is optional after persistence approval and user-flow review, and existing files/source-of-truth layouts remain preserve-first; scaffold tests pass.

## Current State

TASK-0001 through TASK-0041 are complete. TASK-0042, evidence-to-document
mapping for reconciliation, is next.

## Important Findings

- `docs/USER_FLOW.md` is required in the normal documentation scaffold and is
  already copied by the initializer.
- `docs/DB_SCHEMA.md` must remain conditional and must follow user-flow review.
- Existing files, source-of-truth layouts, `.gitignore`, and `.ai/` content are
  preserve-first, not manifest overwrite targets.

## Decisions

- Keep the manifest as an internal policy reference, not a generated project
  file by default.
- Required, optional, and preserve categories are explicit.
- Retain copy-if-missing and approval boundaries in the helper behavior.

## Failed Approaches

No implementation approach failed; the existing aggregate scaffold test passed
after the manifest contract was added.

## Validation

- Markdown lint, root validator, and aggregate disposable scaffold tests passed.

## Open Questions

The manifest still needs evidence-to-document ownership details for
reconciliation, which is the next hardening task.

## Next Steps

Implement TASK-0042 and map safe evidence to document fields and generators.

## Relevant Files

- `skills/project-init/references/template-manifest.md` — manifest policy.
- `skills/project-init/references/workflow.md` — manifest ordering.
- `skills/project-init/SKILL.md` — manifest routing.
- `skills/project-init/tests/test-project-init.sh` — required/optional output
  checks.
- `IMPLEMENTATION_PLAN.md` — task order and evidence.
