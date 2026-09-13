# Shared Contracts Rules

Applies to the repository's designated shared client/server API contract
package, when one exists.

## 1. Purpose

The designated contracts package defines data that is intentionally shared
across application boundaries.

Good candidates:

- API request bodies,
- API path/query parameter schemas,
- API response bodies,
- pagination contracts,
- public enums/discriminated unions,
- reusable validation schemas for API boundaries,
- stable error code types.

Not appropriate:

- ORM models,
- database table types,
- repository interfaces,
- backend service internals,
- server-only configuration,
- frontend component props,
- framework-specific request/response objects.

## 2. Domain Organization

Organize contracts by domain:

```text
<contracts-package>/
  src/
    auth/
    <domain>/
    common/
```

Do not place everything in one file.

## 3. Request and Response Separation

Prefer explicit contracts:

```text
CreateResourceInput
UpdateResourceInput
ResourceResponse
ListResourcesQuery
ListResourcesResponse
```

Do not reuse one database/domain type for create, update, and response when their semantics differ.

## 4. Runtime Validation

When contracts receive untrusted external data:

- provide runtime validation schemas using the project's selected validation library,
- infer static types from schemas where practical,
- do not maintain separate schema and type definitions that can silently drift,
- validate on the server even if the frontend already uses the same schema.

## 5. Naming

Use stable suffixes consistently:

- `Input` for request bodies/commands,
- `Query` for query parameters,
- `Params` for path parameters,
- `Response` for transport responses,
- `Schema` for runtime schemas where naming is needed.

Avoid generic names such as `DTO`, `Data`, or `Payload` when a specific semantic name is clearer.

## 6. API Independence

- Contracts must not depend on backend application modules.
- Contracts must not depend on frontend modules.
- Avoid importing ORM or HTTP framework types.
- Keep package dependencies minimal.
- Shared contracts must be safe to bundle into browser applications.

## 7. Security

Never expose through shared response contracts:

- password hashes,
- refresh token values,
- internal session secrets,
- API keys,
- internal-only audit metadata,
- hidden authorization internals,
- private database-only fields.

## 8. Nullability and Optionality

Model semantics accurately:

- optional = field may be omitted,
- nullable = field may explicitly be `null`.

Do not use both casually.

Create/update differences must be explicit.

## 9. Enums and Constants

- Share enum-like values only when both client and server genuinely need the same protocol/domain values.
- Avoid tying contracts directly to database enum implementations.
- Treat removing or renaming published enum values as a potentially breaking API change.

## 10. Dates and Serialization

- API contracts must describe serialized data, not in-memory classes.
- Date/time fields crossing JSON boundaries should be strings in a defined format, typically ISO 8601.
- BigInt, Decimal, Map, Set, and class instances require explicit serialization contracts.
- Do not assume framework serialization behavior is part of the contract.

## 11. Pagination Contracts

Define common pagination primitives once.

Offset example:

```ts
type OffsetPagination = {
  limit: number
  offset: number
  total: number
}
```

Cursor example:

```ts
type CursorPagination = {
  nextCursor: string | null
  hasMore: boolean
}
```

Domain list responses may compose these shared types.

## 12. Error Contracts

Define stable machine-readable error codes and structured details.

Do not share backend exception classes.

Example conceptual shape:

```text
error.code
error.message
error.details
```

## 13. Versioning and Breaking Changes

Treat contracts as a public boundary between workspaces.

Potentially breaking changes include:

- removing fields,
- changing field meaning,
- changing required/optional status,
- changing enum values,
- changing serialized types,
- changing error codes.

Prefer additive changes where possible.

## 14. Exports

- Export only intended public contracts.
- Avoid enormous catch-all barrel exports that make ownership unclear.
- Domain-level index files are acceptable when they remain explicit.
- Prevent circular dependencies between contract domains.

## 15. Tests

Test important schemas for:

- valid input,
- invalid input,
- optional/nullable behavior,
- defaults/transforms,
- serialization-sensitive values,
- backward-compatible assumptions that clients rely on.
