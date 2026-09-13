<!-- Provenance: bundled project-init template.
     Routing index: .ai/prompts/README.md. -->

# Choose Technical Direction

Use `technical-design` and `source-driven-development` when current framework,
runtime, database, API, or tool behavior matters.

Compare bounded options for project shape, language, runtime, frameworks,
package manager, persistence, ORM/query builder/raw SQL, migrations,
authentication, local development, testing, and environment needs. Record
rationale, trade-offs, unknowns, and the user's approval status.

Ask before recording decisions: repository shape and ownership; language,
runtime, framework, package manager, and local commands; persistence and
database access; migration ownership; authentication, authorization, and
session storage; local emulation and environment-variable names; testing,
browser, accessibility, performance, CI, and deployment boundaries. Allow
`unknown`, `not applicable`, and `recommend options` answers.

Do not install dependencies, create application code, or inspect `.env` values.
