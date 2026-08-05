---
description: Implement, validate, and review only the next unchecked task in one explicitly approved plan.
agent: engineer
---

Run the `/implement-next` workflow for this plan identifier or path:

```text
$ARGUMENTS
```

## Preconditions

1. If no plan identifier or path is supplied, request one and stop. Do not select
   a plan from repository files or conversation context.
2. Read applicable repository instructions, `SESSION_STATE.md`, the identified
   detailed plan, and its relevant code and tests.
3. Require the plan's exact status to be `Approved`. Do not change plan status
   on the user's behalf. If the plan is missing, ambiguous, not approved, has no
   unchecked task, or has unresolved blocking dependencies, report the blocker
   and stop.
4. Inspect the plan's `Acceptance Criteria`, `Validation`, task ordering, and
   `Activity` evidence for its test strategy before selecting work.
5. When a plan changes observable behavior and has a runnable automated test
   seam, require its documented `test-driven-development` contract:
   - The first unchecked behavior task must be the focused red test with its
     narrow command. Do not select an implementation task before it.
   - A green implementation task requires recorded red evidence that the focused
     test failed for the expected behavior gap. If it is absent, stop and request
     plan correction or execution of the red task.
   - A refactor task requires recorded green evidence. Do not combine Red, Green,
     and Refactor into an implementation-first task.
   - A TDD exception must be explicit in the plan and include its alternative
     verification. Do not infer an exception from task wording or convenience.
6. Select exactly the first dependency-ordered unchecked task in that plan. Do
   not select a task from another plan, a later task, or implied follow-up work.
7. State the selected task, acceptance criteria, affected area, planned checks,
   and any material assumption. Ask for clarification only when it changes the
   selected task or its safe implementation.

## Execution contract

- Implement only the selected task and the minimum directly required changes.
  Do not perform unrelated cleanup, dependency upgrades, architecture changes,
  or other plan tasks.
- For a selected red-test task, use `test-driven-development`: add one focused
  test, run its narrow command, confirm the expected failure, and record red
  evidence before stopping. For green or refactor tasks, preserve the same
  focused behavior seam and record the required fresh evidence.
- Preserve repository instructions and existing conventions. Do not access
  secrets, credential files, browser profiles, external directories, production
  systems, or deployment/publishing workflows.
- Run the narrowest relevant validation first, then broader checks when justified.
  If validation fails, report the failure and keep the task incomplete unless the
  user directs otherwise.
- After successful validation, update only the selected task's status and
  activity or evidence in the identified plan. Do not mark the full plan
  completed unless every task is complete and the user explicitly asks.
- Run `git diff --check` and review the complete diff. Report changed files,
  validation evidence, untested paths, assumptions, and risks.
- Stop after this task. Do not begin another task, create a branch, commit,
  push, create an issue, deploy, publish, or change remote settings unless the
  user separately requests and approves it.
