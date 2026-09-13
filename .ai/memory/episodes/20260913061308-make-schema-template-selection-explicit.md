# Make schema template selection explicit

Date: 2026-09-13
Feature: project-init

## Context

TASK-0012 changes the deterministic project-init copier so the optional schema
document is not created before persistence is approved.

## Goal

Make `docs/DB_SCHEMA.md` selection explicit while keeping the base scaffold
copy-if-missing and idempotent.


## Why

The schema is a design contract only when the project needs persistence. A
default bootstrap must not imply a database or create an irrelevant document.

## Outcome

Added `--with-schema` to `init-project.sh`. The default skips
`docs/DB_SCHEMA.md`; the explicit option copies it. Updated the workflow
reference and disposable test accordingly.


## Current State

TASK-0001 through TASK-0012 are complete. TASK-0013 is next. No application
code, migrations, dependencies, or Git mutations were created.

## Important Findings

- The original recursive copier copied every template, including the optional
  schema, by default.
- The focused test failed before the implementation and passed after the
  explicit selection logic was added.

## Decisions

- Keep schema generation opt-in through `--with-schema`; the orchestrator must
  pass it only after persistence approval.
- Preserve an existing schema file by copy-if-missing behavior and default
  skipping.

## Failed Approaches

No implementation approach failed after the red test; the red result correctly
identified the default-copy gap.

## Validation

- Red: the updated disposable test failed because the schema copied by default.
- Green: `bash skills/project-init/tests/test-init-project.sh` passed after the
  flag and selection logic were implemented.
- `shellcheck skills/project-init/scripts/init-project.sh
  skills/project-init/tests/test-init-project.sh` passed.
- Workflow documentation inspection passed.

## Open Questions

The later template-manifest task should generalize this option beyond the
schema file.

## Next Steps

Continue with TASK-0013: preserve existing `.gitignore` and report proposed
additions without overwriting it.
-

## Relevant Files

- `skills/project-init/scripts/init-project.sh` — optional schema selection.
- `skills/project-init/tests/test-init-project.sh` — red/green coverage.
- `skills/project-init/references/workflow.md` — selection contract.
- `IMPLEMENTATION_PLAN.md` — task order and activity evidence.
- `SESSION_STATE.md` — current short-term handoff state.
