# Project-Init Template Manifest

The manifest describes what the normal documentation scaffold may create. It
is a policy contract for the agent and helper script; it is not copied into a
target project unless the user explicitly asks for it.

## Base outputs when missing

The normal new-project scaffold proposes these base outputs when they do not
exist:

- `README.md`, `AGENTS.md`, `MASTER_PLAN.md`, and `SESSION_STATE.md`;
- `docs/PROJECT_ARCHITECTURE.md` and `docs/plans/INDEX.md`;
- `docs/rules/GENERAL.md`;
- the bundled `docs/templates/*.md` files; and
- empty `docs/specs/`, `docs/plans/`, and `docs/reviews/` directories.

`.gitignore.template` is a source template for a missing target `.gitignore`,
not a second output file.

## Optional after profile review and approval

The profile reference at [`project-profiles.md`](project-profiles.md) records
the project shape and concern applicability before optional outputs are
selected. Those outputs include:

- `docs/USER_FLOW.md` when actor or system journeys apply;
- specialized `docs/rules/*.md` files when their concern is relevant;
- the tracked `.ai/prompts/*.md` helper library, with provenance comments and
  the routing index described by [`prompt-contract.md`](prompt-contract.md),
  only when the project wants it; and
- `docs/DB_SCHEMA.md` only when persistence is approved, the user-flow
  contract is reviewed, and the exact separate `--only docs/DB_SCHEMA.md
  --with-schema` selection is used.

Optional output is copy-if-missing and is never selected by project type alone.

## Preserve and propose separately

Any existing target file, directory, symlink, planning layout, architecture
source, schema source, user-flow source, `.gitignore`, `AGENTS.md`, or `.ai/`
content is preserved by default. A revision or migration needs its own
proposal, exact diff, compatibility impact, and explicit approval.

## Never create or inspect

The manifest never includes `.env`, secret-bearing configuration, credentials,
private keys, browser state, application source, framework files, package
manifests, migrations, models, services, routes, UI, deployment files, commits,
remotes, branches, or pushes.

For the complete created-versus-forbidden output contract, use
[`output-boundary.md`](output-boundary.md).
