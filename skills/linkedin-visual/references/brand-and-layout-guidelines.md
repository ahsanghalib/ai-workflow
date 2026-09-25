# Brand and layout guidelines

Use this reference to apply supplied brand rules to a LinkedIn document. It is
not permission to invent a brand identity. A user-provided brand source or an
approved project-local rule is authoritative; a temporary campaign choice must
be labeled separately.

## Approved Ahsan LinkedIn identity

This profile is an explicit user-approved identity for the user's LinkedIn
visuals. It is inspired by the inspected Langfuse reference's editorial
engineering feel, warm paper surface, restrained grid, and bright highlight,
but it does not copy Langfuse's logo, name, assets, exact font files, or brand
claims.

### Direction

**Editorial engineering notes**: calm, technical, open, precise, and slightly
unexpected. Use a quiet paper field, near-black ink, thin structural rules,
one high-energy highlight, and small utility labels. The visual should feel
like a well-designed engineering note rather than a generic AI poster.

### Composition grammar from the reference

The reference site's strongest design signal is its page system, not only its
colors. Translate that system into a carousel as follows:

- **Announcement strip:** a thin near-black band for the series or topic label.
  Keep it informational, not promotional.
- **Utility header:** a quiet identity row with the supplied name and domain.
- **Information rail:** a narrow left rail for topic, section, post number, or
  a small “why?” prompt. It should orient the reader without competing with the
  main content.
- **Framed canvas:** place the main argument in a white or near-white bordered
  panel over the paper field. Use corner marks and fine rules as structural
  cues.
- **Tab strip:** use a small set of section labels to show the document's
  progression, with one dark selected tab per page. Do not pretend the tabs are
  interactive in a static PDF.
- **Module rhythm:** alternate a hero statement with ruled data panels,
  outlined cards, integration-style grids, diagrams, proof rows, CTA blocks, or
  FAQ rows. Keep the modules useful to the argument.
- **Technical background:** use faint diagonal rules, pale geometry, and
  blueprint-like traces as atmosphere. Never use decorative geometry as proof.
- **Footer:** keep the exact professional identity and pagination in a stable,
  quiet baseline.

Do not reproduce Langfuse's logo, copy, navigation labels, product claims,
customer proof, exact layout dimensions, or proprietary assets. The reference
provides a composition language; Ahsan's content, identity, and evidence remain
the source of truth.

### Semantic tokens

<!-- markdownlint-disable MD060 -->

| Token | Value | Role |
|---|---|---|
| `paper` | `#F4F4EE` | warm off-white page background |
| `paper-deep` | `#EAEAE3` | secondary surface or side panel |
| `ink` | `#161A1D` | headline and primary text |
| `ink-soft` | `#4B555C` | body copy and secondary text |
| `grid` | `#D6DAD5` | rules, frames, and quiet separators |
| `lime` | `#F1F36D` | headline highlight and key emphasis |
| `signal-blue` | `#2A60D4` | links, markers, and rare action cues |
| `white` | `#FEFEFA` | contrast surface and selected text |

<!-- markdownlint-enable MD060 -->

Use `lime` for one idea at a time. Use `signal-blue` sparingly; it is a
navigation or annotation cue, not a second dominant brand color. Do not add
gradients, glowing effects, or a rainbow palette without a new approval.

The five selectable campaign schemes are documented in
[color-schemes.md](color-schemes.md). They preserve this identity's geometry,
typography, header, footer, and semantic roles while allowing the skill to pick
one palette per carousel. Do not mix schemes within a single carousel.

### Typography

- Display: `Space Grotesk` SemiBold/Bold when available; use `Noto Sans`
  SemiBold/Bold as the local fallback. The display role may use tight line
  breaks and large scale, but never sacrifice readability.
- Body: `Inter` Regular/Medium when available; use `Noto Sans` Regular/Medium
  as the local fallback.
- Technical labels and code: `IBM Plex Mono` or `Noto Sans Mono` fallback.
- Use one display family, one body family, and one monospace family at most.
  Do not download fonts or claim a font is embedded unless the runtime verifies
  it.

### Layout and geometry

- Sample/default campaign geometry: portrait 4:5, `1080 × 1350` design units;
  the exact PDF page size must be recorded in the brief and approved.
- Use a generous outer margin, a visible but quiet frame, and a simple two-
  column option for evidence or comparison pages.
- Align headlines, body copy, diagrams, and source notes to one shared grid.
- Use asymmetry deliberately: a large highlighted headline can sit against
  open paper space, while supporting details remain quiet and ordered.
- Keep one dominant idea per page. Prefer whitespace over extra cards,
  gradients, or decorative dashboard chrome.

### Header and footer contract

Apply this exact identity to every page unless the user approves a variant:

- Header, left: `M. Ahsan Izhar`
- Header, right: `ahsanizhar.com`
- Footer, left: `Senior Software Engineer`
- Footer, right: page pagination in the form `1/5` ... `5/5` or `1/7` ... `7/7`

Use the same placement, casing, and punctuation across the document. Keep the
identity small and subordinate to the page message. Pagination must reflect the
actual approved page count; never leave `1/5` or `1/7` on every page.

Do not add a logo, employer, client, sponsor, title variation, social handle,
or additional domain without explicit approval. The supplied domain is exactly
`ahsanizhar.com`.

### Branch and variant rules

The base identity is the default branch. A topic or campaign may select one of
the five named color schemes or vary the highlight label, diagram accent, or
section marker, but must retain the typography and header/footer contract.
Record any variant with:

- branch name and purpose;
- changed tokens or assets;
- pages affected;
- expiry/review date if temporary;
- approval owner.

Do not create a new color branch merely to distinguish adjacent posts. Use the
topic label, page marker, or a small signal-blue annotation first.

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

## Color schemes

When approved tokens exist, use their exact names and values from the supplied
source. When they do not exist and a neutral draft is requested, define a
temporary scheme with roles rather than presenting arbitrary colors as brand:

- `background`: page field;
- `surface`: cards, code blocks, or grouped content;
- `text`: primary readable text;
- `muted`: secondary text only when contrast remains sufficient;
- `primary`: main identity or structural accent;
- `secondary`: supporting category or section accent;
- `accent`: one attention cue used sparingly;
- `success`, `warning`, or `error`: semantic states only when needed.

Document contrast decisions and non-color cues. Do not use color alone to
communicate sequence, status, or category. Avoid adding gradients, neon
accents, or a “tech” palette unless the approved identity calls for them.

## Typography and hierarchy

Record the approved typeface, fallback, weight, line height, and hierarchy. If
the font is unavailable, do not install it or silently substitute it in a brand
claim; record the fallback and request approval where the difference matters.

Use a restrained hierarchy for:

- section label or eyebrow;
- page headline;
- supporting text;
- code, data, or quotation treatment;
- footer, page number, and source note.

Hierarchy should survive grayscale, zoom, and mobile viewing.

## Headers

Headers are optional. If used, document:

- exact text, logo, mark, or section label;
- whether it appears on every page or only section pages;
- alignment, safe area, and contrast;
- whether it is a campaign label or a permanent brand rule.

Do not put an unapproved personal name, company name, claim, or logo in a
header.

## Footers

Footers may contain page number, approved identity, domain, source note,
copyright, disclosure, or a short next action. Confirm each item explicitly.
Never guess the user's name, title, domain, repository URL, sponsor, or legal
notice. Keep the footer subordinate to the page argument and readable at the
selected geometry.

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
