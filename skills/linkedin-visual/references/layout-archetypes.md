# LinkedIn carousel layout archetypes

For the Ahsan visual system, **do not invent standalone generic archetypes**.
Use the ten canonical templates in `ahsan-local-design-system.md` and their PNG
references in `../examples/design/carousel-slides/slides/`.

This file maps common content jobs to those canonical templates so the model can
vary the narrative without drifting into a different design system.

## Content-job mapping

<!-- markdownlint-disable MD013 MD060 -->

| Content job | Preferred canonical template | Notes |
|---|---|---|
| Topic/promise | `01 Cover` | Preserve cover silhouette; do not substitute a generic centered title. |
| Single numbered lesson/check | `02 Numbered insight` | Use giant numeral + underline + heading. |
| Definition / concept / mechanism / takeaway | `03 Technical explanation` | Use the three-row structure. |
| Ordered process / architecture / request flow | `04 Flow diagram` | Use stacked native boxes and the canonical accent-path behavior. |
| Before/after / option A vs B / tradeoff | `05 Comparison` | Use two columns and concise verdict/guidance. |
| Strong thesis / quote-like takeaway | `06 Key statement` | Use oversized statement + one cobalt phrase. |
| Metric / benchmark / distribution | `07 Data` | Use one large number and up to three bars. |
| Code / JSON / tool contract | `08 Code` | Use panel + short code + takeaway. |
| Screenshot / trace / generated image with analysis | `09 Image + commentary` | Use large image frame + caption + observation. |
| Final takeaway / CTA / author close | `10 Closing` | Preserve author block and final counter. |

<!-- markdownlint-enable MD013 MD060 -->

## How to handle content that looks like another archetype

If the narrative naturally suggests one of these structures, map it into the
closest canonical template instead of creating a new style:

- conversational contrast → `05 Comparison` or `03 Technical explanation`;
- four principles/failure modes → multiple `02 Numbered insight` pages or one
  `03 Technical explanation` if the points are short;
- five steps/checklist → `04 Flow diagram` when sequence matters, or a short
  series of `02 Numbered insight` pages when each step needs explanation;
- architecture/system map → `04 Flow diagram`;
- quote/callout → `06 Key statement`;
- compact source/caveat card → fit within the selected canonical page without
  changing the shell.

Do not add card grids, chat bubbles, icon matrices, centered diagrams, or other
layouts simply because they are common carousel patterns. The goal is
recognizable continuity with the supplied canonical design set.

## Shared shell

Every portrait canonical template inherits:

- top-left category label and top-right context tag;
- exact Ahsan tokens and typography;
- left-aligned editorial hierarchy;
- lower-right engineering motif and right utility rail at the reference scale;
- bottom-left `M. Ahsan Izhar - ahsanizhar.com`;
- bottom-right sequential `NN / NN` counter;
- one cobalt focal idea per page.

See `visual-fidelity.md` for the actual silhouette contracts and drift-rejection
rules.
