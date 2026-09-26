# Schema Context: `<Project Name>`

> Optional durable context for persisted data. Executable schema and migrations
> remain the structural source of truth; dependent work records only the
> relevant invariants and references.

**Status:** Draft | Proposed | Approved | Superseded
**Last reviewed:** YYYY-MM-DD
**Schema revision:** `<identifier>`
**Source of truth:** executable schema/migrations, or the existing
project-selected path

This context document does not approve a feature or create a second schema
approval gate. Behavior-preserving data design is governed by the approved
SPEC; only decisions outside that contract need fresh user approval.

## Purpose and Scope

<!-- Explain why the project needs persistence and what this document covers. -->

## Confirmed Facts and Invariants

<!-- Record confirmed requirements only. Label assumptions and proposals
     below. -->

-

## Database and Access Decisions

**Database:** `<unknown | selected database and version>`

**Access strategy:** `<unknown | ORM | query builder | raw SQL | approved mix>`

**Migration tooling:** `<unknown | selected tool and ownership>`

**Generated versus hand-written queries:**

**Local development and emulation:**

## Executable Schema and Migration References

Link the authoritative schema, migrations, ORM/entity definitions, and relevant
anchors. Do not copy every table, column, type, constraint, or index here.

- Schema source: `<path or link>`
- Migration source: `<path or link>`
- ORM/entity source: `<path or link | not applicable>`
- Relevant entities, migrations, or anchors: `<links>`

## Durable Ownership and Invariants

Record only cross-entity or cross-domain ownership boundaries and business
invariants that are difficult to infer from executable schema.

- Tenant or owner boundary:
- Cross-domain ownership:
- Business invariants:

## Lifecycle, Retention, and State Guarantees

- Creation and transition guarantees:
- Deletion, archival, and retention rules:
- Recovery or reassignment behavior:

## Constraints, Access Patterns, and Concurrency Semantics

Summarize the reason for important constraints, indexes, access patterns, or
concurrency rules without reproducing their complete executable definitions.

- Important constraint or index rationale:
- Supported access patterns:
- Concurrency and update guarantees:

## Tenant, Authorization, and Privacy Boundaries

<!-- Identify ownership, tenant isolation, access-sensitive fields, retention,
     deletion, audit, and redaction requirements. Do not include secret
     values. -->

## Type, Money, Time, and Identifier Rules

<!-- Define precision, currency, timezone, timestamp, enum, identifier, JSON,
     and serialization rules where relevant. -->

## Concurrency and Integrity

<!-- Record race conditions, atomic operations, locking/versioning, expected
     constraint failures, and database-versus-application enforcement. -->

## Query and Access Patterns

<!-- List concrete reads/writes that justify indexes and constraints. Do not
     design API routes here. -->

## Migration, Backfill, and Compatibility Implications

<!-- Describe forward-only migration order, backfills, validation, rollout,
     compatibility with existing readers/writers, and rollback limits. Do not
     write migration code in this document. -->

## Security and Privacy Constraints

<!-- Record cross-cutting sensitivity, isolation, redaction, retention, and
     audit requirements without including secret values or private data. -->

## Assumptions, Recommendations, and Unresolved Decisions

### Assumptions

-

### Recommendations

-

### Unresolved Decisions and Decision Boundary

-

## Validation Plan

- [ ] Authoritative schema, migration, and entity sources are linked.
- [ ] Durable ownership boundaries and business invariants are explicit.
- [ ] Lifecycle, retention, deletion, and state guarantees are explicit.
- [ ] Important constraints, indexes, and access patterns have rationale
      without duplicating executable definitions.
- [ ] Tenant and authorization boundaries are explicit.
- [ ] Concurrency and failure behavior are documented.
- [ ] Migration and compatibility implications are reviewed.
- [ ] Dependent API, frontend, and SPEC documents identify relevant schema
      dependencies.

## Non-Goals

- Creating or changing database tables.
- Writing migrations, seeds, models, services, routes, or UI.
- Recording secrets, credentials, or real private data.

## Decision Boundary

- Behavior-preserving data design continues under the approved SPEC; this
  document does not authorize implementation by itself.
- Contract-changing, destructive, irreversible, security/privacy, retention,
  or materially operational schema decisions are recorded in the relevant
  SPEC and receive explicit user approval before implementation.

Verdict: useful context | needs clarification
