# User Flow: `<Project Name>`

> The technology-neutral description of how people and other actors use the
> product. Keep product direction in `MASTER_PLAN.md` and persisted-data design
> in `docs/DB_SCHEMA.md`.

**Status:** Draft | Proposed | Approved | Superseded
**Last reviewed:** YYYY-MM-DD
**Source of truth:** `docs/USER_FLOW.md` or the existing project-selected path

## Purpose and Scope

<!-- Describe whose behavior this document explains and what is out of scope. -->

## Confirmed User Outcomes

<!-- Record only outcomes confirmed by the user or existing project evidence. -->

-

## Proposed Outcomes and Open Questions

-

## Actors and Permissions

| Actor | Goal | Allowed actions | Restricted actions |
| --- | --- | --- | --- |
| `<actor>` | `<goal>` | `<actions>` | `<restrictions>` |

## Entry Points and Navigation

<!-- Describe how each actor enters the product and moves between major areas.
     Do not choose a frontend framework or URL structure here. -->

| Entry point | Actor | Prerequisites | Destination or next step |
| --- | --- | --- | --- |
| `<entry>` | `<actor>` | `<prerequisite>` | `<next step>` |

## User Journeys

Repeat this section for each confirmed or clearly labelled proposed journey.

### Journey: `<name>`

**Status:** Confirmed | Proposed | Needs clarification

**Actor and goal:**

**Starting condition:**

**Successful outcome:**

1. `<actor>` `<action>`.
2. The product `<response>`.
3. `<actor>` `<next action>`.

**Information needed:**

<!-- Identify concepts and data needs without inventing tables or API routes. -->

**Permissions and ownership:**

**Validation and feedback:**

**Failure and recovery:**

**End states:**

## States and Transitions

| Object or journey | State | Trigger | Next state | User-visible result |
| --- | --- | --- | --- | --- |
| `<object>` | `<state>` | `<event>` | `<state>` | `<result>` |

Describe loading, empty, success, validation-error, permission-denied,
not-found, conflict, offline, and unexpected-error behavior when relevant.

## Rules and Invariants

<!-- Record behavior that must remain true across journeys. -->

-

## Accessibility and Interaction Expectations

<!-- Record confirmed keyboard, screen-reader, responsive, language, and
     reduced-motion expectations without selecting implementation tools. -->

## Schema and Contract Dependencies

<!-- Link approved schema entities and later contracts after they exist. A flow
     may identify data needs, but it must not silently define database tables. -->

- Schema reference: `<approved schema link | not applicable | unresolved>`
- API/contract references: `<add links here>`

`docs/DB_SCHEMA.md` is optional. Do not create or link it until persistence is
approved and this user-flow document has been reviewed.

## Assumptions, Recommendations, and Unresolved Decisions

### Assumptions

-

### Recommendations

-

### Unresolved Decisions and Approval Gates

-

## Validation Plan

- [ ] Each journey has an actor, goal, starting condition, and outcome.
- [ ] Permissions, ownership, validation, failure, and recovery are explicit.
- [ ] Loading, empty, success, and relevant error states are covered.
- [ ] Confirmed, proposed, assumed, and unknown behavior is labelled.
- [ ] Dependent SPECs identify the relevant user journeys.

## Non-Goals

- Choosing a framework, route structure, database table, or implementation file.
- Creating API contracts, migrations, models, services, or UI code.
- Treating proposed behavior as approved product scope.

## Approval Gates

- [ ] User reviewed the proposed journeys and open decisions.
- [ ] Relevant permissions and failure behavior are approved.
- [ ] Dependent SPECs may reference this flow after review.

Verdict: ready for feature planning | needs clarification
