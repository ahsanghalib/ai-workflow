# Application Security Rules

These are engineering security rules. They do not replace a public vulnerability-reporting `SECURITY.md` if the repository needs one.

## 1. Security Baseline

- Treat all external input as untrusted.
- Enforce authorization server-side.
- Use least privilege.
- Fail closed when authorization/security state is ambiguous.
- Do not expose secrets or sensitive internals.
- Prefer secure defaults.
- Add security complexity based on real threat/risk, not cargo-cult checklists.

## 2. Input Validation

Validate:

- request bodies,
- query parameters,
- path parameters,
- headers when consumed,
- uploaded files,
- webhook payloads,
- third-party API responses where trust is not guaranteed,
- environment/configuration values.

Validation must occur at trusted boundaries before business logic uses the data.

## 3. Injection Prevention

- Always use parameterized database queries.
- Do not concatenate untrusted input into SQL.
- Avoid command/shell execution with user-controlled values.
- If shell execution is unavoidable, use structured argument APIs rather than string construction.
- Escape/encode output according to its target context.
- Avoid dynamic code evaluation (`eval`, `new Function`) with untrusted data.

## 4. Authentication

Follow `AUTH.md`.

Additionally:

- rate-limit credential endpoints,
- rotate/revoke credentials appropriately,
- validate token algorithms and claims,
- protect reset/verification tokens,
- prevent session fixation,
- use secure cookie settings where applicable.

## 5. Authorization

- Every protected operation must authorize the specific action.
- Do not rely on UI hiding.
- Check ownership/tenant scope.
- Avoid insecure direct object references.
- Default deny.
- Permission checks should be reusable and testable.
- Administrative actions require explicit elevated authorization.

## 6. Multi-Tenant Isolation

- Every tenant-owned query/mutation must be scoped.
- Unique constraints often require tenant scope.
- Do not trust `organization_id` from the client by itself.
- Test cross-tenant access attempts.
- Cache keys must include tenant scope where relevant.
- Background jobs must carry and verify tenant context.

## 7. Secrets

Never commit or log:

- passwords,
- access tokens,
- refresh tokens,
- private keys,
- API secrets,
- database passwords,
- reset/verification tokens.

Rules:

- use environment/secret-management mechanisms,
- keep `.env.example` secret-free,
- rotate compromised credentials,
- separate credentials by environment,
- grant minimum required permissions.

## 8. Logging and Observability

- Redact sensitive fields.
- Do not log entire request bodies by default.
- Do not log authorization headers/cookies.
- Security logs should capture useful metadata without secrets.
- Ensure error trackers do not receive sensitive payloads unintentionally.

## 9. CORS

- Configure explicit allowed origins where cross-origin browser access is required.
- Do not use permissive wildcard origins with credentialed requests.
- Restrict methods/headers to actual needs.
- Local development exceptions must not leak into deployed environments.

## 10. CSRF

When authentication relies on cookies automatically sent by browsers:

- use `SameSite` appropriately,
- use CSRF tokens/origin checks when required,
- protect state-changing operations,
- do not use GET for mutations.

## 11. XSS

- Prefer framework escaping.
- Avoid raw HTML rendering.
- Sanitize HTML when rich user content is required.
- Do not interpolate untrusted values into scripts/styles/HTML contexts unsafely.
- Use Content Security Policy when product/security maturity warrants it.

## 12. SSRF

For server-side URL fetching:

- validate protocol,
- restrict allowed destinations when possible,
- block loopback/private/link-local/internal metadata destinations unless explicitly required,
- handle redirects carefully,
- set timeouts and response-size limits.

## 13. File Upload Security

- limit size,
- validate type/content,
- generate safe storage keys,
- prevent path traversal,
- isolate untrusted uploads,
- avoid executing uploaded files,
- restrict public access,
- consider malware scanning when risk warrants it.

## 14. Password and Credential Handling

- use approved adaptive hashing,
- never encrypt passwords for later decryption,
- use strong random generators,
- compare secrets using safe library primitives,
- invalidate sensitive recovery/session artifacts after relevant credential changes.

## 15. Rate Limiting and Abuse

Prioritize:

- auth endpoints,
- password reset,
- email/SMS sending,
- search,
- invitations,
- public writes,
- expensive AI/third-party API calls.

Rate limits should consider user, tenant, IP, endpoint, and abuse model as applicable.

## 16. Webhooks

- Verify provider signatures.
- Validate timestamps/replay windows where supported.
- Use raw body when required for signature verification.
- Handle duplicate delivery idempotently.
- Do not trust webhook payloads before verification.

## 17. Dependency Security

- Keep dependencies reasonably current.
- Review security advisories.
- Avoid unmaintained critical libraries.
- Do not automatically apply breaking upgrades without testing.
- Pin/lock dependencies according to repository policy.
- Minimize dependencies in security-sensitive paths.

## 18. Sensitive Data

- Collect only what product requirements need.
- Restrict who can access sensitive data.
- Avoid exposing sensitive values in URLs.
- Define retention/deletion where legally/product-relevant.
- Encrypt data in transit.
- Use storage/database encryption capabilities where appropriate.

## 19. Error Messages

- Public errors must not expose:
  - SQL,
  - filesystem paths,
  - stack traces,
  - secrets,
  - internal hostnames,
  - raw third-party errors.
- Internal logs may contain technical context after redaction.

## 20. Security Testing

At minimum include tests for:

- unauthenticated access,
- unauthorized access,
- cross-tenant access,
- invalid/tampered tokens,
- input validation,
- critical rate-limit behavior where implemented,
- sensitive data not returned in API contracts.

## 21. Destructive Operations

- Require explicit authorization.
- Use transactions where several writes must stay consistent.
- Prefer soft safeguards/confirmation for high-impact admin actions when appropriate.
- Audit security-sensitive destructive actions where the product needs traceability.
