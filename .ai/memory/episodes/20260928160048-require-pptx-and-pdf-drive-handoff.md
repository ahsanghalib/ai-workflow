# Require PPTX and PDF Drive handoff

Date: 2026-09-28
Feature: linkedin-visual

## Context

The local PPTX-only LinkedIn visual workflow was complete, but the user added a
delivery requirement: after a visual is final, both PPTX and PDF must be stored
in Google Drive.

## Goal

Encode the final dual-file Drive handoff without uploading the current review
draft or weakening the existing authorization and readback safeguards.


## Why

The PPTX must remain editable for future revisions while the PDF is the stable
distribution/upload artifact.

## Outcome

Updated `linkedin-visual` and the local PPTX workflow to require a final PPTX
plus matching PDF, upload both to the same selected Drive visual folder, verify
both Drive links, and create separate `Visual Assets` rows. The PDF is the
`Content Library` primary visual link; the PPTX is the editable-source variant.


## Current State

The contract is documented and packaged. No Drive upload was performed because
the current four-slide PPTX is still a review draft and no selected Drive target
was provided.

## Important Findings

- Existing workspace schema supports two asset rows with the same Content ID and
  source hash, using the `Variant` field and separate Drive links.
- The appropriate default folders are `Content/Visuals/Carousels/` for
  multi-page documents and `Content/Visuals/Images/` for single-page visuals.

## Decisions

- Upload only after final local PPTX/PDF QA. Never mark the visual ready when
  only one file uploaded or either Drive readback is missing.
- Keep local files as source artifacts and use Drive metadata as the stored-file
  authority. Do not synthesize links or guess a target folder.

## Failed Approaches

- A first multi-file patch was rejected by `apply_patch` because it targeted the
  same file in two operations; the change was reapplied as one update plus
  separate file patches.

## Validation

- `quick_validate.py skills/linkedin-visual`: pass.
- `quick_validate.py skills/linkedin-workspace`: pass.
- `bash scripts/validate-skills.sh`: pass.
- `bash -n scripts/*.sh bin/*`: pass.
- `scripts/package-skills.sh --clean`: pass; LinkedIn visual package has 26
  files.
- `unzip -t zip/linkedin-visual.zip`: pass.
- Drive upload/readback is not exercised; no target, credentials, or external
  mutation was used.

## Open Questions

- The exact Drive root/folder and Content ID must be selected when a final visual
  is ready for synchronization.

## Next Steps

- After the user approves/finalizes a visual, export the matching PDF, upload
  both files to Drive, verify metadata, and persist both asset rows.

## Relevant Files

- `skills/linkedin-visual/SKILL.md` — finalization and Drive handoff contract.
- `skills/linkedin-visual/references/pptx-workflow.md` — PPTX/PDF export and
  Drive handoff details.
- `skills/linkedin-visual/references/carousel-brief.md` — required local/Drive
  output fields.
- `skills/linkedin-workspace/references/google-drive-layout.md` — visual folder
  and dual-file storage rule.
