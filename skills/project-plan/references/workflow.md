<!-- markdownlint-disable MD013 -->

# Project-plan workflow reference

Use this reference with the concise entrypoint. It preserves the detailed
gates and evidence requirements for each planning mode.

## Invariants

- Prefer the Git worktree project root; otherwise use the current working
  directory.
- Treat local planning files as authoritative. GitHub issues mirror selected
  work and never overwrite local status automatically.
- Preserve existing user-authored files and structure. Never replace an
  existing `AGENTS.md`, architecture document, plan, branch, issue, or remote
  setting.
- Infer answers from repository evidence before asking the user. Ask only
  questions whose answers materially affect the resulting project or plan.
- Keep planning, approval, implementation, commits, branch operations, pushes,
  GitHub issues, and remote-default changes as separate gates.
- Never mark a plan `Approved`; only the user may manually set that exact
  status. Never run `git push`; provide exact commands for the user when
  publishing is requested, then wait for confirmation.
- Never read or write secrets, credential files, browser sessions, or `.env`
  files. Record required environment-variable names only.
- Treat technology, framework, database, storage, hosting, deployment, CI, and
  provider choices as proposed until explicitly approved. Never infer a
  provider or stack from research notes alone. For an unresolved provider,
  document requirements, constraints, alternatives, recommendation, trade-offs,
  and an explicit approval gate.
- Keep local development fully local. It must not require deployed QA,
  staging, or production resources or target a remote environment by default.
  After a provider is selected, prefer compatible local emulation. Use Docker
  only locally and only when native or other local emulation cannot reproduce a
  concrete required behavior. Explain unreproducible capability and ask before
  requiring a remote development resource.
- Keep architecture low-complexity. Do not propose services, queues,
  databases, Docker, remote dependencies, or abstractions without a demonstrated
  need.
- Treat branch creation, pushes, remote setup, provider setup, deployment, and
  deployment integration as separate approval gates. QA, staging, and
  production may use the same resource types, but must isolate persistent data,
  storage, secrets, credentials, and session-signing material. A pushed
  `develop` branch becomes QA only after separately approved deployment
  integration; if the project explicitly configures another development-branch
  alias, apply the same rule to that alias.
- Plan forward-only migrations. Never edit an applied migration or manually
  alter a deployed schema. Require promotion in this order: local migration
  apply and compatibility validation; QA apply and verification after the
  development branch; staging apply and verification; separately approved
  production apply and deployment. Choose exact provider commands only after
  the provider and stack are approved.

## Detect the mode

Inspect without mutating:

1. Determine whether Git is absent, unborn, empty, or already has commits.
2. Read applicable `AGENTS.md`, `SESSION_STATE.md`, `PLANS.md`,
   `PROJECT_ARCHITECTURE.md`, detailed plans, branch names, and safe metadata.
3. Choose one mode from the request and repository state: bootstrap an empty
   project; create a feature, bug, or improvement plan; revise an existing
   plan; prepare approved GitHub issues; or prepare a branch for approved work
   and stop before implementation.
4. If intent remains ambiguous, ask which mode to run.

### Planning level

State the lightest level that preserves needed decisions; the user may
override it:

- **Light:** isolated, low-risk, clear scope. Return an in-session brief with
  goal, boundaries, acceptance, validation, and open questions. Do not create
  planning artifacts.
- **Standard:** multiple dependent tasks or an approval record. Create or
  revise `PLANS.md` and `plans/PLAN-NNNN.md` with acceptance, dependencies,
  tasks, risks, and validation. Do not change architecture, global
  instructions, or session state unless separately asked.
- **Strict:** bootstrap, cross-cutting architecture, high-risk changes, or
  explicit request. Apply the complete workflow, including architecture and
  session-continuity artifacts.

Bootstrap is always strict. Branch and GitHub preparation require a standard
or strict persisted plan with user-set `Approved` status. Do not create a plan
file for light planning merely to satisfy process.

## Conditional skill handoffs

Select only aids that materially improve the plan; do not load every skill by
default and do not implement work while planning.

| Condition | Planning aid | Output |
| --- | --- | --- |
| Existing code, behavior, dependencies, or tests need understanding | `repository-research` | Relevant paths, behavior, seams, evidence gaps |
| Customer problem, audience, demand, MVP, or success criteria are unclear | `product-discovery` | Problem framing, validation experiment, success and kill criteria |
| Capital, hiring, pricing, ownership, runway, or irreversible prioritization matters | `founder-decision` | Decision memo, dissenting risk, revisit trigger |
| Architecture, API, module, data-flow, migration, or dependency choice matters | `technical-design` | Boundaries, alternatives, trade-offs, validation |
| The plan addresses a defect, failure, flake, regression, or recovery path | `systematic-debugging` | Reproduction baseline, hypotheses, diagnostic evidence |
| The plan changes UI hierarchy, interaction, responsiveness, or accessibility | `frontend-design` | Design brief, state matrix, responsive behavior, accessibility contract |
| Observable behavior has a runnable automated test seam | `test-driven-development` | Behavior seam, focused red test, narrow command, green change, refactor, exception |
| Browser coverage is a durable regression requirement | `webapp-testing` | Existing test command, fixture, locator, artifact, CI strategy |
| GitHub issue or PR preparation is requested | `github-cli-workflow` | Target verification, evidence, draft, separate approval |
| Claiming an artifact or preparation step complete | `verification-before-completion` | Fresh evidence, blocked checks, residual risk, final diff review |

Use `brand-guidelines` or `social-content` only when the artifact needs supplied
brand rules or public-content drafts. Use browser interaction only for a
separately approved, unauthenticated localhost exploratory QA request; it is not
a durable test strategy. Route durable browser coverage to `webapp-testing`.
Use `skill-creator` only when the plan itself changes a skill. If a named
companion is unavailable, keep its handoff contract in the plan and continue
with equivalent work only when approved.

When TDD applies, put the behavior seam and narrow command in both Acceptance
Criteria and Validation. Make the red test the first implementation task, then
create dependency-ordered **Red**, **Green**, and **Refactor** tasks. For
configuration-only, documentation-only, generated, exploratory-spike, or
testless work, record the TDD exception and alternative verification.

## Bootstrap an empty project

Do not run Git commands or write files until the relevant gate is approved.

### Interview

Ask in small related groups for project name, purpose, target users, problem,
outcomes, MVP scope, non-goals, constraints, definition of done, application
type, languages, frameworks, runtime, package manager, and evidence or approval
for each technology decision. Also ask about repository layout, components,
boundaries, data flow, external services, persistence, authentication,
authorization, security, privacy, browser/platform support, accessibility,
performance, availability, testing, linting, formatting, type checking, CI,
deployment, observability, environments, local emulation gaps, documentation,
license, architecture decisions, and isolation of remote data, storage,
secrets, credentials, and session-signing material. Ask for branch aliases;
offer `develop`, `staging`, and `production` while accepting alternatives.

Record confirmed requirements separately from research suggestions, assumptions,
recommendations, and unresolved questions in `PROJECT_ARCHITECTURE.md`. For an
unresolved provider, record requirements, constraints, alternatives,
recommendation, trade-offs, and the approval gate. Keep unresolved decisions
under `Open Questions`.

### Optional files and required artifacts

Offer, but do not assume, creation of `README.md`, `.gitignore`, a license,
editor settings, and initial CI configuration. Create only selected files and
do not scaffold application code unless explicitly requested separately.

After summarizing proposed contents and receiving approval, create or merge
`AGENTS.md`, `PROJECT_ARCHITECTURE.md`, `PLANS.md`, `plans/`, and
`SESSION_STATE.md`. If Git is absent, ask before `git init`; initialize on the
selected development branch when supported. If Git is unborn on another branch,
ask before renaming it. Never alter an established repository's default branch
as part of bootstrap.

Show the complete initial diff, then ask permission for an initial commit. Use a
concise proposed message and commit only approved files. After that commit,
separately offer local staging and production branches, verify names do not
exist, create no extra commits, and finish on the development branch.

If publication is requested, provide exact user-run push commands and do not
execute them. After the user confirms the development branch exists remotely,
ask separately before changing the remote default branch. Do not create a
remote repository unless separately requested.

## Maintain architecture

Use the structure in `templates.md`, adapting existing headings instead of
duplicating them. Store current resolved architecture there, not task-level
implementation details. Surface conflicts before changing accepted decisions.
Keep provider choices unresolved and explicit until approved. In local
development, prohibit remote environments by default and document each approved
emulator, local-only Docker exception, or approved remote-only gap. In
environments, state isolation for data, storage, secrets, credentials, and
session-signing material. In branch/promotion, state when the development
branch becomes QA. In migration/release, require the forward-only local, QA,
staging, production sequence.

Ensure root `AGENTS.md` links to architecture, plans, and session state. Keep it
operational: source directories, stack and package manager, validation
commands, branch policy, generated-file rules, security boundaries, deployment
restrictions, provider-neutral decisions, local-development and Docker rules,
environment isolation, approval gates, forward-only migrations, and the
low-complexity constraint. Do not duplicate the full architecture.

## Maintain the plan index

Keep `PLANS.md` concise using `templates.md`. Each row links to
`plans/PLAN-NNNN.md`; include summary data only. Preserve stable IDs forever,
never reuse or renumber them, and allocate one greater than the highest
existing ID, starting at `PLAN-0001`. Allowed types are `Feature`, `Bug`, and
`Improvement`; allowed statuses are `Proposed`, `Approved`, `In Progress`,
`Blocked`, `Completed`, and `Cancelled`. New plans start as `Proposed`.

## Create or revise a detailed plan

Before planning substantial existing code, trace relevant entry points,
behavior, tests, and constraints and establish a bug baseline when practical.
Separate evidence, assumptions, and open questions. Use the detailed-plan
schema in `templates.md`. Tasks must be independently understandable,
dependency-ordered, observable, and one coherent implementation/validation
slice.

When revising, address every annotation, preserve accepted decisions and stable
IDs, update `Updated` only when content changes, synchronize the index, and
stop without implementation. Keep confirmed requirements, research
suggestions, assumptions, recommendations, and unresolved questions distinct.
For unresolved providers, record requirements, alternatives, trade-offs, and
the approval gate. Require local-only development and forward-only migrations.

After writing a plan, report its path and unresolved decisions, ask the user to
review it, and explain that approval requires manually changing:

```markdown
**Status:** Proposed
```

to:

```markdown
**Status:** Approved
```

## Prepare a branch for approved work

Run only when the user asks to begin and the detailed plan contains exact
`Approved` status. Ask whether to continue on the current branch, create one
branch for the plan, create one for a selected task, or leave setup unchanged.
New branches use the configured development branch as their base. Suggested
names include:

```text
feature/plan-0001-short-title
bugfix/plan-0002-short-title
improvement/plan-0003-short-title
feature/plan-0001-task-0003-short-title
```

Require a clean worktree or explicit direction for existing changes; fetch
nothing automatically; verify base exists and target does not; show the command
and request approval. Update plan and index after creation. Never implement or
push in this skill.

## Mirror approved work to GitHub issues

Create issues only when asked and only from an `Approved` plan. Ask whether to
create one issue for the plan, one for a task group, separate task issues, or
none. Before mutation, verify authentication and targeting without exposing
tokens, search issue links and titles for duplicates, draft every title/body/
label/relationship/backlink, and obtain explicit approval. Create only selected
issues. Do not create labels, milestones, projects, or sub-issues without
separate approval. Record resulting links locally; local plan status remains
authoritative.

## Update session continuity

For strict work, create or merge root `SESSION_STATE.md` after meaningful
changes. Record plan ID/type/status, branch and environment aliases, completed
planning/bootstrap work, issue links, validation, open questions, blockers,
untested paths, exact next action, decision categories, provider/stack status,
local-emulation gaps, environment isolation, migration/release stage, and every
approval needed before remote resources, branch/push, provider setup, or
deployment. Ensure `AGENTS.md` instructs future sessions to read it. Do not
commit session state without approval.

## Validate and stop

Check index-to-plan links, unique plan and task IDs, allowed types and statuses,
branch consistency, and GitHub references. Run the narrowest relevant checks,
then broader checks when justified, `git diff --check`, and a complete diff
review. Report changed files, approvals, commands, untested paths, and the
next manual action. Stop; do not implement any plan task.
