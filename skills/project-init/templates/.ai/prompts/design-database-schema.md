<!-- Provenance: bundled project-init template.
     Routing index: .ai/prompts/README.md. -->

# Design the Database Schema

Use `schema-design` when an approved SPEC or current executable repository
evidence shows that non-trivial persistence design is justified. Do not require
`USER_FLOW.md`, a master plan, or a legacy `DB_SCHEMA.md` before the SPEC. If
persistence is not approved or the product has no persisted data, record
`Schema: not applicable` and stop without creating a schema document.

Record design conclusions in the SPEC's `# Execution` section or the project's
existing approved schema source. Design entities, fields, keys, relationships,
ownership, tenant boundaries, nullability, defaults, constraints, indexes,
concurrency, privacy, access strategy, and migration implications without
duplicating executable schema unnecessarily.

Keep the document design-only. Do not create migrations, models, tables,
services, routes, UI, or secret values. Stop for schema review and approval.
