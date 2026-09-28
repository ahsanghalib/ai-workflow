# Local presentation workflow

Use this workflow when a local presentation capability can create and inspect
editable PPTX files. For the Ahsan visual system, the canonical PNGs in
`../examples/design/` are composition targets and must be inspected during the
build.

## Required preflight

Before authoring:

1. read `ahsan-local-design-system.md`;
2. read `visual-fidelity.md`;
3. open every canonical PNG corresponding to the templates you will use;
4. resolve the approved content and page jobs;
5. create a new output filename rather than overwriting an existing PPTX.

If the active environment cannot inspect the canonical PNGs, preserve the
approved outline and source-to-slide ledger, and mark rendering and
canonical-template fidelity as blocked or unverified. Do not finalize the
visual as reference-verified.

## Authoring

- Create portrait pages at the 4:5 geometry corresponding to `1080 × 1350 px`
  or square cards at `1080 × 1080 px`.
- When coding the PPTX, prefer `10.8 × 13.5 in` for portrait and `10.8 × 10.8
  in` for square so `100 px = 1 in` can be used as a direct coordinate map.
- Keep text, shapes, lines, connectors, tables, chart bars, and diagram nodes as
  native presentation objects.
- A supplied screenshot/photo may remain raster content inside its designated
  image frame. Do not rasterize a complete authored page.
- Use only the exact Ahsan tokens and typography from
  `ahsan-local-design-system.md`. If a named font is unavailable, record the
  actual fallback; do not claim exact font fidelity.
- Build shared helpers/components for utility labels, footer/counter,
  engineering motif, right utility rail, and cobalt route so they remain
  consistent across pages.
- Match the selected canonical PNG's main content boxes, scale relationships,
  negative space, motif size, and accent placement before making aesthetic
  changes.
- For a reusable template-system request, build templates 1–4 first and stop
  for review. For a post-specific asset, use only the content-justified pages.

## Incremental fidelity loop

Do this **after each page**, not only at the end:

1. render the page to an image;
2. view it at the same approximate thumbnail size as its canonical PNG;
3. compare silhouette, anchors, whitespace, hierarchy, motif footprint,
   utility chrome, and accent usage;
4. fix visible drift;
5. rerender before moving to the next page.

A page that merely shares the same colors/fonts but uses a different
composition has failed the fidelity check.

## Export and QA

- Save the final editable PPTX first, then export a matching PDF.
- Inspect every rendered page for clipping, overflow, line breaks, text-box
  bounds, text-to-text collisions, reserved-region collisions, contrast,
  mobile legibility, repeated chrome, page dimensions, engineering motif,
  canonical-template fidelity, and one-accent compliance.
- Treat the text-fit and collision guard as a hard pre-export gate. If the
  layout validator cannot prove a check, render and inspect the page with an
  available geometry-capable tool; otherwise record it as `unverified` and do
  not call the deck final.
- Run the PDF structural checks in `pdf-qa.md`, including page count,
  dimensions, text extraction, file size, and metadata checks.
- Inspect the PPTX source structure for native text and shape objects. A PDF or
  PNG proves visual output only; it does not prove editability.
- Run a verify → fix → re-verify loop. Record deviations and their disposition
  in the QA receipt.

## Google Drive handoff

When the shared Drive/Sheet workflow is actually available and selected:

- identify the exact selected Drive folder, workbook/tab/range, and intended
  asset-row changes;
- confirm that the user authorized that exact target and operation before any
  upload or Sheet mutation;
- upload the final PPTX and PDF to the same selected visual folder;
- verify each upload by reading Drive metadata;
- record separate `Visual Assets` entries for `editable-source` and
  `linkedin-pdf`;
- use the PDF link as the Content Library `Primary Visual Link`;
- if either upload or readback fails, keep local files and mark sync unverified
  rather than pretending the asset is ready.

## Capability fallback

If no local presentation capability is available, preserve the approved page
outline and source-to-slide ledger and mark rendering blocked or unverified.
Do not silently switch to a generic image generator or web template service.

If presentation rendering or image inspection is unavailable, do not claim
canonical-template fidelity or rendered-page QA passed. Keep the local source
and mark those checks unverified.
