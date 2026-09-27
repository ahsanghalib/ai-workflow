---
name: linkedin-visual
description: >-
  Use when assessing whether an approved LinkedIn post needs a visual and, when
  useful, creating a source-grounded single image or document/carousel in Canva
  or another approved design tool with a supplied visual system and QA. Apply
  `copywriting` to the carousel narrative and `humanizer` to eligible prose
  without changing approved claims. Does not publish or schedule LinkedIn
  posts.
license: MIT
---

# LinkedIn visual

Create visuals only when they improve comprehension, credibility, or scanability.
A visual is not mandatory for every post. Preserve the approved post's claims,
certainty, attribution, disclosures, and audience.

## Boundaries

- Start from an approved post/brief or an explicitly approved source.
- Do not invent claims, metrics, testimonials, personal results, diagrams that
  imply unsupported evidence, citations, or identity details.
- Do not publish, upload to LinkedIn, schedule, or claim LinkedIn acceptance.
- Do not change the approved post thesis merely to fit a template.
- Use the supplied approved visual identity and identity fields. If no approved
  brand system exists, propose a neutral temporary system and stop for approval
  before treating it as a reusable rule.
- Treat Canva editing, design creation, and export as conditional external
  actions. Use the connected Canva capability when it is available, but never
  assume that a Canva design was created, saved, shared, or exported without
  explicit tool or UI evidence. Do not overwrite an existing Canva design
  unless the user selected it and authorized that change.

## Workspace integration

When the shared workspace is available:

- read the `Content Library` row and exact approved source/hash;
- write asset metadata to `Visual Assets`;
- upload completed assets to the appropriate Drive `Content/Visuals` folder;
- update `Visual Status`, `Visual Type`, and `Primary Visual Link` only after the
  output exists and its QA state is accurately recorded.

Local files remain valid working outputs when Drive is unavailable. Mark them
unsynced rather than blocking generation. Drive writes and asset uploads require
an authorized capability and an explicitly selected target; a local render is
not proof of a Drive upload.

## Read the references

- [references/visual-selection.md](references/visual-selection.md)
- [references/carousel-brief.md](references/carousel-brief.md)
- [references/canva-workflow.md](references/canva-workflow.md) when Canva is
  available or the user wants an editable Canva source
- [references/narrative-frameworks.md](references/narrative-frameworks.md)
- [references/slide-spec.md](references/slide-spec.md)
- [references/brand-and-layout-guidelines.md](references/brand-and-layout-guidelines.md)
- [references/color-schemes.md](references/color-schemes.md)
- [references/layout-archetypes.md](references/layout-archetypes.md)
- [references/templates/README.md](references/templates/README.md) for local
  carousel rendering
- [references/visual-system-and-accessibility.md](references/visual-system-and-accessibility.md)
- [references/pdf-qa.md](references/pdf-qa.md)
- [references/platform-specs.md](references/platform-specs.md) when current
  LinkedIn requirements matter

## Visual selection

First decide one of:

- `none` — text is stronger without an asset;
- `image` — one diagram, system map, comparison, or focal concept can stand alone;
- `document` — the idea benefits from a multi-page technical narrative.

Do not create a carousel merely because the capability exists. For the imported
post corpus, record the assessment before generating assets so effort goes to the
strongest posts first.

## Workflow

1. Resolve the exact approved Content ID/revision/hash and source artifact.
2. Run the visual-selection assessment. If `none`, set `Visual Status=not_needed`
   and stop without generating decorative filler.
3. For `image`, create one source-grounded portrait asset with the approved
   identity using an available image/design/rendering capability. Prefer diagrams
   and information design over generic AI artwork. If no suitable capability is
   available, mark the asset blocked rather than silently switching to decoration.
4. For `document`, choose the smallest page count that preserves the argument;
   use the existing 5/7-page templates only when they fit. Before rendering,
   use `copywriting` to turn the approved post into a reader-first slide
   sequence: one primary reader, one promise or problem, one job per page, a
   clear mechanism or proof, and one proportionate next action. Choose one
   suitable framework (such as AIDA, PAS, BAB, or the Four Cs as an editorial
   gate) only when it makes the approved argument clearer; frameworks are not
   reach or conversion guarantees. Create a page outline and source-to-slide
   ledger before rendering.
5. Use the approved visual system. Default to `Lime Signal`; choose another
   documented scheme only deliberately based on the topic/brief. Never choose a
   palette randomly. When Canva is available, follow
   [references/canva-workflow.md](references/canva-workflow.md) and use Canva as
   the preferred authoring path. Otherwise use the local renderer or another
   explicitly approved design capability.
6. Once the global brand system is already approved, **do not require a separate
   pre-render approval for every post**. Generate a draft asset, run QA, and mark
   it `Approved=pending`. Ask for approval before publication, not before every
   render. Ask before rendering only when introducing a new brand/layout rule,
   materially changing content, or incurring an external cost the user has not
   authorized.
7. After the narrative is stable, use `copywriting` for a final clarity,
   specificity, benefit, and reader-momentum pass on eligible prose only. It
   may shorten or clarify approved copy but must not change its claims,
   certainty, attribution, thesis, or approved action. Use `humanizer` only for
   prose that needs a natural-voice pass; do not humanize numeric labels,
   citations, diagram text, or data automatically. If either skill is
   unavailable, apply the equivalent bounded checks locally and report the
   fallback; never claim that a separate skill ran. After either pass, rerun
   the exact-claim and attribution diff. Keep every text/diagram element
   traceable to the approved post/evidence.
8. Apply the same copywriting logic to the design: establish a clear visual
   hierarchy, make the focal element carry the page job, use contrast and
   grouping to direct attention, show mechanisms or comparisons rather than
   decoration, and make the final action easy to recognize. Design must improve
   comprehension and trust, not manufacture urgency, imply proof, or overpower
   the caveat/source treatment.
9. Run structural and visual QA. Inspect the Canva design in its editor and the
   exported pages when the active environment supports it. Inspect local
   renders when Canva is unavailable. Do not claim checks that were not
   performed.
10. Save outputs without silent overwrite. Record Content ID, revision, source
   hash, scheme, authoring tool, Canva design/source URL when returned, export
   format, QA state, and Drive/local path.
11. After user approval of the asset, set `Visual Assets.Approved=yes` and
   `Content Library.Visual Status=ready`.

## Batch visual mode

For a large approved corpus:

- assess all candidate posts first;
- generate assets in manageable batches;
- reuse the approved visual identity consistently;
- do not regenerate unchanged assets when their `Source Hash` matches the
  current approved content hash;
- if the post body changes, mark the old asset stale and generate a new revision
  rather than silently reusing it.

## Completion report

Report Content IDs assessed, `none/image/document` decisions, generated files,
Canva design/source links when available, Drive links, QA state,
stale/conflicting assets, approval state, and blocked capabilities. Distinguish
Canva/editor or local asset QA from LinkedIn publication.
