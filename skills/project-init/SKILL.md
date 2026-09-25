---
name: project-init
description: Bootstrap or reconcile the minimal project-control structure for an explicitly selected repository, preserving user-owned files and legacy layouts. Use for new-project initialization, existing-project reconciliation, or later control-structure updates; route feature, bug, and other substantive work requests to spec-workflow instead of planning them here.
license: MIT
---

# Project Init

Own repository-control bootstrap and reconciliation without inventing the
product, architecture, application code, or feature plan.

## Entry point

Use project-init when the user asks to initialize, bootstrap, reconcile, or
refresh project controls for an explicitly selected repository. Resolve the
current directory or supplied target, inspect it safely, and classify it as:

- `new/empty` — no entries;
- `new/git-only` — only `.git`; or
- `existing/reconciliation` — every other target, including incomplete
  projects, hidden files, symlinks, `.env`, and secret-looking names.

Empty and `.git`-only targets receive the same minimal bootstrap proposal.
Existing targets receive a preserve-first reconciliation proposal. Re-running
the skill is expected: reconcile only the controls affected by actual project
evolution and do not create documentation merely because a template has a slot.

The bundled inspector and inventory are evidence only. They never authorize a
write, Git mutation, feature decision, or application change.

## Trigger and handoff boundaries

Use this skill for requests such as:

- “Use project-init to bootstrap the controls for this empty repository.”
- “Reconcile this existing repository's instructions and project-control
  structure without overwriting its documents.”
- “The project gained a frontend; reconcile only the durable controls that now
  need to change.”

Do not use it as the primary workflow for:

- feature, bug, improvement, refactor, performance, security, migration,
  maintenance, or technical-debt planning;
- product discovery or open-ended ideation (`product-discovery` or
  `brainstorming`);
- technical or persistence design (`technical-design` or `schema-design`);
- implementation of an approved task (`implement-next` plus the relevant
  implementation skill).

If a project-init request also contains a work request, complete or propose
only the repository-control bootstrap/reconciliation, then hand the work
request to `spec-workflow`. Do not create a second feature-planning
implementation inside project-init. If that companion is unavailable, report
the dependency rather than pretending it ran.

## Modes and escalation

- **Light** is the default for ordinary iteration: clarify the repository
  control need in chat and write nothing.
- **Standard** reconciles selected controls in an existing project after
  inspection and separate approval for each write scope.
- **Strict** is for new-project bootstrap or higher-risk reconciliation: show
  the exact target, proposal, approval scopes, and validation before writing.
- Ambiguity resolves to Light. Escalate the review scope for persistence,
  migrations, a public API/shared contract, authentication, authorization,
  permissions, or an existing source-of-truth revision.
- A high-impact write requires an `Approving:` acknowledgement naming the
  target, operation, and forbidden side effects.

Explicit requests for an existing legacy roadmap, document, plan index, or
PLAN may use the bundled templates and references as opt-in compatibility
support. That path is isolated from the default bootstrap and never makes the
legacy artifact mandatory.

## Default output contract

The default new-project control plane is intentionally small:

```text
AGENTS.md
SESSION_STATE.md
.ai/memory/
docs/specs/
```

When the target has no `.gitignore`, the initializer may also copy the bundled
`.gitignore.template` after the normal approval. It protects real environment
files and ignored session/memory runtime state; `.ai/` remains trackable.

The initializer does not create `README.md`, `MASTER_PLAN.md`,
`docs/DB_SCHEMA.md`, `docs/USER_FLOW.md`, `docs/PROJECT_ARCHITECTURE.md`,
`docs/plans/`, `docs/reviews/`, rules, helper prompts, application files, or
framework files by default. Any bundled output outside the minimal control
plane is eligible only through an explicit `--only` selection and approval.
This includes legacy documents and explicit PLAN support.

Existing user-owned legacy artifacts are preserved. Do not rename, delete,
overwrite, or duplicate them merely to match the new default layout.

## Safety and approval boundaries

Read [`references/workflow.md`](references/workflow.md) for the full inspect →
propose → approve → write → validate → handoff sequence. The non-negotiable
contract is:

- resolve and show the exact canonical target before writing;
- inspect only safe metadata until the relevant document is approved for review;
- never read, copy, parse, print, or write `.env` contents, credentials, keys,
  browser state, or other secrets;
- preserve source code, configuration, user-authored documents, symlinks, Git
  metadata, `.ai/`, and existing source-of-truth layouts;
- obtain separate approval for missing-file creation, existing-file revision,
  and local `git init`;
- never create commits, branches, remotes, pushes, deployments, or other
  remote/external mutations; and
- stop at a blocked capability or approval instead of partially widening scope.

For existing projects, use `references/source-of-truth.md` and
`references/reconciliation-report.md` to record keep, create, revise,
preserve, or conflict decisions. A missing control and a revision to an
existing control are separate approval scopes.

## Bundled helper boundaries

`scripts/inspect-project.sh` is read-only target/mode inspection.
`scripts/inventory-project.sh` is read-only safe filename evidence and
classification. `scripts/init-project.sh` is deterministic copy-if-missing
scaffolding from the bundled templates. It may report and preserve existing
files and symlinks, but it does not infer a product, populate documents,
choose a stack, create a feature SPEC/PLAN, install dependencies, create
application files, inspect `.env` contents, or reconcile documents by itself.
`scripts/validate-foundation.sh` validates the minimal control plane after an
approved write; its historical name is retained for compatibility. It does
not require the retired foundational document graph.

## Workflow

1. Resolve the exact target and run the read-only inspector. For an existing
   target, run the safe inventory as well.
2. Read applicable instructions and only the relevant project-control sources.
   Read `SESSION_STATE.md` when it exists. Do not preload speculative docs or
   open secrets.
3. Propose the smallest missing or affected controls. Treat new capabilities
   such as frontend, persistence, authentication, public API, monorepo,
   deployment, workers, or AI as reconciliation signals—not automatic reasons
   to create a document.
4. Show exact paths, ownership, evidence, compatibility impact, assumptions,
   validation, and approval scope. Wait for approval before writing.
5. Apply only the approved copy-if-missing or explicitly approved revision
   operations. Use `--only` for every non-default output. Use `--init-git` only
   after separate approval for the exact target; use `--allow-nested` only for
   an explicitly approved nested target.
6. Run `scripts/validate-foundation.sh` against the resulting control plane,
   inspect the diff, and report created, preserved, skipped, blocked, and
   unresolved items.
7. For a feature or other substantive work request, hand off to
   `spec-workflow`; do not create a SPEC, PLAN, task list, or implementation
   from project-init. If an explicit legacy PLAN operation was requested,
   preserve its separate approval and review gates and label that path as
   opt-in compatibility support.

## References

Load only the references needed by the active branch:

- [`workflow.md`](references/workflow.md) — target classification, approval,
  reconciliation, output, Git, and validation boundaries;
- [`template-manifest.md`](references/template-manifest.md) and
  [`output-boundary.md`](references/output-boundary.md) — default, explicit,
  preserved, and forbidden outputs;
- [`source-of-truth.md`](references/source-of-truth.md),
  [`reconciliation-report.md`](references/reconciliation-report.md), and
  [`reconciliation-population.md`](references/reconciliation-population.md) —
  existing-project evidence and safe document handling;
- [`init-compatibility.md`](references/init-compatibility.md),
  [`prompt-contract.md`](references/prompt-contract.md),
  [`git-approval.md`](references/git-approval.md), and
  [`capability-matrix.md`](references/capability-matrix.md) — harness, prompt,
  Git, capability, and reload boundaries;
- [`acceptance-scenarios.md`](references/acceptance-scenarios.md) — observable
  bootstrap/reconciliation acceptance evidence; and
- [`project-profiles.md`](references/project-profiles.md),
  [`technical-options.md`](references/technical-options.md),
  [`technical-questionnaire.md`](references/technical-questionnaire.md),
  [`feature-lifecycle.md`](references/feature-lifecycle.md), and
  [`traceability.md`](references/traceability.md) — conditional or legacy
  compatibility references only; they do not expand project-init ownership.

## Validation and handoff

Run the narrowest relevant shell and contract tests first, then the repository
skill validator and final diff checks. Structural checks do not prove live
harness reload, application runtime, browser, provider, deployment, or remote
behavior. Never claim those paths were exercised unless they were.

After an approved `AGENTS.md` change, report the exact diff and recommend a
harness reload or fresh session before relying on the new routing. Update
`SESSION_STATE.md` only under its separate approval and existing project policy.
Use `session-state` for an existing state update and `agent-memory` for a
reviewed meaningful capsule when those capabilities are available.
