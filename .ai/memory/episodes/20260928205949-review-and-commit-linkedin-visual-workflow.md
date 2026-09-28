# Review and commit LinkedIn visual workflow

Date: 2026-09-28
Feature: linkedin-visual

## Context

The working tree contained the local-first LinkedIn visual migration, three
Inkscape carousel options, supporting skill references, and six uncommitted
LinkedIn workflow history capsules. The user requested a diff review, fixes,
and logical local commits.

## Goal

Review the intended diff, remove actionable inconsistencies, verify the skill
and imported visual assets, then commit the work without staging unrelated or
temporary files.


## Why

The workflow must remain portable, source-grounded, editable, and consistent
with the current Ahsan token system while preserving a clean repository history.

## Outcome

The skill references now pass Markdownlint, the footer wording distinguishes
shared footer identity from the optional closing author role, and all three
carousel option bundles pass the visual asset audits. The commit scopes are
ready for final staged review.


## Current State

The functional LinkedIn visual changes, design references, and reviewed memory
capsules remain uncommitted until the staged diff is inspected. The ignored
`SESSION_STATE.md`, package ZIP outputs, and derived memory database remain
local.

## Important Findings

- All 18 option page SVGs passed Inkscape text-bound and pairwise collision
  checks: 206 text objects, zero geometry failures.
- All imported SVGs use only the six approved colors and `DM Sans`/
  `JetBrains Mono`; no malformed geometry attributes were found.
- Historical capsules contained machine-local validator paths; those paths were
  redacted before they were considered for commit.

## Decisions

- Keep the functional skill/reference/design bundle together so the checked-in
  skill never points at missing option assets.
- Keep episodic history in a separate commit from the functional workflow.
- Preserve historical Canva/Figma mentions inside historical capsules only;
  current LinkedIn visual authoring guidance remains local editable PPTX-first.

## Failed Approaches

- A broad Markdownlint pass initially exposed table-style and line-length
  failures in rewritten references; the affected tables were explicitly
  scoped or reformatted, and the current skill references now pass.

## Validation

- `quick_validate.py skills/linkedin-visual` passed.
- `quick_validate.py skills/linkedin-workspace` is required because its Drive
  layout reference changed.
- `bash scripts/validate-skills.sh`, `bash -n scripts/*.sh bin/*`, targeted
  Markdownlint, `git diff --check`, and package ZIP integrity are required
  before commit.

## Open Questions

- None for the local commit. PowerPoint/LibreOffice rendering and live
  Drive/LinkedIn behavior remain outside this review.

## Next Steps

- Stage the functional bundle, inspect the cached diff, commit it, then stage
  and commit the reviewed memory capsules separately.

## Relevant Files

- `skills/linkedin-visual/SKILL.md`
- `skills/linkedin-visual/references/`
- `skills/linkedin-visual/examples/design/`
- `skills/linkedin-workspace/references/google-drive-layout.md`
- `AGENTS.md`, `README.md`, and `.ai/memory/episodes/`
