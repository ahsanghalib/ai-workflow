# Populate reconciliation documents from evidence

Date: 2026-09-13
Feature: project-init

## Context

TASK-0024 defines how reconciliation populates missing Markdown after safe
inventory and source-of-truth detection.

## Goal

Complete TASK-0024 with safe missing-document population rules that distinguish confirmed facts from inference and unknowns.

## Why

Existing code and configuration can support useful documentation, but it does
not prove product requirements or future technical approvals. Explicit evidence
levels prevent helpful drafts from becoming accidental authority.

## Outcome

Added reconciliation-population reference and routing: copy approved templates only after source detection, map evidence to fields, label evidence levels, preserve existing documents, and keep code/schema/API generation out of project-init.

## Current State

TASK-0001 through TASK-0024 are complete. TASK-0025, the per-file
keep/create/revise/preserve/conflict report, is next. No existing source of
truth was edited.

## Important Findings

- Confirmed, inferred, recommended, assumed, and unknown information need
  separate labels and sections.
- Missing templates should be proposed with evidence-to-field mappings before
  copy-if-missing creation.
- `MASTER_PLAN`, `USER_FLOW`, `DB_SCHEMA`, architecture, and `AGENTS` have
  different content boundaries; one cannot be filled from another by guesswork.

## Decisions

- Populate only confirmed safe evidence by default.
- Never infer secrets, business rules, authorization, schema constraints, API
  contracts, or deployment from filenames or framework conventions.
- Keep the operation documentation-only and stop for review before SPEC, PLAN,
  migration, API, frontend, or application work.

## Failed Approaches

No implementation approach failed; this was documentation-only reconciliation
guidance with no meaningful runnable behavior seam.

## Validation

- Markdown lint and focused inspection of evidence levels, missing-file sequence,
  document boundaries, secret exclusions, and helper routing passed.

## Open Questions

Each project still needs an evidence-to-field report and user review before a
missing document becomes project direction.

## Next Steps

Implement TASK-0025 with a complete per-file proposal report and explicit
compatibility impact.

## Relevant Files

- `skills/project-init/references/reconciliation-population.md` — population
  and evidence rules.
- `skills/project-init/SKILL.md` — reconciliation routing.
- `skills/project-init/references/workflow.md` — safe write sequence.
- `skills/project-init/templates/.ai/prompts/reconcile-existing-project.md` —
  helper prompt.
- `IMPLEMENTATION_PLAN.md` — task order and evidence.
