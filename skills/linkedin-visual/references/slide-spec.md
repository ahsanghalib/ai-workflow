# Slide specification

Use this as content and layout guidance for the approved Ahsan local system,
not as a mandatory page sequence. Portrait carousel pages are `1080 × 1350 px`
and standalone cards are `1080 × 1080 px`. A post-specific visual may use five,
seven, eight, ten, another content-justified count, or one image.

## Copy and design relationship

Treat copy and design as one reader journey. The page headline should state the
page's job, supporting text should answer the next reasonable question, and the
focal visual should explain, compare, or demonstrate rather than decorate. Use
hierarchy, spacing, contrast, and grouping to direct attention in the same order
as the copywriting argument. Preserve caveats, sources, and disclosures where
they affect interpretation; do not hide them in unreadable footers.

## Page contract

Record these values in the carousel brief and post file:

- page count;
- canonical template/reference PNG for each page;
- orientation and exact width/height with units;
- consistent page size across the document;
- `88 px` side margins, `170 px` top/bottom clearance, and the 8 px base grid;
- `paper`, `ink`, `accent-cobalt`, `gray`, `line`, and `panel` tokens only;
- `DM Sans 700/400`, `JetBrains Mono` or `Space Mono` fallback, and the
  approved type scale;
- shared chrome: category/context labels, lower-right engineering motif and
  utility rail, footer identity, and sequential counter;
- optional source note, disclosure, or supporting footer content;
- image, icon, diagram, and asset provenance;
- source-map ID for each non-obvious claim;
- alt/description text or an equivalent accessibility note.

## Page anatomy

Use a consistent hierarchy:

1. optional small label or section marker;
2. one clear page headline;
3. short supporting explanation or example;
4. one focal diagram, quote, code fragment, or whitespace region when useful;
5. footer/source/disclosure area that never competes with the main message.

Keep one dominant idea per page. Use whitespace to show grouping rather than
adding panels, badges, or decorative elements without a communication purpose.
Use a clear visual entry point, a readable path through the page, and a
recognizable takeaway or next action. Do not use visual emphasis to turn a
qualified statement into a guarantee or to make weak evidence look authoritative.

## Text and links

- Write page copy for scanning on a small screen; do not shrink text to rescue
  an overfull page.
- Preserve the certainty and attribution of the approved post.
- Use code only when it explains the mechanism and remains legible.
- Use secure, tested hyperlinks when links are included; record the target in
  the source map.
- Put full citations in the approved citation location, not as unreadable body
  text. If citation placement is unresolved, stop at the proposal.

## Source-to-slide ledger

<!-- markdownlint-disable MD013 -->

```markdown
| Slide | Element | Claim/source ID | Exact or adapted wording | Asset/source | Caveat | Link target |
|---:|---|---|---|---|---|---|
| 1 | headline | C1 | ... | none | ... | ... |
```

<!-- markdownlint-enable MD013 -->

The ledger must make it possible to trace every factual or attributed element
back to the approved post, evidence ledger, or supplied asset.
