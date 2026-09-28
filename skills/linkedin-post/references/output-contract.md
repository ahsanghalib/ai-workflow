# LinkedIn post output contract

## Source artifact and operational state

The Markdown post file is the detailed source artifact. When the shared Google
Sheet is available, `Content Library` is the operational index and contains an
exact publishing snapshot of `Final Post Text` plus revision/hash/status fields.

Do not make `posts.md` mandatory once the Sheet exists. It may remain as a local
cache/export for compatibility with the existing corpus.

## Local layout

Preserve the current local layout when it already exists:

```text
<linkedin-workspace>/posts/
├── posts.md                         # optional local index/cache after migration
├── research-YYYY-MM-DD.md
├── post-<slug>-YYYY-MM-DD.md
├── post-<slug>-YYYY-MM-DD.pdf
└── post-<slug>-YYYY-MM-DD.png
```

Do not rename the user's existing imported files merely to adopt a new naming
convention. Stable identity comes from `Content ID`, not the filename.

## Post file

Keep, when available:

```markdown
# LinkedIn post: <title>

- Content ID: LI-0001
- Status: DRAFT | APPROVED-UNPUBLISHED
- Revision: 1
- Research date: YYYY-MM-DD
- Topic: ...
- Primary angle: ...
- Core takeaway: ...
- Audience: ...
- Objective: ...
- Content intent: discovery | authority | conversion | relationship
- Content pillar: ... (optional for a one-off post)

## Prior-content comparison
...

## Final post text

<exact LinkedIn text>

## Optional alternatives
...

## Sources and caveats
...

## Visual-generation handoff
- Visual status: not_assessed | not_needed | planned | in_progress | ready | failed
- Visual type: none | image | document
- Output files: ...
- QA receipt: ...
```

For existing files, add missing operational metadata only when the user asks to
update the corpus; do not destroy the old structure.

## Hash and revision

- `Content Hash` is SHA-256 of the exact `Final Post Text` publishing snapshot.
- Increment `Revision` when the final body changes.
- Cosmetic changes outside the post body do not require a content revision.
- Sync the same revision/hash to `Content Library`.
- If a different approved body exists in Sheet/Drive/local state and precedence
  is unclear, set `Sync State=conflict` and do not overwrite silently.

## Approval

A draft/reviewed file is not publishable. Only explicit approval of the exact
revision changes `Approval` to `approved` / file status to
`APPROVED-UNPUBLISHED`.

Do not infer publication from approval, visual generation, or file upload. The
user publishes or schedules manually. Record the outcome only when the user
supplies the exact LinkedIn post URL or explicitly confirms scheduling or
publication through the workspace tracking workflow.

## Manual publication and scheduling handoff

After the exact post is approved and any required visual is ready:

- set `Publish Status=ready_for_manual_post` in `Content Library`;
- leave `Post URL`, `Scheduled For`, and `Published At` blank until the user
  reports the outcome;
- when the user confirms scheduling, set `Publish Status=scheduled`, record
  `Publication Evidence=user_confirmed_scheduled`, optionally record
  `Scheduled For`, and leave `Post URL` blank;
- when the user supplies the exact LinkedIn URL, update `Post URL`, set
  `Publish Status=posted`, and record `Publication Evidence=user_supplied_url`;
- when the user confirms publication without a URL, set `Publish Status=posted`
  and record `Publication Evidence=user_confirmed_posted` while leaving `Post URL`
  blank;
- record `Published At` only when the user supplies the time or it is otherwise
  explicitly known;
- if the outcome is ambiguous or a supplied URL cannot be tied to the Content ID,
  keep the row at `ready_for_manual_post` and ask for clarification.

No skill in this workflow opens LinkedIn to publish or schedule the user's post.
