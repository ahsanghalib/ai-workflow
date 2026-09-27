---
name: linkedin-publish
description: >-
  Use when publishing or scheduling the user's own approved LinkedIn posts from
  the shared publishing queue in an authenticated LinkedIn browser session.
  Verifies the exact UI result and conditionally updates authorized workspace
  state; does not draft new posts, create visuals, comment on other posts, or
  perform lead follow-up.
license: MIT
---

# LinkedIn publish

Publish or schedule only content that is already approved and synchronized. This
skill is an execution layer, not an editor.

## Preconditions

Prefer the shared `Publishing Queue` and `Content Library` from
`linkedin-workspace`.

Before touching LinkedIn, confirm:

- `Approval=approved`;
- `Sync State=synced` when persistent workspace state is available;
- the queue `Caption Snapshot` matches the approved `Content Hash`;
- any required asset has `Visual Status=ready` and an approved asset record;
- the exact target account/profile is visible in the authenticated LinkedIn UI.

If the browser session, queue, approved snapshot, or required asset cannot be
verified, stop and report the blocker. Do not repair approval or synchronization
state inside this execution skill.

If these conditions are not met, return the item to the appropriate skill rather
than silently fixing it here.

## External-action approval

By default, process one post at a time.

Before posting or scheduling, show:

- Content ID/title;
- exact final text;
- asset/document to be attached;
- action: publish now or schedule;
- exact date/time/timezone when scheduling.

Ask for approval of that exact action. Approval for one item does not authorize a
different post, time, asset, or account.

A user may explicitly approve a batch only when every Content ID, exact caption,
asset, date/time, and action is shown in the batch plan. Do not treat a vague
"schedule the rest" as approval when the exact queue changed since review.

## Workflow

1. Read the next eligible queue item.
2. Reconfirm the approved revision/hash and asset link.
3. Open LinkedIn's post composer in the authenticated browser session.
4. Enter the exact approved caption. Do not rewrite it to fit the UI. If the UI
   rejects or truncates it, stop and return it to `linkedin-post`.
5. Attach the exact approved image/document when required. For document posts,
   use the available local/Drive picker and verify the selected filename/title.
6. Configure audience/comment controls only when specified by the user or an
   existing workspace rule. Do not invent new restrictions.
7. After the explicit approval described above, submit the exact action; do not
   ask for a broader or duplicate approval. For `publish_now`, submit. For
   `schedule`, set the exact approved local date/time and use LinkedIn's current
   scheduling UI.
8. Wait for visible completion and verify the resulting state:
   - published: capture the live post URL and visible content identity;
   - scheduled: confirm the post appears in LinkedIn's scheduled-post state with
     the expected time/content.
9. Only after verification update `Publishing Queue` and `Content Library`.
10. If the outcome is ambiguous, leave the queue record `pending_verification`,
    record the ambiguity, and do not automatically retry. Use `failed` only
    when LinkedIn visibly reports failure.

## Platform rules

Read [references/platform-notes.md](references/platform-notes.md) when a current
LinkedIn limit or supported post type matters. Recheck official LinkedIn Help at
execution time instead of trusting stale numeric limits.

The live LinkedIn UI is authoritative. Scheduling availability can differ by
post type/account/interface; if the expected control is absent, report the
blocker rather than forcing a workaround.

## No implicit editing

Do not:

- add/remove hashtags, CTAs, mentions, links, emojis, or line breaks for style;
- replace the approved asset;
- change document title/caption meaning;
- use LinkedIn's AI draft feature to rewrite approved copy;
- mark a post scheduled/posted because a local or Sheet action succeeded.

Any material content change requires a new approved revision/hash.

## Completion report

Report Content ID, action, verified status, scheduled/published time, live post
URL when available, exact asset used, and any failure/ambiguity. Update the
authorized workspace only to the state visibly confirmed by LinkedIn. If that
write is unavailable, report the verified UI result and the unsynchronized
workspace state without claiming the Sheet was updated.
