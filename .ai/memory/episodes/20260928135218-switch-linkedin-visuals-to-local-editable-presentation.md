# Switch LinkedIn visuals to local editable presentation

Date: 2026-09-28
Feature: linkedin-visual

## Context

The `linkedin-visual` skill had just been aligned to an Ahsan-specific Canva
system, but the user exhausted Canva AI credits and said Canva/Figma would not
work for this workflow.

## Goal

Make local editable presentation/PPTX authoring the primary route, preserve
Canva/Figma as optional adapters, and prove the design system with templates 1–4.


## Why

The user needs a repeatable, editable artifact without external account credits
or a live design editor, while keeping the exact tokens, chrome, and content-
driven template rules.

## Outcome

Replaced the Canva-primary reference with a local design-system reference and a
PPTX workflow adapter. Created and copied a four-slide native PPTX test deck
covering cover, numbered insight, technical explanation, and flow diagram.


## Current State

The skill and repo guidance now prefer local editable presentations. The deck is
at `skills/linkedin-visual/examples/ahsan-local-templates-1-4.pptx` and is ready
for user review. Changes are uncommitted. The supplied PNG/PDF design examples
remain preserved.

## Important Findings

- The presentation finalizer passed package integrity, layout geometry, and
  first-party import checks with zero findings; the deck is 1080×1350 px.
- DM Sans is not installed in the build environment, so the PPTX encodes the
  requested family but rendered previews use a fallback. JetBrains Mono is
  available.
- Local rendering exposed and enabled fixing a cover overlap and flow-label
  wrapping before finalization.

## Decisions

- Keep local PPTX as the source of truth and make Canva/Figma conditional import
  adapters only. This avoids consuming Canva AI credits and avoids claiming
  editor/export state that was not observed.
- Stop after templates 1–4 for review, then continue 5–10 and standalone cards
  only after user feedback.

## Failed Approaches

- The initial draft had a cover text overlap and flow-diagram label wrapping;
  both were corrected in the build source before finalization.
- In-sandbox finalization could not spawn the bundled Python helper (`EPERM`);
  the user-approved escalated finalizer run completed successfully.

## Validation

- `quick_validate.py skills/linkedin-visual`: pass.
- `bash scripts/validate-skills.sh`: pass.
- PPTX package-integrity and layout validators: pass, zero findings.
- Local render of all four pages: visually inspected.
- `bash -n scripts/*.sh bin/*`, `git diff --check`, and
  `scripts/package-skills.sh --clean`: pass; `linkedin-visual.zip` contains 27
  files.
- No PowerPoint/LibreOffice open, Canva/Figma editor action, LinkedIn action,
  or Drive synchronization was performed.

## Open Questions

- Whether the user wants revisions to templates 1–4 before the remaining
  reusable templates are added.

## Next Steps

- Ask the user to review the four-slide PPTX. Continue templates 5–10 and the
  1080×1080 standalone cards only after approval.

## Relevant Files

- `skills/linkedin-visual/SKILL.md` — local-first routing and QA boundaries.
- `skills/linkedin-visual/references/ahsan-local-design-system.md` — exact
  tokens, layout, chrome, templates, and content rules.
- `skills/linkedin-visual/references/pptx-workflow.md` — native PPTX workflow.
- `skills/linkedin-visual/examples/ahsan-local-templates-1-4.pptx` — validated
  editable test deck.
- `SESSION_STATE.md` — current handoff and validation summary.
