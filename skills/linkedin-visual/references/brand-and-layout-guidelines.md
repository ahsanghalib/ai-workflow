# Brand and layout guidelines

Use this reference to apply supplied brand rules to a LinkedIn document. It is
not permission to invent a brand identity. A user-provided brand source or an
approved project-local rule is authoritative; a temporary campaign choice must
be labeled separately.

## Approved Ahsan LinkedIn identity

This profile has an explicit user-approved local editable design system. The
complete source of truth is
[ahsan-local-design-system.md](ahsan-local-design-system.md), and the
rendered references in `../examples/design/` show its intended direction.
Those renders are not assets to paste into the source presentation. Do not
infer additional brand rules from an external reference, screenshot, or
example.

### Direction

**Editorial engineering notes**: calm, technical, open, precise, and slightly
unexpected. Use a quiet paper field, near-black ink, thin structural rules,
one cobalt focal highlight, and small monospace utility labels. The visual
should feel like a well-designed engineering note rather than a generic AI
poster.

The system is deliberately restrained: one focal idea per page, left-aligned
content by default, useful diagrams and rules, and enough paper space for
mobile reading. Do not introduce decorative composition rules that compete
with the approved argument.

### Semantic tokens

<!-- markdownlint-disable MD060 -->

| Token | Value | Role |
|---|---|---|
| `paper` | `#F7F7F4` | page field |
| `ink` | `#16181D` | primary text |
| `accent-cobalt` | `#2540D9` | one focal idea |
| `gray` | `#5F6472` | secondary text |
| `line` | `#D9DAD4` | rules and dividers |
| `panel` | `#ECECE8` | grouped surfaces and code panels |

<!-- markdownlint-enable MD060 -->

Use `accent-cobalt` for at most one idea per page: a keyword, key path, one bar,
or one number. It is not decoration. Do not add gradients, glow, neon, or any
color outside this six-token system.

### Typography

- Display and headings: `DM Sans 700`.
- Body: `DM Sans 400`.
- Labels and code: `JetBrains Mono`; use `Space Mono` only as a fallback.
- Do not download fonts or claim a font is embedded unless the runtime verifies
  it. Record a fallback when it matters to the output.

### Layout and geometry

- Portrait carousel pages are `1080 × 1350 px`; standalone cards are `1080 ×
  1080 px`.
- Use `88 px` side margins, `170 px` top and bottom clearance, an `8 px` base
  unit, `18 px` box radius, `16 px` code radius, and `2 px` rules.
- Use `124 px` display, `80 px` heading, `36 px` body, and `20 px` uppercase
  monospace labels with `+8%` tracking. Body line-height is `1.4` with a
  maximum line width of `780 px`.
- Keep the page left-aligned by default and give each page one dominant idea.
- Select the smallest content-justified page count; the reusable template set
  is not a mandatory ten-page sequence.

### Shared chrome contract

Apply this exact chrome to every portrait carousel page:

- top left: category label;
- top right: context tag;
- bottom left: `M. Ahsan Izhar - ahsanizhar.com`;
- bottom right: sequential `NN / NN` counter;
- lower-right engineering motif and sparse right-side utility rail as shown in
  the canonical PNGs;
- no generic full-width footer divider on ordinary pages.

Keep casing and punctuation consistent. The footer and utility labels are
supporting structure, not the page's focal message. Standalone square cards may
omit the counter when the brief requires a clean single-card composition.

### Branch and variant rules

The exact token and typography system is the default branch. A topic may vary
the category label, context tag, selected template, diagram content, or page
composition, but may not add colors or fonts.
Record any variant with:

- branch name and purpose;
- changed tokens or assets;
- pages affected;
- expiry/review date if temporary;
- approval owner.

Do not create a new color or font branch merely to distinguish adjacent posts.
Use the topic label, page marker, or page composition first.

## Brand-source inventory

Record the source, scope, owner, and approval state for each rule:

<!-- markdownlint-disable MD013 MD060 -->

| Area | Approved source/token | Scope | Required use | Restrictions or uncertainty |
|---|---|---|---|---|
| Colors | ... | project/campaign | ... | ... |
| Typography | ... | project/campaign | ... | ... |
| Logo/assets | ... | project/campaign | ... | ... |
| Voice/terminology | ... | project/campaign | ... | ... |
| Legal/accessibility | ... | project/campaign | ... | ... |

<!-- markdownlint-enable MD013 MD060 -->

Do not infer a global brand system from one screenshot, post, or example.

## Color use and accessibility

Use only the six canonical tokens above. Pair color with labels, position,
rules, or shape so order, status, and category do not depend on color alone.
Check paper/panel/gray text separately from ink and cobalt focal text. Preserve
the hierarchy in grayscale and for common color-vision differences. Do not use
the accent as a text field unless the contrast check passes.

## Typography and hierarchy

Record the approved typeface, fallback, weight, line height, and hierarchy. If
the font is unavailable, do not install it or silently substitute it in a brand
claim; record the fallback and request approval where the difference matters.

Use a restrained hierarchy for:

- section label or eyebrow;
- page headline;
- supporting text;
- code, data, or quotation treatment;
- category/context labels, footer, source note, and disclosure when needed.

Hierarchy should survive grayscale, zoom, and mobile viewing.

## Identity and utility labels

The shared chrome uses the approved author string in the footer. The approved
AI-engineering role may appear in a closing author block when the selected
composition includes one. Category labels, context tags, page counters, source
notes, and disclosures are utility content and must remain subordinate to the
page message. Do not add a logo, employer, sponsor, social handle, additional
domain, or title variation without explicit approval.

## Optional supporting footer content

Source notes, disclosures, copyright, or a short next action may be placed
where the selected composition keeps them readable. Confirm each item
explicitly. Never guess the user's name, title, domain, repository URL,
sponsor, or legal notice. Do not treat optional supporting content as another
identity requirement.

## Layout variants and branches

If the project has multiple approved branches, audiences, products, or campaign
variants, record the branch identifier and allowed differences:

- inherited global rules;
- branch-specific colors, labels, imagery, or footer;
- prohibited cross-branch assets or claims;
- approval owner for a new variant;
- expiry or review date for a temporary campaign choice.

Do not silently merge conflicting branches. Ask which branch governs the
artifact.

## Brand handoff

Before rendering, the brief should state:

- approved sources used;
- missing rules and neutral defaults, if any;
- conflicts and their decision owner;
- asset and font provenance;
- accessibility and legal constraints;
- exact approval still required.

Route project-provided brand governance through the repository's
`brand-guidelines` capability when available. That capability does not authorize
publishing or asset generation by itself.
