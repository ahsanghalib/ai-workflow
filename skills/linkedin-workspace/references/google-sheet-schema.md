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
| Publish Status | `not_ready`, `ready_for_manual_post`, `scheduled`, `posted`, `not_applicable` |
| Post URL | Exact LinkedIn post URL supplied by the user after manual publication |
| Scheduled For | Schedule time confirmed by the user, when known |
| Published At | Publication time supplied by the user, when known |
| Publication Evidence | `not_provided`, `user_confirmed_scheduled`, `user_supplied_url`, `user_confirmed_posted` |
| Priority | Optional operational priority |
| Sync State | `synced`, `local_newer`, `drive_newer`, `conflict`, `not_synced` |
| Created At | Timestamp |
| Updated At | Timestamp |
| Notes | Free text |

## Manual publication and scheduling tracking

Owned posts do not use a separate queue tab. After approval and any required
visual approval, set `Content Library.Publish Status=ready_for_manual_post`.
The user publishes or schedules independently. If the user confirms a schedule,
record `Publish Status=scheduled` and `Publication Evidence=user_confirmed_scheduled`;
leave `Post URL` blank because LinkedIn may not provide a scheduled-post URL. If
the user later supplies the live LinkedIn URL, record `Post URL`, set
`Publish Status=posted`, and use `Publication Evidence=user_supplied_url`. The
workspace must not claim live UI verification or schedule a post itself.

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
| Prospect Type | `company` or `individual` |
| Relationship Context | Free-text context such as `buyer`, `hiring_contact`, `referrer`, `partner`, `peer`, `candidate`, or another evidence-backed role; not a prospect-type enum |
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

## Hiring Posts

One row per qualifying hiring or recruiting post. This is a dedicated worksheet
in the shared workbook, linked to the enriched company or individual prospect
in `Prospects` and the exact response in `Interactions`.

| Column | Purpose |
|---|---|
| Hiring Post ID | Stable ID such as `HIR-0001`; never renumber |
| Prospect ID | Linked company or individual prospect |
| Post URL | Exact LinkedIn hiring-post URL |
| Author Name | Name shown on the post |
| Author Profile URL | LinkedIn profile URL when available |
| Company | Company named or shown in the post |
| Company URL | Official company URL when known |
| Company LinkedIn URL | Official company LinkedIn page when available |
| Role or Team | Role, team, or hiring need stated in the post |
| Hiring Post Type | `job_opening`, `candidate_request`, `referral_request`, `recruiting_announcement`, `career_update`, `interview`, or `other` |
| Published At | Published timestamp when visible |
| Captured At | Timestamp when the post was reviewed |
| Location | Public role/location information |
| Work Mode | `onsite`, `hybrid`, `remote`, or `not_stated` |
| Employment Type | Employment type when stated |
| Seniority | Seniority when stated |
| Skills or Keywords | Relevant skills or terms stated in the post |
| Application or Referral URL | Official route shown in the post; do not imply submission |
| Post Summary | Short factual summary |
| Why Relevant | Concrete fit or relationship reason |
| Application Status | Manual field; the skill must not set or change it; the user may set `applied` or `not_applied` |
| Interaction ID | Linked exact comment or connection-request record |
| External Action URL | Verified LinkedIn action URL when available |
| Last Verified | Timestamp of the latest UI/state verification |
| Source Visibility | `public` or `authenticated_visible` |
| Notes | Conflicts, caveats, and reconciliation notes |

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
