# Ahsan local editable design system

This is the approved local-first visual system for M Ahsan Izhar's LinkedIn
work. The editable PowerPoint/presentation source is the authoring artifact.
The canonical PNG renders in `../examples/design/` define the intended
composition and visual rhythm; they are references only and must not be pasted
as flattened slide backgrounds.

For reproducible layout, also read
[visual-fidelity.md](visual-fidelity.md). When a selected template has a
canonical PNG, match that PNG's composition before applying generic design
judgment.

## Role and audience

Act as a brand and editorial designer for M Ahsan Izhar, Software Engineering
× AI Integration, `ahsanizhar.com`. The subject area is LLMs, RAG, agents, MCP,
and software architecture. Design for engineers and technical hiring managers.
The result should read as credible practitioner work, not a generic AI poster.

## Deliverables

- Reusable template system: one editable local presentation source containing
  the portrait templates and standalone cards below.
- Portrait carousel pages: exactly `1080 × 1350 px`.
- Standalone cards: exactly `1080 × 1080 px`.
- Keep authored text boxes, shapes, rules, connectors, chart bars, and diagram
  nodes native/editable in the source presentation whenever supported.
- Do not paste canonical PNGs into the source as complete-page backgrounds.
- Keep one geometry within a carousel. A standalone card is a separate square
  format, not a mixed-size carousel page.

## Canonical tokens

Use these values exactly. Do not add colors or fonts.

<!-- markdownlint-disable MD013 MD060 -->

| Role | Token | Value |
|---|---|---|
| Page field | `paper` | `#F7F7F4` |
| Primary text | `ink` | `#16181D` |
| Focal accent | `accent-cobalt` | `#2540D9` |
| Secondary text | `gray` | `#5F6472` |
| Rules | `line` | `#D9DAD4` |
| Grouped surface | `panel` | `#ECECE8` |

Use `DM Sans 700` for display and headings and `DM Sans 400` for body copy.
Use `JetBrains Mono` for labels and code; use `Space Mono` only when JetBrains
Mono is unavailable. Record any local font fallback in the QA receipt.

Base type scale:

- display: `124 px`;
- heading: `80 px`;
- body: `36 px`;
- label: `20 px`, monospace, uppercase, with `+8%` tracking.

Template-specific exceptions for the giant numeral, data number, and key
statement are defined in `visual-fidelity.md`.

Use `1.4` body line-height, a maximum body line width of `780 px`, an `8 px`
base unit, `18 px` box radius, `16 px` code radius, and `2 px` rules. Use
`88 px` side margins. Keep content left-aligned by default.

## Shared page chrome

Every portrait page follows the canonical shell shown in the reference PNGs:

- top left: category label;
- top right: context tag;
- bottom left identity: `M. Ahsan Izhar - ahsanizhar.com`;
- bottom right: sequential `NN / NN` counter;
- lower-right engineering line-art motif plus the sparse right-side utility
  rail;
- one cobalt route/path as part of the motif unless the page's one allowed
  accent is already consumed by a dominant content element.

Do **not** add a generic full-width divider to every footer. Ordinary pages in
the canonical references do not use one. The closing page may use the thin rule
shown above its author block.

Use at most one accent idea per slide: a keyword/phrase, the key path in a
diagram, one bar, one number, or the motif route. The cobalt accent is not
free decoration.

## Engineering motif

The lower-right line-art system diagram is part of the approved identity. It is
not optional decoration on templates where the canonical PNG shows it.

Recreate it using thin native rules, connectors, isometric boxes, nodes, and
simple database/code/API hints. Keep it low-contrast and subordinate. The cover
uses a larger version; standard content pages and square cards use smaller
versions. Exact visual behavior and footprint are defined in
[visual-fidelity.md](visual-fidelity.md).

Do not replace it with generic icons, a chip, a robot, a brain, abstract AI
art, or a stock technology illustration.

## Template library

Build these in this order when creating or revising the reusable source. Match
the corresponding canonical PNG in `../examples/design/carousel-slides/slides/`.

| # | Template | Required structure |
|---:|---|---|
| 1 | Cover | Headline max four lines, one supporting sentence, large engineering motif, and `SWIPE  →`. |
| 2 | Numbered insight | Oversized cobalt number, short cobalt underline, heading, and short body copy. |
| 3 | Technical explanation | Three rows labelled `CONCEPT`, `MECHANISM`, and `TAKEAWAY`. |
| 4 | Flow diagram | Five vertical/stacked boxes with connectors or flow order; accent only the failure-prone path. |
| 5 | Comparison | Two columns, three concise points each, and a one-line verdict/guidance. |
| 6 | Key statement | One sentence around `100 px` with one accented phrase and short support copy. |
| 7 | Data | Oversized number plus three bars; mark demonstration values `SAMPLE DATA`. |
| 8 | Code | Heading, a `panel` code block with at most eight lines, and one takeaway sentence. |
| 9 | Image + commentary | Image/screenshot frame at roughly 50–65% page height, caption, and one highlighted insight. |
| 10 | Closing | One takeaway, understated CTA, author block, shared motif, and final counter. |

<!-- markdownlint-enable MD013 MD060 -->

Also support standalone `1080 × 1080` cards for insight, quote, diagram, data,
and announcement. Canonical square references currently exist for insight,
diagram, data, and announcement. A quote card must be derived from the shared
square shell and key-statement composition; do not use the old contact-sheet
image as a quote-card reference.

When building the reusable system, create templates 1–4 first and stop for the
user's review before creating templates 5–10 and standalone cards.

## Content-driven selection

The template library is not a mandatory ten-page carousel. For a specific
approved post, choose the smallest sequence that explains the argument. A
carousel may be 5, 7, 8, 10, or another content-justified length, and one square
image may be the stronger result. Never add filler to reach ten pages.

Before layout, map every selected page to one reader job and to the approved
source/evidence. Adapt copy to the template; do not redesign the template just
to fit verbose copy.

## Visual and copy boundaries

Do not use gradients, glow, neon, robots, brains, circuit boards, stock photos,
3D renders, glassmorphism, drop shadows, decorative icons, or centered-everything
layouts. Use diagrams, bars, rules, nodes, and panels only when they explain the
approved idea.

Use realistic sample copy about RAG and agents only when demonstrating reusable
templates. For a real post, preserve the approved claim, certainty, attribution,
source, caveat, and CTA. Avoid filler, hype, invented metrics, unsupported
experience, and decorative pseudo-technical language.

## Local construction and QA

1. Resolve the exact brief/source and whether the task is a reusable system or
   post-specific asset.
2. Open the canonical PNG for every selected template.
3. Set page geometry before authoring.
4. Build with native presentation objects; supplied screenshots/photos may
   remain raster content inside their designated frame.
5. Apply the token table, shared chrome, motif, and one-accent rule.
6. Render each page and compare it to the canonical PNG at thumbnail size.
7. Check dimensions, margins, type sizes, font use, line-height, clipping,
   overflow, contrast, mobile legibility, native editability, motif scale,
   chrome, and accent count.
8. Fix every material deviation and rerun QA before replying.

Record the source path, export path, selected canonical reference files, page
count, dimensions, token values, font fallbacks, editability evidence, and QA
state.
