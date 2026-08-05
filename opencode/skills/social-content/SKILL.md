---
name: social-content
description: Use when drafting truthful, channel-specific social or editorial content for X, LinkedIn, Reddit, Hacker News, Product Hunt, blogs, or newsletters from supplied source material, or planning approved data visuals. Do not use for publishing, outreach, engagement, fabricated testimonials, or unsourced promotional claims.
compatibility: OpenCode Agent Skills; no bundled executable dependencies
metadata:
  modified-for: OpenCode
---

# Social Content

Turn approved source material into useful, truthful drafts that fit the target
channel and audience. Drafting is not publishing, outreach, or engagement.

## Boundaries

- Use supplied source material as the truth source. Distinguish verified facts,
  approved positioning, user-provided opinion, inference, and unknowns.
- Never fabricate metrics, customer outcomes, testimonials, endorsements,
  partnerships, availability, pricing, urgency, product capabilities, or personal
  experience. Do not turn a goal into a reported result.
- Do not publish, schedule, submit, post, reply, vote, contact users, collect
  accounts, access social-network sessions, or create accounts. Do not use web
  research unless explicitly requested and approved.
- Do not impersonate people, customers, communities, or platform moderators.
- Do not optimize for engagement through deception, fake scarcity, outrage bait,
  undisclosed sponsorship, or instructions to evade platform or community rules.
- Do not use Anthropic's internal-communications material as a source for this
  skill. This workflow is original and limited to user-provided public-content
  drafts.
- Do not research, create files, install packages or fonts, start a browser,
  render images, or inspect screenshots unless the user explicitly requests and
  approves that work. Do not hardcode personal or product identity; use only
  supplied brand rules and assets.

## Workflow

### 1. Establish the brief and evidence ledger

Identify the target channel, audience, intent, source material, approved call
to action, publication owner, timing constraints, and success signal. Ask only
for information that can materially change a claim, audience fit, or CTA.

List each material claim with its source and status: verified, approved opinion,
inference, or unknown. Remove unsupported claims or rewrite them as clearly
labelled questions, hypotheses, or requests for feedback.

### 2. Choose a channel-native angle

Select one useful angle rather than restating every product feature. Adapt the
shape and level of context, not the underlying facts:

- **X:** concise observation, update, or question with a clear point.
- **LinkedIn:** professional lesson, practical result, or grounded narrative.
- **Reddit:** community-relevant context, transparent affiliation, and a useful
  question or contribution; never disguise promotion as discussion.
- **Hacker News:** factual, technical, and restrained; lead with what was made
  and why it may be useful.
- **Product Hunt:** clear maker context, audience, problem, solution, and
  limitations; do not manufacture social proof.
- **Blog or newsletter:** durable explanation with evidence, examples, and a
  precise takeaway.

Respect supplied channel and community rules. If they are unavailable, flag the
uncertainty rather than asserting compliance.

### 3. Draft, disclose, and fact-check

Write channel-specific drafts with a concrete opening, useful body, explicit
affiliation where relevant, and an approved CTA. Preserve essential caveats and
avoid absolute claims unless the source proves them.

For every draft, include a fact-check list that identifies supporting sources,
claims needing approval, required disclosures, and wording that must not be
presented as fact. Provide hooks and CTAs as alternatives, not instructions to
publish.

### 4. Return drafts and pause

Return this package:

```markdown
## Brief and Audience

## Evidence Ledger

## Channel Strategy and Required Disclosure

## Drafts

### [Channel]

## Hook Options

## CTA Options

## Fact-Check and Approval List

## Open Questions and Publishing Boundary
```

Label all drafts as unpublished. Stop after drafting; the user retains all
publication, timing, account-access, and engagement decisions.

## Optional data-visual branch

Use this branch only when the user explicitly requests evidence research or
visual assets and approves the required tools, files, and commands.

### Evidence research

Collect concrete, linkable sources before drafting evidence-led copy. Prefer
primary studies, reports, or original data; record institution or author, date,
sample or scope, methodology limitations, and whether a finding is isolated or
consensus. Do not state correlation as causation, omit material caveats for a
stronger hook, or use an unsourced statistic.

When strong evidence is unavailable, say so and offer a clearly labelled
argument or opinion draft without numerical claims. Paraphrase sources rather
than reproducing article text. Check platform limits at the time of delivery;
for X, account for URL shortening and keep a free-tier post within 280 effective
characters.

### Data-visual proposal and production

Before creating anything, propose the exact deliverables, project-local output
path, visual system, source-to-claim mapping, existing renderer, and QA method.
Wait for approval. Reuse existing project brand assets, tokens, local fonts, and
rendering tools; do not install dependencies, call image-generation APIs, or
load remote assets without separate approval.

For an approved visual set, make every displayed number traceable to its source.
Design for the specific subject and one clear idea per image, with bounded text,
reserved footer space when the supplied brand requires it, accessible contrast,
and realistic longest-copy checks. After approved rendering, inspect the actual
output for overflow, overlap, legibility, and source attribution; do not infer
visual quality from markup alone.

Report the source map, output paths, render evidence, untested states, and any
brand or factual uncertainty. Visuals remain unpublished artifacts.
