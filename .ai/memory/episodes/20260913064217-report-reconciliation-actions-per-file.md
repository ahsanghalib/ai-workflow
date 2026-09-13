# Report reconciliation actions per file

Date: 2026-09-13
Feature: project-init

## Context

TASK-0025 turns reconciliation findings into a per-file proposal before any
write.

## Goal

Complete TASK-0025 with a reviewable per-file keep/create/revise/preserve/conflict proposal.

## Why

Existing projects need a precise distinction between preserving a source,
creating a missing document, revising an existing file, and stopping on a
conflict. A broad approval would be unsafe.

## Outcome

Added reconciliation-report reference and routing with exact path, evidence, source owner, action, approval scope, compatibility impact, validation, unresolved decisions, and next review fields.

## Current State

TASK-0001 through TASK-0025 are complete. TASK-0026, explicit approval before
changing existing project-control files, is next. No existing project file was
changed by this task.

## Important Findings

- The report needs exact paths, evidence, source-of-truth owner, action,
  approval scope, and compatibility impact for every relevant item.
- `conflict` and `revise after approval` must remain visible rather than being
  collapsed into generic reconciliation.
- Handoff fields must include assumptions, unresolved decisions, validation,
  and the next review action.

## Decisions

- Use the five actions `keep unchanged`, `create missing`, `revise after
  approval`, `preserve`, and `conflict`.
- Keep the report proposal-only; it never constitutes approval.
- State that application source, dependencies, migrations, secrets, commits,
  remotes, branches, and pushes are outside reconciliation.

## Failed Approaches

No implementation approach failed; this was documentation-only reporting and
approval-scope work with no meaningful runnable behavior seam.

## Validation

- Markdown lint and focused inspection of the report table, action semantics,
  approval scopes, handoff fields, and secret boundary passed.

## Open Questions

Each existing project still needs its actual per-file evidence report and user
decision where candidates conflict.

## Next Steps

Implement TASK-0026 and keep existing-file changes separately approval-gated.

## Relevant Files

- `skills/project-init/references/reconciliation-report.md` — report contract.
- `skills/project-init/SKILL.md` — report routing.
- `skills/project-init/references/workflow.md` — proposal sequence.
- `skills/project-init/templates/.ai/prompts/reconcile-existing-project.md` —
  helper prompt.
- `IMPLEMENTATION_PLAN.md` — task order and evidence.
