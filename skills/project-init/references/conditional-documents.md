# Conditional Project Documents

Use this reference only after source-of-truth detection shows that a project
has durable knowledge worth preserving in a project-wide document. These
templates are reusable starting points, not bootstrap outputs.

## Selection rules

1. Identify the exact concern and the current executable or user-owned source
   of truth.
2. Decide whether the knowledge is durable, cross-feature, and difficult to
   infer from source, configuration, schema, or a SPEC.
3. Propose the smallest applicable template and exact target path.
4. Obtain approval for the missing document or an exact revision before
   copying or populating it.
5. Populate only confirmed facts; label recommendations, assumptions, and open
   decisions. Do not copy secrets or invent requirements.
6. Validate links, ownership, status, and source-of-truth boundaries, then
   hand feature behavior to `spec-workflow`.

## Available templates

<!-- markdownlint-disable MD013 -->
| Concern | Bundled starting point | Preferred new-project target | Use when |
| --- | --- | --- | --- |
| Architecture | `templates/docs/architecture.md` | `docs/architecture.md` | The system has enough cross-service, package, integration, or deployment complexity that README and AGENTS are insufficient. |
| Consequential architecture decision | `templates/docs/decisions/adr.md` | `docs/decisions/<adr>.md` | A consequential, durable decision needs its own rationale, alternatives, trade-offs, and consequences. |
| Shared user flows | `templates/docs/user-flows.md` | `docs/user-flows.md` | Several features depend on the same non-trivial onboarding, checkout, approval, authorization, or multi-step lifecycle. |
| Database context | `templates/docs/schema/context.md` | `docs/schema/` | Executable schema and migrations do not make durable ownership, invariants, retention, concurrency, or privacy rules clear. |
| Engineering rules | `templates/docs/rules/*.md` | `docs/rules/<concern>.md` | A cross-feature invariant or repository convention needs a stable home. |
<!-- markdownlint-enable MD013 -->

Existing projects that use older filenames remain user-owned and are not
renamed automatically. New projects should use the lowercase contextual paths
above. Do not create any of these documents merely because a template exists.

## Boundaries

- `schema/context.md` is not a duplicate of executable schema or migrations.
- `decisions/<adr>.md` records one consequential decision; it is not a SPEC,
  task list, roadmap, or replacement for current architecture documentation.
- `user-flows.md` is not a prerequisite for creating a SPEC.
- `architecture.md` is not a prerequisite for implementation.
- A project document does not approve a feature, migration, API, permission, or
  deployment change.
- A feature-specific behavior belongs in the SPEC; promote only genuinely
  cross-feature knowledge to a project-wide document.
- Avoid duplicate sources of truth: keep each concern in one authoritative
  location and link to it from contextual documents.
