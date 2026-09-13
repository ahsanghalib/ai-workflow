# Map reconciliation evidence to document ownership

Date: 2026-09-13
Feature: project-init

## Context

TASK-0042 hardens reconciliation population with explicit evidence-to-document
mapping and confidence.

## Goal

Complete TASK-0042 with evidence type, confidence, document mapping, generator ownership, and secret exclusions.

## Why

The same signal can support current tooling documentation but not future product
scope. Mapping prevents filenames, conventions, or generated output from being
treated as authority.

## Outcome

Expanded reconciliation-population with a mapping table: user/docs/config/source/filename/convention/secret evidence gets confidence and safe use; generated output routes through its generator and unknown ownership stays open.

## Current State

TASK-0001 through TASK-0042 are complete. TASK-0043, worktree-root versus
nested-directory handling, is next.

## Important Findings

- Direct user statements and approved documents are high-confidence sources.
- Manifests and verified command configuration support current tooling, not
  future technology selection.
- Filenames/conventions are discovery evidence only; `.env` and secret-like
  paths provide no safe content evidence.
- Known generated output must be updated through its generator; unknown
  ownership stays open and the output is preserved.

## Decisions

- Record evidence path or statement, confidence, content label, target section,
  and owner/generator for each populated field.
- Keep evidence confidence separate from confirmed/proposed/assumed/unknown
  content labels.
- Preserve secret exclusions and existing-file approval gates.

## Failed Approaches

No implementation approach failed; this was documentation-only evidence and
ownership work with no meaningful runnable behavior seam.

## Validation

- Markdown lint and focused inspection of the mapping table, confidence labels,
  generator ownership, and secret exclusions passed.

## Open Questions

Each project still needs actual evidence paths and owner decisions during
reconciliation.

## Next Steps

Implement TASK-0043 with explicit worktree-root/nested-target safety rules.

## Relevant Files

- `skills/project-init/references/reconciliation-population.md` — mapping
  contract.
- `skills/project-init/references/source-of-truth.md` — source ownership.
- `skills/project-init/references/template-manifest.md` — generator/output
  boundary.
- `IMPLEMENTATION_PLAN.md` — task order and evidence.
