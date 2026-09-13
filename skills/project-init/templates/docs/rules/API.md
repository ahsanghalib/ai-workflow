# API Engineering Rules

Applies to public/internal HTTP APIs and OpenAPI contracts.

## 1. Resource Design

- Use consistent resource-oriented naming.
- Prefer nouns for resources.
- Use HTTP methods according to semantics.
- Avoid verbs in paths when standard resource operations express the action clearly.
- Use explicit action endpoints only for domain commands that do not map cleanly to CRUD.

Examples:

```text
GET    /resources
POST   /resources
GET    /resources/:id
PATCH  /resources/:id
DELETE /resources/:id

POST   /auth/login
POST   /auth/logout
POST   /resources/:id/archive
```

## 2. Versioning

- Do not add API versioning until there is an actual compatibility requirement.
- Once external clients depend on a versioned API, breaking changes require a deliberate compatibility/versioning strategy.
- Prefer additive backward-compatible changes where possible.

## 3. Contracts

- Every public endpoint must have explicit request and response contracts.
- Shared client/server API contracts belong in the repository's designated
  contracts package, when one exists.
- Persistence entities must not be exposed directly as API contracts.
- Internal backend-only DTOs remain backend-local.
- Runtime validation schemas must match documented contracts.

## 4. Request DTOs

Define separate contracts when applicable:

- path parameters,
- query parameters,
- request body,
- response body.

Rules:

- Reject unknown/invalid input according to framework/project policy.
- Normalize input intentionally, not silently in many layers.
- Do not accept fields the operation does not support.
- Distinguish create and update contracts.
- PATCH-like updates should not unintentionally erase omitted fields.

## 5. Response Standard

Use one consistent response convention across the API.

Recommended success shape when an envelope is desired:

```json
{
  "data": {}
}
```

List response:

```json
{
  "data": [],
  "pagination": {
    "limit": 20,
    "offset": 0,
    "total": 100
  }
}
```

Recommended error shape:

```json
{
  "error": {
    "code": "RESOURCE_NOT_FOUND",
    "message": "Resource not found",
    "details": {}
  }
}
```

Rules:

- Machine-readable `code` values must be stable.
- Human messages may be user-facing but must not leak internals.
- `details` should contain structured actionable information only.
- Do not mix several unrelated response envelope conventions.

If the project intentionally uses raw REST resources instead of envelopes, document that once and remain consistent.

## 6. HTTP Status Codes

Use status codes semantically:

- `200` successful read/update with response body
- `201` resource created
- `204` successful operation with no response body
- `400` malformed/invalid request not better represented below
- `401` unauthenticated
- `403` authenticated but not authorized
- `404` resource not found or intentionally hidden
- `409` state/uniqueness/conflict
- `422` semantic validation when project convention uses it
- `429` rate limit
- `500` unexpected server failure
- `503` temporary service unavailability

Do not return `200` for errors.

## 7. Pagination

Choose one strategy intentionally.

### Offset Pagination

Use for:
- admin tables,
- bounded datasets,
- interfaces needing page jumps/total counts.

Standard fields:

```text
limit
offset
```

Response metadata may include:

```text
limit
offset
total
```

### Cursor Pagination

Use for:
- large/changing feeds,
- stable incremental traversal,
- high-scale collections.

Rules:

- Cursor must be opaque to clients.
- Ordering must be deterministic.
- Include a unique tie-breaker in sort order.
- Do not mix offset and cursor semantics in one endpoint without a strong reason.

## 8. Filtering and Sorting

- Use predictable query parameter names.
- Allowlist sortable/filterable fields.
- Validate direction and values.
- Do not expose arbitrary database column sorting/filtering.
- Keep filters composable.
- Document default ordering.

Example:

```text
GET /resources?status=active&category_id=123&sort=created_at&order=desc
```

## 9. Search

- Define whether search is prefix, substring, full-text, fuzzy, or external-search-backed.
- Apply sensible limits.
- Do not run expensive unindexed wildcard searches over large tables.
- Normalize searchable values consistently.

## 10. Idempotency

- GET/HEAD must not cause meaningful side effects.
- PUT/DELETE should follow idempotent semantics where used.
- For retry-prone create/payment/external side-effect endpoints, support idempotency keys where the domain requires it.

## 11. Validation

- Validate path/query/body before entering business logic.
- Validation errors should identify fields in a stable structured form.
- Server validation is authoritative.
- Use the same shared schema/type definitions across client/server where this does not leak server-only concerns.

## 12. Authentication and Authorization

- Authentication requirements must be explicit per endpoint.
- Authorization is evaluated against the requested resource/action.
- Never rely on frontend route guards.
- Multi-tenant resources must be tenant-scoped.
- Avoid returning existence information when that creates a security leak.

## 13. Rate Limiting

- Apply rate limits especially to:
  - login,
  - registration,
  - forgot/reset password,
  - verification,
  - expensive search,
  - public mutation endpoints.
- Rate-limit keys and thresholds must match the threat model.
- Return predictable `429` behavior.

## 14. OpenAPI

- Every public endpoint must be represented in OpenAPI.
- Request/response schemas must match runtime behavior.
- Document authentication requirements.
- Document query/path parameters.
- Document important error responses.
- Keep examples useful but not secret-bearing.
- Use Scalar or Swagger UI for local developer documentation as selected by the project.
- CI should detect invalid/broken OpenAPI generation where practical.

## 15. Deprecation

- Do not silently break existing clients.
- Mark deprecated fields/endpoints explicitly.
- Provide migration guidance for external consumers.
- Remove deprecated APIs only according to an agreed compatibility window.

## 16. API Testing

At minimum test:

- successful request,
- invalid input,
- unauthenticated access,
- unauthorized access,
- not found,
- important conflict/invariant cases,
- pagination/filtering behavior where applicable.
