---
name: social-content
description: Use when drafting truthful, channel-specific social or editorial content for X, LinkedIn, Reddit, Hacker News, Product Hunt, blogs, or newsletters from supplied source material, or planning approved data visuals. Use when asked to create blog posts from existing social content. Do not use for publishing, outreach, engagement, fabricated testimonials, or unsourced promotional claims.
license: MIT
compatibility: OpenCode Agent Skills; no bundled executable dependencies
metadata:
  modified-for: OpenCode
---

# Social Content

Draft truthful, channel-specific social and editorial content from approved
source material. Every non-obvious claim must trace to a real, named, linkable
source. Outputs are unpublished drafts saved to version-controlled files; the
user retains all publication, timing, and engagement decisions.

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
- Do not hardcode personal or product identity; use only supplied brand rules and
  assets. The footer template below is a placeholder — ask for the actual name,
  title, and domain before rendering.
- Do not create files, install packages or fonts, start a browser, render
  images, or inspect screenshots unless the user explicitly requests and approves
  that work.

## Workflow

### 1. Establish the topic

If the user provides a specific topic or source material, confirm it and
proceed. Otherwise:

- Offer to research current social media trends and conversations via live
  search, or ask the user to supply a topic directly.
- If the topic is too broad to act on (e.g. "post about AI"), offer 3-4
  concrete angle options and ask which one.
- Once a topic is confirmed, do not re-ask this session.

### 2. Research and gather evidence

If the post should be factual or evidence-backed:

- Search for current, specific data: studies, field experiments, reports.
  Prefer named institutions, sample sizes, and primary sources from the last 12
  months. Collect 3-5 concrete stats with source URLs before writing any copy.
- Note whether a finding is a single study rather than consensus, and preserve
  material caveats (sample size, time window, methodology limits). Do not
  convert correlation into causation for a stronger hook.
- Treat every source with normal epistemic caution. If solid data can't be
  found, say so and offer to write an argument-only post.

Present a brief evidence ledger to the user: each key claim with its source,
status (verified / approved opinion / inference), and any caveats.

### 3. Draft with the humanizer skill

Load the humanizer skill to strip AI-writing tells from every draft. Apply it
after the content is structurally complete.

Channel-specific guidance:

- **X:** concise observation, update, or question. Must fit 280 effective
  characters (URLs count as exactly 23 chars regardless of real length). One
  source link, 3-6 specific hashtags.
- **LinkedIn:** 150-300 words, short paragraphs, professional lesson or grounded
  narrative. List all sources used. 3-6 hashtags.
- **Reddit:** community-relevant context, transparent affiliation, useful
  contribution. Never disguise promotion as discussion.
- **Hacker News:** factual, technical, restrained. Lead with what was made and
  why it may be useful.
- **Product Hunt:** clear maker context, audience, problem, solution, and
  limitations. Do not manufacture social proof.
- **Blog or newsletter:** durable explanation with evidence, examples, and a
  precise takeaway.

Voice rules for all channels:

- Paraphrase every source in your own words. Never lift a sentence or headline
  verbatim. A stat that needs exact wording to stay accurate (a precise
  percentage, a named study title) is fine; full sentences are not.
- Avoid: inflated significance language, filler openers ("Honestly," "Here's the
  thing"), em-dash overuse, rule-of-three formulas, superficial "-ing" analyses.
- Lead with the most counterintuitive real finding, explain the mechanism in 1-2
  sentences, end with a concrete implication — not a generic call to action.

Include a fact-check list with each draft: supporting sources, claims needing
approval, required disclosures, and wording that must not be presented as fact.

### 4. Review and revise

Before presenting drafts to the user:

- Self-rate each draft out of 10. Below 8 → revise before showing it.
- Sanity-check positioning: could a skimmer misread a stat as undermining the
  poster's credibility (their business, job search, expertise)? If so, reframe
  the argument without changing the data.
- Present all drafts for user review. Iterate on feedback.
- **Do not write files or proceed without explicit user approval.**

### 5. Output approved content to files

Once the user approves:

- Create `sm_[post_title]/` at the project root. Slugify the post title:
  lowercase, hyphens, no special characters.
- Write `posts.md` containing all approved channel drafts, separated by `##`
  channel headings.
- Add a `## Sources` section listing every URL referenced in the posts.
- If images were generated or approved alongside the drafts, save them in the
  same directory and reference them from `posts.md`.
- Label all content as unpublished. Do not create GitHub commits, posts, or
  schedule anything.

## Blog posts

When asked to create a blog post from social content:

- Use the social post's core insight as the blog's lead and thesis.
- Expand into longer-form: intro hook → 2-4 body sections with evidence and
  analysis → implications or takeaway → sources.
- Load the humanizer skill for voice. The blog should feel like the natural
  long-form version of the social post, not a padded outline.
- Write `blog.md` in the same `sm_[post_title]/` directory (create it if it
  doesn't exist yet).
- If multiple social posts on the same topic exist, synthesize them into one
  coherent draft rather than stitching posts together.
- Present for review; do not save without approval.

## Optional data-visual branch

Use only when the user explicitly requests visual assets and approves the
required tools, files, and commands.

### Evidence research for visuals

- Collect concrete, linkable sources before designing any visual. Prefer primary
  studies, reports, or original data. Record institution or author, date, sample
  or scope, methodology limitations, and whether a finding is isolated or
  consensus.
- Paraphrase sources rather than reproducing article text. Check platform limits
  at delivery time; for X, account for URL shortening (23 chars per URL).
- When strong evidence is unavailable, say so and offer a clearly labelled
  argument or opinion visual without numerical claims.

### Image specifications

- Prefer SVG as the source format: text stays sharp, files are version-
  controllable, and layouts are inspectable without a headless browser. Convert
  to PNG only when a platform requires raster (Instagram, some OG previews).
- **1 hero image** (1200×630): universal OG/link-preview size, shared by
  LinkedIn and X. No slide numbering. Deliver as SVG and a derived PNG.
- **1 Instagram carousel** (1080×1080, 4-6 slides): hook slide → one slide per
  stat → closing takeaway slide. Number slides as `n/total`. Deliver as SVGs
  with derived PNGs.

### Design process

1. Before writing any SVG/HTML/CSS, define a token system: color (4-6 named hex
   values), type (a display face, a body face, a mono/utility face if
   data-heavy), layout (one-sentence concept + ASCII wireframe), and signature
   (one memorable element specific to the subject).
2. Critique the plan against the brief. Ground the visual metaphor in the
   subject itself — a post about code review earns an actual code-diff motif
   because that's what the content is, not because diffs look techy.
3. Avoid three default AI-generated looks: cream background + warm-clay serif;
   near-black background + single neon accent with no other structure; broadsheet
   hairline-rule newspaper columns. Take one deliberate, justified aesthetic risk
   instead.
4. If using HTML/CSS, build and inspect the rendered PNG before shipping — not
   just the source. Check spacing, contrast, and whether the "one bold thing per
   slide" rule held.
5. Every number from the copy should appear large in at least one slide, in a
   consistent accent color.

### Anti-overlap layout rules

With SVG, verification is direct: open the file in a browser and inspect text
placement visually. No render step obscures the layout. For HTML/CSS, verify by
eye on the rendered screenshot, not just the code:

- Check font-size/line-height/container combos against the longest realistic
  headline or sub-copy. Long headlines must wrap within a bounded `max-width` or
  drop to a smaller size — never spill past the canvas or collide with adjacent
  blocks.
- Leave explicit vertical breathing room (min. ~40-60px at 1080-wide scale)
  between every stacked block. No two text blocks share a bounding box.
- The footer is a fixed reserved zone with this content on every slide (hero
  included), left and right:
  - Left: `[Your Name] | [Your Title] | [your-domain.com]`
  - Right: slide index as `n/total` — omit only on the hero image, which has no
    sequence.
  Ask the user for the exact name, title, and domain before rendering.
- Re-render and re-view after any copy change. Text that fit at one length may
  overflow after a rewrite.

For SVG specifically: use `font-family` with system fallback stacks (e.g.
`"Inter", "Helvetica Neue", Arial, sans-serif`). Text must be actual `<text>`
elements — not paths — so it remains selectable and version-diffable. Avoid
`<foreignObject>` for critical content; it renders inconsistently across SVG
viewers.

### Data-visual proposal and approval

Before creating anything, propose the exact deliverables, project-local output
path, render format (SVG preferred; PNG derived where platforms require it),
visual system, source-to-claim mapping, and QA method. Wait for approval. Reuse
existing project brand assets, tokens, local fonts, and rendering tools; do not
install dependencies, call image-generation APIs, or load remote assets without
separate approval.

After approved rendering, inspect the actual output for overflow, overlap,
legibility, and source attribution. For SVG, open each file in a browser and
visually confirm layout at the target dimensions. For PNG, view the rendered
image directly — do not infer quality from the source alone. Report the source
map, output paths, render evidence, untested states, and any brand or factual
uncertainty.

## Output checklist

- [ ] Topic confirmed (offered research or angle options if vague)
- [ ] All stats sourced, dated, linked, and paraphrased (not quoted)
- [ ] Single-study/correlation caveats preserved, not stripped for punch
- [ ] Humanizer skill applied to all drafts
- [ ] Self-rated ≥ 8/10, positioning sanity-checked
- [ ] User reviewed and explicitly approved all drafts
- [ ] `sm_[post_title]/posts.md` written at project root with all channel drafts
- [ ] `## Sources` section included with every referenced URL
- [ ] Images saved in same directory and referenced from posts.md (when
  approved)
- [ ] Blog post: `blog.md` written in same directory, synthesizes social posts
  into long-form (when requested)
- [ ] Data-visual: SVGs produced for all slides, with derived PNGs where
  platforms require raster (when approved)
- [ ] Data-visual: SVGs opened in a browser and visually confirmed at target
  dimensions; text is `<text>` elements, not paths (when approved)
- [ ] Data-visual: every displayed number traceable to its source (when
  approved)
- [ ] Data-visual: footer uses user-supplied name/title/domain, not hardcoded
  (when approved)
