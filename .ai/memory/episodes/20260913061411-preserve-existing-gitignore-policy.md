# Preserve existing gitignore policy

Date: 2026-09-13
Feature: project-init

## Context

TASK-0013 covers `.gitignore` preservation and proposed additions in the
project-init scaffold.

## Goal

Ensure an existing ignore policy is never overwritten while a missing template
is copied safely and missing recommended rules remain reviewable proposals.


## Why

Projects may have intentional ignore rules. Automatic merges could hide user
decisions or accidentally change secret and tracked-document boundaries.

## Outcome

Added explicit skill and workflow rules for absent versus existing
`.gitignore`. Extended the disposable initializer test to assert creation when
missing and byte-for-byte preservation when present.


## Current State

TASK-0001 through TASK-0013 are complete. TASK-0014 is next. No application
code, dependency, remote, commit, branch, or Git mutation was performed.

## Important Findings

- The deterministic copier already used copy-if-missing; the missing behavior
  was explicit proposal language for existing ignore files.
- Approved changes must preserve real `.env` rules and keep `.ai/` trackable.

## Decisions

- Copy `.gitignore.template` only when `.gitignore` is absent.
- Treat existing-file revisions as a separate approval scope.

## Failed Approaches

No implementation approach failed.

## Validation

- `bash skills/project-init/tests/test-init-project.sh` passed.
- `shellcheck` passed for the initializer and test.
- Markdown lint passed for the changed skill/reference.

## Open Questions

The later reconciliation orchestration task must report exact missing-rule
proposals without editing existing ignore files.

## Next Steps

Continue with TASK-0014: preserve symlink, canonical-path, idempotency, and
extra-argument protections.
-

## Relevant Files

- `skills/project-init/SKILL.md` — ignore-file contract.
- `skills/project-init/references/workflow.md` — reconciliation rule.
- `skills/project-init/tests/test-init-project.sh` — preservation coverage.
- `IMPLEMENTATION_PLAN.md` — task order and activity evidence.
