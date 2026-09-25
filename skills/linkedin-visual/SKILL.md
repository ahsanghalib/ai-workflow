---
name: linkedin-visual
description: Use when turning an approved LinkedIn post or content brief into a 5-page or 7-page document/carousel PDF with source mapping, brand/layout rules, and visual QA; do not use for drafting posts, comments, publishing, general presentations, or inventing a brand identity.
license: MIT
---

# LinkedIn visual

Transform an approved LinkedIn post into a focused document/carousel artifact.
Preserve the source claims, certainty, attribution, disclosures, and audience
while adapting wording to readable pages. The skill may produce a PDF and
optional image previews in a user-selected runtime workspace; it never uploads
or publishes them.

## Boundaries

- Require an `APPROVED-UNPUBLISHED` post, approved content brief, or explicit
  user approval for the supplied source before preparing visual copy.
- Do not invent claims, numbers, testimonials, personal results, visual
  evidence, citations, or identity details while splitting content into pages.
- Do not publish, upload, schedule, access an authenticated social account, or
  claim LinkedIn acceptance from a local file check.
- Do not become a general presentation, video, image-generation, or brand-
  identity skill. Use conditional presentation/PDF/image capabilities only when
  the active harness provides them.
- Do not invent a permanent palette, logo, type system, header, footer, or
  domain. Use supplied and approved project rules; label temporary neutral
  defaults as campaign choices.
- Keep the public skill harness-neutral. Renderer, PDF, presentation, and
  image capabilities are optional adapters with a safe unverified fallback.

## Read the references

Read the references needed for the current branch:

- [references/carousel-brief.md](references/carousel-brief.md) for input,
  approval, and deliverable preflight.
- [references/narrative-frameworks.md](references/narrative-frameworks.md) for
  choosing and outlining 5-page or 7-page narratives.
- [references/slide-spec.md](references/slide-spec.md) before writing page
  copy, layout, headers, footers, or source maps.
- [references/brand-and-layout-guidelines.md](references/brand-and-layout-guidelines.md)
  when supplied brand material or a visual system is involved.
- [references/color-schemes.md](references/color-schemes.md) when selecting or
  recording the campaign palette.
- [references/layout-archetypes.md](references/layout-archetypes.md) when
  choosing varied page structures such as chat, table, grids, steps, or
  diagrams.
- [references/templates/README.md](references/templates/README.md) when using
  the saved one-time Figma exports and local renderer.
- [references/visual-system-and-accessibility.md](references/visual-system-and-accessibility.md)
  before finalizing typography, contrast, or mobile readability.
- [references/pdf-qa.md](references/pdf-qa.md) before rendering and before
  reporting structural or visual QA.
- [references/platform-specs.md](references/platform-specs.md) when checking
  current LinkedIn document requirements. Recheck its official links at
  implementation time.

## Workflow

1. Resolve the user-selected runtime workspace and locate the approved post
   file, evidence ledger, and any supplied visual brief. Read the post's
   visual-generation section and preserve the existing flat `posts/` layout.
   If approval or the source evidence is missing, create only a brief/proposal
   and stop before creating visual assets.

2. Complete the preflight in [references/carousel-brief.md](references/carousel-brief.md):
   audience, promise, source, objective, page count, orientation, dimensions,
   brand inputs, footer identity, citations, deliverables, renderer, and QA
   capability. Treat 5 and 7 pages as editorial choices, not LinkedIn
   requirements.

3. Read [references/narrative-frameworks.md](references/narrative-frameworks.md)
   and select the smallest page count that preserves the argument. Create a
   page-by-page outline and source-to-slide ledger. Do not add filler pages to
   reach seven.

4. Read [references/slide-spec.md](references/slide-spec.md) and
   [references/brand-and-layout-guidelines.md](references/brand-and-layout-guidelines.md),
   [references/color-schemes.md](references/color-schemes.md), and
   [references/layout-archetypes.md](references/layout-archetypes.md).
   Separate approved project rules from temporary campaign choices. If a brand
   rule is missing, use a neutral default only when the user requests it and
   label the choice for approval. Select one approved color scheme before
   layout, randomly when the brief does not specify one, and record the choice
   so rerenders do not silently change it. Map each page to an archetype that
   serves the approved outline; do not repeat one shell merely to reach seven
   pages.

5. Present the outline, visual system, page geometry, citation treatment,
   deliverables, and rendering plan for explicit visual approval. Do not render
   a PDF, image, or editable source before this approval.

6. Create the visual source and requested output with the available conditional
   capability. Prefer the saved Figma-exported templates and
   `scripts/render_carousel.py` when they are present; this local path does not
   require a Figma MCP connection. Keep every page traceable to the approved
   post or evidence ledger. If no suitable renderer is available, preserve the
   approved source and proposal, mark rendering and visual QA as unverified,
   and do not claim a completed PDF. The local renderer refuses existing
   outputs by default; use its explicit overwrite option only after the user
   requests regeneration.

7. Read [references/pdf-qa.md](references/pdf-qa.md). Run structural checks,
   render pages when possible, inspect the rendered pages, fix issues, and
   re-run the relevant checks. Separate verified structural checks from
   unverified or unavailable human visual review.

8. Read [references/visual-system-and-accessibility.md](references/visual-system-and-accessibility.md)
   and check contrast, non-color cues, mobile legibility, overflow, clipping,
   links, source traceability, disclosures, and consistent page geometry.

9. Save same-base outputs beside the approved post, using its research date:
   `post-<slug>-YYYY-MM-DD.pdf`, `.png`, or `.jpg`, with an explicit numeric
   suffix for additional same-type files. Never overwrite an existing file.
   Update the post file's visual-generation section with the outline, source
   map, brand reference, outputs, approval note, and QA receipt. Update the
   matching `posts.md` row to `Visuals: created` only when the requested visual
   file exists and its QA state is accurately recorded.

## Completion report

Report the source post, runtime workspace, selected page count, output files,
source-map coverage, structural checks, rendered visual review, unresolved
brand or citation decisions, and any blocked renderer or approval. Distinguish
verified local QA from LinkedIn upload or publication, which this skill never
performs.
