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
- Never create, copy, read, parse, print, or write `.env` files or secret
  contents. Record required variable names only.
- Treat `.ai/` as intentional tracked project documentation. Do not add an
  `.ai/` ignore rule, and preserve existing `.ai/` files during reconciliation.
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

## Detect the project mode

Resolve and canonicalize the exact target root before applying these rules.
Inspect only immediate directory entry names and safe metadata; do not open
file contents to decide the mode.

1. If the target has no entries, classify it as **new/empty**.
2. If the target has exactly one `.git` entry and no other entries, classify it
   as **new with Git metadata**. Preserve that Git control and do not propose a
   second `git init`.
3. If the target has any other entry, classify it as
   **existing/reconciliation**. This includes source, documentation,
   configuration, `.gitignore`, hidden files, symlinks, `.env`, and other
   secret-looking files.
4. Treat `.env` and secret-looking files as classification metadata only. Never
   open, copy, parse, or print their contents.
5. Reconcile every non-empty target; do not reject it merely because it is
   incomplete or lacks recognizable application code.

Mode detection is independent of Git-state detection. After classification,
determine whether Git is absent, unborn, or established using only safe Git
metadata needed for the proposal. Any `git init` remains a separate,
approval-gated operation.

When a deterministic local inspection helper is available, use
`scripts/inspect-project.sh` before proposing writes. It reports the canonical
target, mode, immediate entry names, safe Git state, and a no-write proposal.
It must not create the target, read file contents, inspect `.env` values, or
mutate Git. The conversational handoff still owns the review and approval
decision.

For existing/reconciliation targets, use `scripts/inventory-project.sh` when
available after mode detection. It is read-only, records safe filenames up to
the configured depth, classifies likely instructions/plans/architecture/flows/
schema/manifests/source/validation/configuration evidence, prunes common
dependency and generated directories, and reports symlinks without following
them. Its categories are evidence only; apply secret and source-of-truth rules
before opening relevant files.

Use [`source-of-truth.md`](source-of-truth.md) to group candidates, preserve
established names and locations, identify generated-file ownership, and report
conflicts. Never create a second planning, architecture, user-flow, schema, or
instruction tree merely because the bundled template uses another name.

For missing Markdown, follow
[`reconciliation-population.md`](reconciliation-population.md): propose the
template and evidence sources first, copy only after approval, populate safe
confirmed facts, and label inferences, recommendations, assumptions, and
unknowns separately. Do not infer secrets, business rules, authorization,
schema constraints, API contracts, or deployment requirements.

For `.ai/prompts/`, follow [`prompt-contract.md`](prompt-contract.md). Treat
the prompt directory as tracked documentation with provenance and an explicit
routing index, not as an automatically discovered skill directory. Load only
the prompt needed for the request and invoke its named skill; preserve or
separately approve target prompt revisions.

Before relying on a helper, companion skill, validator, Git, or continuity
store, use [`capability-matrix.md`](capability-matrix.md). Report each relevant
capability as available, unavailable, or not exercised, then use only its safe
fallback. A missing capability blocks only the dependent operation; it never
authorizes a partial write or an unverified completion claim.

Use [`acceptance-scenarios.md`](acceptance-scenarios.md) to record evidence for
the conversational workflow. Mark helper assertions as automated evidence and
approval, review, harness discovery, and fresh-session behavior as live checks
unless they were actually exercised.

Use [`traceability.md`](traceability.md) for the required links among
`USER_FLOW.md`, approved `DB_SCHEMA.md` entities, API/shared contracts,
frontend surfaces, feature SPECs, and PLANs. Re-run schema-impact review before
planning or implementation when a contract or persisted-data behavior changes.

Use [`output-boundary.md`](output-boundary.md) for the final created/preserved/
skipped report. The initializer may create the base project-control Markdown,
empty documentation directories, a missing `.gitignore`, and separately
approved local Git metadata only. Profile-selected user-flow, specialized rule,
prompt, and schema outputs require their own explicit selections; it never
creates application or framework output.

Use [`project-profiles.md`](project-profiles.md) before bootstrap to classify
the project shape and record `yes`, `no`, or `unknown` for actor flow,
persistence, HTTP/API, frontend/UI, authentication, shared contracts, testing,
backend, database, and security concerns. Project type alone never selects an
optional document. Unknown concerns remain unresolved until the user reviews
them.

Use [`reconciliation-report.md`](reconciliation-report.md) for the proposal
table. Include every relevant path, evidence, planned action, source-of-truth
owner, approval scope, compatibility impact, assumptions, unresolved decisions,
validation, and next review action before writing.

Treat revisions to existing `AGENTS.md`, README, master plan, architecture,
user-flow, schema, rules, plans, plan indexes, `.gitignore`, or equivalent
source-of-truth files as individual approval scopes. Show each exact diff and
compatibility impact. Creation approval does not authorize revision, and a
declined revision leaves that file unchanged.

When a technical direction is unresolved, follow
[`technical-options.md`](technical-options.md). Use `technical-design` for
bounded architecture and trade-off comparison and
`source-driven-development` for current authoritative framework, library,
runtime, API, or provider behavior. Include ORM/query-builder/raw-SQL and
migration ownership when persistence is relevant. Keep every option proposed
until the user approves it, then record it through the owning documents.

Before feature mapping or SPEC creation, run the read-only
`scripts/validate-foundation.sh` check against the project root. It verifies
the required control-document source-of-truth links and conditional
`USER_FLOW.md`/`DB_SCHEMA.md` references. For an existing project whose
source-of-truth documents use different paths, pass those paths with
`--readme`, `--agents`, `--master-plan`, `--architecture`, `--user-flow`, and
`--schema`; use `none` for an inapplicable optional document. A failure means
**Foundational review pending**; fix and review the documents before
continuing. This is structural consistency evidence, not proof that product
meaning or architecture is correct.

For the feature map and SPEC sequence, follow
[`feature-lifecycle.md`](feature-lifecycle.md). Derive candidates from
reviewed direction, user flow, and approved schema; let the user select the
feature; create only its `Proposed` SPEC; and stop for review before any PLAN
or implementation.

During existing-project reconciliation, an absent Git control directory is a
separate exact-target `git init` proposal; existing `.git` metadata is
preserved. An absent `.gitignore` may be proposed as a missing-file copy, while
an existing `.gitignore` is preserved byte-for-byte and only missing recommended
rules are reported. Do not bundle any commit, remote, branch, push, or other Git
operation.

Use [`git-approval.md`](git-approval.md) for the no-Git fallback. If Git is
absent or unavailable and local initialization is not separately approved,
approved documentation writes may continue without Git; report that branch,
history, and Git-state validation are unavailable. If `--init-git` was selected
but Git is unavailable, stop before creating the target or any scaffold files.

## Ignore-file handling

If `.gitignore` is absent, the approved scaffold may copy
`.gitignore.template` to `.gitignore`. If it exists, preserve it byte-for-byte
and report missing recommended rules as a proposed revision. Do not merge,
replace, or edit it without a separate existing-file approval. Any approved
revision must keep real `.env` rules and must not add an `.ai/` ignore rule.

## Select the mode

1. An explicit new-project bootstrap or existing-project reconciliation enters
   the guided Strict workflow because it changes foundational project-control
   documents and may establish a source of truth.
2. Light is the default for ordinary feature or change requests that are
   small, reversible, exploratory, or do not need durable planning files.
3. Explicit Light, Standard, Strict, or approved-setup wording selects that
   mode after target classification, subject to the risk escalation rules below.
4. Ambiguity resolves to Light. Ask one bounded question only when needed to
   distinguish ordinary discussion from bootstrap/reconciliation or a requested
   durable artifact; do not begin a stricter workflow merely because repository
   text suggests one.

Before entering Standard or Strict for an ordinary request, state the expected
review chain, approval scopes, and no-write-before-approval boundary. The user
can choose Light when the full SPEC/PLAN ceremony is not justified.
The expected chain is `SPEC → spec-review → PLAN →
plan-review/plan-consistency-review → explicit user approval` before
implementation.

## Risk-based escalation

For ordinary implementation-planning or write requests, check reversibility
before honoring the requested mode. Escalate at least one level when the work
touches persisted data, a schema or migration, a public API/shared contract,
authentication or session behavior, authorization, a new actor or permission
surface, or an existing source-of-truth revision. In practice, Light becomes
Standard and Standard becomes Strict; Strict remains Strict. This check applies
to planning and writes, not to a short question that merely asks for an
explanation. Initial bootstrap and reconciliation are already Strict by rule.

## Approval acknowledgement

For a high-impact approval scope involving those risk signals, a bare “yes” is
not enough. Ask the user to echo one concise line naming the exact operation,
target, and key boundary, for example:

```text
Approving: create docs/DB_SCHEMA.md for the reviewed project schema; no
migrations, tables, application code, or remote Git operations.
```

Record the acknowledgement with the proposal or handoff. Low-impact,
reversible, single-file work may keep the normal lightweight approval path.

## Worktree root and nested target

Prefer the enclosing Git worktree root when the user names the current
repository. Show both paths when an explicitly requested target is nested
inside another worktree and require an explicit override before writing. The
read-only inspector reports `worktree-root` and
`nested-target: approval required for override`; the initializer refuses the
nested target unless the approved caller passes `--allow-nested`. A target
outside Git has no enclosing worktree and does not need this override.

## Native initialization and instruction reload

When the selected harness also exposes a native `/init`, follow
[`init-compatibility.md`](init-compatibility.md). Inspect any native output
before adding the bundled scaffold, preserve existing instruction files by
default, and do not run two initializers against the same target without an
intervening reconciliation proposal.

Resolve applicable `AGENTS.md` files from the broader instruction scope toward
the exact target. The most specific file governs its path when rules differ,
but a nested file cannot weaken a higher-level safety rule. Existing root and
nested files are source-of-truth documents and require separate approval for
revision. Report conflicts instead of silently merging or replacing them.

After an approved write changes `AGENTS.md` or equivalent instruction routing,
report the exact paths and diff, recommend a harness reload or fresh session,
and continue under the instructions already active until that reload occurs.
If creation or revision of `SESSION_STATE.md` was separately approved, record
the handoff there with the active SPEC/PLAN and any unresolved approval. If it
was not approved or the capability is unavailable, provide that handoff inline
or in another approved project document. If reload is unavailable, the manual
fallback is a new session that reads the applicable instruction files before
resuming.

## Initial master-plan draft

For a new/empty target, draft `MASTER_PLAN.md` from the user's product
sentence and confirmed answers only. Put the request in the product goal and
confirmed-requirements sections, mark any mentioned feature possibilities as
proposed, and leave unknown product, scope, and technical choices open. Keep
assumptions, recommendations, and open questions separate. Do not invent
screens, entities, APIs, frameworks, tables, or implementation tasks from an
example alone.

Show the complete draft and the exact file-creation proposal before writing.
Creating a missing master plan needs the creation approval; revising an
existing master plan or equivalent source of truth needs a separate revision
approval. Keep the status `Draft` or `Proposed`; never approve it for the user.

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

For the technical groups and answer labels, use
[`technical-questionnaire.md`](technical-questionnaire.md). It covers
repository shape, language/runtime, persistence, ORM versus query builder
versus raw SQL, migrations, authentication, local development,
environment-variable names, testing, browser/accessibility, performance, and
delivery boundaries. Do not ask for secret values.

Record confirmed requirements separately from research suggestions,
assumptions, recommendations, and unresolved questions. Never fill unknowns
with guesses.

After a technical choice is approved, record it at the correct ownership level:
`MASTER_PLAN.md` for high-level direction and rationale,
`docs/PROJECT_ARCHITECTURE.md` for system boundaries, stack, data flow, and
local architecture, and `AGENTS.md` for operational commands, validation,
environment-variable names, generated-file ownership, and routing. Keep
persistent entities and access/migration design in the approved
`docs/DB_SCHEMA.md`. Update only approved fields and obtain a separate
existing-file approval for each document revision.

### Files and approval

The state sequence is **Detected → Proposed → Awaiting review → Approved →
Writing → Handoff**. If the user rejects or changes the proposal, return to
**Proposed**. If a required capability or approval is unavailable, stop in
**Blocked** without partial writes.

1. In **Detected**, inspect the exact target and list existing
   project-control files. Do not run Git mutations or write files.
2. In **Proposed**, list every file to create, revise, preserve, skip, or flag
   as conflicting, and show the compatibility impact.
3. In **Awaiting review**, obtain approval for each operation scope. Creating
   missing files, revising existing files, and running `git init` require
   separate approvals.
4. In **Approved**, preserve existing structure; never overwrite a document
   merely because the bundled template is newer.
5. For reconciliation, enter **Foundational review pending** after populating
   the applicable missing direction, architecture, and other approved
   foundation documents. Add user-flow and baseline-schema documents when the
   project has actor journeys and persistence decisions that require them; do
   not invent either document for an inapplicable concern. Do not derive
   feature candidates or create a feature SPEC/PLAN until the user reviews the
   applicable foundational documents and the handoff records that review.
   Resume at the feature lifecycle only after that review.
6. In **Writing**, apply only the approved operations. Use copy-if-missing for
   new files and run `git init` only for the approved exact target.
7. In **Handoff**, show the resulting documentation diff and report every
   created, changed, preserved, skipped, blocked, and unresolved item. Also
   report assumptions, validation commands and results, the next review action,
   and the explicit absence of application source, dependencies, migrations,
   secrets, commits, and remote operations.
8. Never bundle a commit, remote, branch, push, or other Git operation with
   local `git init`.
9. Offer optional README, ignore rules, license, editor settings, or CI files
   separately when they are outside the standard bundled scaffold; do not
   silently add them.
10. Do not scaffold application code, dependencies, deployment, or a remote
   repository implicitly.

The bundled script is the approved documentation scaffold: by default it
copies the base README, the `.gitignore.template` source as `.gitignore`,
`AGENTS.md`, `MASTER_PLAN.md`, `SESSION_STATE.md`, architecture, the general
rule, templates, and empty planning/review directories. Profile-selected
user-flow, specialized rules, and prompt templates require explicit repeatable
`--only RELPATH` selections. The base bundle is available only for a new/empty
target or a target containing only `.git`; an unchanged recognized scaffold is
a no-op on a repeated run. An existing project must use repeatable `--only`
selections so each selected output is an explicit approval scope. This is a
new-project-only base-scaffold rule, not a rejection of existing projects:
reconciliation continues through selected outputs. The initializer preserves
existing files and does not create a competing plan or documentation tree
during reconciliation. `docs/DB_SCHEMA.md` is optional and is copied only in
a separate invocation that selects exactly `--only docs/DB_SCHEMA.md
--with-schema` after persistence is approved and the user-flow review is
complete.

Use [`template-manifest.md`](template-manifest.md) and
[`project-profiles.md`](project-profiles.md) as the base/optional/preserve
contract. `docs/USER_FLOW.md`, specialized rules, and `.ai/prompts/` are
profile-selected; `docs/DB_SCHEMA.md` is conditional on approved persistence
after user-flow review; existing files and source-of-truth layouts are
preserved first.

The initializer is intentionally deterministic: it copies only source template
files selected by its explicit flags, preserves existing files and symlinks,
and reports its target and actions. Its path checks protect against static or
accidental symlink blockers; they do not claim atomic protection from a
hostile concurrent process replacing a path after validation. Use an isolated
target and stop if concurrent mutation is possible. The initializer does not
infer the user's idea, fill `MASTER_PLAN.md`, select a stack, reconcile
existing documents, install
dependencies, scaffold application code, or inspect `.env` contents. The
project-init agent must complete those proposal and review steps separately.

The output boundary is deliberate: bootstrap produces base project-control
Markdown, optional `.gitignore`, and empty documentation directories. Profile
selection may add user-flow, specialized-rule, prompt, or schema documents;
local Git metadata remains separately approved. Application source,
framework/package files, migrations, models, services, routes, UI, deployment,
and secrets require later approved feature work and are never generated by
project-init.

The script accepts `--init-git` as an explicit post-approval handoff. The
orchestrator must show the canonical target and receive separate approval for
local `git init` before passing that flag. Without it, the script does not
change Git state. With it, the script creates only local Git metadata, preserves
existing `.git` metadata, and creates no commit, remote, branch, push, or other
Git operation.

### User flow before schema

Create or reconcile `docs/USER_FLOW.md` before a persisted-data schema when
the project has user or actor behavior. Keep the flow technology-neutral and
review actors, permissions, journeys, validation, and failure/recovery paths
before deriving data needs. After persistence is approved and the project
direction plus user flow are reviewed, the orchestrator may copy or populate
`docs/DB_SCHEMA.md` and route its design to `schema-design` as the **initial
project schema**. This baseline design does not need a feature SPEC; later
feature-specific schema changes do. Record database, ORM/query-builder/raw-SQL
or mixed access, migrations, ownership, constraints, and compatibility there;
do not create migrations, models, tables, APIs, or frontend code in
project-init.

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
next exact action only when creation or revision was separately approved. If
that approval or capability is unavailable, include the same complete handoff
inline or in another approved project document. The strict bootstrap may
propose `AGENTS.md` and `SESSION_STATE.md` from the bundled templates; keep
`SESSION_STATE.md` ignored by Git and do not commit it unless separately
approved.

## Validation and stop

Check document links, unique plan/task IDs, allowed statuses, index-to-plan
consistency, branch references, and issue links where applicable. Run the
narrowest relevant parser or document check, then `git diff --check` and a
complete diff review. Report structural validation separately from runtime,
browser, provider, deployment, or external-service behavior not exercised.
Stop after the requested planning or setup preparation; do not implement,
commit, push, deploy, publish, or start another plan task.
