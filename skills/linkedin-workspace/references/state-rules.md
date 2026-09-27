# State rules

## Content

`draft -> needs_review -> approved -> queued -> scheduled/posted`

The operational fields are separate; do not collapse them into one status.
Approval describes content approval, visual status describes the asset, and
publish status describes LinkedIn publication.

## Relationship

`discovered -> commented -> engaged -> connected -> conversation`

Stages may be skipped only when the actual interaction supports it. Do not call
someone `engaged` merely because the user commented on their post.

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
- For post publication and scheduling, `pending_approval` means the exact
  caption snapshot, content hash, target action, and required asset state are
  persisted in the `Publishing Queue` row and the external-action approval is
  still pending.
- `submitted` means an action was attempted.
- `verified` means the live LinkedIn UI visibly confirms the exact action.
- `pending_verification` means an action was attempted but the result is
  ambiguous. Do not retry automatically or treat it as completed.
- For publication, keep the Content Library content state at `queued` until the
  corresponding Publishing Queue row is resolved from fresh visible evidence.
- `scheduled` means LinkedIn shows the post in its scheduled state with the
  expected content/time.
- `posted` means the live post is visible and its URL was captured.

Never infer external completion from local files or Sheet rows.
