# Google Sheet schema

Use one workbook named `LinkedIn Client Acquisition` unless the user supplies a
different name. Preserve unknown user columns; do not delete data to enforce the
schema.

## Content Library

One row per post/content item.

| Column | Purpose |
|---|---|
| Content ID | Stable ID such as `LI-0001`; never renumber |
| Title | Internal title |
| Topic | Primary topic |
| Angle | Primary angle/takeaway |
| Audience | Intended reader |
| Objective | Authority, education, proof-of-work, discussion, etc. |
| Content Intent | `discovery`, `authority`, `conversion`, or `relationship` |
| Content Pillar | Optional recurring-series classification |
| Source File | Markdown filename |
| Source File Link | Google Drive link |
| Research Link | Research/evidence file link |
| Revision | Integer revision |
| Content Hash | SHA-256 of exact final post body |
| Final Post Text | Exact approved/draft publishing snapshot |
| Approval | `draft`, `needs_review`, `approved`, `declined`, `archived` |
| Visual Status | `not_assessed`, `not_needed`, `planned`, `in_progress`, `ready`, `failed` |
| Visual Type | `none`, `image`, `document` |
| Primary Visual Link | Drive link |
| Publish Status | `not_queued`, `queued`, `scheduled`, `posted`, `failed`, `skipped` |
| Priority | Optional operational priority |
| Sync State | `synced`, `local_newer`, `drive_newer`, `conflict`, `not_synced` |
| Created At | Timestamp |
| Updated At | Timestamp |
| Notes | Free text |

## Publishing Queue

One row per planned publication attempt.

| Column | Purpose |
|---|---|
| Queue ID | Stable queue record ID |
| Content ID | Link to Content Library |
| Planned Date | Local target date |
| Planned Time | Local target time |
| Timezone | Explicit timezone |
| Mode | `publish_now` or `schedule` |
| Caption Snapshot | Exact text to submit |
| Content Hash | Hash of caption snapshot |
| Asset Link | Approved Drive asset |
| Status | `queued`, `pending_approval`, `pending_verification`, `scheduled`, `posted`, `failed`, `skipped` |
| Scheduled For | Verified LinkedIn schedule, when applicable |
| Published At | Verified publication time |
| Post URL | Live LinkedIn URL |
| Last Verified | Verification timestamp |
| Failure Reason | Exact blocker/failure |
| Notes | Free text |

## Visual Assets

| Column | Purpose |
|---|---|
| Asset ID | Stable asset ID |
| Content ID | Parent content |
| Type | `image` or `document` |
| Variant | Optional variant name |
| Filename | Stored filename |
| Drive Link | Asset link |
| Source Hash | Content hash used to generate it |
| QA Status | `draft`, `verified`, `failed`, `unverified` |
| Approved | `yes`, `no`, `pending` |
| Created At | Timestamp |
| Notes | Free text |

## Prospects

| Column | Purpose |
|---|---|
| Prospect ID | Stable ID |
| Name | Person name |
| Profile URL | LinkedIn profile URL |
| Company | Current company |
| Company URL | Company/profile/site URL when known |
| Role | Current role |
| Location | Public professional location when available |
| Website | Official person or company website when relevant |
| Company LinkedIn URL | Official company LinkedIn page when available |
| Industry | Publicly stated company/market industry |
| Company Size | Published employee range |
| Employee Count | Exact public count only when explicitly published |
| Company Location | Public headquarters or operating location |
| Public Business Email | Explicitly published professional contact email only |
| Public Business Phone | Explicitly published business phone only |
| Authenticated-Visible Professional Email | Professional email visible in the authorized LinkedIn session; record visibility and source |
| Authenticated-Visible Professional Phone | Professional phone visible in the authorized LinkedIn session; record visibility and source |
| Contact Routes | Verified available routes such as comment, connection, message, email, phone, website, or contact form |
| Contactability Status | `multiple`, `linkedin_only`, `email_available`, `phone_available`, `company_route`, `no_verified_route`, or `blocked` |
| Last Contactability Checked | Timestamp/date of the latest route check |
| Prospect Type | `buyer`, `referrer`, `partner`, `peer`, `other` |
| Why Relevant | Concrete reason |
| First Seen | Timestamp/date |
| Last Interaction | Timestamp/date |
| Relationship Stage | `discovered`, `commented`, `engaged`, `connected`, `conversation`, `inactive` |
| Lead Stage | `none`, `lead`, `qualified`, `opportunity`, `proposal`, `won`, `lost` |
| Next Action | Concrete next action |
| Next Action Date | Optional date |
| Source | Where the person was discovered |
| Enrichment Status | `not_started`, `partial`, `complete`, `blocked`, `stale` |
| Last Enriched | Timestamp/date of the latest bounded public-source pass |
| Enrichment Summary | Concise verified findings and unresolved conflicts |
| Notes | Free text |

## Prospect Evidence

One row per material public fact used to enrich a prospect. Keep the prospect
row concise and retain field-level provenance here.

| Column | Purpose |
|---|---|
| Evidence ID | Stable evidence ID |
| Prospect ID | Related prospect |
| Field | Prospect field supported by the evidence |
| Value or Summary | Observed value or concise factual summary |
| Source URL | Public source URL |
| Source Type | `linkedin_profile`, `linkedin_company`, `linkedin_contact_info`, `official_website`, `registry`, `public_business_source`, or `other` |
| Visibility | `public` or `authenticated_visible`; record the actual visibility |
| Retrieved At | Retrieval timestamp/date |
| Confidence | `high`, `medium`, or `low` |
| Status | `observed`, `conflicting`, or `not_found` |
| Notes | Scope, caveat, or reason a value was not used |

## Interactions

| Column | Purpose |
|---|---|
| Interaction ID | Stable ID |
| Prospect ID | Related prospect |
| Date/Time | Interaction time |
| Topic | Relevant topic |
| Type | `comment`, `comment_reply`, `connection_request`, `connection_accept`, `dm_sent`, `dm_received`, `meeting`, `other` |
| Post URL | Related post when applicable |
| External Action URL | Verified comment, message, or other LinkedIn action URL when available |
| Post Summary | Short factual summary |
| Our Text | Exact comment/message |
| Their Text | Relevant reply text or summary |
| Status | `drafted`, `pending_approval`, `pending_verification`, `submitted`, `verified`, `declined`, `failed`, `skipped` |
| Next Action | Suggested/approved next step |
| Notes | Free text |

## Pipeline

Only genuine commercial opportunities belong here.

| Column | Purpose |
|---|---|
| Lead ID | Stable lead ID |
| Prospect ID | Related prospect |
| Company | Company |
| Problem | Problem described by the prospect |
| Service Fit | Relevant service/capability |
| Evidence | Concrete evidence for qualification |
| Stage | `lead`, `qualified`, `opportunity`, `proposal`, `won`, `lost` |
| Next Step | Concrete next step |
| Next Step Date | Optional date |
| Potential Value | Optional amount, only when grounded |
| Currency | Currency for value |
| Source | Interaction/post/referral source |
| Notes | Free text |

## Topics

| Column | Purpose |
|---|---|
| Topic ID | Stable topic ID |
| Topic | Topic name |
| Search Terms | Search/query expansion |
| Audience | Intended audience |
| Commercial Relevance | Why it matters to target clients/referrers |
| Active | `yes` or `no` |
| Notes | Free text |

## Post Performance

Store only metrics that can actually be observed or supplied.

| Column | Purpose |
|---|---|
| Content ID | Related post |
| Post URL | Live post URL |
| Published At | Publication time |
| Snapshot At | Metric capture time |
| Impressions | Visible metric if available |
| Reactions | Visible metric |
| Comments | Visible metric |
| Reposts | Visible metric |
| Inbound Conversations | Identifiable conversations plausibly linked to the post |
| Qualified Leads | Identifiable qualified leads plausibly linked to the post |
| Notes | Caveats/attribution notes |

## Dashboard

Use formulas/pivots only after the underlying tabs contain enough data. Do not
manufacture conversion rates from missing denominators or uncertain attribution.
