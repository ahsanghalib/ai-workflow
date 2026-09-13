# Fix project-init subagent review findings

Date: 2026-09-13
Feature: project-init

## Context

The completed `project-init` implementation received three independent
read-only reviews covering progressive disclosure, security/portability, and
the end-to-end bootstrap-to-feature workflow.

## Goal

Record and remediate the three independent review findings without committing changes.

## Why

The user requested that every finding be recorded and fixed, with no commit,
and that session state and project memory remain current.

## Outcome

Implemented TASK-0051 through TASK-0058 and passed focused and repository validation.

## Current State

TASK-0051 through TASK-0058 are complete in `IMPLEMENTATION_PLAN.md`. The
review ledger is in `PROJECT_INIT_SUBAGENT_REVIEW.md`. The working tree remains
uncommitted and contains the user's earlier project-init implementation scope.

## Important Findings

- Missing target aliases must be canonicalized before comparing against a Git
  worktree root; checking only the raw lexical path permits an aliased nested
  target.
- Scaffold parent paths are preflighted for symlinks, regular files, and
  writability before any copy or optional Git initialization, preventing partial
  output and false success.
- Initial project schema design is a baseline contract after approved project
  direction and reviewed user flow; only feature-specific schema changes need a
  feature SPEC first.
- The template manifest is the authoritative scaffold inventory, while PLAN
  task groups and SPECs now carry durable traceability and lifecycle metadata.

## Decisions

- Keep the no-commit/no-remote boundary. Move `git init` after scaffold copy so
  copy/preflight failures do not leave newly created Git metadata.
- Keep nested generated/dependency directories pruned by basename at all
  inventory depths.
- Treat `SESSION_STATE.md` updates as a separate approved scope; provide the
  full handoff inline when that scope or capability is unavailable.

## Failed Approaches

- The first contract test expected wording that was semantically equivalent but
  not present in the workflow; it was narrowed to an exact stable phrase.
- Removing every direct reference from the skill entrypoint caused the root
  routed-reference validator to report orphan references; a compact entrypoint
  reference map preserves progressive disclosure and validator coverage.

## Validation

- Red evidence: new alias, parent-blocker, nested-pruning, lifecycle,
  task-group traceability, initial-schema, and optional-link assertions failed
  before their fixes.
- Green evidence: `bash skills/project-init/tests/test-project-init.sh` passed,
  including all focused helper tests; `bash validate-skills.sh` passed;
  Bash syntax and ShellCheck passed; targeted Markdown lint passed;
  memory-index verification passed; `git diff --check` passed; no retired
  planning-skill reference or trailing whitespace remains.
- Untested: filesystem races after preflight, non-Linux/BSD command behavior,
  live harness approval/reload behavior, and application runtime behavior.

## Open Questions

- None for the recorded review findings. Live harness reload and approval
  behavior remain an explicit environment-level validation boundary.

## Next Steps

- Review the uncommitted diff and review ledger. Do not commit or perform
  remote operations unless separately requested and approved.

## Relevant Files

- `PROJECT_INIT_SUBAGENT_REVIEW.md` — review findings and remediation status.
- `IMPLEMENTATION_PLAN.md` — TASK-0051 through TASK-0058 and activity evidence.
- `skills/project-init/scripts/init-project.sh` — canonical target and scaffold
  preflight safety.
- `skills/project-init/scripts/inventory-project.sh` — nested directory pruning.
- `skills/project-init/SKILL.md` and `references/` — workflow gates and routing.
- `skills/project-init/templates/docs/templates/SPEC.md` and `PLAN.md` —
  lifecycle and per-task-group traceability contracts.
