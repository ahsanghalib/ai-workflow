# User-Flow, Schema, and Contract Traceability

Use this reference when a project has optional shared flow, schema-context,
API, or frontend documents that need stable cross-feature links. It keeps
documents aligned; it does not authorize implementation or make any document a
prerequisite for SPEC creation.

## Stable references

- A feature SPEC may reference an exact user-flow journey, state, permission,
  validation, or failure heading when shared flow documentation exists.
- When persistence is relevant, reference executable schema, migrations, ORM
  definitions, or an approved contextual schema document. Do not duplicate
  executable schema without a durable reason.
- Preserve established document names and anchors. Links may point to an
  equivalent existing source of truth.
- If a concern is not applicable or remains unresolved, record that explicitly
  in the SPEC rather than inventing a document or entity.

## Required SPEC traceability fields

When relevant, a SPEC records:

- **User-flow references:** exact journey/state links and supported behavior;
- **Schema references:** exact entity/table links or not-applicable/unresolved;
- **API/shared-contract references:** existing contracts or none;
- **Frontend surface references:** route, screen, component, or not-applicable;
  and
- **Schema impact:** `none`, `read-only`, `new entity`,
  `field/constraint change`, `relationship change`, `retirement`, or
  `unresolved`.

## API and shared-contract rules

Each API endpoint, event, or shared transport contract identifies relevant
flow and schema references when it reads or writes persistent data. It also
records the schema-impact classification. Transport contracts expose deliberate
shapes, not database models.

If a change alters fields, nullability, authorization scope, lifecycle,
relationships, or persistence semantics, pause for the appropriate SPEC,
technical-design, or schema-design review before implementation.

## Frontend rules

Each frontend route, screen, or feature surface identifies the API/shared
contracts it consumes and its relevant flow when shared documentation exists.
Frontend behavior must not invent a new entity, field, permission, or lifecycle
state outside the approved SPEC and contracts.

## Schema-impact review

Use `schema-design` before implementation when a feature or contract has a
material persistence impact beyond confirmed read-only use of an existing
entity. Review ownership, tenant boundaries, fields, constraints, indexes,
deletion/retention, concurrency, migration compatibility, and API/frontend
effects. Record behavior-preserving conclusions in the same SPEC's `#
Execution` section.

## Change propagation

- A shared user-flow change prompts review of affected SPECs, contracts, and
  schema references.
- A schema change prompts review of affected API, frontend, SPEC, migration,
  and compatibility references.
- An API or shared-contract change prompts flow, schema-impact, and frontend
  review as applicable.
- A frontend-only change may avoid schema review when the SPEC and contracts
  confirm no behavior, persistence, permission, or API change.

Record affected references, owner, approval state, validation, and next action
in the SPEC execution record or the relevant project document.
