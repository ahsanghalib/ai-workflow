# Repair final project-init review findings

Date: 2026-09-13
Feature: project-init

## Context

The final independent read-only review of the project-init bootstrap found
twelve issues across approval scope, reconciliation layout, schema/SPEC
ordering, API contracts, shell failure propagation, filesystem safety,
portability, unusual filenames, and CI coverage.

## Goal

Repair every actionable finding without committing or performing remote Git
operations, while preserving the user's disposable implementation plan and
review ledger for later removal.


## Why

Project-init must be safe for both empty and already-started projects. Its
helpers must report reliable evidence and its Markdown workflow must not imply
that an approval or document transition happened when it did not.

## Outcome

All twelve findings were addressed. Existing-project writes now require
explicit repeatable `--only RELPATH` selections, full scaffolding is restricted
to empty or `.git`-only targets, and schema creation is a separate exact
selection after user-flow review. The SPEC lifecycle explicitly requires the
user to set Status to `Approved` and record approval evidence before PLAN
creation. Prompt/template/API pagination contracts now agree on initial-schema,
no-persistence, optional-schema, and cursor fields.

The shell helpers now capture `find` status, check `cp` failures, avoid GNU
utility `--` forms, preserve newline-containing names as escaped evidence, and
run additional failure-injection regressions. CI runs project-init shell
syntax and the disposable suite. The remaining race boundary is explicit:
static symlink checks and a post-creation recheck protect ordinary accidental
blockers, but the shell helper does not claim atomic protection from a hostile
concurrent path replacement.


## Current State

The project-init focused suite, root skill validator, Bash syntax checks,
ShellCheck, whitespace check, and retired-name scan pass. No commit, push,
branch, remote, deployment, or application-code generation was performed.
The root `SESSION_STATE.md` records the handoff. `IMPLEMENTATION_PLAN.md` and
`PROJECT_INIT_SUBAGENT_REVIEW.md` remain disposable user-owned artifacts.

## Important Findings

- A single broad initializer approval was incompatible with per-file
  reconciliation approvals; explicit selected-output mode resolves that
  boundary and avoids competing plan trees.
- `docs/DB_SCHEMA.md` is conditional and must be selected only after the
  reviewed `docs/USER_FLOW.md`; no-persistence and unresolved-schema branches
  remain explicit in prompts and templates.
- The helper evidence path must use NUL-delimited temporary lists with checked
  traversal status; newline-containing names cannot be passed through ordinary
  newline-delimited sorting.
- Review evidence is stronger when failure injection covers both traversal and
  copying, not only successful fixture runs.

## Decisions

- Use `--only RELPATH` repeatedly for approved selected outputs. A full bundle
  is new-project-only for an empty or `.git`-only target.
- Require exact `--only docs/DB_SCHEMA.md --with-schema` for the separate
  schema-copy step.
- Keep the user-owned SPEC approval transition explicit: accepted Proposed
  SPEC -> user sets `Status: Approved`, review date, and approval evidence ->
  PLAN may be created.
- Align cursor pagination on `next`, `prev`, and optional `limit` to match the
  API envelope contract.
- Document the non-hostile-directory race assumption instead of claiming
  descriptor-relative atomic guarantees that the Bash helper does not provide.

## Failed Approaches

- The first copy-failure regression used `command -v false`, which returned a
  shell builtin name and created a dangling shim; using `type -P false` made
  the failure injection real.
- The first newline assertions expected two backslashes, while the helper
  intentionally emits one escaped `\\n`; the tests were corrected to assert
  the actual one-line evidence contract.

## Validation

- `bash skills/project-init/tests/test-project-init.sh` passed, including the
  focused inspect, inventory, initializer, acceptance, and traceability tests.
- `bash -n skills/project-init/scripts/*.sh skills/project-init/tests/*.sh`
  passed.
- `shellcheck skills/project-init/scripts/*.sh skills/project-init/tests/*.sh`
  passed.
- `bash validate-skills.sh` passed.
- `git diff --check` passed.
- No live hostile-concurrency or native BSD/macOS execution was performed.

## Open Questions

- Whether a future implementation needs descriptor-relative no-follow writes
  for hostile shared directories; current project-init documents isolated
  target use as the required boundary.
- Live harness reload/discovery and user approval behavior remain environment
  checks, not shell-test claims.

## Next Steps

- User may delete the disposable implementation plan and subagent review
  ledger when satisfied.
- Do not commit this repair pass unless the user later requests a scoped
  logical commit.
- On a future handoff, read `SESSION_STATE.md` and verify the current skill
  references before relying on this historical capsule.

## Relevant Files

- `skills/project-init/scripts/init-project.sh` — selected-output mode,
  schema sequencing, failure checks, and path boundary.
- `skills/project-init/scripts/inspect-project.sh` and
  `skills/project-init/scripts/inventory-project.sh` — checked traversal and
  escaped evidence reporting.
- `skills/project-init/references/workflow.md` and
  `references/output-boundary.md` — approval and race-boundary contract.
- `skills/project-init/references/feature-lifecycle.md` — user-owned SPEC
  approval transition.
- `skills/project-init/templates/.ai/prompts/`, `templates/docs/USER_FLOW.md`,
  and `templates/docs/rules/CONTRACTS.md` — prompt and contract alignment.
- `skills/project-init/tests/` and `.github/workflows/validate.yml` —
  regression coverage and CI execution.
