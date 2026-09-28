# Align LinkedIn visuals with Canva design system

Date: 2026-09-28
Feature: linkedin-visual

## Context

The repository's `linkedin-visual` skill had a Canva-first workflow but its
supporting references still prescribed an older Lime Signal palette, fonts, and
identity placement. The user supplied a new exact Canva brief and editable
design examples under `skills/linkedin-visual/examples/designs/`.

## Goal

Make the new brief the reusable source of truth while preserving the skill's
source-grounding, approval, and no-publication boundaries.


## Why

Poorly constrained visual instructions were producing inconsistent designs.
Canva needs explicit tokens, editable-element rules, content-driven template
selection, and a fix-before-report QA loop.

## Outcome

Added the Ahsan Canva design-system reference and routed it from the skill and
Canva workflow. Reconciled brand/layout, color-token, brief, slide-spec,
archetype, visual-selection, and PDF-QA references. The system now supports a
reusable 1080×1350 template file, 1080×1080 standalone cards, post-specific
five/seven/eight/ten-page or other justified sequences, and a single-image
output when that is stronger.


## Current State

The changes are uncommitted. The user-added example renders/PDF are preserved
and packaged as references, not flattened assets. A reusable-system request
must build templates 1–4 in order and stop for user review before 5–10 and the
standalone cards. A real post-specific request selects only the needed layouts.

## Important Findings

- The exact visual tokens are paper `#F7F7F4`, ink `#16181D`, cobalt
  `#2540D9`, gray `#5F6472`, line `#D9DAD4`, and panel `#ECECE8`; no alternate
  palette or font is allowed for this identity.
- The shared portrait chrome is category/context labels at the top, a 2 px
  divider, `M Ahsan Izhar · AI Engineering` at bottom left, and `NN / NN` at
  bottom right.
- The example PNGs are visual references only. Native Canva text, shapes,
  connectors, bars, and diagram nodes must remain editable.

## Decisions

- Keep general LinkedIn visual selection and source/approval boundaries intact;
  specialize the Ahsan branch through a directly routed reference.
- Replace the old color-scheme catalog with one canonical token set rather than
  leaving conflicting options available to the authoring workflow.
- Treat the ten templates as a reusable library, not a required carousel
  length; content determines page count and whether an image is enough.

## Failed Approaches

- The first validator path was unavailable. The repository's system validator
  was used successfully instead.

## Validation

- The repository's `quick_validate.py skills/linkedin-visual` check — passed.
- `bash scripts/validate-skills.sh` — passed.
- `bash -n scripts/*.sh bin/*` — passed.
- `git diff --check` — passed.
- `scripts/package-skills.sh --clean` — produced the 14-skill bundle;
  `unzip -t zip/linkedin-visual.zip` passed and the archive includes the new
  reference plus supplied examples.
- No live Canva editor, native editability, or export QA was performed.
-

## Open Questions

- Whether the user wants the untracked example renders/PDF included in the
  eventual logical commit; they are currently preserved and untouched.

## Next Steps

- User reviews the complete diff. If approved, stage only the intended skill
  references and explicitly selected examples, then commit without pushing.

## Relevant Files

- `skills/linkedin-visual/SKILL.md` — Canva-first routing, template selection,
  and QA contract.
- `skills/linkedin-visual/references/ahsan-canva-design-system.md` — exact
  source of truth for tokens, templates, chrome, and editability.
- `skills/linkedin-visual/references/brand-and-layout-guidelines.md` and
  `references/color-schemes.md` — reconciled palette/identity guidance.
- `skills/linkedin-visual/examples/designs/` — supplied visual references.
