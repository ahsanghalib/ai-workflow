# State rules

## Content

`draft -> needs_review -> approved -> ready_for_manual_post -> scheduled -> posted`

The user may also move directly from `ready_for_manual_post` to `posted` by
confirming publication or supplying the live URL.

The operational fields are separate; do not collapse them into one status.
Approval describes content approval, visual status describes the asset, and
publish status describes the manual-publication handoff and user-supplied
publication result.

## Relationship

`discovered -> commented -> engaged -> connected -> conversation`

Stages may be skipped only when the actual interaction supports it. Do not call
someone `engaged` merely because the user commented on their post.

## Hiring posts

Keep one factual row per qualifying hiring post in the `Hiring Posts` worksheet.
Every row must retain the exact `Post URL`, linked `Prospect ID`, publication
context, source visibility, and linked `Interaction ID` when an action is
prepared. Do not maintain an automated hiring-post workflow status. The
`Application Status` field is manual: leave it blank until the user sets
`applied` or `not_applied`; never infer or change it from a comment, connection,
or application URL. A hiring post is not proof of budget, authority, service
need, candidacy, or application submission.

## Prospect enrichment and contactability

- `public` means accessible without the user's authenticated LinkedIn session.
- `authenticated_visible` means visible to the authorized user in LinkedIn's
  logged-in UI; it is not public and must remain operationally restricted.
- Store professional contact details only when their source and purpose are
  clear. Never infer or guess an email, phone number, employee count, or
  private identity detail.
- Every enriched field and contact route requires a source URL, visibility,
  retrieval date, and confidence in `Prospect Evidence`.
- `Contactability Status` describes observed routes; it does not authorize a
  message, email, call, connection request, or other external action.

## Lead

`none -> lead -> qualified -> opportunity -> proposal -> won/lost`

A LinkedIn connection is not a lead. A reply is not automatically a lead.
Record the concrete commercial signal that justifies each transition.

## External action verification

- For comments and initial connection requests, `pending_approval` means the
  exact draft and its prospect/post context are persisted in the `Interactions`
  row and the user approval is still pending. It does not mean approved,
  submitted, or verified.
- `submitted` means an action was attempted.
- `verified` means the live LinkedIn UI visibly confirms the exact action.
- `pending_verification` means an action was attempted but the result is
  ambiguous. Do not retry automatically or treat it as completed.
- For an owned post, `ready_for_manual_post` means the exact approved content
  and any required approved visual are synchronized in `Content Library`; it
  does not mean the post is live.
- `scheduled` means the user explicitly confirmed that LinkedIn accepted the
  schedule. A URL is not required; record `Scheduled For` when the user supplies
  it and leave `Post URL` blank otherwise.
- `posted` means the user supplied the exact LinkedIn URL or explicitly confirmed
  publication, and the workspace recorded that evidence in the Content Library.
- The workspace never schedules the post or claims live UI verification.

Never infer publication from local files, approval, visual readiness, or Sheet
rows alone. A user-supplied URL or explicit user confirmation is required.
