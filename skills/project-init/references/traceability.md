# User-Flow, Schema, and Contract Traceability

Traceability keeps product behavior, persisted data, transport contracts, and
implementation planning aligned. It links documents; it does not authorize
implementation or silently create schema, API, or frontend behavior.

## Prerequisites and stable references

- Review `docs/USER_FLOW.md` before creating a feature SPEC that has actor,
  journey, state, permission, validation, or failure behavior. Reference the
  exact journey or state heading, preferably with a stable `FLOW-*` or
  `STATE-*` identifier when the project uses identifiers.
- When persistence is approved, review `docs/DB_SCHEMA.md` before defining
  API, frontend, SPEC, or PLAN data behavior. Reference the exact approved
  entity/table heading, preferably with a stable `ENTITY-*` identifier when
  the project uses identifiers.
- If persistence is not approved, write `Schema: not applicable` or
  `Schema: unresolved` and do not invent entities from an API or screen idea.
- Preserve the project's established document names and anchors. Links may
  point to an equivalent existing source of truth.

## Required traceability fields

### Feature SPEC

Every feature SPEC records:

- **User-flow references:** exact flow/journey/state links and the behavior
  they support;
- **Approved schema entities:** exact entity/table links, or an explicit
  not-applicable/unresolved status;
- **API and shared-contract references:** existing contracts or a statement
  that the feature has none;
- **Frontend surface references:** affected route, screen, component, or an
  explicit not-applicable status; and
- **Schema impact:** `none`, `read-only`, `new entity`, `field/constraint
  change`, `relationship change`, `retirement`, or `unresolved`.

### Implementation PLAN

Every PLAN repeats the SPEC's traceability and adds:

- the approved SPEC path and exact flow/schema references for each task group;
- API, shared-contract, and frontend surfaces affected by the task;
- schema or migration work and its dependency on an approved schema review;
- the contract and schema-impact review required before implementation; and
- validation evidence showing that the implementation still satisfies the
  referenced flow and schema invariants.

Do not replace a traceability link with a copied summary that can go stale.

## API and shared-contract rules

Each API endpoint, event, or shared transport contract identifies its relevant
user-flow journey/state and approved schema entities when it reads or writes
persistent data. It also records the schema-impact classification. API
contracts expose deliberate transport shapes, not database models.

If an API change alters fields, nullability, authorization scope, lifecycle,
relationships, or persistence semantics, pause for schema-impact review and
update the approved schema contract before implementation planning continues.

## Frontend rules

Each frontend route, screen, or feature surface identifies its relevant
user-flow journey/state and the API/shared contracts it consumes. When the
surface displays or edits persisted data, it also identifies the approved
schema entities indirectly through those contracts or directly where the
project's documentation convention requires it.

Frontend behavior must not invent a new entity, field, permission, or lifecycle
state. If the needed contract or schema reference is missing, leave the choice
unresolved and return to the appropriate design/review gate.

## Schema-impact review

Run schema-design review before implementation planning when a feature or
contract has any impact other than `none` or a confirmed read-only use of an
existing entity. Re-review the relevant API, frontend, SPEC, and PLAN when the
approved schema changes.

At minimum, review:

- ownership, tenant boundaries, and authorization implications;
- new or changed fields, nullability, defaults, constraints, and indexes;
- relationship cardinality and deletion/retention behavior;
- concurrency and consistency requirements;
- migration, backfill, compatibility, and rollback limits; and
- API/frontend contract effects and validation coverage.

Do not create migrations, models, routes, services, or UI while doing this
documentation traceability or schema review.

## Change propagation

- A **user-flow change** triggers review of affected SPECs, API contracts,
  frontend surfaces, and schema references.
- A **schema change** triggers schema-impact review plus affected API,
  frontend, SPEC, PLAN, migration, and compatibility review.
- An **API or shared-contract change** triggers flow, schema-impact, SPEC,
  PLAN, and frontend review as applicable.
- A **frontend-only change** may avoid schema review only when its SPEC and
  contract links confirm no behavior, persisted data, permission, or API change.

Record the affected references, owner, approval state, validation, and next
review action in the SPEC/PLAN activity or review artifact.
