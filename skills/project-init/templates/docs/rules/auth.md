# Authentication and Authorization Rules

Applies to authentication, sessions, identity, organization membership, permissions, and reusable auth packages.

## 1. Scope

Keep these concerns distinct:

- **Authentication**: who is the user?
- **Session management**: how is authenticated state maintained/revoked?
- **Authorization**: what may the user do?
- **Identity profile**: user/account information.
- **Organization membership**: relationship between users and tenants/organizations.

Do not collapse all of these into one generic auth check.

## 2. Reusable Auth Package

If `packages/auth` exists:

- Keep framework-independent auth/domain logic reusable where practical.
- Do not make the package depend on a specific HTTP framework unless that package is intentionally an adapter.
- Keep transport adapters in the API application when they are API-specific.
- Keep browser-specific behavior in frontend packages/apps.
- Define explicit extension points for persistence, mail, token/session storage only when actual reuse requires them.
- Do not build a generic auth framework beyond current project needs.

## 3. Passwords

- Never store plaintext or reversible passwords.
- Use a modern adaptive password hashing algorithm approved by the project, such as Argon2id or bcrypt with an appropriate cost.
- Centralize hashing configuration.
- Support future rehashing when hash parameters change.
- Enforce reasonable password policy without arbitrary complexity rules unless required.
- Never log passwords.
- Password comparison must use the hashing library's safe verifier.

## 4. Registration

- Validate and normalize identity fields consistently.
- Enforce unique identity constraints in the database.
- Handle duplicate registration without leaking unnecessary account information.
- Do not grant elevated permissions during registration.
- If verification is required, unverified accounts must have clearly defined capabilities.

## 5. Login

- Use generic failure messages where account enumeration is a concern.
- Rate-limit login attempts.
- Record security-relevant failures/successes where appropriate.
- Avoid revealing whether email, username, password, or account status specifically caused the failure unless product policy allows it.
- Regenerate/rotate session state after successful authentication where session fixation is relevant.

## 6. Access Tokens

If JWT access tokens are used:

- Keep access tokens short-lived.
- Include only required claims.
- Validate signature, issuer, audience, expiry, and expected algorithm.
- Do not accept `alg=none` or dynamically trust token-provided algorithms.
- Do not put secrets or sensitive profile data inside tokens.
- Treat token contents as signed data, not encrypted data.
- Authorization decisions must still use current server-side state where revocation/permission freshness matters.

## 7. Refresh Tokens

- Refresh tokens must be high-entropy and long enough to resist guessing.
- Prefer rotation on use.
- Detect/reject reuse if the chosen session model supports it.
- Store refresh-token secrets safely; prefer hashed/token-family representations where practical.
- Bind refresh tokens to explicit sessions/devices when session management is part of the product.
- Revoke session/token families on logout, compromise, or password reset according to policy.
- Do not reuse access tokens as refresh tokens.

## 8. Cookie-Based Auth

When cookies are used for sensitive auth state:

- use `HttpOnly`,
- use `Secure` outside insecure local development,
- choose `SameSite` intentionally,
- scope `Domain` and `Path` narrowly,
- set explicit expiry/max-age,
- protect state-changing requests against CSRF when browser behavior requires it.

Do not store sensitive long-lived tokens in JavaScript-readable storage without a deliberate reason.

## 9. Sessions

If `auth_sessions` exists:

- each session has an explicit owner,
- sessions have creation and expiry timestamps,
- revocation must be supported if product requirements need it,
- sensitive token material should not be stored raw where avoidable,
- session cleanup/expiry behavior must be defined,
- organization or device context must be modeled only when actually needed.

## 10. Logout

- Logout must invalidate the relevant server-side session/refresh capability when revocation exists.
- Clearing only client state is insufficient for revocable sessions.
- Decide whether logout affects one session or all sessions.
- Return success safely even when a session is already invalid where idempotent behavior is useful.

## 11. Forgot Password

- Do not reveal whether an account exists.
- Rate-limit requests.
- Generate high-entropy single-purpose tokens.
- Store token representations safely.
- Tokens must expire.
- Tokens must be single-use.
- Sending a new reset token should invalidate older tokens according to policy.

## 12. Reset Password

- Verify token purpose, expiry, and one-time status.
- Invalidate the reset token atomically with password change.
- Consider revoking existing sessions after password reset.
- Do not automatically authenticate after reset unless explicitly designed.
- Record security-relevant audit information without storing the token.

## 13. Email Verification

If required:

- verification tokens are single-purpose,
- high entropy,
- expiring,
- single-use,
- not logged,
- account verification state changes atomically.

## 14. Authorization Model

Choose and document one clear model or combination:

- role-based access control (RBAC),
- permission-based access,
- attribute/policy-based checks,
- resource ownership,
- organization membership.

Rules:

- Permissions should represent capabilities, not UI visibility.
- Check permission at the server operation boundary.
- Resource ownership/tenant scope must be included in authorization.
- Avoid hard-coded role-name checks scattered throughout code.
- Centralize policy evaluation when rules are reused.
- Default deny when a rule is missing or ambiguous.

## 15. Organizations and Membership

Where organizations exist:

- model membership explicitly,
- do not infer membership from client-selected organization IDs,
- enforce organization scope in queries and mutations,
- roles/permissions are scoped correctly,
- cross-organization access must be explicitly authorized,
- switching active organization must not bypass server authorization.

## 16. Profile Endpoint

- `/profile` or equivalent returns only fields appropriate for the authenticated client.
- Do not expose password hashes, token state, internal security metadata, or unnecessary private fields.
- Profile updates must allowlist mutable fields.
- Sensitive identity changes may require re-authentication/verification.

## 17. Security Events

Consider audit/security records for:

- login success/failure,
- password reset,
- password changed,
- email changed,
- permission/role changes,
- session revocation,
- suspicious token reuse.

Do not log secrets.

## 18. Testing

Auth tests should cover:

- registration,
- duplicate identity,
- login success/failure,
- token/session expiry,
- refresh rotation,
- refresh replay/reuse where supported,
- logout,
- forgot/reset password,
- permission denial,
- tenant isolation,
- revoked/disabled users,
- malformed/tampered tokens.
