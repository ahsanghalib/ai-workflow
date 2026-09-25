# LinkedIn post output contract

Use a user-selected runtime workspace. Do not write these artifacts into the
public skill repository unless the user explicitly selects it as the workspace.

## Flat folder layout

```text
<linkedin-workspace>/posts/
├── posts.md
├── research-YYYY-MM-DD.md
├── post-<slug>-YYYY-MM-DD.md
├── post-<slug>-YYYY-MM-DD.pdf
├── post-<slug>-YYYY-MM-DD.png
└── post-<slug>-YYYY-MM-DD-1.png
```

`linkedin-post` creates or updates `posts.md`, `research-*.md`, and
`post-*.md`. `linkedin-visual` owns PDF/PNG/JPG creation. Do not create a
`<slug>/` subfolder.

The date in a post or visual filename is the research-file date, even when the
file is created later. Never overwrite a file silently. If a basename already
exists, use an explicit numeric suffix or a user-approved rename and update
every relative link. Same-day research appends a labeled `## Run HH:MM` section
to the existing daily research file.

## `posts.md`

Keep one complete row for every post and preserve all existing rows. `No.` is a
stable post identifier and must not be renumbered.

<!-- markdownlint-disable MD013 -->

```markdown
| No. | Post topic | Primary angle / takeaway | Post summary | Approval | Posted | Visuals | Research file | Post file | Visual files | Notes |
|---:|---|---|---|---|---|---|---|---|---|---|
| 1 | ... | ... | ... | pending | pending | not_created | [research-YYYY-MM-DD.md](research-YYYY-MM-DD.md) | [post-slug-YYYY-MM-DD.md](post-slug-YYYY-MM-DD.md) | — | ... |
```

<!-- markdownlint-enable MD013 -->

Controlled values:

- `Approval`: `pending`, `approved`, or `declined`;
- `Posted`: `yes`, `no`, or `pending`;
- `Visuals`: `created`, `not_created`, or `not_needed`.

Escape pipe characters and replace line breaks with spaces so each record is
one valid Markdown table row. Keep links relative to the `posts/` folder.
Post files mirror the row's topic, angle, summary, status, and file links.

The skill never publishes or independently verifies external publication. New
rows start with `Posted: pending`. Use `Posted: yes` only after explicit user
confirmation or an approved publication record. Use `Posted: no` only after
explicit confirmation that it was not posted. Preserve `pending` when unknown.

## Research file

Create `research-YYYY-MM-DD.md` before any post file. For each run, include:

- run date/time, request, audience, objective, source-only setting, and count;
- prior-content inventory: existing `posts.md` rows, research files, and post
  files reviewed;
- candidate number, topic, reader question, proposed angle, and takeaway;
- prior files reviewed, overlap, previous angle/takeaway, new angle/takeaway,
  material-difference rationale, and `distinct`/`revise`/`reject` decision;
- search queries, filters, date windows, and research scope;
- evidence ledger with URL, publisher, publication date, retrieval date, source
  type, claim or insight, caveat, status, and supported post number;
- trend signals, fact checks, conflicting evidence, and unresolved issues;
- post-by-post hook direction, key claims, disclosure needs, and visual
  candidacy;
- a statement that `revise` and `reject` candidates were not silently drafted;
- handoff links to each planned post file.

Do not use an unrecorded research decision as the basis for a post file.

## Post file

Each `post-<slug>-YYYY-MM-DD.md` contains:

```markdown
# LinkedIn post: <title>

- Status: DRAFT
- Post no.: <stable number>
- Research date: YYYY-MM-DD
- Topic: <topic>
- Primary angle: <angle>
- Core takeaway: <takeaway>
- Audience: <audience>
- Objective: <objective>
- Research: [research-YYYY-MM-DD.md](research-YYYY-MM-DD.md)
- Index: [posts.md](posts.md#...)

## Prior-content comparison

- Files reviewed: ...
- Overlap: ...
- Material difference: ...

## Final post text

<exact unpublished LinkedIn post text>

## Optional alternatives

<hook or angle alternatives, outside the final post text>

## Sources and caveats

<claim mapping, links, uncertainty, and disclosure notes>

## Visual-generation handoff

- Visual status: not_created | created | not_needed
- Approval required before rendering: yes
- Requested page count: ...
- Color scheme: selected scheme name and token reference ...
- Slide outline: ...
- Source-to-slide map: ...
- Brand/layout reference: ...
- Output files: ...
- QA receipt or unverified checks: ...
```

After per-post approval, change only the status to `APPROVED-UNPUBLISHED` and
record the approval note. Do not erase the research comparison or caveats.

## Batch sequence

1. Inventory the existing corpus.
2. Create or append the daily research file.
3. Research and record evidence.
4. Record an originality decision for every candidate.
5. Add one pending index row per `distinct` candidate.
6. Create one `DRAFT` post file per row.
7. Present the batch for per-post approval and update each row independently.
8. Hand only approved posts to `linkedin-visual`.
