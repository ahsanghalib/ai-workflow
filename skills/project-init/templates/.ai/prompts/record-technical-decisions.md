<!-- Provenance: bundled project-init template.
     Routing index: .ai/prompts/README.md. -->

# Record Approved Technical Decisions

Use `project-init` after the user has explicitly approved one or more
technical choices.

Read the current `MASTER_PLAN.md`, architecture source, `AGENTS.md`, relevant
rules, and `docs/DB_SCHEMA.md` when it exists. Record only approved decisions:

- high-level direction and rationale in `MASTER_PLAN.md`;
- repository shape, boundaries, stack, data flow, local development, and
  invariants in `docs/PROJECT_ARCHITECTURE.md`; and
- commands, validation, environment-variable names, generated-file ownership,
  and routing in `AGENTS.md`.

Keep entity and migration details in `docs/DB_SCHEMA.md`. Show the exact files
and proposed changes before writing. Ask separately before revising existing
documents, never copy secret values, and leave unresolved choices open. For
each recorded decision include its status, selected value, rationale, evidence,
approval, and boundary; do not convert a recommendation or framework default
into a confirmed choice.
