# Text-fit and collision guard

Use this reference for every authored portrait page and standalone card before
export. A renderer can produce a technically valid file while text still runs
past the safe edge, crosses a reserved panel, or collides with another text
block. Treat those as authoring failures, not visual polish issues.

## Required geometry ledger

Before rendering, record or be able to recover these values for every authored
text object:

- `id` or stable locator;
- role: `utility`, `headline`, `body`, `label`, `code`, `footer`, or `caption`;
- measured or renderer-reported bounding box in page coordinates;
- intended container or reserved region, when applicable;
- whether overlap is allowed. The default is `false`.

Use actual font metrics after resolving the requested font. A declared width or
an SVG `text` element's starting `x` is not evidence that the rendered text
fits. For Inkscape/SVG, `validate_document` proves structure and font/glyph
health but does not prove visual geometry; use the runtime's object-query or
rendered-bounding-box capability when available, then inspect the render.

## Hard failures

Fail the page and do not export when any of these is true:

1. A text bounding box crosses the page safe area, footer zone, or utility rail
   without an explicit template exception.
2. A headline or body block crosses into a panel, image frame, diagram node,
   connector corridor, or other reserved region that it does not own.
3. Two text bounding boxes intersect by more than a 1 px tolerance, unless the
   overlap is an intentional text-on-surface relationship inside the same
   container and both boxes remain readable.
4. Text is clipped, truncated, hidden behind another object, or wraps into a
   line not included in the planned page job.
5. A code line, label, counter, URL, or footer identity exceeds its container
   or becomes unreadable at the intended mobile review size.
6. A page relies on shrinking below the approved type scale to recover from
   overflow.

The only normal text-on-surface exception is text intentionally placed inside
its own panel or code block. That exception does not permit label/detail
collisions inside the panel; give each line its own vertical slot or wrap it.

## Repair order

When the guard fails, repair in this order:

1. shorten or split the copy without changing its claim, certainty, or
   attribution;
2. add an intentional line break and recompute the block height;
3. move or resize the owning container and preserve the canonical silhouette;
4. move neighboring elements to restore the reserved collision zones;
5. make a small size adjustment within the approved reference range;
6. split the content across another justified page if it still does not fit.

Do not solve a collision by silently hiding text, clipping it, reducing opacity,
or shrinking all page text. Do not let a template's decorative motif consume a
content region that the page job needs.

## Verify -> fix -> re-verify

For each page:

1. run the available structural/font check;
2. measure or query text boxes and compare them with safe bounds and reserved
   regions;
3. render at final dimensions and at a phone-scale review size;
4. inspect the page for clipping, collision, line-wrap drift, and readability;
5. fix every failure and repeat the checks;
6. record `overflow: pass`, `collision: pass`, or `unverified` in the QA
   receipt. `unverified` is not ready for a final deliverable.

For a multi-page source, run the guard on every page, not only the cover and
closing page. A deck-level pass is valid only when every page passes.

## Capability-specific evidence

- Editable PPTX: use the presentation/layout validator when available, then
  inspect every rendered page. Structural validity alone is insufficient.
- Inkscape/SVG: use `validate_document`, object-query or bounding-box evidence,
  and rendered previews. If the MCP only returns structure without text
  geometry, mark geometry as `unverified` and do not call the visual final.
- Raster-only GIMP MCP output: treat text as non-editable and do not use it as
  the canonical source for this workflow. It may be an image-only treatment,
  review artifact, or export artifact only.

## QA receipt fields

Record these fields for each page or for a page-indexed receipt:

```text
text-bounds: pass | failed | unverified
text-collisions: pass | failed | unverified
reserved-region-collisions: pass | failed | unverified
mobile-review: pass | failed | unverified
repair: <what changed, or none>
```
