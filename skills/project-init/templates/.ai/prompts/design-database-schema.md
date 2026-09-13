<!-- Provenance: bundled project-init template.
     Routing index: .ai/prompts/README.md. -->

# Design the Database Schema

Use `schema-design` only after the user-flow document has been reviewed and
persistence has been approved. For a new project, design the initial project schema
from the approved project direction and reviewed user flow; this path
does not require a feature SPEC. For a later feature, use its approved feature
context and selected schema source of truth. If persistence is not approved or
the product has no persisted data, record `Schema: not applicable` and stop
without creating `docs/DB_SCHEMA.md`.

Design entities, fields, keys, relationships, ownership, tenant boundaries,
nullability, defaults, constraints, indexes, concurrency, privacy, access
strategy, and migration implications in `docs/DB_SCHEMA.md`.

Keep the document design-only. Do not create migrations, models, tables,
services, routes, UI, or secret values. Stop for schema review and approval.
