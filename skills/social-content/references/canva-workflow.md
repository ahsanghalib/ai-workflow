# Canva workflow

Use this reference when the connected Canva capability is available for a
social-content visual. It is a conditional adapter: the skill remains usable
with other runtimes and keeps local rendering as a fallback.

## Before authoring

- Confirm the approved copy, source ledger, channel, audience, visual type,
  dimensions, brand system, and export format.
- Confirm the exact Canva target: a new design or an existing design selected by
  the user. Do not overwrite an existing design merely because its title or
  filename matches.
- Keep the design unpublished until the user approves the visual and any
  external upload or publication action separately.

## Build and review

- Use Canva for layout, typography, hierarchy, and visual explanation. Do not
  use it to invent metrics, testimonials, citations, outcomes, or urgency.
- Keep the approved headline, numbers, caveats, disclosures, source notes, and
  call to action traceable to the source ledger.
- Use the requested channel dimensions and current platform requirements when
  they matter. Record the dimensions in the visual-generation receipt.
- Inspect the Canva design for hierarchy, contrast, overflow, spacing,
  mobile-scale readability, and readable source/disclosure text.

## Export and evidence

- Export only the approved formats and verify that each output exists and
  belongs to the intended design.
- Record the Canva design URL or ID when returned, export path, format,
  dimensions, page count, authoring status, and QA status.
- A Canva design link proves access to the design, not that the export succeeded
  or that the asset was uploaded or published.

If Canva is unavailable, use the local SVG/HTML workflow in `visuals.md` or
another explicitly approved design capability. Mark Canva authoring as
`not_available`; never imply that a local render was created in Canva.
