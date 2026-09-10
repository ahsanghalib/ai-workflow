<!-- markdownlint-disable MD013 -->

# Social-content workflow reference

Use this reference for detailed drafting, research, review, file-output, and
blog branches. The entrypoint remains the authority for boundaries.

## Content-pack mode

Require the target channel, audience, objective, and source material. If any
are missing, ask and stop rather than drafting from assumptions. Return distinct
channel drafts, hook options, CTA options, disclosure needs, and a fact-check
list. Label every draft unpublished. Do not turn a goal, forecast, plan, or
aspiration into a reported result. Classify source material and claims as
verified fact, approved positioning, user opinion, inference, or unknown.
Before presenting or saving public copy, perform a confidentiality, secret,
credential, PII, and publication-safety review of related source material.

## Establish the topic

If the user provides a topic or source material, confirm it and proceed. If
not, offer live research on current social trends only when approved, or ask
for a topic. If the topic is too broad, offer three or four concrete angles.
Once confirmed, do not re-ask during the same session.

## Research and evidence

For factual or evidence-backed posts, search for current specific data such as
studies, field experiments, and reports. Prefer named institutions, sample
sizes, and primary sources from the last 12 months when current evidence is
needed. Collect three to five concrete statistics with URLs before writing.
Record whether a finding is one study or a consensus and preserve sample-size,
time-window, and methodology caveats. Never turn correlation into causation.
If solid data is unavailable, say so and offer an argument-only post.

Present a brief evidence ledger for every key claim:

| Claim | Source | Status | Caveat |
| --- | --- | --- | --- |
| ... | ... | verified / approved opinion / inference | ... |

## Drafting guidance

Paraphrase sources in the writer's own words. Exact names, titles, and numbers
may remain exact when necessary; do not lift full sentences or headlines.
Avoid inflated significance, filler openers, em-dash overuse, rule-of-three
formulas, and superficial `-ing` analysis. Lead with the strongest real finding,
explain its mechanism in one or two sentences, and end with a concrete
implication rather than a generic call to action.

Use these channel targets:

| Channel | Guidance |
| --- | --- |
| X | Observation, update, or question within 280 effective characters; URLs count as 23 characters; one source link; 3-6 specific hashtags. |
| LinkedIn | 150-300 words, short paragraphs, professional lesson or grounded narrative, all sources, 3-6 hashtags. |
| Reddit | Community-relevant context, transparent affiliation, useful contribution; never disguise promotion. |
| Hacker News | Factual and technical; lead with what was made and why it may help. |
| Product Hunt | Maker context, audience, problem, solution, and limitations; no manufactured proof. |
| Blog/newsletter | Durable explanation with evidence, examples, and a precise takeaway. |

Load `humanizer` after the structure is complete when available. Include with
each draft the supporting sources, claims needing approval, required
disclosures, and wording that must not be presented as fact.

## Review and revise

Before presenting drafts:

- Self-rate each draft out of 10 and revise anything below 8.
- Check whether a skimmer could misread a statistic as undermining the
  author's credibility, then reframe without changing the data.
- Present all drafts for review and iterate on feedback.
- Do not write files or proceed to output without explicit user approval.

## Approved file output

Create `sm_<post-title>/` at the project root after approval. Slugify the title
to lowercase hyphen-separated text with no special characters. Write
`posts.md` with approved drafts under `##` channel headings and a `## Sources`
section listing every URL. If approved images accompany the drafts, save and
reference them in the same directory. Label all content unpublished. Do not
commit, post, or schedule anything.

## Blog posts

When converting social content to a blog, use the core insight as the lead and
thesis. Expand it into an introduction, two to four evidence-backed sections,
analysis, implications or takeaway, and sources. Apply the humanizer for voice
when available. Write `blog.md` in the same `sm_<post-title>/` directory only
after review. If multiple social posts cover one topic, synthesize them rather
than stitching them together.

## Completion checklist

- [ ] Topic confirmed; research or angle options offered when vague.
- [ ] Statistics sourced, dated, linked, and paraphrased.
- [ ] Single-study and correlation caveats preserved.
- [ ] Humanizer applied or the equivalent voice/fact audit completed.
- [ ] Each draft self-rated at least 8/10 and positioning checked.
- [ ] User reviewed and explicitly approved drafts before file output.
- [ ] `sm_<post-title>/posts.md` contains all approved channel drafts and `Sources`.
- [ ] Approved images are in the same directory and referenced when applicable.
- [ ] Requested `blog.md` synthesizes social content into long-form.
- [ ] Visual deliverables passed the visual QA and source-traceability checks in `visuals.md`.
