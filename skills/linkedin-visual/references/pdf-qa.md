# PDF and visual QA

Use a verify → fix → re-verify loop. A structurally valid PDF is not proof that
the pages are readable or that LinkedIn will accept an upload.

## Structural checks

Record each check as `verified`, `failed`, `unverified`, or `not_applicable`:

- output exists at the exact requested path and uses the post basename;
- PDF parses and opens without repair warnings;
- page count matches the approved brief;
- every page has the same approved dimensions and orientation;
- file size and format meet the current official platform guidance;
- text extraction does not reveal missing, duplicated, or corrupted text;
- hyperlinks are present, secure, and target the approved URLs;
- layers, animations, unsupported media, and accidental editable artifacts are
  flattened or handled according to the approved deliverable;
- no secrets, private paths, hidden notes, or unwanted metadata are included.

## Rendered-page checks

When a renderer and image inspection capability are available, inspect every
page for:

- clipping, overflow, overlap, broken line wraps, and orphaned text;
- headline/supporting-text hierarchy and mobile readability;
- contrast, grayscale meaning, and non-color cues;
- consistent margins, identity anchors, optional source/disclosure treatment,
  and selected geometry;
- image or diagram provenance, clarity, and claim scope;
- source notes, disclosures, and approved identity treatment;
- visual continuity without decorative filler.

If rendering or inspection is unavailable, do not claim these checks passed.
Preserve a clear unverified record and recommend the next required capability.

## QA receipt

Store the receipt in the post file's visual-generation section unless a separate
QA file was explicitly requested and created:

```markdown
### QA receipt

- Checked: YYYY-MM-DD HH:MM, workspace timezone
- Output: [post-<slug>-YYYY-MM-DD.pdf](...)
- Structural checks: verified | failed | unverified
- Rendered visual review: verified | failed | unverified
- Page count/dimensions: ...
- File size/format: ...
- Links/text extraction: ...
- Overflow/clipping/contrast: ...
- Sources/disclosures/identity: ...
- Fixes and remaining risks: ...
```

Set `Visuals: created` only when the requested file exists and the receipt
accurately reports its verified and unverified checks. A failed or blocked QA
step must remain visible to the user.
