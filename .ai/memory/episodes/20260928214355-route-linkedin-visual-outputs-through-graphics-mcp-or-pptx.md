# Route LinkedIn visual outputs through graphics MCP or PPTX

Date: 2026-09-28
Feature: linkedin-visual

## Context

The `linkedin-visual` skill had a local editable-PPTX workflow plus Inkscape
reference assets. The user clarified that design work must probe connected
Inkscape MCP and GIMP MCP capabilities before falling back to PPTX, and that
the final handoff should be PDF by default or an image only when explicitly
requested.

## Goal

Make the routing and output contract explicit without reintroducing web design
editors or flattening authored presentation content.


## Why

The user does not want Canva or Figma in the LinkedIn visual workflow and does
not want PPTX treated as the final end-user deliverable.

## Outcome

Updated the skill to probe both graphics MCP paths first, use Inkscape for
vector/diagram/reference/geometry work, use GIMP for raster image preparation,
and call native PPTX authoring when neither MCP is suitable or available.
Updated the output and Drive/QA references so editable PPTX is source material,
PDF is the default final output, and PNG/JPG is produced only when requested.


## Current State

The working tree contains the reviewed routing/output changes and one new
memory capsule pending two logical local commits. No Canva or Figma product
reference remains in the LinkedIn visual or LinkedIn workspace guidance. The
generic word `canvas` in an accessibility note is unrelated.

## Important Findings

- Historical project-memory capsules and the unrelated `social-content` skill
  retain old Canva/Figma context as provenance or separate workflow guidance;
  they do not route the LinkedIn visual skill.
- Raster GIMP output cannot prove editable text or diagram content, so GIMP is
  limited to image-only treatments unless the final is explicitly requested as
  a raster image.

## Decisions

- Always check the exposed tool list for both Inkscape MCP and GIMP MCP before
  choosing the PPTX fallback; installed applications or config entries alone
  do not prove runtime availability.
- Keep editable PPTX as the authoring source when used, but make PDF the final
  default and image export opt-in. Do not hand off PPTX by default.

## Failed Approaches

- A broad patch initially expected a sentence that was not present in
  `presentation-execution.md`; no files were changed by that failed patch, and
  the updates were reapplied in smaller exact patches.

## Validation

- `quick_validate.py` passed for `skills/linkedin-visual` and
  `skills/linkedin-workspace`.
- `bash scripts/validate-skills.sh`, `bash -n scripts/*.sh bin/*`, targeted
  `markdownlint`, and `git diff --check` passed.
- Product-name search found no Canva/Figma matches in the LinkedIn visual,
  workspace guidance, root `README.md`, or root `AGENTS.md`.
- Native PowerPoint/LibreOffice rendering and live Drive upload were not run.
-

## Open Questions

- None for the routing/output contract. The selected post still determines
  whether the final exported artifact is PDF or an explicitly requested image.

## Next Steps

- Commit the functional skill/reference changes, then commit this memory
  capsule separately. Do not push without a separate request.

## Relevant Files

- `skills/linkedin-visual/SKILL.md` — MCP preflight, fallback order, and final
  output contract.
- `skills/linkedin-visual/references/pptx-workflow.md` — source/export and
  Drive handoff details.
- `skills/linkedin-visual/references/pdf-qa.md` — PDF/image QA receipt fields.
- `skills/linkedin-workspace/references/google-drive-layout.md` — optional
  source archival and final-output storage rule.
