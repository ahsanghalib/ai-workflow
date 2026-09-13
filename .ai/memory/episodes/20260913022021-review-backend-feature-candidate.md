# Review backend-feature candidate

Date: 2026-09-13
Feature: backend-feature

## Context

The fourth pending candidate was `backend-feature`. No repository-root or
installed counterpart exists. It was compared with `implement-next`,
`test-driven-development`, project-init, and the bundled backend/security/API
rules.

## Goal

Make `backend-feature` a bounded executor for one approved backend task while
preserving plan ownership, TDD sequencing, server-side security, and safe
handoff to code review.


## Why

The candidate queue is reviewed one skill at a time. Backend implementation is
downstream of approved requirements, plans, and schema decisions and must not
silently expand into frontend, architecture, or deployment work.

## Outcome

Hardened the candidate's preconditions, task selection, context boundaries,
implementation rules, and verification handoff. The trivial-fix exception is
now limited to bounded non-schema/non-API/non-auth/security/deployment work
with narrow validation. The skill also requires exact plan/task selection,
server-side input and authorization checks, generated-file protection, and no
remote operations.


## Current State

`backend-feature` is complete in the staging folder. The queue now has six
completed candidates (`session-state`, `project-init`, `spec-review`,
`plan-review`, `schema-design`, and `backend-feature`) and two pending
candidates: `frontend-feature` and `code-review`. No root skill was promoted or
removed.

## Important Findings

- `implement-next` remains the owner of selecting the first eligible task and
  enforcing its Red/Green/Refactor evidence when available.
- `backend-feature` should not infer plan approval from a user request; the
  exact plan and SPEC gates remain required for substantial work.
- The repository validator does not scan nested staging candidates directly,
  so the candidate was checked in a disposable Git fixture.

## Decisions

- Preserve the candidate's downstream implementation role and route plan
  authoring to `project-init`, test sequencing to `test-driven-development`,
  unexplained failures to `systematic-debugging`, and completed substantial
  work to `code-review`.
- Keep trivial/localized work explicitly bounded instead of allowing it to
  bypass security, data, API, or deployment controls.
- Keep branch, issue, remote, push, deploy, publish, and production operations
  outside this skill.

## Failed Approaches

- No candidate-specific implementation failure occurred. Existing execution,
  TDD, and repository rules were used as comparison material without changing
  application code.

## Validation

- `bash validate-skills.sh` passed for the current checkout.
- An isolated disposable-Git validator fixture containing the candidate passed.
- Custom frontmatter and trailing-whitespace checks passed.
- `git diff --check` and an untracked-file whitespace check passed.
- Trigger and exclusion behavior was reviewed manually; no live backend
  implementation, test loop, or harness discovery was exercised.

## Open Questions

- The eventual root promotion should add this candidate only after the full
  review queue and cutover dependencies are settled.

## Next Steps

Review `frontend-feature` next and keep the queue in SESSION_STATE.md current.

## Relevant Files

- `skills/new-skills-to-add/backend-feature/SKILL.md` — finalized candidate.
- `skills/implement-next/SKILL.md` — first-task selection and TDD gate.
- `skills/test-driven-development/SKILL.md` — red/green/refactor contract.
- `skills/new-skills-to-add/project-init/templates/docs/rules/BACKEND.md` —
  backend implementation rules used for comparison.
- `SESSION_STATE.md` — persistent review queue and current handoff.
