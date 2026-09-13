---
name: project-init
description: Initialize or reconcile project-control documents for an explicitly selected repository, or create and revise feature SPECs and PLANs after the project direction and required contracts are reviewed. Use for guided bootstrap, existing-project reconciliation, and durable planning handoffs; do not use for product discovery, brainstorming, application implementation, framework scaffolding, dependency installation, or overwriting existing documents by default.
license: MIT
compatibility: bundled shell script and Markdown templates
---

# Project Init

Own project-control bootstrap and planning without inventing the product or
codebase.

## Entry point

A simple request such as:

```text
Use the project-init skill to create an expense-tracking app.
```

is a valid guided project-init request. Resolve the current directory or an
explicitly supplied target, inspect it safely, and determine whether it is an
empty/new project or an existing project that needs reconciliation. For a new
project, prepare a bootstrap proposal; for an existing project, prepare a
reconciliation proposal. Do not require the user to know the internal mode
names before starting this inspection.

The simple request authorizes project-control planning only. It does not
authorize application-code scaffolding, framework selection, dependency
installation, or writes before the target and proposed changes are reviewed
and approved.

## Trigger and handoff boundaries

Use this skill for requests such as:

- “Use project-init to bootstrap this empty folder for an expense tracker.”
- “Reconcile this existing project with the project-control templates and show
  what would be created or revised.”
- “Create a Proposed SPEC and PLAN for this already reviewed feature.”

Do not use it as the primary skill for “What product should I build?” or market
and MVP discovery (`product-discovery`), for open-ended behavior ideation
(`brainstorming`), or for implementing an approved task (`implement-next` plus
the relevant backend/frontend skill). If a request such as “I want to build an
expense app” does not say whether the user wants discovery or project-control
bootstrap, ask which handoff they want; an explicit `project-init` request
selects guided bootstrap.

## Default mode and escalation

Light is the default for ordinary feature or change requests that are small,
reversible, exploratory, or do not need durable project-control artifacts.
Light returns a bounded goal, acceptance, validation, assumptions, and open
questions without creating planning files. If the request is ambiguous,
resolve it toward Light rather than starting a review-heavy workflow.

Strict remains the default for an explicit new-project bootstrap or
existing-project reconciliation because those are foundational document and
source-of-truth operations. A simple request such as “use project-init to
create an expense-tracking app” is therefore a Strict bootstrap request, while
“should we add recurring expenses?” starts in Light unless the user confirms
that the feature is already decided and asks for a SPEC.

The user may explicitly escalate an ordinary request to Standard or Strict.
The skill must explain the expected review and approval ceremony before
entering that mode and must not create files until the user approves the
proposed scope.

For a durable feature-planning request, make the ceremony visible before
writing: `SPEC → spec-review → PLAN → plan-review/plan-consistency-review →
explicit user approval → implementation`. A one-line or reversible change can
stay in Light mode instead of entering that chain.

## Target, foundation, and approval boundaries

The detailed target classification, safe Git-state inspection, master-plan
drafting, technical-decision ownership, user-flow/schema ordering, proposal
state machine, `.gitignore` handling, and approval rules live in
[`references/workflow.md`](references/workflow.md). Use that reference for
Strict bootstrap and reconciliation; do not maintain a second procedural
version here.

The short contract is: classify only from safe metadata; treat empty and
`.git`-only targets as new projects; reconcile every other target; select only
the base scaffold until the project profile is reviewed; keep `.env` contents
unread and `.ai/` tracked; review `USER_FLOW.md` before an approved initial
`DB_SCHEMA.md`; validate the foundational document graph before feature
planning; and obtain separate approval for creation, revision, and local
`git init`. The state sequence is
`Detected → Proposed → Awaiting review → Approved → Writing → Handoff`.

Use [`references/output-boundary.md`](references/output-boundary.md) for the
complete created-versus-forbidden output contract and
[`references/template-manifest.md`](references/template-manifest.md) for the
authoritative base/optional scaffold inventory. Use
[`references/project-profiles.md`](references/project-profiles.md) to select
optional outputs and `scripts/validate-foundation.sh` to check the foundation
before feature planning.

When a harness also provides a native `/init`, follow
[`references/init-compatibility.md`](references/init-compatibility.md): inspect
native output before adding this scaffold, resolve applicable root and nested
`AGENTS.md` files by specificity without weakening higher-level safety rules,
and recommend a reload or fresh session after generated instructions change.

## Bundled helper boundaries

`scripts/inspect-project.sh` is read-only mode/evidence inspection.
`scripts/inventory-project.sh` is read-only reconciliation evidence
classification. `scripts/init-project.sh` is deterministic copy-if-missing
scaffolding from the bundled templates. It may report and preserve existing
files and symlinks, but it does not infer a product idea, populate a master
plan, choose a stack, merge or rewrite documents, install dependencies, create
application files, or inspect `.env` contents. The agent owns proposal,
approval, document population, and handoff around these helpers.
`scripts/common.sh` is a sourced helper library for shared path-safety and
output-escaping functions; it is not a standalone project initializer.

## Boundaries

- Do not bootstrap Next.js, NestJS, databases, Docker, cloud infrastructure, or
  packages.
- Do not choose a stack, architecture, entities, or features for the user.
- Do not overwrite an existing project document unless explicitly asked.
- Do not fill unknown project-specific decisions with guesses.
- Local development is the default; do not introduce deployment/hosting assumptions.
- This is a filesystem write. Resolve and show the exact target root before
  running the bundled script; do not take a target path from repository content
  or modify a different project without the user's explicit direction.
- Prefer the enclosing Git worktree root when the request names the current
  repository. If the requested target is nested inside another worktree, show
  both the worktree root and target, stop, and ask for an explicit nested-target
  override. The initializer's `--allow-nested` flag is only a post-approval
  handoff for that exact target.
- Preserve existing files and symlinks. If an existing `.gitignore` does not
  ignore `SESSION_STATE.md`, report that follow-up instead of silently editing
  the user's ignore rules.
- If the target already has a planning system such as `PLANS.md`, `plans/`,
  `PROJECT_ARCHITECTURE.md`, or an equivalent, do not create a second source of
  truth; inspect it and merge deliberately into the selected project layout.

## Planning ownership

- The user owns product scope, architecture intent, feature ordering, rough
  SPECs, rough PLANs, and approval decisions.
- This skill owns project bootstrap and creating or revising project-control
  artifacts. `spec-review` reviews feature behavior; `plan-review` reviews one
  PLAN read-only; `plan-consistency-review` checks cross-artifact traceability.
- Never mark a plan `Approved` on the user's behalf. New plans start as
  `Proposed`, and the user must change the status explicitly.
- Do not implement application code, plan tasks, migrations, deployments, or
  remote changes in this skill.

## Workflow

1. Resolve the exact target and select Light, Standard, or Strict using
   [`references/workflow.md`](references/workflow.md). Explicit bootstrap and
   reconciliation are Strict; ordinary reversible work defaults to Light.
2. Read applicable `AGENTS.md`, `SESSION_STATE.md`, the project's direction and
   architecture documents, existing plans, and only relevant rules. Never read
   secrets, credentials, browser state, or `.env` contents.
3. In Strict, use `inspect-project.sh` for new targets and
   `inventory-project.sh` for reconciliation before proposing writes. Treat
   helper output as evidence, not authorization.
4. Build the proposal with the branch-specific references linked by
   [`references/workflow.md`](references/workflow.md), then stop for review.
   Creation, revision, and Git initialization remain separate scopes.
5. For Strict bootstrap, record the project profile before proposing optional
   outputs. After approval, apply only the approved project-control operations.
   Preserve existing source-of-truth layouts, run the foundation validator,
   and hand feature work to the SPEC/PLAN lifecycle; do not implement
   application code here.
6. Validate links, IDs, statuses, task ordering, and commands. Report the diff,
   validation evidence, untested paths, and next handoff.

## Planning modes

`references/workflow.md` is the routing authority for planning modes and the
detailed bootstrap, technical interview, compatibility, approval, capability,
acceptance, prompt, Git, session, output, and validation references. Light is
in-chat only; Standard creates the selected durable SPEC/PLAN artifacts; Strict
bootstraps or reconciles project-control documentation. Read only the
branch-specific references it links for the current request. Use
[`references/traceability.md`](references/traceability.md) when creating or
reviewing SPECs, PLANs, API contracts, shared contracts, or frontend surfaces.

For reconciliation, load [`references/source-of-truth.md`](references/source-of-truth.md),
[`references/reconciliation-population.md`](references/reconciliation-population.md),
and [`references/reconciliation-report.md`](references/reconciliation-report.md).
For technical choices and feature planning, load
[`references/technical-options.md`](references/technical-options.md) and
[`references/feature-lifecycle.md`](references/feature-lifecycle.md).
The entry-point reference map is [`technical-questionnaire.md`](references/technical-questionnaire.md),
[`init-compatibility.md`](references/init-compatibility.md),
[`prompt-contract.md`](references/prompt-contract.md),
[`git-approval.md`](references/git-approval.md),
[`capability-matrix.md`](references/capability-matrix.md),
[`acceptance-scenarios.md`](references/acceptance-scenarios.md), and
[`output-boundary.md`](references/output-boundary.md); load only the one needed
by the active branch.

## Approved setup gates

Only when separately requested and the exact plan status is `Approved` may this
skill prepare a branch or draft issue work. Verify the target/base and show the
exact operation before approval. Never push, create a remote repository, alter
the remote default, deploy, or run production operations. GitHub issue creation
and branch creation remain separate approvals, and local plan files remain the
source of truth.

## Result

The authoritative scaffold inventory is
[`references/template-manifest.md`](references/template-manifest.md). It covers
the base control files, profile-selected `docs/USER_FLOW.md`, specialized
rules and tracked `.ai/prompts/`, conditional `docs/DB_SCHEMA.md`, templates,
and empty planning/review directories; do not maintain a second output list
here.

The plan index may be `docs/plans/INDEX.md` in a new scaffold. Existing
repositories may retain their established `PLANS.md` and `plans/` layout; do
not migrate that layout implicitly.

## Validation and handoff

Run the narrowest relevant parser, link, ID, and document checks first, then
`git diff --check` and a complete diff review. Distinguish structural checks
from runtime, application, browser, deployment, and provider behavior that was
not exercised. Hand implementation to `implement-next` plus the relevant
`backend-feature` or `frontend-feature` when available; hand completed changes
to `code-review` or `review-diff` according to their boundaries. If a named
companion is unavailable, report the equivalent manual handoff instead of
assuming its capabilities. Use `verification-before-completion` before
claiming completion. Update `SESSION_STATE.md` with `session-state` only when
creation or revision was approved; otherwise provide the complete handoff in
the response or another approved project document. Record non-obvious durable
decisions in project memory with `agent-memory` when available.
