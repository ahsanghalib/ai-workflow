# Component consistency

Use this reference when a page contains repeated cards, rows, headings, text
roles, section shells, controls, illustrations, or theme-aware surfaces. The
goal is a coherent system that remains easy to change across breakpoints,
themes, languages, and content variations.

## Audit before adding CSS

1. Inventory repeated semantic roles and their anatomy: element order, spacing,
   type role, border/surface treatment, states, and responsive behavior.
2. Trace existing tokens, classes, components, and variants before creating a
   selector. Compare computed styles for instances that are intended to match.
3. Choose one shared base for identical anatomy and behavior. Add an explicit,
   named variant or optional slot only when the role or behavior really differs.
   When the user identifies a preferred instance, use that as the base and
   migrate its peers; do not blend in the rejected treatment.
4. Delete or replace superseded rules. Keep deliberate responsive, state, and
   variant overrides explicit; remove patches that leave competing sources of
   truth for the same role and state.

## Reuse decision examples

### Positive

- Process steps and positioning cards that share a number, title, body, and
  optional output line use one numbered-card component; the output is an
  optional slot or named variant.
- Section headings that share a hierarchy use one typography role with shared
  size, leading, margins, and responsive values rather than section-specific
  heading selectors.
- A sticky header and other theme-aware surfaces consume semantic light/dark
  token pairs for background, text, border, illustration, and control states.

### Negative

- Adding `#process h2` and `#stack h2` overrides for a heading role that should
  look like the other section headings creates a second design system.
- Using ad hoc last-item offsets to align an odd fifth item hides a missing
  shared layout rule. Structural selectors are valid for intentional separators
  or documented grid patterns; test the pattern with different item counts.
- Appending another padding, font-size, or border override after a visual fix
  leaves conflicting declarations and makes later changes unpredictable.

### Ambiguous: same description, different presentation

If two items have the same title/body structure but one includes an output line,
keep one shared base and expose that line through an optional slot or a named
`has-output` variant. If the difference is only copy, do not create a variant.
Route the decision through the same audit when the description is unchanged but
the visual treatment is proposed to change.

## Shared visual contracts

- Define typography roles with size, weight, leading, measure, and block
  margins together. Define section rhythm and content gutters as shared layout
  tokens or utilities.
- Keep light and dark values paired by semantic role, including illustrations,
  diagrams, sticky headers, focus states, and text on surfaces.
- Use the same responsive breakpoints for shared components. Test long copy,
  translated labels, URLs, and odd item counts without clipping or accidental
  per-item alignment hacks.
- Use logical properties (`margin-inline`, `padding-block`, `inset-inline`,
  and related forms) when layout must work in RTL. Avoid decorative density or
  heavy visual chrome unless it serves the hierarchy.

## Acceptance checks

For a shared-role change, inspect the implementation and capture fresh evidence
at representative supported widths and one pixel below and above changed
breakpoints. Scale coverage to the affected component rather than requiring a
full-page Cartesian matrix for every small change:

- matching instances consume the same shared rules, rather than copied values
  or empty class names still controlled by section-specific selectors;
- computed styles for equivalent instances match for the intended roles;
- rendered screenshots cover desktop, tablet, and mobile in both themes and
  supported languages, including RTL when present;
- a baseline at widths explicitly requested to remain unchanged confirms their
  layout, typography, and spacing did not drift;
- keyboard order/focus and reduced-motion behavior remain usable;
- long copy and odd item counts preserve the component anatomy without hidden
  overflow or alignment exceptions.

If a check fails, fix and recheck the affected states before claiming completion.
Source inspection or matching computed metrics alone cannot establish that a
layout looks balanced; inspect readable screenshots of the affected component.
Preserve copy, assets, CTA destinations, and scope unless the user requests a
change. Keep previous versions when versioning is part of the user's workflow.

These are validation patterns, not a mandate for any particular palette,
heading size, number of sections, portrait treatment, alternating background
scheme, or layout direction. Choose those from the project evidence and brief.
