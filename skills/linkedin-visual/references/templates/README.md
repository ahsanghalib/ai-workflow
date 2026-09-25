# Figma-exported LinkedIn templates

These SVG files are the one-time export of the approved Figma master. They are
local renderer inputs; creating a carousel does not require a Figma connection.

- `linkedin-7-page-01-cover.svg` through `linkedin-7-page-07-closing.svg` are
  the seven editable layout references.
- The five-page renderer uses the cover, chat, table, grid, and closing
  templates from this same set.
- The renderer rebuilds the tab strip for the requested page count: five tabs
  for a five-page carousel and seven tabs for a seven-page carousel.
- Keep the files together with `scripts/render_carousel.py`; do not overwrite
  an existing export without visual comparison against the Figma source.
- The Python renderer treats these exports as layout references and owns
  source-grounded text, pagination, color selection, and final PDF QA.

## Local rendering

Prepare a JSON brief with `page_count` set to `5` or `7` and a `pages` array,
then run:

```bash
python3 skills/linkedin-visual/scripts/render_carousel.py \
  --input /path/to/carousel.json \
  --output /path/to/post.pdf \
  --format both
```

The renderer refuses to replace an existing PDF, SVG page directory, or
metadata sidecar by default. Pass `--overwrite` only when regeneration is
intentional. When a metadata sidecar is written, its `source` value contains
only the input filename, never an absolute workspace path.

If no `color_scheme` is present, the script randomly selects one of the five
schemes and records it beside the output in `post.meta.json`. A rerun reuses
that recorded choice. PDF output requires optional local `cairosvg` and `pypdf`
dependencies; SVG output is available without them.
