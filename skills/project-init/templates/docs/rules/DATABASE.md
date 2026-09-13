# Database Engineering Rules

Applies to relational schema design, ORM schemas, migrations, queries, and
database access. Apply PostgreSQL-specific guidance only when PostgreSQL is in
use.

## 1. Schema-First Development

For new domains/features:

1. define domain entities and invariants,
2. design the relational schema,
3. define keys and relationships,
4. add constraints,
5. add indexes based on access patterns,
6. review the schema,
7. create migration,
8. only then build services/routes that depend on it.

Do not design the database indirectly from UI forms or DTOs.

## 2. Source of Truth

- The database must enforce invariants that are fundamentally data integrity rules.
- Application validation complements database constraints; it does not replace them.
- Do not rely solely on ORM types for integrity.
- Important uniqueness, relationship, and valid-range rules should be enforced by the database when possible.

## 3. Primary Keys

- Use one consistent primary-key strategy per project/domain unless a different choice is justified.
- Do not expose sequential internal IDs publicly when enumeration is a security/product concern.
- Composite primary keys are appropriate for true identity composed of multiple columns.
- Do not add surrogate IDs to join tables automatically when the natural composite key already represents identity and no other requirement needs a surrogate.

## 4. Foreign Keys

- Define foreign keys for real relational ownership/reference.
- Choose `ON DELETE` and `ON UPDATE` behavior intentionally.
- Do not default blindly to cascading deletes.
- Use `RESTRICT`/`NO ACTION` for data that must not disappear implicitly.
- Use `CASCADE` when child lifetime is strictly owned by the parent.
- Index foreign-key columns used in joins/filtering where appropriate.

## 5. Nullability

- Columns should be `NOT NULL` unless absence has a real domain meaning.
- Do not use nullable fields as a substitute for modeling states.
- Distinguish unknown, not applicable, and empty when the domain cares.
- Defaults should represent valid domain behavior, not hide missing input.

## 6. Constraints

Use database constraints when applicable:

- `NOT NULL`
- `UNIQUE`
- foreign keys
- `CHECK`
- exclusion constraints
- constrained enums/reference tables where appropriate

Examples:

- positive monetary amounts where negatives are invalid,
- start date before end date,
- percentage within valid range,
- status-compatible field combinations,
- one active record per scoped entity when enforceable.

Name important constraints predictably if the migration/tooling benefits from it.

## 7. Uniqueness

- Define the actual scope of uniqueness.
- In multi-tenant systems, uniqueness is often `(organization_id, value)`, not globally `value`.
- Consider case normalization/case-insensitive uniqueness for emails, slugs, usernames, etc.
- Handle soft-deleted rows intentionally with partial indexes when needed.

## 8. Data Types

- Use database-native types that represent the domain accurately.
- Do not store structured data as JSON when relational columns/relations are the real model.
- Use JSON/JSONB for genuinely flexible or document-like data, not to avoid schema design.
- Use `numeric/decimal` or integer minor units for money according to project convention; never binary floating point for financial values.
- Use timezone-aware timestamp types for instants.
- Use bounded varchar/text according to actual validation/DB conventions; do not invent arbitrary limits without reason.

## 9. Timestamps

Common rules:

- `created_at` for creation time.
- `updated_at` when update tracking is useful.
- store instants in UTC.
- use database/application behavior consistently for update timestamps.
- do not add timestamps to every join/configuration table mechanically.

## 10. Soft Delete

- Use soft delete only when restoration, audit/history, legal, or business requirements justify it.
- Do not make soft delete the default.
- If used, ensure:
  - queries consistently exclude deleted rows where required,
  - uniqueness handles deleted rows correctly,
  - foreign-key behavior is understood,
  - restore behavior is defined,
  - indexes account for active-row access patterns.

## 11. Indexes

- Index for real query patterns, joins, ordering, and constraints.
- Do not add an index to every column.
- Remember that indexes increase write cost and storage.
- Use composite index column order based on actual predicates/order.
- Use partial indexes for selective recurring predicates when appropriate.
- Verify query plans for important or unexpectedly slow queries.

## 12. Multi-Tenancy

Where organization/tenant isolation applies:

- include tenant ownership explicitly,
- scope reads/writes by tenant,
- include tenant scope in relevant unique constraints,
- prevent cross-tenant relationship references,
- consider row-level security only when intentionally adopted and tested,
- never trust tenant IDs supplied by clients without authorization checks.

## 13. Migrations

- Every schema change must be represented by a migration.
- Never edit an already-applied/shared migration unless the project explicitly permits it before release.
- Prefer forward-compatible migrations for deployed systems.
- Separate destructive changes into safe phases when data or running applications could be affected.
- Backfills must be bounded, restartable, and safe for production-scale data when production exists.
- Do not drop columns/tables until dependent code has stopped using them.
- Review generated migrations; never assume ORM-generated SQL is correct.
- Migration order must be deterministic.
- Migration rollback strategy must be understood even if formal down migrations are not used.

## 14. Query Rules

- Select only required data when practical.
- Avoid N+1 queries.
- Paginate unbounded collections.
- Use deterministic ordering for pagination.
- Parameterize queries; never concatenate untrusted SQL.
- Use transactions for atomic multi-step mutations.
- Avoid long-running transactions.
- Lock only when needed and understand lock scope.

## 15. Concurrency

- Identify read-modify-write races.
- Use atomic updates, constraints, optimistic locking, or row locks as appropriate.
- Do not rely on a pre-check followed by insert/update when a unique constraint is the real guarantee.
- Map expected constraint conflicts to stable application errors.

## 16. Audit Data

- Audit tables/logs should capture actor, action, target, timestamp, and relevant context where required.
- Audit logs should be append-oriented and tamper-resistant according to product needs.
- Do not store secrets in audit logs.
- Do not add full auditing to every project without a concrete requirement.

## 17. Schema Review Checklist

Before implementation:

- Are entities correctly separated?
- Are relationships and cardinality correct?
- Are nullability decisions intentional?
- Are uniqueness scopes correct?
- Are important invariants enforced?
- Are delete behaviors safe?
- Are indexes based on expected queries?
- Are tenant boundaries enforced?
- Are money/time types correct?
- Is JSON being used only where justified?
- Will migrations be safe?
