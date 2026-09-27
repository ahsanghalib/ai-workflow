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

## Lead

`none -> lead -> qualified -> opportunity -> proposal -> won/lost`

A LinkedIn connection is not a lead. A reply is not automatically a lead.
Record the concrete commercial signal that justifies each transition.

## External action verification

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
