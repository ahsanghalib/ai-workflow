# Backend Engineering Rules

Applies to backend applications, workers, jobs, server-side packages, and service logic.

## 1. Layer Boundaries

Keep responsibilities separate:

- **Transport/controller**: HTTP/RPC parsing, authentication context, request validation, status/response mapping.
- **Application/service/use case**: orchestration and business workflows.
- **Domain**: business rules, invariants, policies, domain calculations.
- **Persistence/repository**: database access and persistence mapping.
- **Infrastructure**: external services, queues, filesystem, email, cache, third-party APIs.

Rules:

- Controllers must stay thin.
- Do not place business rules in controllers, route files, ORM callbacks, or serializers.
- Repositories must not decide business policy.
- Domain/application code should not depend on HTTP-specific request/response objects.
- Infrastructure details must not leak into domain APIs without reason.

## 2. Service Design

- A service/use case should represent a meaningful application operation.
- Avoid god services with unrelated responsibilities.
- Do not create one service per trivial function if cohesive grouping is clearer.
- Make dependencies explicit through construction/DI.
- Avoid service locator patterns and hidden global dependencies.
- Prefer deterministic domain functions where possible.

## 3. Domain Logic

- Encode important invariants in one authoritative place.
- Do not rely on frontend validation for business correctness.
- Validate state transitions explicitly.
- Prefer domain-specific errors for expected rule violations.
- Keep authorization distinct from authentication.
- Do not duplicate the same permission/business rule across routes.

## 4. Repositories and Persistence

- Repositories should expose domain/application-oriented operations, not arbitrary ORM access.
- Avoid returning raw ORM internals across architectural boundaries when that couples callers unnecessarily.
- Select only fields needed for a use case when practical.
- Prevent N+1 queries.
- Use transactions for multi-write operations that must succeed or fail together.
- Keep transaction scope as small as correctness allows.
- Do not perform slow external network calls while holding a database transaction unless required.
- Define concurrency behavior for update-sensitive operations.

## 5. Input and Output Boundaries

- Validate all external input before business logic executes.
- Use shared contracts for public API request/response shapes when those contracts are consumed by clients.
- Backend-only internal types remain backend-local.
- Do not expose persistence models directly as public API contracts.
- Map domain/persistence objects to explicit response contracts.

## 6. Errors

- Translate domain/application errors into transport errors at the transport boundary.
- Unexpected errors should produce a stable generic client response and detailed server logs.
- Do not return raw ORM or third-party errors.
- Preserve causal error information internally.
- Define stable machine-readable error codes for client-actionable errors.

## 7. Authentication and Authorization

- Authentication establishes identity.
- Authorization determines permission for a specific action/resource.
- Enforce authorization server-side for every protected operation.
- Never trust organization/user/resource identifiers merely because they came from an authenticated client.
- Scope queries by tenant/organization where multi-tenancy applies.
- Avoid authorization checks that occur only after sensitive data has already been loaded or returned.

## 8. Logging

- Use structured logging.
- Include request/correlation identifiers where supported.
- Log operational context, not secrets.
- Never log passwords, raw tokens, session secrets, API keys, reset tokens, or sensitive personal data.
- Avoid duplicate logging of the same error at multiple layers unless each adds useful context.
- Use appropriate severity levels consistently.

## 9. External Services

- Wrap third-party APIs behind focused adapters when they are important boundaries.
- Set explicit timeouts.
- Handle transient failures separately from permanent failures.
- Retry only operations that are safe to retry.
- Use idempotency for retried side-effecting requests where supported.
- Validate third-party responses before trusting them.
- Do not let vendor-specific types leak throughout the application.

## 10. Background Jobs and Queues

- Jobs must be idempotent where retries are possible.
- Persist enough state to diagnose failed jobs.
- Define retry limits and backoff.
- Dead-letter or surface permanently failed work.
- Do not enqueue work before the database transaction that creates the required state is safely committed unless using an outbox/transactional mechanism.
- Include tenant/user context explicitly when needed.

## 11. Caching

- Cache only when there is a measured or clear need.
- Define ownership, TTL, invalidation, and stale-data tolerance.
- Do not treat cache as source of truth.
- Cache keys must include tenant/resource scope where applicable.
- Never cache authorization-sensitive results without correct identity/tenant dimensions.

## 12. Time and Dates

- Store timestamps in UTC unless domain requirements explicitly require otherwise.
- Make timezone conversion a presentation/domain concern.
- Use an injectable clock for logic that must be deterministic in tests.
- Do not mix seconds and milliseconds implicitly.
- Treat expiry comparisons consistently.

## 13. File Uploads

- Validate file size, type, and content constraints server-side.
- Do not trust filename extensions or client MIME types alone.
- Generate storage-safe filenames/keys.
- Prevent path traversal.
- Scan or isolate untrusted content where product risk warrants it.
- Do not serve private uploads through public unrestricted URLs.

## 14. Backend Testing Expectations

- Business rules require unit or integration tests.
- Repository queries with meaningful behavior require database integration tests.
- Critical API workflows require integration/E2E coverage.
- Bug fixes should add a regression test where feasible.
- Avoid tests that only verify framework behavior.
