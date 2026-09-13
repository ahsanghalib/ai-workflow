# Database Schema: `<Project Name>`

> The approved design contract for persisted data. APIs, frontend features,
> migrations, and application models must trace their data needs to this file.

**Status:** Draft | Proposed | Approved | Superseded
**Last reviewed:** YYYY-MM-DD
**Schema revision:** `<identifier>`
**Source of truth:** `docs/DB_SCHEMA.md` or the existing project-selected path

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

## Model Overview

| Entity/table | Purpose | Owner or tenant scope | Lifecycle |
| --- | --- | --- | --- |
| `<table>` | `<purpose>` | `<scope>` | `<retention/deletion rule>` |

## Entity and Field Definitions

Repeat this section for every approved entity or table.

### `<table_name>`

**Purpose:**

**Owner/tenant boundary:**

**Lifecycle and retention:**

| Field | Type/precision | Nullable | Default | Description | Sensitive? |
| --- | --- | --- | --- | --- | --- |
| `id` | `<type>` | No | `<default>` | `<meaning>` | No |

**Primary key:**

**Foreign keys and delete behavior:**

**Unique constraints:**

**Check or exclusion constraints:**

**Indexes and supported queries:**

**Concurrency and update behavior:**

## Relationships and Cardinality

| From | Relationship | To | Cardinality | Enforcement |
| --- | --- | --- | --- | --- |
| `<from>` | `<relation>` | `<to>` | `<cardinality>` | `<enforcement>` |

Describe join tables, scoped uniqueness, optional relationships, and lifecycle
effects such as deletion, archival, or reassignment.

## Keys, Constraints, and Indexes

<!-- Summarize cross-table invariants and why each index exists. -->

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

## Assumptions, Recommendations, and Unresolved Decisions

### Assumptions

-

### Recommendations

-

### Unresolved Decisions and Approval Gates

-

## Validation Plan

- [ ] Every persisted field has an owner, type, nullability, and lifecycle.
- [ ] Relationships, keys, constraints, and indexes support confirmed flows.
- [ ] Tenant and authorization boundaries are explicit.
- [ ] Concurrency and failure behavior are documented.
- [ ] Migration and compatibility implications are reviewed.
- [ ] Dependent API, frontend, SPEC, and PLAN documents identify their schema
      dependencies.

## Non-Goals

- Creating or changing database tables.
- Writing migrations, seeds, models, services, routes, or UI.
- Recording secrets, credentials, or real private data.

## Approval Gates

- [ ] User reviewed the proposed schema.
- [ ] Required architecture and security decisions are approved.
- [ ] A separately approved implementation PLAN exists before schema changes.

Verdict: ready for planning | needs clarification
