# Project-Init Output Boundary

Project-init creates project-control documentation and planning structure. It
does not create the application. This boundary applies to new bootstrap and
existing-project reconciliation.

## Allowed bootstrap outputs

After the relevant approval, the base scaffold may create missing:

- project-control Markdown such as `README.md`, `AGENTS.md`,
  `MASTER_PLAN.md`, `SESSION_STATE.md`, architecture, `GENERAL.md`, templates,
  and planning indexes;
- empty `docs/specs/`, `docs/plans/`, and `docs/reviews/` directories;
- `.gitignore` from the bundled template only when the target has no existing
  `.gitignore`; and
- local `.git` metadata only after separate approval for the exact canonical
  target and only when `--init-git` is selected.

After profile review and separate selection, project-init may also create
`docs/USER_FLOW.md`, relevant specialized rule files, and tracked `.ai/prompts/`
documentation. `docs/DB_SCHEMA.md` is created only after persistence and the
user-flow contract are reviewed, using exactly `--only docs/DB_SCHEMA.md
--with-schema`.

Existing files, source-of-truth layouts, symlinks, and `.gitignore` are
preserved unless their separate revision or creation scope is approved.

The base scaffold is a new-project-only bundle: it may run for an empty target
or a target containing only `.git`. An unchanged project-init scaffold is an
explicit no-op on a repeated run. Reconciliation uses explicit selected
outputs such as `--only README.md` or `--only docs/USER_FLOW.md`; each selected
path is part of the approval scope. This prevents a broad scaffold from
creating a competing plan, schema, or instruction tree beside an established
source of truth. Schema creation is a separate selected operation and must use
exactly `--only docs/DB_SCHEMA.md --with-schema` after the user-flow review.

## Forbidden bootstrap outputs

Project-init never creates, copies, or installs:

- **No application source:** no `src/`, routes, services, models, UI,
  components, or feature implementation files;
- **No framework or dependency files:** no framework scaffold, package
  manifest, lockfile, runtime configuration, or installed dependency;
- **No persistence implementation:** no migrations, seeds, generated ORM
  models, tables, or database data;
- **No deployment or infrastructure:** no Docker, CI, hosting, cloud, or
  environment provisioning files;
- **No secrets:** no `.env`, credentials, tokens, private keys, or secret
  values; and
- **No bundled Git/external mutations:** no commit, branch, remote, push,
  fetch, issue, deployment, publication, or production operation.

Reconciliation may document safe evidence from existing application files, but
it does not copy those files into the scaffold or rewrite them implicitly.

## Verification and handoff

The initializer is deterministic copy-if-missing scaffolding. A repeated run
against an unchanged recognized scaffold reports a no-op; an unrelated
existing project still requires explicit selections. The handoff must
list every created, preserved, skipped, blocked, and unresolved item, show the
final diff, and state the absence of forbidden application outputs and Git or
external mutations. Use the acceptance scenarios and disposable suite for
structural evidence; report live runtime behavior as untested unless it was
actually exercised.
