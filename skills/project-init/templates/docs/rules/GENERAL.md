# General Engineering Rules

These rules apply to all applications and packages unless a more specific rule overrides them.

## 1. Core Principles

- Prefer simple, explicit code over clever abstractions.
- Optimize for maintainability, correctness, and readability before micro-optimization.
- Make the smallest coherent change that fully solves the requested problem.
- Do not refactor unrelated code during feature work unless required for correctness.
- Preserve existing public behavior unless the task explicitly changes it.
- Reuse existing project conventions before introducing new patterns.
- Avoid speculative abstractions for requirements that do not exist yet.
- Prefer composition over inheritance.
- Prefer explicit dependencies over hidden global state.
- Keep side effects near system boundaries.
- Make invalid states difficult or impossible to represent where practical.

## 2. Clean Code

- Use names that describe intent, not implementation trivia.
- Functions should do one cohesive job.
- Keep functions small enough to understand without scrolling excessively; split only when it improves clarity.
- Avoid deeply nested conditionals. Prefer guard clauses when they make flow clearer.
- Avoid boolean parameters when they make call sites ambiguous; prefer named options or separate functions.
- Avoid magic numbers and magic strings. Use named constants or domain types where the value has meaning.
- Remove dead code, commented-out code, unused imports, and obsolete TODOs.
- Comments should explain **why**, constraints, or non-obvious decisions. Do not narrate obvious code.
- Do not duplicate comments already expressed by types, names, tests, or schemas.
- Avoid catch-all utility modules. Group helpers by domain or responsibility.
- Prefer pure functions for deterministic transformations.
- Keep I/O, network, filesystem, clock, and database access behind explicit boundaries.

## 3. DRY, Duplication, and Abstraction

- Do not duplicate business rules.
- Do not abstract code merely because two snippets look similar.
- Prefer duplication over the wrong abstraction when concepts are likely to diverge.
- Extract shared code when:
  - behavior is intentionally identical,
  - duplication appears in multiple stable places,
  - the abstraction has a clear domain meaning.
- Do not create generic `utils`, `helpers`, `common`, or `base` abstractions without a specific responsibility.
- Shared packages must contain genuinely reusable concepts, not code moved there only to reduce local file size.

## 4. SOLID Principles

Apply SOLID as design guidance, not as a requirement to create more classes.

### Single Responsibility
- A module, class, or function should have one coherent reason to change.
- Separate transport, validation, business logic, persistence, and presentation concerns.

### Open/Closed
- Prefer extension through composition, configuration, strategies, or stable interfaces.
- Do not create plugin systems or extension points before a real need exists.

### Liskov Substitution
- Implementations must honor the behavioral contract of the interface they implement.
- Do not weaken preconditions or silently change expected return/error semantics.

### Interface Segregation
- Prefer small, purpose-specific interfaces over large kitchen-sink interfaces.
- Consumers should depend only on methods they use.

### Dependency Inversion
- High-level domain logic should not depend directly on infrastructure details when an abstraction provides real value.
- Do not introduce interfaces for every concrete class automatically.
- Create abstractions at boundaries that need substitution, testing isolation, or multiple implementations.

## 5. TypeScript projects

Apply this section only when the project uses TypeScript.

- Keep `strict` mode enabled.
- Do not use `any` unless interacting with an unavoidable untyped boundary; narrow it immediately.
- Prefer `unknown` over `any` for untrusted values.
- Do not use non-null assertions (`!`) to silence real uncertainty.
- Avoid unsafe type assertions (`as`) unless runtime invariants guarantee them.
- Validate external/untrusted data at runtime; TypeScript types alone are not validation.
- Prefer discriminated unions for state machines and variant data.
- Prefer `type` for unions, mapped types, and data composition; use `interface` when declaration merging or object contracts materially benefit from it.
- Export the smallest public API required.
- Avoid broad barrel files that create circular dependencies or hide ownership.
- Prefer immutable inputs/outputs where mutation is unnecessary.
- Do not widen precise domain values into generic `string`/`number` if a bounded type or enum-like schema is appropriate.

## 6. Async and Concurrency

- Await promises that affect correctness.
- Do not create floating promises.
- Use parallel execution only when operations are independent.
- Avoid sequential `await` chains when safe parallelism materially improves latency.
- Bound concurrency for bulk operations.
- Always define timeout, cancellation, retry, and idempotency behavior for external I/O where relevant.
- Retries must not duplicate non-idempotent side effects.

## 7. Error Handling

- Do not swallow errors.
- Catch errors only when you can recover, translate, add meaningful context, or guarantee cleanup.
- Preserve original causes when wrapping errors.
- Distinguish expected domain/application errors from unexpected system errors.
- Do not use exceptions for normal branching when a typed result is clearer.
- Never expose stack traces, secrets, SQL, internal paths, or sensitive implementation details to clients.
- Logs should contain enough context to debug without leaking sensitive data.

## 8. Configuration

- Configuration must come from explicit configuration sources, not scattered environment reads.
- Validate required environment variables at startup.
- Fail fast on invalid required configuration.
- Never commit secrets.
- Keep `.env.example` current for required local variables.
- Do not add production-provider-specific configuration during local-first development unless requested.

## 9. Dependencies

- Prefer existing dependencies before adding new ones.
- Add a dependency only when it provides clear value over a small local implementation.
- Avoid abandoned, unmaintained, or unnecessarily large dependencies.
- Do not add overlapping libraries that solve the same problem without justification.
- Use workspace packages for internal dependencies.
- Keep dependency direction consistent with repository architecture.
- Avoid adding runtime dependencies for build-time-only needs.

## 10. File and Module Organization

- Organize code primarily by domain/feature when practical.
- Keep private implementation details close to the feature that owns them.
- Do not create shared modules prematurely.
- Avoid circular dependencies.
- Keep entry points small.
- Keep generated files separate from hand-written source where possible.
- One module should have a clear owner and responsibility.

## 11. Naming

- Use domain terminology consistently.
- Prefer nouns for data/types and verbs for actions/functions.
- Boolean names should read as predicates: `isActive`, `hasAccess`, `canEdit`.
- Avoid abbreviations unless universally understood in the project.
- Avoid vague names such as `data`, `info`, `manager`, `handler`, `helper`, or `processor` when a more precise name exists.
- Keep singular/plural usage consistent with domain meaning.

## 12. Comments and Documentation

- Public or non-obvious APIs should document constraints and behavior.
- Update documentation when setup, public behavior, architecture, or development commands change.
- Do not duplicate detailed specifications inside implementation comments.
- Record permanent architectural decisions in the appropriate architecture/ADR location, not in session state.

## 13. Performance

- Do not optimize without evidence unless avoiding an obvious pathological design.
- Prevent known N+1 queries and unbounded data loads.
- Paginate potentially large collections.
- Avoid repeated expensive parsing, serialization, or network calls inside loops.
- Benchmark before making complex performance changes.
- Preserve readability unless performance requirements justify complexity.

## 14. Accessibility and Internationalization

- User-facing code must not assume mouse-only interaction.
- Do not encode meaning by color alone.
- Do not hard-code locale-sensitive formatting if the product supports multiple locales.
- Keep user-facing strings ready for localization if i18n is part of project scope.

## 15. Git and Change Discipline

- Do not commit, push, rebase, reset, create tags, or modify remote state unless explicitly requested. Never force-push, use destructive reset/clean operations, or perform production mutations.
- Do not modify unrelated files.
- Do not overwrite user changes.
- Keep generated artifacts out of source control unless the repository intentionally tracks them.
- Before completion, inspect the diff for accidental changes.

## 16. Definition of Done

A change is not complete until, as applicable:

- implementation matches the approved scope,
- relevant tests pass,
- type checking passes,
- linting passes,
- build passes,
- migrations are valid,
- documentation is updated when behavior/setup changed,
- no debug code or temporary workarounds remain,
- security and authorization implications were considered,
- the final diff contains no unrelated changes.
