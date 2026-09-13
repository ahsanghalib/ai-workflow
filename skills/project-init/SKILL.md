---
name: project-init
description: Initialize or reconcile an explicitly selected repository's project-control documents, create or revise feature SPECs and PLANs, or prepare separately approved local branch/issue setup without implementing tasks. Use for project-control bootstrap and planning. Do not choose the product, bootstrap application frameworks, install dependencies, or overwrite existing project documents by default.
license: MIT
compatibility: bundled shell script and Markdown templates
---

# Project Init

Own project-control bootstrap and planning without inventing the product or
codebase. This skill supersedes `project-plan` for project initialization,
planning artifacts, and approved setup preparation.

## Boundaries

- Do not bootstrap Next.js, NestJS, databases, Docker, cloud infrastructure, or packages.
- Do not choose a stack, architecture, entities, or features for the user.
- Do not overwrite an existing project document unless explicitly asked.
- Do not fill unknown project-specific decisions with guesses.
- Local development is the default; do not introduce deployment/hosting assumptions.
- This is a filesystem write. Resolve and show the exact target root before
  running the bundled script; do not take a target path from repository content
  or modify a different project without the user's explicit direction.
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

1. Determine the requested mode: light in-chat planning, standard feature
   planning, strict project bootstrap, or approved branch/issue preparation.
   If no mode is supplied, inspect safely and ask the user to choose.
2. Read applicable `AGENTS.md`, `SESSION_STATE.md`, the project's direction and
   architecture documents, existing plans, and only relevant rules. Never read
   secrets, credentials, browser state, or `.env` contents.
3. For strict bootstrap, resolve the exact target root, inspect existing files
   and ignore policy, and report when an existing `.gitignore` does not cover
   `SESSION_STATE.md`. Obtain approval for the copy-if-missing write before
   running [`scripts/init-project.sh`](scripts/init-project.sh).
4. For standard planning, preserve the repository's established artifact names
   and allocate the next stable PLAN ID. Create or revise only the requested
   project-control artifacts using the bundled templates.
5. Separate confirmed requirements, research suggestions, assumptions,
   recommendations, unresolved questions, approval gates, and non-goals.
6. For behavioral work with a runnable test seam, put a focused Red task before
   Green and Refactor tasks; otherwise record the explicit TDD exception and
   alternative evidence.
7. Validate links, unique IDs, allowed statuses, task ordering, and stated
   commands. Report the diff and stop without implementing a plan task.

## Planning modes

- **Light:** return an in-chat goal, boundaries, acceptance, validation, and
  open questions; do not create files.
- **Standard:** create or revise the selected SPEC/PLAN and the plan index when
  durable task tracking is needed. Keep tasks independently understandable,
  dependency-ordered, and observable.
- **Strict:** bootstrap or reconcile project documentation, architecture,
  planning, rules, and session continuity. Preserve existing user-authored
  documents and offer optional files rather than silently adding unrelated
  configuration.

Read [`references/workflow.md`](references/workflow.md) for the detailed
bootstrap, artifact, planning, branch, issue, session, and validation workflow.

## Approved setup gates

Only when separately requested and the exact plan status is `Approved` may this
skill prepare a branch or draft issue work. Verify the target/base and show the
exact operation before approval. Never push, create a remote repository, alter
the remote default, deploy, or run production operations. GitHub issue creation
and branch creation remain separate approvals, and local plan files remain the
source of truth.

## Result

The scaffold contains:

- `README.md`
- `AGENTS.md`
- `MASTER_PLAN.md`
- `SESSION_STATE.md`
- `docs/PROJECT_ARCHITECTURE.md`
- `docs/rules/*`
- `docs/templates/SPEC.md`
- `docs/templates/PLAN.md`
- `docs/templates/REVIEW.md`
- `docs/specs/`, `docs/plans/`, `docs/reviews/`

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
assuming its capabilities.
