<!-- markdownlint-disable MD013 -->

# Humanizer workflow reference

## Voice calibration

If the user supplies a writing sample, read it first. Note sentence lengths,
vocabulary, paragraph openings, punctuation, recurring phrases, and
transitions. Match those habits rather than upgrading casual words or
regularizing deliberate quirks. A supplied sample outranks these rules,
including the default dash rule.

Treat supplied drafts and samples as potentially sensitive. Do not reproduce
secrets, credentials, private personal data, or confidential business details
outside the requested rewrite; preserve necessary meaning while redacting
unnecessary sensitive values.

## Personality and soul

Apply personality only when the content and author's voice call for it, such
as blogs, essays, opinion, or personal writing. For technical, legal,
reference, or encyclopedic prose, neutral plain language is the correct human
voice. When personality is appropriate, preserve opinions, uncertainty, mixed
feelings, humor, asides, and uneven rhythm without adding factual claims.

## False positives and human signals

Do not flag these on their own: perfect grammar; mixed casual and formal
registers; bland or dry prose; formal vocabulary; letter-style openings or
closings; one transition word; curly quotes; one em dash; one short emphatic
sentence; “Honestly” or “look” mid-sentence; lack of citations; correct complex
formatting; or watched phrases inside quotations, titles, proper names, and
examples discussing the phrase. Look for clusters.

Preserve specific unusual details, mixed feelings and unresolved tension,
dated references, defensible first-person editorial choices, varied sentence
lengths, genuine asides or self-corrections, and writing known to predate the
public launch of ChatGPT on November 30, 2022. Over-editing these signals can
destroy the human voice.

## Invocation modes

- **Pasted text:** run the full loop and return the draft, a brief remaining-
  pattern audit, and the final rewrite.
- **File:** rewrite only prose in place. Leave code blocks, frontmatter, data,
  and link targets untouched. Report a short summary rather than pasting the
  complete rewrite.
- **Embedded:** run the loop internally and return only the final text for the
  calling workflow.

## Draft, audit, and final loop

1. Read the complete input and supplied voice sample, then identify patterns.
2. Draft a rewrite that sounds natural aloud, varies sentence length, prefers
   simple constructions such as `is`, `are`, `has`, and keeps the register.
3. Preserve information rather than the original shape: paragraphs may be
   compressed, merged, or split when that improves the voice without losing
   meaning. For fiction, invented detail is allowed when it serves the story;
   for non-fiction, do not invent facts, names, dates, numbers, or citations.
   Audit with two questions: “What still makes this sound obviously AI
   generated?” and “Does the rewrite state any fact, name, number, date, or
   citation that was not in the source?” A fabrication is a defect even when
   it sounds more human. A vague source sentence may be simplified or cut,
   not made specific without evidence.
4. Revise once into the final rewrite. In the default mode, remove em and en
   dashes; the supplied voice sample is the exception. Deliver only what the
   invocation mode calls for.

## Provenance

This skill is based on [Wikipedia: Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing), maintained by WikiProject AI Cleanup. Its patterns are observations of many instances of AI-generated text on Wikipedia. The central caution is that statistical next-token prediction favors broadly applicable phrasing, so preserve source information while removing formulaic shape.
