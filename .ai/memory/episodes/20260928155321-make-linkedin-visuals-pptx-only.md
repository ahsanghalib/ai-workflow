# Make LinkedIn visuals PPTX-only

Date: 2026-09-28
Feature: linkedin-visual

## Context

The repository had just been changed to prefer local editable PPTX while still
describing Canva/Figma as optional adapters. The user confirmed local PPTX is
the better option and requested those alternatives be removed.

## Goal

Make the `linkedin-visual` workflow and repository guidance unambiguously
PPTX/local-presentation-only, without deleting the validated example deck.


## Why

The user is installing the required fonts and wants a stable local workflow
without web editors, remote accounts, or Canva AI-credit limits.

## Outcome

Removed the Canva adapter reference and all Canva/Figma authoring fields,
fallbacks, and routing from `linkedin-visual`. Updated root guidance and the
carousel brief to name local presentation authoring only.


## Current State

`skills/linkedin-visual` routes only the Ahsan local design system and
`pptx-workflow.md`. The validated test deck remains at
`skills/linkedin-visual/examples/ahsan-local-templates-1-4.pptx`. Changes are
uncommitted.

## Important Findings

- The only remaining product-name audit match is the generic word `canvas` in
  an accessibility reference; there are no Canva or Figma matches in the
  LinkedIn visual skill or root authoring guidance.
- The old `references/canva-workflow.md` was removed, and packaging now emits
  26 LinkedIn visual files.

## Decisions

- Treat local editable presentation/PPTX as the sole visual authoring path. If
  the capability is unavailable, preserve the brief and report rendering as
  blocked or unverified rather than switching tools.

## Failed Approaches

- A broad multi-file patch initially failed because one expected wrapped line
  did not match the current `SKILL.md`; the changes were reapplied in smaller,
  verified patches.

## Validation

- `quick_validate.py skills/linkedin-visual`: pass.
- `bash scripts/validate-skills.sh`: pass.
- `bash -n scripts/*.sh bin/*`: pass.
- `git diff --check`: pass.
- `scripts/package-skills.sh --clean`: pass; `linkedin-visual.zip` contains 26
  files and no deleted Canva reference.
- `unzip -t zip/linkedin-visual.zip`: pass.
- No live editor, LinkedIn, Drive, or remote publication action was performed.

## Open Questions

- None for this routing change. The remaining review question is visual
  feedback on templates 1–4 before continuing templates 5–10.

## Next Steps

- User reviews the local PPTX deck; then revise 1–4 or continue the remaining
  reusable templates and standalone square cards.

## Relevant Files

- `skills/linkedin-visual/SKILL.md` — sole local-PPTX routing contract.
- `skills/linkedin-visual/references/pptx-workflow.md` — authoring/export/QA
  workflow.
- `skills/linkedin-visual/references/canva-workflow.md` — intentionally removed.
- `skills/linkedin-visual/examples/ahsan-local-templates-1-4.pptx` — editable
  test deck.
- `AGENTS.md` and `README.md` — repository routing guidance.
