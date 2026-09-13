<!-- Provenance: bundled project-init template.
     Routing index: .ai/prompts/README.md. -->

# Create a Feature SPEC

Use `project-init` after reading the approved project direction, user flow,
architecture, relevant rules, and plan index. If persistence is approved,
read the approved schema; if persistence is not approved, record
`Schema: not applicable` and do not invent entities. If persistence is still
unresolved, record `Schema: unresolved` and stop at the open approval gate.

Create only the requested SPEC with status `Proposed`. Define goal, scope,
non-goals, actors, behavior, invariants, validation, states, failures, edge
cases, authorization, compatibility, and acceptance criteria.

Include exact user-flow references, approved schema entities or an explicit
not-applicable/unresolved status, API/shared-contract references, frontend
surfaces, and a schema-impact classification. Route nontrivial persistence or
contract impact to schema-impact review before PLAN creation.

For an initial feature map, derive candidates from reviewed `MASTER_PLAN.md`,
`docs/USER_FLOW.md`, and the approved schema when persistence is relevant. Let
the user select one feature before creating its SPEC. For later requests,
confirm whether the request is a new feature or SPEC revision and trace any
persisted data to approved schema entities. For example, “create a SPEC for
adding income details” must create or revise only that feature's SPEC and must
repeat the same review/PLAN/approval gates.

Do not create a PLAN or implement code. Stop for user review and route to
`spec-review` when requested.
