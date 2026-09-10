# Social-content visual branch

Use only when the user explicitly requests visual assets and approves the
required tools, files, and commands.

## Proposal

Before creating anything, propose the exact deliverables, project-local paths,
source-to-claim mapping, visual system, and QA method. Reuse project brand
assets, tokens, fonts, and rendering tools. Do not install dependencies, call
image-generation APIs, or load remote assets without separate approval.

## Evidence and formats

- Use concrete, linkable sources. Record author or institution, date, scope,
  method limits, and whether a finding is isolated or consensus.
- Prefer SVG source files with selectable `<text>` elements and system fallback
  fonts. Derive PNG when a platform requires raster output, and deliver both
  SVG source and derived PNG for the hero and carousel when those platforms are
  in scope. Check platform limits at delivery time.
- Default deliverables are one 1200x630 hero and a 4-6 slide 1080x1080
  carousel. The hero has no slide number; carousel slides use `n/total` and
  normally follow hook, one slide per stat, and closing-takeaway structure.

## Design and QA

1. Define 4-6 color tokens, display/body/utility type, a layout concept, and a
   subject-specific signature element before writing SVG or HTML/CSS. Ground
   the visual metaphor in the subject itself rather than using a generic tech
   motif.
2. Make every number from the copy prominent at least once and preserve the
   source caveats. When strong evidence is unavailable, offer a clearly
   labelled argument or opinion visual without numerical claims.
3. Bound text with realistic max widths. Reserve 40-60px breathing room at
   1080-wide scale and a fixed footer zone. Ask for the exact name, title, and
   domain before rendering the footer.
4. For HTML/CSS, render and inspect the PNG. For SVG, inspect the file in a
   browser. Use the project's existing renderer or the active harness's visual
   capability; do not install a new tool implicitly. If rendering or browser
   inspection is unavailable, provide the source, mark visual QA unverified,
   and list the exact check that remains. Re-render and re-view after copy
   changes. Check overflow, contrast, spacing, collisions, and that no two text
   blocks share a bounding box. For HTML/CSS, verify the “one bold thing per
   slide” rule. Avoid default AI looks such as a warm-clay serif on cream, a
   near-black canvas with one neon accent, or newspaper columns without a
   justified reason to use them; take one deliberate, justified aesthetic risk.

For SVG specifically, use an explicit system fallback stack such as
`"Inter", "Helvetica Neue", Arial, sans-serif`. Text must be actual `<text>`
elements rather than paths, and critical content must not depend on
`<foreignObject>`, which renders inconsistently across viewers.

Reserve a fixed footer zone on every slide, including the hero. Use this exact
left footer template after the user supplies the values:
`[Your Name] | [Your Title] | [your-domain.com]`. Put the carousel slide index
on the right as `n/total`; omit it only on the hero. Bound long headlines with
`max-width`, reduce type when needed, and leave roughly 40–60px of breathing
room at 1080-wide scale. Inspect every output directly and report source map,
output paths, render evidence, untested states, and uncertainty.
