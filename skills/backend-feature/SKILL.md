---
name: backend-feature
description: Implement one approved backend/API PLAN task for a feature while following its SPEC and relevant repository rules. Use after planning is approved. Keep scope bounded, use TDD for testable behavior, use an available structural index when useful, and verify before completion. Do not redesign the product or expand into frontend work unless the approved task requires a shared-contract change.
license: MIT
compatibility: repository commands determine runtime dependencies
---

# Backend Feature

## Preconditions

For substantial work, require:

- the exact approved SPEC and backend PLAN path or identifier
- the exact first eligible PLAN task, selected through `implement-next` when
  that companion is available
- a PLAN status of `Approved` and a matching SPEC scope; never infer approval
  from the user's implementation request

An explicitly requested trivial/localized fix may proceed without persistent
SPEC/PLAN files only when it is one bounded behavior or defect, does not change
schema, public API, authentication/authorization, security boundaries, or
deployment behavior, and has a clear narrow validation command. If any of those
conditions is uncertain, stop and route the work through `project-init`.

## Task ownership

When the approved PLAN has ordered unchecked tasks, use `implement-next` to
select the first eligible task and preserve its red/green/refactor gates. Do
not choose a later task or implement several plan tasks in one pass. If that
companion is unavailable, require the same exact-plan, first-task, and TDD
checks directly; do not silently select a task from repository context.

## Context loading

Read only:

- root `AGENTS.md` and `SESSION_STATE.md` when present
- active SPEC and backend PLAN
- the repository's `GENERAL.md` and `BACKEND.md`
- the repository's `DATABASE.md`, `API.md`, `AUTH.md`, `CONTRACTS.md`,
  `SECURITY.md`, and `TESTING.md` only when the change touches those areas

Use an available repository structural index, such as CodeGraph, for indexed
structural questions. Use normal reads/search for docs, configuration, and
non-indexed details.

Never read secrets, credentials, private keys, browser state, or `.env`
contents. Do not edit generated files directly; use the documented generator or
report that the generator is unavailable. Do not install dependencies or
tooling without approval.

## Implementation

1. Confirm the exact SPEC, PLAN, selected task, affected area, current worktree
   state, and validation target before editing.
2. Use `test-driven-development` for testable behavior.
3. If persistent data changes, ensure `schema-design` decisions are approved before services/routes.
4. Implement only the selected task and the smallest coherent change it needs.
5. Validate external input at the transport boundary, enforce authorization
   server-side at the resource/action scope, and keep persistence models out of
   public responses when the task crosses those boundaries.
6. Keep public API shapes in the repository's shared contracts package only
   when clients genuinely share them.
7. Keep controllers/transports thin and business rules in the proper
   application/domain layer.
8. Use `systematic-debugging` for unexplained failures instead of speculative
   fixes.
9. Do not refactor unrelated code, change generated files directly, or broaden
   the selected task when validation reveals unrelated work; report it instead.

Do not create branches or issues, change remotes, push, deploy, publish, or
run production operations as part of implementation.

## Verification

Run the narrowest relevant tests first, then required repository checks. For
behavioral changes, preserve the TDD evidence or record an explicit exception
with alternative verification. Use configured deterministic tools only when
relevant. Before claiming done, use `verification-before-completion`.

Hand off completed substantial work to `code-review` when available; otherwise
use the repository's existing diff-review workflow. Report the selected task,
changed files, validation evidence, untested paths, assumptions, and handoff;
do not mark the whole PLAN complete from this skill.
