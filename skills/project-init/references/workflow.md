# Project-Init Workflow Reference

Use this reference with `SKILL.md` for bootstrap, reconciliation, and later
project-control maintenance. It owns the repository control plane only.

## Invariants

- Prefer the Git worktree root when the user names the current repository;
  otherwise use the explicitly selected target root.
- Treat local project-control files as authoritative. Do not silently replace
  user-authored documents, accepted decisions, plans, branches, settings, or
  generated outputs.
- Never create, copy, read, parse, print, or write `.env` files or secret
  contents. Record variable names only when they are already safely known.
- Treat `.ai/` as intentional tracked project documentation/runtime support.
  Do not add an `.ai/` ignore rule or use it as hidden authorization.
- Keep bootstrap, reconciliation, product decisions, work-request contracts,
  implementation, validation, Git, issue, provider, deployment, and publishing
  as separate gates.
- Do not add services, queues, databases, Docker, remote dependencies, or
  abstractions without a demonstrated current need.
- Never run production migrations, backfills, deployments, deletions, or remote
  operations from this workflow.

## Detect the target

Resolve and canonicalize the exact target before proposing writes. Inspect only
immediate entry names and safe metadata to determine the mode:

1. no entries → `new/empty`;
2. exactly one `.git` entry → `new/git-only`; or
3. any other entry → `existing/reconciliation`.

This includes source, documentation, configuration, `.gitignore`, hidden
files, symlinks, `.env`, and secret-looking names. Never open or use secret
contents to classify a target. Reconcile every non-empty target; incomplete
structure is not a reason to reject it.

Mode detection is independent of Git state. Inspect whether Git is absent,
unborn, established, or unavailable using safe metadata only. Any `git init`
remains a separate approval-gated operation.

Use `scripts/inspect-project.sh` before proposing writes. It reports the
canonical target, enclosing worktree, mode, immediate names, safe Git state,
and a no-write proposal. It must not create the target, read file contents,
inspect `.env` values, or mutate Git.

For an existing target, use `scripts/inventory-project.sh`. It records safe
filenames up to its configured depth, classifies likely instruction, planning,
architecture, flow, schema, source, validation, manifest, and configuration
evidence, prunes common dependency/generated paths, and reports symlinks
without following them. Categories are evidence, not authority.

## Reconcile from evidence

Use [`source-of-truth.md`](source-of-truth.md) to group candidates and preserve
established names and locations. Existing `MASTER_PLAN.md`, `DB_SCHEMA.md`,
`USER_FLOW.md`, `PROJECT_ARCHITECTURE.md`, `docs/plans/`, `docs/reviews/`, root
rules, or equivalent artifacts may remain authoritative; project-init must not
create a duplicate layout merely because a bundled template uses another name.
Use [`project-profiles.md`](project-profiles.md) only when project-shape or
concern questions are needed to scope the reconciliation proposal.

For every relevant path, record one of:

- `keep unchanged` — no content change;
- `create missing` — a new path with its own approval;
- `revise after approval` — an existing path with an exact proposed diff;
- `preserve` — an existing source of truth remains authoritative; or
- `conflict` — multiple plausible owners need a user decision.

Use [`reconciliation-report.md`](reconciliation-report.md) for the per-file
proposal and [`reconciliation-population.md`](reconciliation-population.md) for
safe evidence-to-field handling. Unknown ownership stays open. Generated files
are changed through their generator, not directly.

When an existing project uses different control-file paths, preserve those
paths and validate them through an explicit mapping. Do not create duplicate
canonical files merely to satisfy a bundled template.

## Minimal default bootstrap

The default new-project proposal contains only:

```text
AGENTS.md
SESSION_STATE.md
.ai/memory/
docs/specs/
```

If `.gitignore` is missing, propose the bundled template separately as a
missing-file copy. The template ignores real environment files and local
runtime state while keeping `.ai/` trackable.

Do not create `README.md`, `MASTER_PLAN.md`, `docs/DB_SCHEMA.md`,
`docs/USER_FLOW.md`, `docs/PROJECT_ARCHITECTURE.md`, `docs/plans/`,
`docs/reviews/`, rules, prompts, architecture books, schema copies, or feature
plans by default. These remain explicit outputs only when current evidence and
user approval justify them. A template slot is not justification.

When the project evolves—frontend, persistence, auth, public API, monorepo,
deployment, workers, multiple deployables, or AI—ask whether durable
repository-wide knowledge is missing. Update the smallest appropriate control,
or do nothing when source/configuration already explains it. Report an
inapplicable optional document as skipped rather than creating it speculatively.

## Inspect, propose, approve, write, validate, hand off

Use the following state sequence for each operation:

`Detected → Proposed → Awaiting review → Approved → Writing → Validated → Handoff`

If the user changes or rejects the proposal, return to `Proposed`. If a
required capability or approval is unavailable, stop in `Blocked` with no
partial write.

1. **Detected:** resolve the exact target, inspect safe metadata, and identify
   applicable instructions and source-of-truth candidates.
2. **Proposed:** list every path to create, preserve, revise, skip, or flag;
   include evidence, owner, compatibility impact, assumptions, validation, and
   the exact next review action.
3. **Awaiting review:** obtain separate approval for missing-file creation,
   existing-file revision, optional legacy output, and local `git init`.
4. **Approved:** preserve existing structure and apply only approved scopes.
5. **Writing:** use copy-if-missing and exact `--only` selections. The
   initializer refuses target or parent symlinks and does not claim atomic
   protection from hostile concurrent replacement. An unchanged recognized
   scaffold is an explicit no-op.
6. **Validated:** run `scripts/validate-foundation.sh`, inspect the resulting
   diff, and distinguish structural evidence from live runtime or harness proof.
7. **Handoff:** report created, changed, preserved, skipped, blocked, and
   unresolved items. Recommend a fresh session after instruction changes.

Do not bundle commits, branches, remotes, pushes, issues, deployment, or
publishing with local documentation bootstrap.

## Risk-based escalation and approval acknowledgement

Escalate the review scope when a request involves a public API/shared contract,
authentication, authorization, persisted data, migrations, or a source-of-truth
revision. High-impact writes must identify the exact target, operation, and
forbidden side effects in an `Approving:` acknowledgement before writing.
Project-init still owns only repository-control changes; substantive behavior
goes to `spec-workflow`.

## Capability and native-init fallback

Use [`capability-matrix.md`](capability-matrix.md) before relying on approval,
filesystem, shell, Git, validation, routing, session-state, memory, or current
research capabilities. A missing capability blocks only the dependent
operation. It never authorizes a partial write or an unverified completion
claim.

When a harness provides native `/init`, follow
[`init-compatibility.md`](init-compatibility.md). Inspect native output first,
preserve existing instructions, and do not run two initializers against the
same target without an intervening reconciliation proposal.

After an approved `AGENTS.md` change, show the exact diff and recommend a
harness reload or fresh session before relying on the new rules. Continue under
the rules already active until then.

## Handoff for substantive work

Project-init does not derive a feature map, create a SPEC, create a task list,
or create a normal-work PLAN. A feature, bug, improvement, refactor,
performance, security, migration, maintenance, or technical-debt request
hands off to `spec-workflow`. If that companion is unavailable, record the
dependency and stop rather than routing normal work back into project-init.

Technical, persistence, product-discovery, and implementation decisions belong
to their named companion workflows when available. The project-init prompt
library is only a tracked routing aid.

## Explicit legacy compatibility

When the user explicitly requests a legacy roadmap, user-flow, schema,
architecture, plan index, review directory, or PLAN, use the selected bundled
template only after a separate approval. Preserve existing paths, keep the
legacy lifecycle isolated from default bootstrap, and do not imply that the
artifact is required for new work. `--with-schema` is accepted only with the
exact `--only docs/DB_SCHEMA.md --with-schema` selection.

The retained [`feature-lifecycle.md`](feature-lifecycle.md) and
[`traceability.md`](traceability.md) references describe this opt-in legacy
path only. Normal feature-work routing remains `spec-workflow`.

## Git and ignore handling

If `.gitignore` is absent, a missing-file proposal may copy
`.gitignore.template`. If it exists, preserve it byte-for-byte and report
missing recommended rules without editing. Never add an `.ai/` ignore rule.

If Git is absent or local initialization is not approved, approved control
writes may continue without Git; report that history and Git-state validation
are unavailable. If `--init-git` was selected but Git is unavailable, stop
before creating the target or scaffold files.

## Session continuity and stop condition

`SESSION_STATE.md` records active SPEC and active SPEC task when those exist,
plus current status, blockers, validation, untested paths, and next action. It
does not become the permanent requirements source. Update it only under its
existing project policy and separate approval.

Stop after the requested bootstrap or reconciliation handoff. Do not implement
application code, create a normal-work PLAN, commit, push, deploy, publish, or
start another workflow task.
