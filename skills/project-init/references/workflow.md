# Project-Init Workflow Reference

Use this reference with `SKILL.md` for bootstrap, reconciliation, and later
project-control maintenance. It owns the repository control plane only.

## Invariants

- Prefer the Git worktree root when the user names the current repository;
  otherwise use the explicitly selected target root.
- Treat project-control files as evidence and preserve their names and content
  until a revision is explicitly approved.
- Never create, copy, read, parse, print, or write `.env` files or secret
  contents. Record variable names only when safely known without opening them.
- Treat `.ai/` as intentional tracked project documentation/runtime support.
- Keep bootstrap, reconciliation, product decisions, work-request contracts,
  implementation, validation, Git, provider, deployment, and publishing as
  separate gates.
- Never run production migrations, backfills, deployments, deletions, or remote
  operations from this workflow.

## Context and execution discipline

For a repository refactor or a substantial control-plane change, establish
context before editing:

- inspect the whole relevant skill graph and current handoff contracts;
- read the test expectations that protect those contracts; and
- distinguish user-authored artifacts and source of truth from generated
  artifacts before proposing a change.

During editing, change the smallest coherent set of files, keep terminology
consistent across skills, update tests when a contract changes, and preserve
one authoritative source instead of creating parallel state. Avoid unrelated
stylistic rewrites and never silently weaken an existing safety guarantee.

After each major refactor area, run its most relevant focused tests and fix
failures before moving on when practical. Before handoff, run the full
available test suite, rerun stale-reference searches, inspect the final diff,
and confirm the default workflow has no accidental
`PLAN`/`MASTER_PLAN.md`/`DB_SCHEMA.md`/`USER_FLOW.md` dependency.

Resolve routine implementation choices from repository evidence. Ask the user
only when the repository does not answer a genuinely user-owned decision.

## Anti-overengineering guardrails

Do not introduce a SPEC metadata database, mandatory YAML/JSON registry, global
SPEC index, replacement master-plan file, separate execution-plan file, or
duplicate state. Do not make GitHub or external services mandatory, require a
particular application tech stack, assume frontend/backend/database/auth
concerns exist, or create every possible rule file, nested `AGENTS.md`
hierarchy, or architecture document by default.

Do not require blanket schema or technical-design approval. Do not fabricate
repository requirements, user approval, or GitHub state, and do not delete
useful legacy artifacts merely because they are no longer mandatory. Prefer
simple Markdown plus executable repository evidence.

## Artifact decision rule

Before creating or requiring any artifact, ask:

> Does this represent durable information the current project actually needs,
> and is there no clearer existing source of truth?

If the answer is no, do not create or require the artifact. If a clearer
source already exists, preserve and reference it rather than duplicating its
facts. Create a new project-control artifact only when the current project
has a demonstrated durable need, no clearer authoritative source exists, and
the owning workflow's approval boundary permits the write.

## Detect the target

Resolve and canonicalize the exact target before proposing writes. Inspect only
immediate entry names and safe metadata:

1. no entries → `new/empty`;
2. exactly one `.git` entry → `new/git-only`; or
3. any other entry → `existing/reconciliation`.

This includes source, documentation, configuration, `.gitignore`, hidden
files, symlinks, `.env`, and secret-looking names. Never open secret contents
to classify a target. Mode detection is independent of Git state.

Use `scripts/inspect-project.sh` before proposing writes. For an existing
target, use `scripts/inventory-project.sh`. These scripts report safe metadata
and filenames only; they do not authorize or perform the write.

## Reconcile from evidence

Group evidence by control purpose:

- instructions and routing;
- session handoff;
- SPEC location;
- agent/runtime memory;
- source/configuration and executable truth; and
- current rules, architecture, flow, schema, or decision documents when they
  already exist.

For every relevant path, record one of:

- `keep unchanged` — no content change;
- `create missing` — a new minimal control with its own approval;
- `revise after approval` — an exact proposed diff;
- `preserve` — an existing source of truth remains authoritative; or
- `conflict` — multiple plausible owners need a user decision.

Unknown ownership stays open. Generated files are changed through their
documented generator, not directly.

## Minimal default bootstrap

The default proposal contains only:

```text
AGENTS.md
SESSION_STATE.md
.ai/memory/
docs/specs/
```

Copy `.gitignore.template` only when `.gitignore` is missing and that scope is
approved separately. Do not generate speculative README, rules, architecture,
decision, flow, schema, plan, review, prompt, or application documents.
If an existing project already has `specifications/`, `specs/`, or
`docs/specifications/` as its SPEC source of truth, preserve that location and
use an explicitly approved `--spec-dir` mapping rather than creating a second
SPEC directory. The helper refuses to guess this mapping.

When a project gains a frontend, persistence, authentication, public API,
monorepo, deployment, background jobs, multiple deployables, or AI, ask:

> Does this introduce durable repository-wide knowledge or routing that is not
> already represented clearly?

If yes, update the smallest appropriate artifact. If no, do nothing.

## Inspect, propose, approve, write, validate, hand off

Use this state sequence for each operation:

`Detected → Proposed → Awaiting review → Approved → Writing → Validated → Handoff`

1. **Detected:** resolve the target, inspect safe metadata, and identify
   applicable instructions and control sources.
2. **Proposed:** list every path to create, preserve, revise, skip, or flag;
   include evidence, owner, assumptions, validation, and approval scope.
3. **Awaiting review:** obtain separate approval for missing-file creation,
   existing-file revision, and local `git init`.
4. **Approved:** apply only the approved copy-if-missing or exact revision.
5. **Writing:** refuse target or parent symlinks and report concurrent-change
   limitations; do not claim atomic protection.
6. **Validated:** run `scripts/validate-foundation.sh`, inspect the diff, and
   distinguish structural evidence from runtime or harness proof.
7. **Handoff:** report created, changed, preserved, skipped, blocked, and
   unresolved items. Recommend a fresh session after instruction changes.

Do not bundle commits, branches, remotes, pushes, issues, projects, deployment,
or publishing with local bootstrap.

## Substantive work handoff

Project-init does not derive a feature map, create a SPEC, create a task list,
or create an execution document. A feature, bug, improvement, refactor,
performance, security, migration, maintenance, or technical-debt request
hands off to `spec-workflow`. Technical, persistence, product-discovery, and
implementation decisions belong to their named companion workflows.

## Git and ignore handling

If `.gitignore` is absent, a missing-file proposal may copy
`.gitignore.template`. If it exists, preserve it and report recommended
additions without editing unless revision is separately approved. `--init-git`
is a separate, exact-target approval and creates no commit or remote.
