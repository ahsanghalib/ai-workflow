---
description: Bootstrap project planning or create and revise feature, bug, and improvement plans without implementing them.
agent: engineer
---

Run the `/project-plan` workflow for:

```text
$ARGUMENTS
```

If no request is supplied, inspect repository state without mutating it, ask the
user to choose bootstrap, plan creation, plan revision, GitHub issue preparation,
or approved branch preparation, then stop.

Create or revise planning artifacts and perform only separately approved Git or
GitHub setup actions. Never implement plan tasks in this command.

## Invariants

- Prefer the Git worktree project root; otherwise use the current working directory.
- Treat local planning files as authoritative. GitHub issues mirror selected
  work and never overwrite local status automatically.
- Preserve existing user-authored files and structure. Never replace an existing
  `AGENTS.md`, architecture document, plan, branch, issue, or remote setting.
- Infer answers from repository evidence before asking the user.
- Ask only questions whose answers materially affect the resulting project or
  plan, grouping related questions when practical.
- Keep planning, approval, implementation, commits, branch operations, pushes,
  GitHub issues, and remote-default changes as separate gates.
- Never mark a plan `Approved`; only the user may manually set that exact status.
- Never run `git push`. Global policy denies it. Provide exact commands for the
  user when publishing branches is requested, then wait for confirmation.
- Never read or write secrets, credential files, browser sessions, or `.env`
  files. Record required environment-variable names only.

## 1. Detect the mode

Inspect the current directory without mutating it:

1. Determine whether Git is absent, unborn, empty, or already has commits.
2. Read applicable `AGENTS.md`, `SESSION_STATE.md`, `PLANS.md`,
   `PROJECT_ARCHITECTURE.md`, existing detailed plans, branch names, and safe
   repository metadata when present.
3. Choose one mode from the request and repository state:
   - Bootstrap an empty project.
   - Create a feature, bug, or improvement plan.
   - Revise an existing plan after user annotations.
   - Prepare approved plan or task issues for GitHub.
   - Prepare a branch for approved work, then stop before implementation.
4. If intent remains ambiguous, ask which mode to run.

### Conditional skill handoffs

Select only the skills that materially improve the plan. Do not load every
skill by default, and do not implement work while planning.

| Condition | Required planning aid | Planning output |
| --- | --- | --- |
| Existing code, behavior, dependencies, or tests must be understood | `repository-research` | Relevant paths, current behavior, seams, and evidence gaps. |
| Customer problem, audience, demand, MVP scope, or success criteria are unclear | `product-discovery` | Problem framing, validation experiment, success and kill criteria. |
| Capital, hiring, pricing, ownership, runway, or irreversible prioritization is material | `founder-decision` | Decision memo, dissenting risk, and revisit trigger. |
| Architecture, API, module, data-flow, migration, or dependency choice is material | `technical-design` | Boundaries, alternatives, trade-offs, and validation strategy. |
| The plan addresses a defect, failure, flake, regression, or recovery path | `systematic-debugging` | Reproduction baseline, causal hypotheses, and diagnostic evidence. |
| The plan changes UI hierarchy, interaction, responsiveness, or accessibility | `frontend-design` | Design brief, state matrix, responsive behavior, and accessibility contract. |
| The plan changes observable behavior and has a runnable automated test seam | `test-driven-development` | Behavior seam, focused red test, narrow command, green change, refactor, and exception path. |
| Browser coverage is a durable regression requirement in an existing web app | `webapp-testing` | Existing Playwright command, fixture, locator, artifact, and CI strategy. |
| GitHub issue or PR preparation is explicitly requested | `github-cli-workflow` | Target verification, read-only evidence, exact draft, and separate mutation approval. |
| Claiming a planning artifact or preparation step complete | `verification-before-completion` | Fresh evidence, blocked checks, residual risk, and final diff review. |

Use `brand-guidelines` or `social-content` only when the requested artifact
needs supplied brand rules or public-content drafts. Use `agent-browser` only
for separately approved, exploratory unauthenticated localhost QA; it is not a
durable test strategy. Use `skill-creator` only when the plan itself changes an
OpenCode skill.

When `test-driven-development` applies, put the behavior seam and narrow test
command in both `Acceptance Criteria` and `Validation`, and make the red test
the first implementation task. Create distinct dependency-ordered **Red**,
**Green**, and **Refactor** tasks: Red records the expected focused failure;
Green depends on that red evidence; Refactor depends on green evidence. For
configuration-only, documentation-only, generated, exploratory-spike, or
no-meaningful-test-seam work, record the TDD exception and alternative
verification rather than forcing a failing-test-first loop.

## 2. Bootstrap an empty project

Use this mode instead of `/init`. Do not run Git commands or write files until
the relevant gate is approved.

### Interview

Ask for unresolved project decisions in small related groups:

- Project name, purpose, target users, primary problem, and expected outcomes.
- MVP scope, non-goals, constraints, and definition of done.
- Application type, languages, frameworks, runtime versions, and package manager.
- Repository layout, components, boundaries, data flow, and external services.
- Persistence, authentication, authorization, security, and privacy requirements.
- Browser/platform support, accessibility, performance, and availability goals.
- Testing, linting, formatting, type checking, CI, deployment, and observability.
- Environments, documentation, license, and known architecture decisions.
- Branch aliases. Offer `develop`, `staging`, and `production`, while accepting
  alternatives such as `dev`, `stag`, and `prod`.

Record resolved answers in `PROJECT_ARCHITECTURE.md`; retain unresolved decisions
under `Open Questions` rather than inventing answers.

### Optional bootstrap files

Offer, but do not assume, creation of `README.md`, `.gitignore`, a license, editor
settings, and initial CI configuration. Create only selected files and do not
scaffold application code unless explicitly requested in a separate task.

### Required planning artifacts

After summarizing the proposed contents and receiving approval, create or merge:

- `AGENTS.md`
- `PROJECT_ARCHITECTURE.md`
- `PLANS.md`
- `plans/`
- `SESSION_STATE.md`

If Git is absent, ask permission before `git init`. Initialize directly with the
selected development branch when supported. If Git is unborn on another branch,
ask before renaming it. Never alter an established repository's default branch
as part of empty-project bootstrap.

Show the complete initial diff, then ask permission for an initial commit. A
commit is necessary before additional branches can reference repository history.
Use a concise proposed message and commit only files the user approved.

After a successful initial commit, separately offer to create the selected local
staging and production branches from the development branch. Verify branch names
do not already exist, create no extra commits, and finish checked out on the
development branch.

If publication is requested, provide exact `git push` commands for the user; do
not execute them. After the user confirms the development branch exists on a
GitHub remote, separately ask permission before using `gh` to change the remote
default branch. Do not create a GitHub repository unless separately requested.

## 3. Maintain project architecture

Use this project root structure, adapting existing headings instead of duplicating them:

```markdown
# Project Architecture

## Project Overview

## Users and Use Cases

## Goals

## Non-Goals

## Functional Requirements

## Quality Attributes

## Technology Stack

## Repository Structure

## Components and Boundaries

## Data Model

## Data Flow

## External Integrations

## Authentication and Authorization

## Environments

## Branch and Promotion Model

## Build and Tooling

## Testing Strategy

## CI/CD

## Deployment

## Observability

## Security and Privacy

## Accessibility and Browser Support

## Performance and Availability

## Documentation

## Open Questions

## Architecture Decisions
```

Store current resolved architecture here, not task-level implementation details.
When answers conflict with existing decisions, surface the conflict and ask
before changing the document.

Ensure project root `AGENTS.md` links to `PROJECT_ARCHITECTURE.md`, `PLANS.md`, and
`SESSION_STATE.md`. Keep `AGENTS.md` operational: source-of-truth directories,
stack and package manager, build and validation commands, branch policy,
generated-file rules, security boundaries, and deployment restrictions. Do not
duplicate the full architecture.

## 4. Maintain the plan index

Keep project root `PLANS.md` concise:

```markdown
# Project Plans

## Active

| ID  | Title | Type | Status | Dependencies | Branch | GitHub | Updated |
| --- | ----- | ---- | ------ | ------------ | ------ | ------ | ------- |

## Completed

## Cancelled
```

Each row links its ID to `plans/PLAN-NNNN.md`. Include only summary data. Preserve
stable IDs forever and never reuse or renumber them. For a new plan, inspect all
existing IDs and allocate one greater than the highest ID, starting at
`PLAN-0001`.

Allowed types are `Feature`, `Bug`, and `Improvement`. Allowed statuses are
`Proposed`, `Approved`, `In Progress`, `Blocked`, `Completed`, and `Cancelled`.
New plans always start as `Proposed`.

## 5. Create or revise a detailed plan

Before planning substantial existing code, inspect applicable instructions and
trace the relevant entry points, behavior, tests, and constraints. Establish a
baseline for bugs when practical. Separate evidence, assumptions, and open
questions.

Use this structure in `plans/PLAN-NNNN.md`:

```markdown
# PLAN-NNNN: Title

**Type:** Feature | Bug | Improvement
**Status:** Proposed
**Created:** YYYY-MM-DD
**Updated:** YYYY-MM-DD
**Branch:** Not created
**GitHub:** Not created

## Goal

## Context

## Scope

## Non-Goals

## Architecture Impact

## Decisions

## Acceptance Criteria

## Task Groups

## Dependencies

## Risks

## Validation

## Rollback

## Open Questions

## Activity
```

Create stable task IDs within grouped work:

```markdown
### Group 1: Domain model

- [ ] TASK-0001: Define the domain entities.
- [ ] TASK-0002: Add repository behavior and tests.
```

Tasks should be independently understandable, ordered by dependency, and carry
observable completion criteria in their details when the title is insufficient.
Use one task for one coherent implementation and validation slice.

When revising, address every user annotation, preserve accepted decisions and
stable IDs, update `Updated` only when content changes, synchronize the index,
and stop without implementing. Never change `Approved` on the user's behalf.

After writing a new or revised plan, report its path and unresolved decisions,
ask the user to review it, and explain that approval requires manually changing:

```markdown
**Status:** Proposed
```

to:

```markdown
**Status:** Approved
```

## 6. Prepare a branch for approved work

Run this phase only when the user asks to begin work and the detailed plan
contains the exact status `Approved`.

Ask whether to:

- Continue on the current branch.
- Create one branch for the complete plan.
- Create one branch for the selected task.
- Leave branch setup unchanged.

Every new work branch must use the configured development branch as its base,
without exceptions. Suggest names derived from type and stable IDs:

```text
feature/plan-0001-short-title
bugfix/plan-0002-short-title
improvement/plan-0003-short-title
feature/plan-0001-task-0003-short-title
```

Before branch creation, require a clean worktree or explicit user direction for
existing changes; fetch nothing automatically; verify the base exists; verify
the target does not exist; show the proposed command; and request approval.
Update the detailed plan and index after creation. Never implement in this
command and never push the branch.

## 7. Mirror approved work to GitHub issues

Create issues only when asked and only from an `Approved` plan. Ask which scope:

- One issue for the complete plan with a task checklist.
- One issue for a selected task group.
- Separate issues for selected tasks.
- No GitHub issues.

Before any mutation:

1. Verify `gh` authentication and repository targeting without printing tokens.
2. Search existing issue links and titles to prevent duplicates.
3. Draft titles, bodies, labels, relationships, and plan backlinks.
4. Show every draft and ask for explicit approval.

After approval, create only the selected issues. Do not create labels,
milestones, projects, or sub-issues unless separately approved. Record issue
numbers and URLs in the detailed plan, relevant tasks, and index. Local plan
status remains authoritative when GitHub differs.

## 8. Update session continuity

Create or merge project root `SESSION_STATE.md` after meaningful changes. Record:

- Current plan ID, type, and status.
- Current branch and configured environment branch aliases.
- Planning or bootstrap work completed.
- GitHub issue links created.
- Validation performed and its results.
- Open questions, blockers, untested paths, and the exact next action.

Ensure `AGENTS.md` instructs future sessions to read `SESSION_STATE.md`. Do not
commit session state unless the user approved it as part of the current change.

## 9. Validate and stop

Before handoff:

1. Check links between index rows and detailed plans.
2. Check unique plan and task IDs, valid types and statuses, branch consistency,
   and GitHub references.
3. Run the narrowest relevant repository checks, then broader checks when
   justified.
4. Run `git diff --check` and review the complete diff.
5. Report files changed, approvals used, commands run, untested paths, and the
   next manual action.
6. Stop. Do not implement any plan task.
