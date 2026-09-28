# Editable presentation execution contract

Use this operational contract when creating the local editable presentation
source for the Ahsan LinkedIn visual system. It keeps execution deterministic
while remaining usable across presentation-capable harnesses.

## Do not begin by designing

Before creating any slide or card:

1. read `ahsan-local-design-system.md`;
2. read `visual-fidelity.md`;
3. open the exact canonical PNG(s) for the template(s) selected;
4. read `pptx-workflow.md`;
5. resolve the approved source copy and page jobs;
6. only then create the editable presentation.

If a canonical PNG cannot be inspected in the active environment, preserve the
approved page outline and source-to-slide ledger, and mark rendering and
canonical-template fidelity as blocked or unverified. Do not finalize the
visual as reference-verified.

If a canonical PNG exists, do not invent a new composition for that template.
Use the PNG as a layout target.

## Deterministic build sequence

For each page:

1. create the `paper` background;
2. add the top-left category and top-right context tag;
3. place the primary content using the selected template silhouette;
4. add the engineering motif and right utility rail;
5. add the cobalt route/path as the single accent idea unless the page content
   itself already uses the one allowed cobalt focal element;
6. add footer identity and carousel counter when applicable;
7. render the page;
8. compare it to the canonical PNG at thumbnail size;
9. run the text-fit and collision guard against the rendered page and its
   measured text boxes;
10. fix visual drift or geometry failures before building the next page.

Do not postpone all visual comparison until the end of a long carousel.

## Presentation implementation

Prefer an editable PPTX. If generating with code:

- use a custom `10.8 × 13.5 in` layout for portrait and `10.8 × 10.8 in` for
  square;
- use a helper such as `px(n) = n / 100` so design coordinates can be written
  directly from the pixel specification;
- create shared helper functions for page chrome and the engineering motif;
- keep text, rules, rounded boxes, diagram nodes, connectors, bars, and code
  panels as native objects;
- do not rasterize a complete slide or use the canonical PNG as a background;
- a supplied user screenshot/photo may remain raster content inside the
  image-commentary frame;
- use one output source file for the carousel, not one PPTX per page.

Recommended helper responsibilities:

- `addUtilityLabels(slide, leftLabel, rightLabel)`
- `addEngineeringMotif(slide, variant)` where variant is `cover`, `standard`,
  or `square`
- `addFooter(slide, pageNumber, pageCount)`
- `addAccentRoute(slide, variant)`
- `addBodyText(...)` with canonical line-height and widths

The exact programming library is secondary to visual fidelity and editability.
Do not switch to a different visual style because a particular library is more
convenient.

## Copy fitting rules

When approved copy is longer than the reference:

1. preserve the claim and certainty;
2. shorten wording without changing meaning;
3. split across another content-justified page if necessary;
4. only then make a small typography adjustment within the reference's visual
   range.

Never solve overflow by shrinking body text until the page no longer resembles
the reference.

## Mandatory geometry gate

Before export, read
[text-fit-and-collision.md](text-fit-and-collision.md) and produce a page-
indexed result for text bounds, text-to-text collisions, reserved-region
collisions, and mobile review. A page fails if any authored text crosses its
safe region, overlaps an unrelated text block, crosses a panel or diagram
region, or is clipped. If the active presentation or graphics capability does
not expose usable text geometry, mark the check `unverified` and stop before
calling the visual final.

## Self-check before final output

For each rendered page answer these internally:

- Is the selected canonical template still obvious at thumbnail size?
- Is the page left-aligned like the reference?
- Is there one dominant idea?
- Is cobalt used for only one focal idea?
- Is the engineering motif present at the right scale?
- Are the utility labels, identity, and counter in the reference positions?
- Did I accidentally add generic cards, shadows, icons, gradients, or excess
  decoration?
- Is all authored content still native/editable?
- Did every page pass text bounds, text collision, reserved-region collision,
  and mobile review checks?

If any answer is wrong or unverified, revise or obtain the missing evidence
before export.

## Drive and Sheet handoff

Before any remote mutation, apply the `linkedin-workspace` authorization
contract: identify the exact selected Drive folder, workbook/tab/range, and
intended PPTX/PDF and Visual Assets changes; confirm that the user authorized
that target and operation; then upload and write state. Do not create or choose
a remote target implicitly.

After uploading, verify Drive metadata and reread the affected Sheet rows. If
upload or readback fails, keep the local files and mark synchronization
unverified rather than treating the visual as ready.
