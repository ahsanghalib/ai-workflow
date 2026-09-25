<!-- Provenance: bundled project-init template.
     Routing index: .ai/prompts/README.md. -->

# Create a Feature SPEC

Use `spec-workflow` for a substantive feature, bug, improvement, refactor,
performance, security, migration, maintenance, or technical-debt request.
Read only the project context and current behavior needed to define its
contract. Persistence and architecture details are conditional; do not require
`USER_FLOW.md`, `DB_SCHEMA.md`, a master plan, or a plan index.
If persistence is not approved, record that no persistence behavior is in scope
and do not invent entities; leave an unresolved persistence decision open.

Create only the requested SPEC with status `Draft`. Define goal, scope,
non-goals, actors, behavior, invariants, validation, states, failures, edge
cases, authorization, compatibility, and acceptance criteria.

Include relevant behavior, API/shared-contract, frontend, persistence, and
security impact only when applicable. Route non-trivial architecture or
persistence decisions to the named design skill after the contract is approved.

If the request is still product exploration, route to `product-discovery` or
`brainstorming` first. For later requests, confirm whether it is a new feature,
SPEC revision, or an approved task. Preserve stable SPEC IDs and do not create
a second source-of-truth tree.

Do not create a PLAN or implement code. Route the exact SPEC to `spec-review`,
wait for the user's explicit approval, and keep tasks under `# Execution`.
