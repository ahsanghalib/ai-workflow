<!-- Provenance: bundled project-init template.
     Routing index: .ai/prompts/README.md. -->

# Create an Implementation PLAN

Use `project-init` only after the exact SPEC has been reviewed and approved.

Create one `Proposed` PLAN with dependency-ordered observable tasks, TDD order
where a runnable seam exists, architecture and schema impact, environments,
migration/rollback boundaries, tests, validation, and handoff.

Repeat the SPEC's user-flow, approved-schema, API/shared-contract, and
frontend references. Identify the schema-impact review and validation evidence
for each affected task group; do not invent entities or contracts in the PLAN.

Update the existing plan index without replacing unrelated entries, and allocate
the next stable ID. Route the exact PLAN to `plan-review` and
`plan-consistency-review` when relevant before asking the user for approval.

Do not mark the PLAN approved, implement tasks, create branches, or change
remote state. Preserve the existing plan index and numbering system. After the
user approves the PLAN, hand off only the next task to `implement-next` plus
the relevant backend/frontend skill, then use review, verification, and
session-state handoffs.
