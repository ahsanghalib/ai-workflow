# Project-Init Template Manifest

The manifest describes what the project-init helper may create. It is a policy
contract for the agent and helper script; it is not copied into a target unless
the user explicitly asks for it.

## Default outputs when missing

The normal new-project scaffold creates only the minimal control plane:

- `AGENTS.md`;
- `SESSION_STATE.md`;
- `.ai/memory/`; and
- `docs/specs/`.

`.gitignore.template` is also copied to `.gitignore` when the target has no
existing `.gitignore`. The template protects real environment files and local
runtime state without ignoring `.ai/`.

The default scaffold does not create `README.md`, `MASTER_PLAN.md`,
`docs/DB_SCHEMA.md`, `docs/USER_FLOW.md`, `docs/PROJECT_ARCHITECTURE.md`,
`docs/plans/`, `docs/reviews/`, rules, helper prompts, or application files.

## Explicit outputs after review and approval

Use repeatable `--only RELPATH` selections for any output outside the minimal
control plane. This includes:

- `README.md`, legacy roadmap, architecture, user-flow, and schema documents;
- `docs/rules/*.md` and `docs/templates/*.md`;
- `.ai/prompts/` and its routing index;
- `docs/plans/` or `docs/reviews/`; and
- any other bundled file whose exact purpose, owner, and compatibility impact
  are recorded.

`docs/DB_SCHEMA.md` remains available only as explicit legacy compatibility
support with `--only docs/DB_SCHEMA.md --with-schema`. It is not a prerequisite
for a SPEC or ordinary implementation. PLAN templates and indexes are likewise
opt-in compatibility outputs, not the default work lifecycle.

All explicit outputs are copy-if-missing and never overwrite an existing file.

## Preserve and propose separately

Any existing target file, directory, symlink, legacy document, planning layout,
architecture source, schema source, `.gitignore`, `AGENTS.md`, or `.ai/` content
is preserved by default. A revision or migration needs its own proposal, exact
diff, compatibility impact, and explicit approval. Uncertain ownership is left
in place.

## Never create or inspect

The manifest never includes `.env`, secret-bearing configuration, credentials,
private keys, browser state, application source, framework files, package
manifests, migrations, models, services, routes, UI, deployment files,
commits, remotes, branches, or pushes.

For the complete created-versus-forbidden output contract, use
[`output-boundary.md`](output-boundary.md).
