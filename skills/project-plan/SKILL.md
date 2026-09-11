---
name: project-plan
description: Use when bootstrapping project planning, creating or revising feature, bug, and improvement plans, preparing an approved branch, or preparing approved GitHub issues without implementing them.
---

# Project plan

Create or revise planning artifacts and perform only separately approved Git or
GitHub setup. Never implement plan tasks in this skill.

## Non-negotiable rules

- Prefer the Git worktree root and treat local planning files as authoritative.
- Preserve existing `AGENTS.md`, architecture documents, plans, branches, and
  remote settings. Infer from repository evidence before asking questions.
- Keep planning, approval, implementation, commits, branches, pushes, issues,
  provider setup, and deployment as separate gates.
- Never mark a plan `Approved`; only the user may set that status.
- Never run `git push`. Provide the exact user command when publishing is asked.
- Never read secrets, credentials, browser state, or `.env` files.
- Keep development local by default. Do not assume a provider, framework,
  database, Docker, deployment target, or remote environment. Record
  requirements, alternatives, trade-offs, and an approval gate instead.
- Plan forward-only migrations with local, QA, staging, and separately approved
  production verification in that order.

## Select the mode

If no request is supplied, inspect repository state without mutating it, ask the
user to choose bootstrap, plan creation, plan revision, GitHub issue
preparation, or approved branch preparation, then stop.

Read applicable `AGENTS.md`, `SESSION_STATE.md`, `PLANS.md`, architecture docs,
existing plans, safe Git metadata, and relevant code/tests. Choose the lightest
mode that preserves the required decisions:

| Mode | Output |
| --- | --- |
| Light | In-session brief with goal, acceptance, validation, and questions. |
| Standard | `PLANS.md` and `plans/PLAN-NNNN.md`; tasks, risks, validation. |
| Strict | Standard plus architecture artifacts; required for bootstrap. |

Bootstrap is always strict. Branch or GitHub preparation requires a persisted
plan whose exact status is `Approved`.

Read [references/workflow.md](references/workflow.md) for the complete
invariants, bootstrap, architecture, branch, issue, session-state, and
validation workflow. Use [references/templates.md](references/templates.md) for
the artifact schemas.

Strict bootstrap asks for project scope, users, constraints, stack evidence,
repository boundaries, data and security requirements, local development,
testing, environments, deployment, and branch aliases. After approval it may
create or merge `AGENTS.md`, `PROJECT_ARCHITECTURE.md`, `PLANS.md`, `plans/`,
and `SESSION_STATE.md`, while never scaffolding application code implicitly.

Route only the relevant specialist skills when they are available: repository
research for existing
behavior, product discovery for customer scope, founder decision for business
trade-offs, technical design for architecture, systematic debugging for
failures, frontend design for UI, TDD for a runnable behavior seam,
webapp-testing for durable browser tests, and verification before completion
for the handoff. Use `skill-creator` only when changing a skill. If a named
companion skill is unavailable, keep its handoff contract in the plan and
continue with the equivalent work only when the user has approved it.

Use `plan-consistency-review` after requirements, design, and tasks exist and
before implementation when cross-artifact consistency or coverage needs
checking. Use `plan-convergence` after approved implementation when the user
asks whether the plan and repository state still agree. Both are read-only
companions: they report or propose follow-up work, while this skill remains the
only plan-editing owner.

Use browser interaction only for separately approved, unauthenticated localhost
exploratory QA; it is not a durable test strategy. Route durable browser
coverage to `webapp-testing`.

## Create or revise

1. Establish evidence, assumptions, confirmed requirements, recommendations,
   unresolved questions, and approval gates separately.
2. Use the structures in [references/templates.md](references/templates.md).
   Allocate the next stable plan ID; never reuse or renumber IDs.
3. Make tasks independently understandable, dependency-ordered, and observable.
   For testable behavior, separate Red, Green, and Refactor tasks. Record a TDD
   exception and alternative evidence for configuration, documentation,
   generated, exploratory, or testless work.
4. When revising, address every annotation, preserve stable IDs and accepted
   decisions, synchronize `PLANS.md`, and stop without implementation.

For strict work, update `SESSION_STATE.md` with the plan, branch, completed
planning work, validation, blockers, open questions, decision status, and the
next action. Do not commit it unless the user approved that change.

## Approved setup gates

For branch preparation, verify the plan is `Approved`, ask whether to use the
current branch or create a plan/task branch, show the exact command, require a
clean worktree or explicit direction, verify the base and target, and stop
before implementation or push. Use the configured development branch as base.

For GitHub issues, create them only when asked. Verify authentication and
repository targeting, search for duplicates, draft every issue, obtain explicit
approval, then record links locally. Do not create labels, milestones, projects,
or sub-issues without separate approval.

## Validate and stop

Check plan links, unique IDs, allowed types/statuses, branch consistency, and
GitHub references. Run the narrowest relevant checks, then `git diff --check`
and a complete diff review. Report changed files, approvals, commands,
untested paths, blockers, and the next manual action. Stop; do not implement.
