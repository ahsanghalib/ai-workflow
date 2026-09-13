# Route existing-project reconciliation prompts

Date: 2026-09-13
Feature: project-init

## Context

TASK-0028 packages the existing-project reconciliation workflow into the
generated AGENTS routing and tracked helper prompts.

## Goal

Complete TASK-0028 with tracked reconciliation prompts and generated AGENTS routing.

## Why

A non-technical user should be able to ask for reconciliation without knowing
the inventory, source-of-truth, evidence, or approval references individually.
The project should retain those rules as visible Markdown routing aids.

## Outcome

Expanded AGENTS routing and the reconciliation helper to reference safe inventory, source-of-truth detection, evidence population, per-file reports, Git, and ignore policy as tracked documentation aids.

## Current State

TASK-0001 through TASK-0028 are complete. TASK-0029, technical-option
comparison handoff, is next. No project application or existing user project
was changed.

## Important Findings

- Generated AGENTS guidance needs to route safe inventory, source selection,
  evidence population, per-file reports, Git, and ignore policy together.
- Tracked helper prompts are routing aids, not automatic skills or authority.
- Existing-file revisions and Git/ignore operations remain separate approvals.

## Decisions

- Keep `reconcile-existing-project.md` as the user-facing entrypoint and link
  the internal references from generated AGENTS guidance.
- Preserve `.ai/` as tracked documentation and keep `.env` excluded.

## Failed Approaches

No implementation approach failed; this was documentation/routing work with no
meaningful runnable behavior seam.

## Validation

- Markdown lint and focused inspection of generated AGENTS routing and the
  reconciliation prompt passed.

## Open Questions

The technical comparison flow still needs explicit handoff boundaries and
current-source verification when options are version-sensitive.

## Next Steps

Implement TASK-0029 and route technical option comparison to the specialized
technical-design and source-driven-development skills.

## Relevant Files

- `skills/project-init/templates/AGENTS.md` — generated routing.
- `skills/project-init/templates/.ai/prompts/reconcile-existing-project.md` —
  tracked reconciliation entrypoint.
- `skills/project-init/references/source-of-truth.md` — source detection.
- `skills/project-init/references/reconciliation-population.md` — evidence
  population.
- `skills/project-init/references/reconciliation-report.md` — proposal report.
- `IMPLEMENTATION_PLAN.md` — task order and evidence.
