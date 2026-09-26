# Document existing repository safety gates

Date: 2026-09-26
Feature: project-init prompt-v3 reconciliation

## Context

Prompt-v3 section 39 required explicit safety behavior for reconciling existing
repositories. The project-init workflow already implemented most safeguards,
but they were distributed across several references and lacked a single
durable migration/removal gate.

## Goal

Make existing-repository preservation, legacy-artifact handling, secret safety,
Git safety, and external-state authorization explicit and regression-tested.

## Why

Reconciliation must add only missing controls without churning user-owned
projects, deleting useful legacy information, or treating old plan-era files as
requirements.

## Outcome

Added `skills/project-init/references/existing-repository-safety.md` and routed
it from `project-init/SKILL.md`. The reference covers inspection, preservation,
no boilerplate overwrite, the six named legacy artifacts, the three-condition
migration/removal gate, secret boundaries, and explicit authorization for
remote/deployment/publishing changes. Added traceability assertions and
adjusted the retired-plan-workflow scan to allow legacy names when they are
documented as preservation guidance.

## Current State

Section 39 is complete and the worktree remains intentionally uncommitted.
Prompt-v3 section 40 is the next review target.

## Important Findings

- Legacy artifact names may appear in safety guidance without activating the
  retired planning workflow; tests must distinguish preservation from routing.
- Migration/removal requires unambiguous ownership, demonstrably safe
  migration, and no loss of useful user-authored information.

## Decisions

- Keep existing-repository safety in a dedicated routed reference so the
  project-init entrypoint stays concise and the branch is loaded only when
  reconciling an existing target.
- Preserve old artifacts and make the new workflow independent unless all
  migration/removal conditions and user approval are satisfied.

## Failed Approaches

- The first contract phrases crossed Markdown line wraps and one included
  backticks that triggered ShellCheck. Assertions were narrowed to
  shell-safe fragments while retaining coverage.

## Validation

- Passed SPEC lifecycle, cross-skill, design-completion, project-init,
  traceability, and disposable project-init suites.
- Passed `validate-skills.sh`, Markdownlint, Bash syntax, ShellCheck, and
  `git diff --check`.
- Live reconciliation against an external repository and harness reload were
  not exercised.

## Open Questions

- None for section 39.

## Next Steps

1. Review prompt-v3 section 40 and fix concrete gaps in place.
2. Keep temporary `prompt-v3.md` and `todo.md` uncommitted.

## Relevant Files

- `skills/project-init/references/existing-repository-safety.md` — new safety
  reference.
- `skills/project-init/SKILL.md` — routed reference list.
- `skills/project-init/tests/test-traceability-contract.sh` — assertions.
- `SESSION_STATE.md` — current handoff state (ignored).
