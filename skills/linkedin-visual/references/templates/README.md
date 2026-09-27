# LinkedIn visual templates and Canva path

Canva is the preferred authoring path when its connected capability is
available. These SVG files are the one-time export of the approved visual
master and remain local renderer inputs and layout references. Creating a
carousel does not require a Figma or Canva connection when the local fallback
is sufficient.

- `linkedin-7-page-01-cover.svg` through `linkedin-7-page-07-closing.svg` are
  the seven editable layout references.
- The five-page renderer uses the cover, chat, table, grid, and closing
  templates from this same set.
- The renderer rebuilds the tab strip for the requested page count: five tabs
  for a five-page carousel and seven tabs for a seven-page carousel.
- The closing page has a single CTA slot. Replace it with the one approved next
  action for the reader; do not stack save/share/comment requests by default.
- Keep the files together with `scripts/render_carousel.py`; do not overwrite
  an existing export without visual comparison against the approved source.
- The Python renderer treats these exports as layout references and owns
  source-grounded text, pagination, color selection, and final PDF QA.

## Local rendering

Use the local renderer only when Canva is unavailable, when a deterministic
offline artifact is specifically requested, or when the user approves the
fallback. It does not create or update a Canva design.

Prepare a JSON brief with `page_count` set to `5` or `7`, an approved `brand`
object containing `author`, `domain`, and `role`, and a `pages` array, then run:

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

If no `color_scheme` is present, the script uses the deterministic `Lime Signal`
default and records it beside the output in `post.meta.json`. A rerun reuses
that recorded choice. Named schemes only are accepted so production output does
not change randomly between runs. PDF output requires optional local `cairosvg` and `pypdf`
dependencies; SVG output is available without them.
