# Harden progressive project documentation controls

Date: 2026-09-26
Feature: project-init prompt-v3 reconciliation

## Context

The public `ai-workflow` repository is being reconciled with the temporary
`prompt-v3.md` contract. Sections 10–17 define progressive documentation and
remove mandatory legacy project artifacts.

## Goal

Review the current project-init implementation and fix concrete gaps while
preserving the uncommitted, user-directed working tree.

## Why

The workflow must follow actual project complexity, keep executable sources
authoritative, preserve useful legacy documents, and avoid speculative control
files.

## Outcome

Added explicit conditional ADR routing and a reusable ADR template, clarified
the architecture-versus-ADR boundary, narrowed schema context to durable
context plus executable-source links, and added regression coverage for legacy
document preservation and non-speculative shared flow output.
Added a capability-signal fixture covering API, auth, deployment, workers,
shared packages, and AI without creating premature project documents.

## Current State

Changes are uncommitted and remain for user review. The temporary
`prompt-v3.md` and `todo.md` remain untracked. The root ignored
`SESSION_STATE.md` was refreshed to a concise current handoff.

## Important Findings

- `MASTER_PLAN.md`, `DB_SCHEMA.md`, `USER_FLOW.md`, and
  `PROJECT_ARCHITECTURE.md` must not be default outputs, but existing copies
  remain user-owned and must be preserved.
- Schema context must not require copying every entity, field, type, constraint,
  or index from executable schema/migrations.
- `docs/decisions/<adr>.md` needs explicit ownership and conditional routing;
  a current architecture summary is not a decision history.
- Project shape, stack, deployment, authentication, API, monorepo, and feature
inventory are discovery signals or optional context, not bootstrap contracts.
- `spec-workflow` must route for approval and record user approval; it must not
  imply that the skill itself approves a SPEC or implement application code.
- SPEC creation must follow the project's approved source path; alternate
  existing paths must not be shadowed by a new `docs/specs/` directory.

## Decisions

- Keep architecture, flow, schema-context, engineering-rule, and ADR templates
  as conditional resources rather than bootstrap outputs.
- Use a reference-led schema template and link executable sources instead of
  maintaining a parallel schema catalog.
- Add tests at the initializer and traceability-contract boundaries so these
  rules remain observable.
- Assert SPEC workflow handoffs and ownership boundaries in the dedicated
  spec-workflow contract suite.
- Keep one SPEC lifecycle for all substantive categories rather than separate
  plan systems.

## Failed Approaches

- The first aggregate test run failed because a required validation phrase was
  split across a Markdown line wrap; restoring the phrase on one line fixed the
  compatibility assertion.
- The first cross-skill test run found the same explicit architecture boundary
  depended on the phrase `architecture documents`; the wording was restored
  without weakening the ADR clarification.

## Validation

- Passed project-init aggregate tests, all four spec-workflow contract suites,
  `bash validate-skills.sh`, targeted Markdown lint, ShellCheck, Bash syntax
  checks, and `git diff --check`.
- Untested: live harness reload and runtime behavior outside local structural
  and contract checks.

## Open Questions

- None for sections 10–17; continue with the next prompt-v3 section.

## Next Steps

- Review the next prompt-v3 section, fix concrete gaps in place, rerun focused
  validation, and leave all changes uncommitted unless explicitly requested.

## Relevant Files

- `skills/project-init/references/conditional-documents.md` — conditional
  document and ADR routing.
- `skills/project-init/templates/docs/decisions/adr.md` — reusable ADR shape.
- `skills/project-init/templates/docs/schema/context.md` — reference-led
  schema context.
- `skills/project-init/tests/test-init-project.sh` — legacy preservation tests.
- `skills/project-init/tests/test-reconciliation-scenarios.sh` — conditional
  flow-output tests.
- `skills/project-init/tests/test-traceability-contract.sh` — template and
  documentation boundary assertions.
