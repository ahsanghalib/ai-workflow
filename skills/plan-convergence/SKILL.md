---
name: plan-convergence
description: Compare an approved project plan and its tasks with the current repository state to identify completed, partial, missing, stale, blocked, or unplanned work. Use during or after implementation when convergence against requirements, design, tasks, and validation is requested. Report or propose work only; do not edit plans or implement fixes.
license: MIT
metadata:
  source: github/spec-kit
  compatibility: harness-neutral; uses ordinary repository Markdown artifacts
---

# Plan Convergence

Assess whether implementation has converged with an approved plan. This is a
read-only evidence and reconciliation workflow. It does not replace code
review, does not implement fixes, and does not append tasks automatically.

## Preconditions and boundaries

1. Require the exact plan path or identifier from the user. Do not select a
   plan from repository files or conversation context.
2. Read the plan's exact status. If it is not `Approved`, report that
   convergence is not authorized for execution tracking and stop after the
   available read-only comparison.
3. Read applicable `AGENTS.md`, `SESSION_STATE.md`,
   `PLANS.md`, the selected plan, its task list, and its referenced design and
   requirement artifacts.
4. Inspect safe repository state such as `git status`, the current diff, code,
   tests, schemas, and documented validation. Never read secrets or browser
   state.
5. Keep `project-init`, `technical-design`, `implement-next`, and
   `verification-before-completion` as the owners of their existing concerns.

Do not assume `.specify/`, a CLI, slash commands, a branch name, or a GitHub
integration. Do not create issues, change task status, append plans, commit,
push, deploy, or modify source code.

## Comparison workflow

### 1. Establish the baseline

Record the plan revision or baseline commit, the current revision, the plan's
acceptance criteria, dependency order, TDD requirements, migration/rollback
conditions, and required validation. If the plan does not identify a baseline,
state that limitation instead of inferring one.

### 2. Trace each task to evidence

For every task, locate current evidence in code, tests, configuration,
documentation, or activity records:

| Task          | Expected evidence                | Current evidence              | Classification                         |
| ------------- | -------------------------------- | ----------------------------- | -------------------------------------- |
| exact task ID | file, test, command, or artifact | `path:line`, diff, or missing | complete/partial/missing/stale/blocked |

Check that:

- the task's stated behavior exists and is covered by its acceptance criteria;
- a test-first task has red evidence before green implementation evidence;
- implementation follows the approved design's module and seam boundaries;
- migrations, compatibility, security, and rollback requirements have evidence;
- validation commands actually observe the claimed outcome; and
- unrelated changes are not being counted as plan completion.

### 3. Find drift and gaps

Classify discrepancies as:

- **Complete** — current evidence satisfies the task and its validation.
- **Partial** — some acceptance evidence exists but a requirement remains.
- **Missing** — no credible implementation evidence exists.
- **Stale** — the task or plan points to removed, renamed, or superseded work.
- **Blocked** — an explicit dependency, decision, environment, or approval is
  preventing completion.
- **Unplanned** — current changes are outside the selected plan's scope.

Distinguish code correctness findings from convergence gaps. Do not invent a
failure where the plan deliberately records an exception or non-goal.

### 4. Reconcile without mutation

Re-read every finding's cited evidence and remove duplicates, false positives,
and already-fixed issues. For remaining gaps, propose one of:

- a specific plan/task revision;
- a clarification or technical decision;
- a validation action; or
- no action because the difference is an accepted non-goal.

The proposal is advisory. The user or `project-init` must authorize any edit.

## Required output

Return:

```markdown
## Convergence summary

Plan: <path and status>
Baseline: <revision or unknown>
Current: <revision>
Result: Converged | Partially converged | Not converged | Blocked

## Evidence table

| #   | Classification | Severity | Task/criterion | Evidence | Gap or confirmation | Proposed next action |
| --- | -------------- | -------- | -------------- | -------- | ------------------- | -------------------- |

## Unplanned changes

- ... or none found

## Validation status

- Verified: ...
- Not run: ...
- Blocked: ...

## Required approvals

- ... or none
```

Use `Converged` only when all in-scope tasks and acceptance criteria have
current evidence and no blocking validation remains. Do not equate a clean
convergence report with a code-review approval or production readiness.

## Handoff

Hand proposed task or artifact changes to `project-init`. Hand design drift to
`technical-design`, implementation of the next approved task to
`implement-next`, and final evidence review to
`verification-before-completion`. Stop after the report.
