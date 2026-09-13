# Testing Rules

Applies to unit, integration, component, contract, database, and E2E testing.

## 1. Testing Philosophy

Tests exist to protect behavior, invariants, and important integrations.

- Test observable behavior, not implementation trivia.
- Prefer a smaller set of valuable tests over large amounts of brittle coverage.
- Critical business rules must be tested.
- Bug fixes should include regression tests when feasible.
- Do not weaken or delete valid tests merely to make a change pass.

## 2. TDD

Use TDD when it improves design or reduces uncertainty.

Recommended red-green-refactor cycle:

1. write a failing test expressing required behavior,
2. implement the smallest correct behavior,
3. make the test pass,
4. refactor while keeping tests green.

Rules:

- TDD is strongly encouraged for domain logic, parsers, calculations, state transitions, validation, and bug fixes.
- Do not force test-first development for trivial configuration, generated code, or exploratory spikes.
- Tests written first must describe behavior, not dictate internal structure.
- Refactoring is part of the cycle; do not stop at merely passing code.

## 3. Test Pyramid / Distribution

Prefer:

- many fast domain/unit tests where logic is isolated,
- meaningful integration tests for database and application boundaries,
- fewer E2E tests for critical user journeys.

Do not attempt to unit-test framework internals already covered by the framework.

## 4. Unit Tests

Good unit-test targets:

- calculations,
- pure transformations,
- policies,
- permissions,
- state transitions,
- validators,
- domain services.

Rules:

- Keep tests deterministic.
- Avoid network/database access in true unit tests.
- Mock only real external boundaries when needed.
- Do not mock the function under test's own internal collaborators merely to reproduce implementation details.

## 5. Integration Tests

Use integration tests for:

- repositories,
- ORM mappings,
- SQL behavior,
- transactions,
- API routes,
- authentication flows,
- queue adapters,
- important third-party adapters with test doubles/sandboxes.

Prefer real database behavior for database tests where practical.

## 6. E2E Tests

E2E tests should cover critical workflows such as:

- registration/login,
- primary product workflow,
- critical admin actions,
- payment or irreversible operations where applicable,
- high-value cross-system flows.

Rules:

- Keep E2E suites focused.
- Use stable selectors based on accessible roles/labels or dedicated test IDs when necessary.
- Avoid arbitrary sleeps; wait on actual conditions.
- Make test data isolated and repeatable.

## 7. Arrange / Act / Assert

Keep test structure obvious:

- Arrange the state.
- Act once on the behavior under test where possible.
- Assert the important outcome.

Do not enforce comments if the structure is already clear.

## 8. Test Naming

Names should describe behavior and conditions.

Prefer:

```text
rejects refresh token reuse after rotation
returns 403 when member lacks resource:update permission
```

Avoid:

```text
test1
works
should call repository method
```

## 9. Mocking

- Mock external systems, clocks, randomness, and expensive boundaries when useful.
- Do not mock every internal module.
- Excessive mocking that mirrors implementation creates fragile tests.
- Prefer fakes/in-memory implementations when they model behavior better than call-count mocks.
- Verify outcomes first; verify collaborator calls only when interaction itself is contractual.

## 10. Time, Randomness, and IDs

- Inject/fake clocks for time-dependent logic.
- Control randomness in tests.
- Generate deterministic IDs or capture generated values.
- Never make tests depend on wall-clock timing or external internet services.

## 11. Database Tests

- Run against the same database engine as production/local architecture when practical.
- Apply real migrations/schema.
- Isolate test data.
- Reset state deterministically.
- Test important constraints, uniqueness, cascade/restrict behavior, and transactions.
- Do not rely only on mocked repositories for query correctness.

## 12. API Tests

Cover:

- success,
- validation failure,
- authentication failure,
- authorization failure,
- not found,
- conflict/invariant failures,
- response contract,
- pagination/filter/sort behavior where applicable.

## 13. Auth Tests

Cover:

- password hashing/verification,
- login failure/success,
- token/session expiry,
- refresh rotation,
- logout/revocation,
- forgot/reset password,
- permission checks,
- tenant isolation,
- tampered tokens.

## 14. Frontend Tests

Prefer user-level assertions:

- visible content,
- accessible state,
- navigation,
- submitted data,
- error messages,
- loading behavior.

Avoid testing internal hook calls or component state when user-visible behavior is the actual contract.

## 15. Coverage

- Coverage is a diagnostic metric, not the goal.
- Do not write meaningless tests solely to increase percentage.
- Critical code should have strong behavioral coverage even if global percentage targets are modest.
- If CI enforces thresholds, do not lower them without explicit approval.

## 16. Flaky Tests

- Treat flaky tests as defects.
- Do not add retries to hide deterministic race conditions.
- Fix shared-state leaks, timing assumptions, nondeterminism, and environment dependencies.
- Quarantine only temporarily and document the reason.

## 17. Test Data

- Use builders/factories for complex test entities.
- Keep defaults valid and minimal.
- Override only fields relevant to the test.
- Avoid giant shared fixtures that make tests interdependent.

## 18. Definition of Tested

A feature is adequately tested when important behavior, edge cases, permissions, and failure paths are protected at the cheapest reliable test layer.
