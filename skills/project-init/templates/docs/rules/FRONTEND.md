# Frontend Engineering Rules

Applies to web clients, admin clients, desktop clients, and frontend-specific
packages. Apply framework-specific guidance only when that framework is in use.

## Traceability

Each frontend route, screen, and feature surface must identify its relevant
user-flow journey/state and the API or shared contracts it consumes. Persisted
data behavior must trace to approved schema entities through those contracts;
frontend work must not invent fields, permissions, entities, or lifecycle
states. If the contract or schema reference is missing, return to the SPEC and
schema-impact review gate.

## 1. Feature Organization

- Prefer feature/domain-oriented organization over grouping every file globally by technical type.
- Keep feature-specific components, hooks, schemas, API calls, and tests near the feature.
- Shared code must be truly shared.
- Do not move feature logic into global `utils` or `hooks` folders merely for reuse within one feature.

## 2. Component Design

- Components should have a clear UI responsibility.
- Prefer composition over large prop-heavy components.
- Avoid components that simultaneously fetch data, implement business rules, manage unrelated state, and render complex UI.
- Keep presentation components simple when separation improves reuse/testability.
- Do not split components mechanically by line count.
- Prefer explicit props over hidden context for local dependencies.
- Use context for stable cross-tree concerns, not as a replacement for state design.

## 3. Server vs Client Boundaries

For frameworks that support server/client components:

- Default to server-side execution where interactivity is not needed.
- Mark client components only when browser APIs, hooks, or interactivity require it.
- Keep client boundaries as low in the tree as practical.
- Do not expose server secrets or server-only modules to client bundles.
- Perform authorization-sensitive data access server-side.

## 4. State Management

Use the narrowest state scope that works:

1. local component state,
2. lifted feature state,
3. URL/search params for navigational state,
4. server-state/query cache for remote data,
5. global client store only for genuinely cross-feature client state.

Rules:

- Do not copy server state into global client stores without a reason.
- Avoid derived state; compute from the source state when practical.
- Do not use effects for values that can be derived during render.
- Keep state normalized when multiple views edit the same entities.
- Persist client state only when product behavior requires persistence.

## 5. Data Fetching

- Centralize API transport behavior.
- Feature endpoint functions should live by feature or API domain, not in one giant global endpoint file.
- Use shared contracts for client/server API shapes.
- Handle loading, empty, success, and error states explicitly.
- Avoid waterfall requests when independent data can load concurrently.
- Configure caching/staleness intentionally.
- Invalidate or update caches after mutations predictably.
- Do not silently ignore failed mutations.

Recommended shape:

```text
src/
  features/
    auth/
      api.ts
    <domain>/
      api.ts
```

## 6. Forms

- Use schema-driven validation where practical.
- Client validation improves UX; server validation remains authoritative.
- Display field-level errors near the relevant field.
- Preserve user input after recoverable errors.
- Disable or guard duplicate submissions.
- Handle pending state visibly.
- Do not depend on placeholder text as the only label.

## 7. Routing and URL State

- Use URLs for state users should bookmark, share, refresh, or navigate back/forward through.
- Keep route naming predictable and resource-oriented.
- Validate route/search parameters.
- Preserve meaningful filters/pagination in the URL when appropriate.
- Do not put sensitive values in URLs.

## 8. Error Handling

- Distinguish validation errors, authorization errors, not-found states, network errors, and unexpected failures.
- Show actionable messages to users.
- Do not expose internal stack traces or raw backend errors.
- Use error boundaries for unexpected rendering failures where supported.
- Log client errors through the approved observability mechanism.

## 9. Accessibility

- Use semantic HTML first.
- Every interactive element must be keyboard accessible.
- Use actual buttons/links instead of clickable `div`s.
- Inputs must have labels.
- Maintain visible focus states.
- Dialogs must manage focus and keyboard dismissal correctly.
- Images require meaningful alt text or empty alt text when decorative.
- Do not rely on color alone to convey state.
- Respect reduced-motion preferences where animations are nonessential.

## 10. Styling and Design System

- Prefer shared design tokens and UI primitives.
- Do not duplicate design-system components inside features.
- Feature-specific components should compose shared primitives.
- Avoid arbitrary one-off values when a token exists.
- Keep responsive behavior intentional.
- Do not hard-code theme-specific assumptions.

## 11. Performance

- Do not memoize everything by default.
- Use memoization when measurement or known render cost justifies it.
- Lazy-load expensive/noncritical client code when useful.
- Avoid shipping server-only libraries to the browser.
- Optimize large lists with pagination/virtualization when required.
- Use framework-native image/font optimization where applicable.
- Avoid unnecessary global state subscriptions.

## 12. Security

- Treat all browser state as attacker-controlled.
- Never store server secrets in frontend code.
- Avoid storing long-lived sensitive tokens in unsafe browser storage when secure cookie-based approaches are available.
- Sanitize/escape untrusted HTML; avoid raw HTML injection.
- Do not implement authorization only through hidden buttons/routes.
- Avoid leaking sensitive information through analytics, logs, query strings, or local storage.

## 13. Admin Applications

- Admin capability must be authorized server-side.
- High-impact destructive actions require clear confirmation when appropriate.
- Preserve an audit trail for sensitive administrative actions where required.
- Do not expose broad admin APIs to normal clients.
- Prefer explicit permission checks over a single broad `isAdmin` assumption when the domain supports granular permissions.

## 14. Frontend Testing Expectations

- Test business-significant UI behavior, not implementation details.
- Prefer user-observable assertions.
- Critical forms and workflows require integration/E2E coverage.
- Mock network boundaries deliberately; do not over-mock component internals.
- Add regression tests for frontend bugs when feasible.
