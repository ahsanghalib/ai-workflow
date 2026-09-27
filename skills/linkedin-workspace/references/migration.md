# Existing Markdown migration

Use this for the user's existing post corpus.

## Import, then improve

The first migration is inventory work, not editorial work. Preserve the original
files unchanged. Do not humanize, fact-check, rewrite, rename, or generate visuals
as a side effect of importing them.

## Parse when present

Extract these fields from the current post format when available:

- status;
- post number;
- research date;
- topic;
- primary angle;
- core takeaway;
- audience;
- objective;
- content intent and content pillar when present;
- exact `Final post text` body;
- sources/caveats;
- visual-generation status and links.

If a field is missing, leave it blank or mark it for review. Do not infer a
personal claim or publication status.

## Stable IDs

Preserve existing numeric post identifiers. A suitable mapping is:

- post `1` -> `LI-0001`
- post `23` -> `LI-0023`

For a file with no stable number, assign the next unused ID and record that it
was assigned during migration.

## Duplicates

Use exact path, existing post number, source link, and final-text hash before
creating a second row. Similar topics are not duplicates by themselves.

## Review queue

After migration, set clearly unfinished/draft posts to `Approval=needs_review`.
Preserve explicitly approved posts as `approved` when the source file states that
status. Never mark a post `posted` unless publication is independently known.
