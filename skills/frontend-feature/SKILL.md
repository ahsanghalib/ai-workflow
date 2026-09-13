---
name: frontend-feature
description: Implement one approved frontend/web/admin PLAN task for a feature using existing contracts, API conventions, shared UI, and frontend rules. Use after the backend/API contract is known or intentionally mocked by the approved task. Keep scope bounded and verify user-observable behavior. Do not redesign backend/domain behavior or create catch-all API modules.
license: MIT
compatibility: no bundled executable dependencies
---

# Frontend Feature

## Preconditions

For substantial work, require the exact approved SPEC and frontend PLAN path or
identifier, plus the first eligible PLAN task selected through `implement-next`
when that companion is available. Require a PLAN status of `Approved` and a
matching SPEC scope; never infer approval from the implementation request.

An explicitly requested trivial/localized fix may use the lightweight path only
when it is one bounded user-visible behavior or defect, does not change API
contracts, authentication/authorization, security boundaries, persistence, or
deployment behavior, and has a clear narrow validation command. If any of
those conditions is uncertain, stop and route the work through `project-init`.

## Task ownership

When the approved PLAN has ordered unchecked tasks, use `implement-next` to
select the first eligible task and preserve its red/green/refactor gates. Do
not choose a later task or implement several plan tasks in one pass. If that
companion is unavailable, require the same exact-plan, first-task, and TDD
checks directly; do not silently select a task from repository context.

## Context loading

Read only:

- root `AGENTS.md` and `SESSION_STATE.md` when present
- active SPEC and frontend PLAN
- the repository's `GENERAL.md` and `FRONTEND.md`
- the repository's `API.md`, `AUTH.md`, `CONTRACTS.md`, `UI.md`, `SECURITY.md`,
  and `TESTING.md` only when relevant

Use an available repository structural index, such as CodeGraph, for indexed
structural questions and blast radius. Use normal reads/search for docs,
configuration, and non-indexed details.

Never read secrets, credentials, private keys, browser profiles, cookies,
storage, or `.env` contents. Do not edit generated files directly; use the
documented generator or report that it is unavailable. Do not install
dependencies or tooling without approval.

## Implementation

1. Confirm the exact SPEC, PLAN, selected task, affected UI, backend/shared
   contract, current worktree state, and validation target before editing. If a
   required contract is absent and not explicitly mocked by the approved task,
   stop and route the dependency to the backend/API workflow.
2. Use feature/domain-local API modules (for example, `features/auth/api.ts`)
   rather than a catch-all endpoint or API module.
3. Prefer the narrowest state scope: local → URL → server/query cache → global store only when genuinely shared.
4. Client validation improves UX; server validation remains authoritative.
5. Represent loading, success, empty, error, permission-denied, disabled, and
   retry states where they apply; preserve user input after recoverable errors
   and guard duplicate submissions.
6. Keep authorization-sensitive data access and all authorization decisions on
   the server; never treat hidden controls or browser state as authorization.
7. Reuse shared UI primitives; keep domain workflows out of a generic shared UI
   package.
8. Use `frontend-design` for genuinely new page, layout, responsive, interaction,
   or accessibility design work, and `ui-design-system` for product-wide visual
   system changes. Do not invent a parallel design system in a feature.
9. Use `test-driven-development` for testable behavior and
   `systematic-debugging` for unexplained failures.
10. Use browser/E2E skills only when relevant, through the existing
    repository-owned workflow and separately approved isolated localhost
    execution. Do not access remote sites or persistent browser state.

Do not redesign backend/domain behavior, modify unapproved shared contracts, or
create catch-all API modules. Do not create branches or issues, change remotes,
push, deploy, publish, or run production operations as part of implementation.

## Verification

Verify user-observable behavior, typecheck/lint/tests as required, and preserve
TDD evidence or record an explicit exception with alternative verification. Use
`verification-before-completion` before claiming done. Hand off substantial
work to `code-review` when available; otherwise use the repository's existing
diff-review workflow. For browser checks, record the approved origin,
viewport/fixture scope, user-visible assertions, console/network observations,
and artifacts; do not claim untested states or cross-browser behavior. Report
the selected task, changed files, validation evidence, untested paths,
assumptions, and handoff; do not mark the whole PLAN complete from this skill.
