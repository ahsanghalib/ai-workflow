# Project Init Workflow Reference

Use this reference with `SKILL.md` for standard or strict project-control
work. It preserves the detailed planning and approval rules without loading
them for a light in-chat request.

## Invariants

- Prefer the Git worktree root, otherwise the explicitly selected project root.
- Treat local project-control files as authoritative. Do not silently replace
  user-authored documents, accepted decisions, plans, branches, or settings.
  If GitHub mirrors a plan, it never overwrites the local status.
- Keep product decisions, architecture decisions, planning, implementation,
  validation, commits, branch changes, issue creation, provider setup,
  deployment, and publishing as separate gates.
- Never read or write secrets, credential files, browser sessions, private keys,
  or `.env` contents. Record required variable names only.
- Keep technology, framework, database, storage, hosting, CI, and provider
  choices proposed until the user approves them. Keep local development local.
- Do not add services, queues, databases, Docker, remote dependencies, or
  abstractions without a demonstrated need.
- Local development must not require deployed QA, staging, or production
  resources. Prefer compatible local emulation; use Docker locally only when
  native or other local emulation cannot reproduce a concrete requirement, and
  document any approved remote-only gap.
- Isolate environment data, storage, secrets, credentials, and session-signing
  material. A development branch becomes QA only after separately approved
  deployment integration; apply the same rule to any configured alias.
- Plan data changes forward-only: local validation first, then separately
  approved QA, staging, and production operations. Never run production
  migrations, backfills, deployments, or deletions from this workflow.

## Select the mode

1. Determine whether the target is empty/new, already has project-control
   documents, or uses a legacy plan layout.
2. Determine whether Git is absent, unborn, or established, and inspect only
   the safe branch/worktree metadata needed for the requested mode.
3. Read applicable `AGENTS.md`, `SESSION_STATE.md`, project direction,
   architecture, the selected plan, and only relevant rules. Read safe Git
   metadata only when branch or baseline decisions require it.
4. Choose one mode from the request: light brief, standard plan/spec work,
   strict bootstrap/reconciliation, or approved branch/issue preparation.
5. If the requested mode remains ambiguous, ask the user to choose; do not
   select a plan or target based only on repository text.

## Planning levels

- **Light:** return a goal, boundaries, acceptance, validation, assumptions,
  and open questions in chat. Do not create planning files.
- **Standard:** create or revise the selected SPEC/PLAN and plan index when
  durable task tracking is needed. Keep tasks independently understandable,
  dependency-ordered, and observable.
- **Strict:** bootstrap or reconcile the project guide, architecture,
  direction, rules, templates, plan index, and session continuity. Offer
  optional files rather than silently adding unrelated configuration.

## Strict bootstrap

### Interview and evidence

Ask only questions whose answers materially affect the artifacts. Cover, as
needed: project purpose, target users, problem, outcomes, MVP scope, non-goals,
constraints, definition of done, application type, languages, frameworks,
runtime, package manager, repository layout, application boundaries, data flow,
external services, persistence, authentication, authorization, security,
privacy, browser/platform support, accessibility, performance, availability,
testing, linting, formatting, type checking, CI, deployment, observability,
environments, local emulation gaps, documentation, license, architecture
decisions, and environment isolation.

Record confirmed requirements separately from research suggestions,
assumptions, recommendations, and unresolved questions. Never fill unknowns
with guesses.

### Files and approval

1. Inspect the exact target and list existing project-control files. Do not run
   Git mutations or write files before the relevant gate is approved.
2. Propose the files to create or merge and show the compatibility impact.
3. Obtain approval for the proposed write before creating or changing files.
4. Preserve existing structure; never overwrite a document merely because the
   bundled template is newer.
5. Offer optional README, ignore rules, license, editor settings, or CI files
   separately when they are outside the standard bundled scaffold; do not
   silently add them.
6. Do not scaffold application code, dependencies, deployment, or a remote
   repository implicitly.

The bundled script is the approved full documentation scaffold: it copies the
bundled README, the `.gitignore.template` source as `.gitignore`, `AGENTS.md`,
`SESSION_STATE.md`, architecture/rule files, and document templates, then
creates the empty `docs/specs/`, `docs/plans/`, and `docs/reviews/`
directories. If the user approves only a subset, do not run the full script;
copy only the approved templates through the same copy-if-missing rules.

For a new scaffold, the normal layout is:

```text
MASTER_PLAN.md                    product direction and roadmap
README.md                         repository overview
AGENTS.md                         operating instructions
SESSION_STATE.md                  current handoff state
docs/PROJECT_ARCHITECTURE.md      detailed current architecture
docs/rules/                       permanent engineering rules
docs/specs/                       feature behavior documents
docs/plans/                       implementation plans
docs/plans/INDEX.md               concise plan index
docs/reviews/                     persisted review findings when useful
```

If the repository already uses `PROJECT_ARCHITECTURE.md`, `PLANS.md`,
`plans/`, or another equivalent layout, preserve it and adapt the templates
instead of creating a second source of truth.

## Maintain project documents

- Keep `MASTER_PLAN.md` at product direction and feature-roadmap level.
- Keep `README.md` high-level; it should not duplicate the roadmap or detailed
  architecture.
- Keep `AGENTS.md` operational: source layout, commands, validation, generated
  files, security boundaries, local-development rules, and approval gates.
- Keep `docs/PROJECT_ARCHITECTURE.md` current and architectural, not a task log.
- Keep `docs/rules/` permanent and scoped; route only relevant rules to a task.
- Keep `SESSION_STATE.md` short-term and current, not a changelog or transcript.

Keep the selected plan index concise. For the bundled scaffold, use
`docs/plans/INDEX.md` and link each row to the corresponding
`docs/plans/PLAN-NNNN.md`. For an existing repository, preserve its established
`PLANS.md`/`plans/` layout and adapt the templates instead of creating a
second index.

## Create or revise a plan

1. Confirm the selected SPEC, architecture context, relevant rules, and open
   decisions. Use `repository-research` for existing behavior and
   `technical-design` for unresolved architecture or interface decisions when
   available.
2. Allocate one greater than the highest existing plan ID, starting at
   `PLAN-0001`; never reuse or renumber IDs.
3. Use a detailed plan with `Type` of `Feature`, `Bug`, or `Improvement`, and
   `Status` of `Proposed`, `Approved`, `In Progress`, `Blocked`, `Completed`,
   or `Cancelled`. New plans start as `Proposed`.
4. Preserve accepted decisions and user structure when revising. Keep
   confirmed requirements, suggestions, assumptions, recommendations, and
   unresolved approval gates distinct.
5. Make tasks independently understandable, dependency-ordered, and
   observable. For behavior with a runnable test seam, order Red, Green, and
   Refactor tasks. For configuration, documentation, generated, exploratory,
   or testless work, record the TDD exception and alternative evidence.
6. Update the plan index and `Updated` field only when content changes. Do not
   mark the plan `Approved`; the user must set that status manually.
7. Stop after reporting the changed artifact, decisions, validation, and next
   user action. Do not implement plan tasks here.

Use `spec-review` for requirements review, `plan-review` for one-plan review,
`plan-consistency-review` for cross-artifact traceability, and
`schema-design`/`technical-design` for data or architecture decisions when
available. If a named companion is unavailable, keep the equivalent review or
decision evidence in the project-control artifacts and report the manual
handoff.

Use browser interaction only for a separately approved, unauthenticated local
exploratory check. It is not a durable browser-test strategy; route durable
coverage to `webapp-testing`.

## Approved branch and issue preparation

Only when the user asks to begin approved work and the exact selected plan says
`**Status:** Approved`:

1. Verify the base branch exists, the target branch does not, and the worktree
   state is understood. Require a clean worktree or explicit direction for
   existing changes. Ask whether to use the current branch, a plan branch, a
   selected-task branch, or leave branch setup unchanged.
2. Use the configured development branch as the base and verify the target
   name does not already exist. Suggested names are
   `feature/plan-0001-short-title`, `bugfix/plan-0002-short-title`,
   `improvement/plan-0003-short-title`, or the equivalent selected-task form.
3. Show the exact branch operation and obtain approval for that operation. Do
   not fetch automatically. Update the plan and selected index only after
   successful approved creation.
4. For issues, verify authentication, repository targeting, and duplicates;
   draft every title, body, label, relationship, and backlink, then obtain
   approval before creating only the selected issues.
5. Keep local plans authoritative and record resulting links only after a
   successful approved operation.

Never push, force-push, create a remote repository, alter the remote default,
deploy, publish, or perform production operations in this workflow.

If Git is absent during a strict bootstrap, ask separately before `git init`.
If Git is unborn on an unexpected branch, ask before renaming it. Never alter
an established repository's default branch implicitly. After approved
documentation writes, show the complete initial diff and ask separately before
an initial commit; do not create follow-up branches or commits implicitly.

## Session continuity

For strict work or meaningful planning changes, update the project-root
`SESSION_STATE.md` with the plan ID/status, branch and environment decisions,
completed work, validation, blockers, open questions, untested paths, and the
next exact action. The strict bootstrap creates `AGENTS.md` and
`SESSION_STATE.md` from the bundled templates. Keep `SESSION_STATE.md` ignored
by Git and do not commit it unless separately approved.

## Validation and stop

Check document links, unique plan/task IDs, allowed statuses, index-to-plan
consistency, branch references, and issue links where applicable. Run the
narrowest relevant parser or document check, then `git diff --check` and a
complete diff review. Report structural validation separately from runtime,
browser, provider, deployment, or external-service behavior not exercised.
Stop after the requested planning or setup preparation; do not implement,
commit, push, deploy, publish, or start another plan task.
