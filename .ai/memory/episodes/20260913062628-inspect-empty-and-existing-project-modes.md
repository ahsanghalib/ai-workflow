# Inspect empty and existing project modes

Date: 2026-09-13
Feature: project-init

## Context

TASK-0016 adds the deterministic inspection step that must precede a
project-init bootstrap or reconciliation proposal.

## Goal

Complete TASK-0016 with a safe no-write inspection and proposal for empty, Git-only, and existing targets.

## Why

The initializer writes documentation, so the agent needs a separate read-only
inspection that proves the target and mode before any approval or mutation.

## Outcome

Added inspect-project.sh and disposable coverage; it reports canonical target, mode, safe entry names, Git state, and proposal shape without reading .env contents or mutating files.

## Current State

TASK-0001 through TASK-0016 are complete. TASK-0017, initial master-plan draft
generation, is next. The inspector and initializer remain separate: inspection
does not create directories, copy templates, or mutate Git.

## Important Findings

- Immediate entry names are enough to classify empty, `.git`-only, and all
  other targets without opening file contents.
- `.env` can be reported by name for classification while its contents remain
  absent from output; the test includes a sentinel to enforce this boundary.
- A `.git`-only directory is a new-project bootstrap with existing Git state,
  not a request for a second `git init`.

## Decisions

- `inspect-project.sh` is read-only and reports the canonical target, mode,
  safe entry names, Git state, and proposal shape.
- Existing targets use reconciliation mode rather than being rejected merely
  because they are non-empty.
- The helper prints a no-write proposal and leaves conversational approval to
  the project-init agent.

## Failed Approaches

The initial test was written before the helper existed and failed with a
missing-script error; adding the helper and preserving the safe output contract
made the test pass.

## Validation

- `bash skills/project-init/tests/test-inspect-project.sh` passed.
- `shellcheck skills/project-init/scripts/inspect-project.sh
  skills/project-init/tests/test-inspect-project.sh` passed.
- `bash -n skills/project-init/scripts/inspect-project.sh` passed.
- The existing initializer/path-safety test also passed.
- `git diff --check` passed.

## Open Questions

The conversational layer still needs to turn the inspection result and the
user's product sentence into a clearly labeled draft `MASTER_PLAN.md`.

## Next Steps

Implement TASK-0017 without inventing technical choices or unconfirmed product
scope.

## Relevant Files

- `skills/project-init/scripts/inspect-project.sh` — read-only inspector.
- `skills/project-init/tests/test-inspect-project.sh` — mode and secret-output
  coverage.
- `skills/project-init/SKILL.md` — inspector invocation and proposal boundary.
- `skills/project-init/references/workflow.md` — inspection contract.
- `README.md` — user-facing helper usage.
- `IMPLEMENTATION_PLAN.md` — task order and acceptance evidence.
