---
name: linkedin-workspace
description: >-
  Use when setting up, migrating, synchronizing, auditing, or reporting the shared
  LinkedIn client-acquisition workspace across local Markdown files, Google Drive,
  and Google Sheets. Owns the data model and state synchronization; does not draft
  comments, publish LinkedIn posts, or send messages.
license: MIT
---

# LinkedIn workspace

Maintain the persistent operational layer for the LinkedIn client-acquisition
system. Prefer one Google Drive folder plus one native Google Sheet workbook when
those capabilities are available. Local Markdown files remain valid source
artifacts; the Sheet is the operational index and workflow state.

## Business objective

The workspace exists to measure and support this funnel:

`visibility -> credibility -> conversations -> qualified leads -> paying clients`

Do not optimize the system around likes, comments, or follower counts alone.

## Durable workflow order

For an owned LinkedIn post, use this order:

`research/evidence -> draft -> Content Library persistence -> content approval ->`
`optional visual persistence -> Publishing Queue persistence -> external-action`
` approval -> publish/schedule -> live UI verification -> Sheet state update`

For comments, connection requests, and warm follow-up messages, use:

`discovery/context -> exact draft -> Interaction persistence -> action approval ->`
`live re-check -> submit -> live UI verification -> Interaction/Prospect update`

The exact draft and its identifiers must exist in the Sheet before the relevant
approval request. A successful LinkedIn action is never a substitute for the
final verified Sheet update; if that update fails, reconcile by stable ID and do
not retry the external action automatically.

Public prospect enrichment is additive and provenance-led. Preserve existing
user-entered values, write only professional public data or professional
contact data visible in the user's authorized LinkedIn session, store
field-level source and visibility evidence in `Prospect Evidence`, and represent
missing or conflicting values explicitly instead of guessing or overwriting
them. Authenticated-visible contact details are operationally sensitive: do not
copy them into public comments, posts, or shared artifacts without a separate
purpose and approval.

## Authority hierarchy

Use these sources in this order for their respective facts:

1. **LinkedIn live UI** — authoritative for whether a comment, connection,
   schedule, publication, reply, or other external LinkedIn action actually happened.
2. **Approved Markdown/source artifact** — authoritative for research context,
   evidence, revision history, and the exact approved post body.
3. **Google Sheet** — authoritative for operational state, queue state, links,
   prospect/interaction state, next actions, and reporting.
4. **Drive file metadata** — authoritative for stored asset/file location.

Never change a stronger source merely because a weaker source disagrees.

This hierarchy determines which fact wins; it does not authorize a remote
mutation. Before creating a Drive folder/workbook, uploading a file, or writing
Sheet state, identify the exact target, show the intended change, and confirm
that the user has authorized that workspace operation. A read-only audit may
inspect available state without creating or repairing remote resources.

## References

Read:

- [references/google-drive-layout.md](references/google-drive-layout.md)
- [references/google-sheet-schema.md](references/google-sheet-schema.md)
- [references/state-rules.md](references/state-rules.md)
- [references/migration.md](references/migration.md) for existing local content.

## Setup workflow

1. Resolve the local workspace, if any. Never scan unrelated home directories.
2. Detect whether an authorized Google Drive/Sheets capability is available.
3. If an authorized write capability and user-selected target are available,
   create or reuse the Drive layout and the single workbook defined by the
   references. Do not create a separate Sheet per skill. Otherwise report the
   proposed layout without mutating remote state.
4. Reuse existing tabs and columns when compatible. Add missing columns without
   deleting user data.
5. Record the workbook and root Drive folder as the workspace targets for the
   current run.
6. If Google access is unavailable, continue with local/session state for
   read-only discovery and drafting where the requested task permits it, and
   clearly mark unsynchronized changes. Do not ask for approval or take an
   external comment/connection action from `linkedin-engagement` until the
   required draft row is persisted and verified, unless the user explicitly
   selects a session-only workflow. Do not treat a local row as proof of an
   external LinkedIn action.

## Migration workflow

For an existing Markdown corpus, especially the user's current LinkedIn posts:

1. Inventory filenames and metadata first. Do not rewrite content during import.
2. Read the existing index (`posts.md`) when present, then parse each post file.
3. Preserve existing stable post numbers. Convert them to stable `Content ID`
   values without renumbering. Assign IDs only where none exist.
4. Extract the exact `Final post text` body as the Sheet publishing snapshot.
5. Compute a SHA-256 hash of the exact final post text, not of unrelated notes.
6. Re-check the authorized write capability and user-selected Drive target
   immediately before uploading. If either is unavailable, retain the local
   source and report the unsynchronized upload instead of guessing a target.
   Upload the original Markdown files without changing their contents.
7. Create/update `Content Library` rows idempotently only after the target and
   write authorization are confirmed; otherwise prepare a local migration
   report without pretending the Sheet changed.
8. Map old statuses conservatively. Never infer `posted` or `scheduled` without
   an external publication record or verified LinkedIn state.
9. Link research and existing visual files when they exist; otherwise leave the
   visual state as `not_assessed`.
10. Produce a migration report with imported, skipped, duplicate, conflict, and
    unresolved counts.

## Synchronization

When a post changes after migration:

- increment `Revision`;
- update the exact Sheet `Final Post Text` snapshot;
- recompute `Content Hash`;
- update the Drive source file only after re-checking the authorized capability
  and selected target;
- set `Sync State=conflict` rather than silently overwriting when two approved
  revisions differ and precedence cannot be established.

When an external action is attempted but its result cannot be verified, record
`pending_verification` in the corresponding Publishing Queue or Interaction
record; keep Content Library content state at `queued` until fresh evidence
resolves the attempt. Do not convert ambiguity into `posted`, `sent`, or
`failed`, and do not retry automatically.

A browser-only workflow may publish from the Sheet snapshot when the local file
is unavailable, but only if `Approval=approved`, `Sync State=synced`, and the
snapshot hash matches the approved revision recorded in the Sheet.

## Reporting

Use the workbook to report useful funnel facts such as:

- posts drafted, approved, queued, scheduled, and posted;
- comments verified and replies received;
- connection requests and accepts;
- conversations, qualified leads, calls, proposals, wins, and losses;
- which topics/angles generated identifiable conversations or leads.

Do not fabricate attribution. If a lead cannot be tied to a specific post or
interaction, record the source as unknown or mixed.
