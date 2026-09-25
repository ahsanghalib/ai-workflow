# Project-Init Output Boundary

Project-init creates or reconciles project-control structure. It does not
create the application or own a substantive work-request lifecycle. This
boundary applies to new bootstrap and existing-project reconciliation.

## Default bootstrap outputs

After the relevant approval, the minimal scaffold may create missing:

- `AGENTS.md`;
- `SESSION_STATE.md`;
- `.ai/memory/`; and
- `docs/specs/`.

It may copy `.gitignore.template` to `.gitignore` only when the target has no
existing `.gitignore`. Local `.git` metadata is separate and requires explicit
approval for the exact canonical target with `--init-git`.

The default scaffold does not create `README.md`, `MASTER_PLAN.md`,
`docs/DB_SCHEMA.md`, `docs/USER_FLOW.md`, `docs/PROJECT_ARCHITECTURE.md`,
`docs/plans/`, `docs/reviews/`, rules, helper prompts, or application output.

## Explicit and preserved outputs

After a separate proposal and approval, `--only RELPATH` may select any
bundled project-control template, including legacy documents, rules,
`docs/templates/`, helper prompts, plan/review directories, or explicit PLAN
support. Existing files, source-of-truth layouts, symlinks, `.ai/`, and
`.gitignore` are preserved unless their separate revision scope is approved.

`docs/DB_SCHEMA.md` and other legacy documents are compatibility outputs only;
they are never prerequisites for a SPEC, ordinary implementation, or the
minimal bootstrap. `--with-schema` is accepted only with the exact explicit
selection `--only docs/DB_SCHEMA.md --with-schema`.

For a non-empty target, the full minimal scaffold is not applied beside an
unrelated existing layout. Select each missing output explicitly after the
source-of-truth inventory. An unchanged recognized minimal scaffold is an
explicit no-op on a repeated run.

## Forbidden outputs

Project-init never creates, copies, installs, or mutates:

- application source, routes, services, models, UI, or feature files;
- framework scaffolds, package manifests, lockfiles, or dependencies;
- migrations, seeds, generated ORM models, tables, or database data;
- Docker, CI, hosting, cloud, or environment provisioning;
- `.env`, credentials, tokens, private keys, or secret values; or
- commits, branches, remotes, pushes, fetches, issues, deployments,
  publications, or production operations.

Reconciliation may document safe filename evidence from existing application
files, but it does not copy or rewrite those files implicitly.

## Verification and handoff

The initializer is deterministic copy-if-missing scaffolding. A repeated run
against an unchanged recognized minimal scaffold reports a no-op; an unrelated
existing project still requires explicit selections. The handoff lists every
created, preserved, skipped, blocked, and unresolved item, shows the final
diff, and states the absence of forbidden application outputs and external
mutations. Structural evidence does not prove live harness, runtime, browser,
provider, deployment, or remote behavior.
