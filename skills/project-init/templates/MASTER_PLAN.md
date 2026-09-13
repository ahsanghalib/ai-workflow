# Master Plan

> Owner: user. AI may review/refine this document but should not silently
> choose product scope or priorities.

**Status:** Draft | Proposed | Approved | Superseded
**Last reviewed:** YYYY-MM-DD

## How to Use This Document

Keep this file at product-direction and roadmap level. Record confirmed facts,
proposals, assumptions, recommendations, and unknowns in separate sections.
Describe detailed user behavior in `docs/USER_FLOW.md` when actor or system
journeys apply. Describe persisted-data design in `docs/DB_SCHEMA.md` only
after persistence is approved and the user-flow contract has been reviewed.

## Product

### Problem

### Target Users

### Product Goal

### Non-Goals

### Confirmed Requirements

<!-- Facts and outcomes confirmed by the user or existing project evidence. -->

-

### Proposed Features and Outcomes

<!-- Ideas are not approved scope until the user reviews them. -->

-

### Assumptions

-

### Recommendations

-

### Open Questions

-

## Technical Direction

<!-- For each decision, record status (Unknown / Proposed / Confirmed), the
     selected value only after approval, rationale, evidence, and open boundary.
     Keep unresolved choices open. -->

### Repository Shape

<!-- single repo / monorepo -->

### Tech Stack

### Core Applications

### Shared Packages

### Database and Data Access

<!-- Link docs/DB_SCHEMA.md when persistence is approved. Record whether access
     uses an ORM, query builder, raw SQL, or an approved combination. -->

### Authentication and Sessions

### API and Contracts

### Testing and Quality

### Local Development Dependencies

<!-- PostgreSQL, Redis, etc. Only what is actually needed. Do not define
     hosting here. -->

## Foundation

<!-- Brief notes only: auth, organizations, contracts, API standards, etc. Add
     only what this product needs. -->

### User Flow Reference

- `<docs/USER_FLOW.md link | not applicable | unresolved>`

### Schema Reference

- `<docs/DB_SCHEMA.md link | not applicable | unresolved>`

### Control References

- [`docs/PROJECT_ARCHITECTURE.md`](./docs/PROJECT_ARCHITECTURE.md)
- [`AGENTS.md`](./AGENTS.md)

## Features

### 1. `<Feature>`

**Goal:**

**Brief scope:**

**Depends on:**

### 2. `<Feature>`

**Goal:**

**Brief scope:**

**Depends on:**

## Current Priority

## Deferred / Later

<!-- Future ideas that are explicitly out of current scope. -->

## Review and Approval Gates

- [ ] Product direction and proposed scope reviewed by the user.
- [ ] User flow reviewed in `docs/USER_FLOW.md` when actor or system journeys apply.
- [ ] Persistence decision and `docs/DB_SCHEMA.md` reviewed when applicable.
- [ ] Technical direction and local-development decisions approved.
- [ ] Feature SPECs created and reviewed before implementation PLANs.
- [ ] PLANs reviewed and explicitly approved before implementation.

## Decision Status

<!-- Keep unresolved decisions here until the user approves them. -->

### Confirmed Decisions

-

### Unresolved Decisions and Approval Gates

-
