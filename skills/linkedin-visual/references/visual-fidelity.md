# Canonical visual-fidelity specification

This file exists to make the Ahsan LinkedIn visual system reproducible by an
LLM instead of merely stylistically similar. The PNG renders in
`../examples/design/` are the canonical composition references.

## Priority when rules conflict

Use this order:

1. user-approved source content and factual constraints;
2. the canonical PNG for the selected template;
3. this visual-fidelity specification;
4. `ahsan-local-design-system.md` token and typography rules;
5. generic layout/accessibility guidance elsewhere in the skill.

The PNG controls **composition, proportion, visual rhythm, ornament placement,
and chrome**. The written token files control exact colors, fonts, dimensions,
and editable-object requirements.

Do not reinterpret the design as a generic minimal-tech carousel. Reproduce the
reference silhouette first, then replace its example copy with the approved
content.

## Canonical reference files

Portrait templates:

- Cover: `../examples/design/carousel-slides/slides/01-cover.png`
- Numbered insight: `../examples/design/carousel-slides/slides/02-numbered-insight.png`
- Technical explanation: `../examples/design/carousel-slides/slides/03-technical-explanation.png`
- Flow diagram: `../examples/design/carousel-slides/slides/04-flow-diagram.png`
- Comparison: `../examples/design/carousel-slides/slides/05-comparison.png`
- Key statement: `../examples/design/carousel-slides/slides/06-key-statement.png`
- Data: `../examples/design/carousel-slides/slides/07-data.png`
- Code: `../examples/design/carousel-slides/slides/08-code.png`
- Image + commentary: `../examples/design/carousel-slides/slides/09-image-commentary.png`
- Closing: `../examples/design/carousel-slides/slides/10-closing.png`

Square references:

- `../examples/design/carousel-slides/standalone/insight-card.png`
- `../examples/design/carousel-slides/standalone/data-card.png`
- `../examples/design/carousel-slides/standalone/diagram-card.png`
- `../examples/design/carousel-slides/standalone/announcement-card.png`

There is currently no canonical standalone quote-card render. Do not use the
old contact-sheet image as a quote-card reference. Derive a quote card from the
shared square shell and the `key statement` composition only when a quote card
is explicitly needed.

## Alternate design-system options

The repository also includes three complete six-page portrait options for
direction selection. These are composition references, not additional template
names to mix with the canonical mapping above:

- Evidence Ledger: inspect
  `../examples/design/carousel-options/evidence-ledger/slides/` for the light
  evidence-ledger layout with structured rows and retrieval notes.
- Dark Signal: inspect
  `../examples/design/carousel-options/dark-signal/slides/` for the dark
  editorial layout built around traces, failure paths, and observability.
- Modular Index: inspect
  `../examples/design/carousel-options/modular-index/slides/` for the light
  asymmetric grid with index rails, modular cards, and data bars.

When an option is selected, inspect all of its page PNGs before authoring and
keep the selected option's shell, spacing, and motif language consistent. Do
not combine an option's pages with the baseline template set or another
option. The editable SVG and PDF files beside each option are for source and
export review; the final editable source remains native PPTX content, while
the final handoff is a PDF or explicitly requested image.

## Mandatory calibration pass

Before authoring an Ahsan visual:

1. inspect the canonical PNG for every template you plan to use;
2. inspect `01-cover.png` and `10-closing.png` for the global shell when making
   a carousel;
3. record the selected reference filenames in the generation notes;
4. preserve the reference's main bounding boxes and negative-space pattern;
5. after rendering, compare every output page against its reference at the same
   thumbnail size and fix composition drift before finalizing.

Do not rely on memory of the examples. Open them during the task.

## Geometry mapping

Use a deterministic PowerPoint coordinate mapping of **100 px = 1 inch** when
coding a PPTX. This gives:

- portrait: `10.8 × 13.5 in` = `1080 × 1350 px`;
- square: `10.8 × 10.8 in` = `1080 × 1080 px`;
- `88 px` = `0.88 in`;
- `170 px` = `1.70 in`;
- `8 px` = `0.08 in`;
- `18 px` = `0.18 in`;
- `2 px` = `0.02 in`.

When a renderer uses a different DPI, preserve the 4:5 or 1:1 geometry and the
same normalized coordinates.

## Shared portrait shell

The following anchors describe the canonical renders. Keep them within roughly
`±24 px` unless content length forces a documented change.

- page field: `paper`;
- left content edge: `x = 88 px`;
- right safe edge for primary content: approximately `x = 990 px`;
- top utility labels: around `y = 76–82 px`;
- top-left label: left aligned to `x = 88 px`;
- top-right context tag: right aligned near `x = 992 px`;
- footer identity baseline: around `y = 1270–1285 px`;
- footer identity text: **`M. Ahsan Izhar - ahsanizhar.com`**;
- page counter on carousel pages: right aligned near `x = 992 px`, formatted
  `01 / 10`, `02 / 10`, etc.;
- no generic full-width footer divider on ordinary pages;
- the closing page may use a thin horizontal rule above the author block as
  shown in the canonical render.

## Canonical engineering motif

The low-contrast engineering line-art is a **brand motif**, not optional
clip-art. Recreate it from native presentation shapes/lines whenever possible.
It must remain visually subordinate to content.

Core motif characteristics:

- anchored to the lower-right corner;
- thin `line`-token strokes, mostly 1–2 px equivalent;
- a stacked isometric system/server form with surrounding database, code, API,
  connector, and node hints;
- a sparse right-side utility rail using a dotted/dashed vertical rule, a small
  square/circle marker pair, and three small outlined horizontal boxes;
- one cobalt route/path passing through the motif with circular nodes;
- large on the cover, smaller and lower on content pages;
- allowed to crop beyond the bottom/right page edge exactly as the references
  do;
- never increase opacity until it competes with text;
- do not substitute a robot, chip, brain, sparkles, abstract blobs, or stock
  illustration.

Approximate footprint:

- cover: motif occupies about the lower-right `55–60%` of page width and lower
  `48–52%` of page height;
- standard portrait content pages: motif occupies about the lower-right
  `38–45%` of page width and lower `28–34%` of page height;
- square cards: motif occupies about the lower-right `42–48%` of width and lower
  `34–40%` of height.

The cobalt route is part of the motif. On most pages it enters from the lower
middle/left area, stays thin, and terminates or bends through the stacked form.
Do not add a second accent route elsewhere.

## Typography behavior

Use the canonical type scale from the design-system file, with these template
exceptions visible in the references:

- numbered insight numeral: roughly `210–240 px` equivalent;
- data headline number: roughly `170–210 px` equivalent;
- key-statement sentence may use approximately `92–108 px` equivalent;
- comparison/flow/code/image-commentary headings may be smaller than the
  standard 80 px heading when required to preserve the reference silhouette;
- labels, captions, counters, and footer identity remain small and monospaced.

Do not shrink body copy below the canonical readable scale simply to fit more
text. Shorten or split content instead.

## Template silhouette contracts

### 1. Cover

- top utility labels;
- large 3–4 line display headline beginning around `y = 180 px`;
- only one word/phrase in cobalt;
- supporting sentence below with generous leading;
- `SWIPE  →` near the lower-left, in cobalt monospace;
- large engineering motif across lower-right;
- footer identity + counter.

### 2. Numbered insight

- giant cobalt number in upper-left quadrant;
- short cobalt underline below the number;
- 2–3 line heavy heading below;
- 2–3 lines of gray body copy;
- standard small lower-right motif;
- footer identity + counter.

### 3. Technical explanation

- heading near top-left below utility labels;
- three horizontal information rows;
- left row labels `CONCEPT`, `MECHANISM`, `TAKEAWAY` in cobalt monospace;
- explanatory text to their right;
- fine horizontal rules between rows;
- standard lower-right motif.

### 4. Flow diagram

- compact headline;
- five stacked horizontal rounded boxes;
- primary labels on left, small explanation on right;
- only the failure-prone path/boxes use cobalt stroke/text;
- short interpretation line below;
- standard lower-right motif.

### 5. Comparison

- compact headline;
- two columns with one thin vertical divider;
- 3 concise points per column separated by light rules;
- at most one column heading or key phrase in cobalt;
- bold one-line verdict/decision guidance below;
- standard lower-right motif.

### 6. Key statement

- small cobalt vertical accent mark above or beside the statement;
- one oversized sentence taking the visual center;
- only one phrase in cobalt;
- short gray supporting explanation;
- generous empty space;
- standard lower-right motif.

### 7. Data

- one oversized cobalt number with compact unit;
- one gray explanatory sentence;
- three horizontal bars with labels and values;
- only the focal bar in cobalt, others neutral;
- mark invented demonstration values as `SAMPLE DATA`;
- standard lower-right motif.

### 8. Code

- compact heading;
- large `panel` code block with no more than eight visible lines;
- monospace code; cobalt only for one semantic emphasis family;
- one takeaway sentence below, with the first clause bold if useful;
- standard lower-right motif.

### 9. Image + commentary

- large image/screenshot placeholder in upper half to two-thirds;
- tiny monospaced figure caption immediately below;
- compact heading below caption;
- takeaway/observation introduced with a short cobalt vertical rule;
- do not force the large lower-right engineering motif if it interferes with
  the supplied image; keep only the shared utility chrome.

### 10. Closing

- top utility labels;
- large 2–3 line takeaway headline;
- understated cobalt CTA/link text plus one gray follow-up line;
- author block in lower-left above footer area;
- thin rule above author block;
- standard lower-right motif;
- footer identity + final counter.

## Square shell

Square cards use the same visual language rather than a compressed portrait
page:

- `1080 × 1080 px`;
- `88 px` left/right margins;
- utility labels near the top;
- no carousel counter;
- footer identity around the lower-left baseline;
- standard engineering motif lower-right;
- one content job only.

For a quote card without a canonical render, use the key-statement silhouette:
large quote, one cobalt phrase at most, small source/attribution beneath, shared
square shell, and no quotation-mark decoration unless it is typographic and
subtle.

## Drift that must be rejected

Rework the page if any of these occur:

- centered headline/body when the reference is left aligned;
- generic card-grid composition replacing the selected template;
- full-bleed cobalt panels or multiple cobalt highlights;
- large decorative iconography;
- missing engineering motif on templates where the canonical render has it;
- missing right-side utility rail;
- generic full-width footer divider on every page;
- wrong identity string;
- drop shadows, gradients, glassmorphism, glow, neon, 3D renders, or stock AI
  art;
- changing the selected template layout because another layout is easier to
  code;
- treating the example PNG itself as the slide background.

## Fidelity target

The output does not need pixel-perfect text wrapping because source copy
changes, but it should be immediately recognizable as the same design system
when the canonical reference and generated page are viewed side-by-side at
thumbnail size. Preserve the major anchor positions, proportions, negative
space, motif scale, typography hierarchy, and single-cobalt focal treatment.
