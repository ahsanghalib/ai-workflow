<!-- Provenance: bundled project-init template.
     Routing index: .ai/prompts/README.md. -->

# Record Approved Technical Decisions

Use `technical-design` after the user has explicitly approved one or more
technical choices. This is compatibility guidance for existing project-control
documents; technical conclusions for normal work belong in the approved SPEC's
`# Execution` section or a justified durable architecture/rules document.

Read the current architecture source, `AGENTS.md`, relevant rules, and
executable schema or justified schema-context documentation when they exist.
Record only approved decisions:

- feature-specific conclusions in the approved SPEC's `# Execution` section;
- durable cross-feature architecture decisions in the project's approved
  architecture or decision document; and
- commands, validation, environment-variable names, generated-file
  ownership, and routing in `AGENTS.md`.

Keep entity and migration details in executable schema sources and, when
durable context is justified, the approved schema-context document. Show the
exact files and proposed changes before writing. Ask separately before
revising existing documents, never copy secret values, and leave unresolved
choices open. For each recorded decision include its status, selected value,
rationale, evidence, approval, and boundary; do not convert a recommendation
or framework default into a confirmed choice.
