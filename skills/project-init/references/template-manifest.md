# Project-Init Template Manifest

The manifest describes the only files the project-init helper may create. It
is policy for the skill and is not copied into a target.

## Default outputs when missing

The normal new-project scaffold creates only:

- `AGENTS.md`;
- `SESSION_STATE.md`;
- `.ai/memory/`; and
- `docs/specs/`.

For an existing project with an already-authoritative `specifications/`,
`specs/`, or `docs/specifications/` directory, an explicitly approved
`--spec-dir` mapping may preserve and use that source instead.

When `.gitignore` is absent, the helper may copy `.gitignore.template` after
the missing-file approval. The template protects environment files and local
runtime state without ignoring `.ai/`.

No roadmap, schema, user-flow, architecture, decision, plan, review, rule,
prompt, application, framework, package, or deployment files are default
outputs.

## Conditional resources retained for later use

The skill bundle still includes optional starting points under
`templates/docs/`:

- `architecture.md` for durable cross-feature architecture, or as a source to
  adapt to `docs/architecture.md`;
- `decisions/adr.md` for one consequential architecture decision, or as a
  source to adapt to `docs/decisions/<adr>.md`;
- `user-flows.md` for shared, non-trivial user lifecycles, or as a source to
  adapt to `docs/user-flows.md`;
- `schema/context.md` for durable schema context that executable schema cannot
  make clear, or as a source to adapt under `docs/schema/`; and
- `rules/*.md` for justified cross-feature engineering rules.

These resources are referenced only after source-of-truth detection and an
explicit approval for the exact target. They are deliberately excluded from
the initializer's default file list.

## Reconciliation outputs

Existing projects are inspected first. A reconciliation may propose an exact
revision to `AGENTS.md`, `SESSION_STATE.md`, or another already-authoritative
control when the user approves that scope. A capability can also justify a
small routing update under `docs/` or the root `AGENTS.md`, but the owning
workflow creates the durable domain document rather than a generic bootstrap
template.

Every write is copy-if-missing or an exact approved revision. Existing files,
directories, symlinks, source/configuration, Git metadata, and `.ai/` content
are not overwritten.

## Never create or inspect

The helper never creates, copies, installs, or mutates application source,
framework files, package manifests, dependencies, migrations, models,
services, routes, UI, deployment files, `.env` contents, credentials, keys,
commits, branches, remotes, pushes, issues, projects, or production state.
