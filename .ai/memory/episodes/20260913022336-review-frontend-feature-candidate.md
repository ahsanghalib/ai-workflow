# Review frontend-feature candidate

Date: 2026-09-13
Feature: frontend-feature

## Context

The sixth pending candidate was `frontend-feature`. No repository-root or
installed counterpart exists. It was compared with `frontend-design`,
`frontend-motion-review`, `ui-design-system`, `webapp-testing`, the frontend
rules, and the finalized backend-feature execution contract.

## Goal

Make `frontend-feature` a bounded executor for one approved frontend/web/admin
task while preserving API boundaries, user-observable behavior, accessibility,
and safe browser-test handling.


## Why

The candidate queue is reviewed one skill at a time. Frontend implementation is
downstream of approved requirements and plans and must not silently redesign
backend/domain behavior or invent a parallel UI system.

## Outcome

Hardened the candidate's preconditions, task selection, context boundaries,
implementation rules, state coverage, design routing, browser-test boundary, and
verification handoff. The lightweight exception is now limited to bounded
non-contract/non-auth/non-persistence/non-deployment work with narrow
validation.


## Current State

`frontend-feature` is complete in the staging folder. The queue now has seven
completed candidates and one pending candidate: `code-review`. No root skill was
promoted or removed.

## Important Findings

- `frontend-design` owns new page/layout/responsive/interaction/accessibility
  design briefs, `ui-design-system` owns product-wide visual systems, and
  `webapp-testing` owns repository-native browser execution.
- Client validation improves UX but server validation and authorization remain
  authoritative.
- The repository validator does not scan nested staging candidates directly,
  so the candidate was checked in a disposable Git fixture.

## Decisions

- Require an existing or explicitly mocked backend/shared contract and route a
  missing dependency to the backend/API workflow.
- Require loading, success, empty, error, permission, disabled, and retry
  states where applicable, plus duplicate-submission protection.
- Keep browser checks isolated to approved localhost workflows; never access
  persistent profiles, remote sites, or browser secrets.
- Preserve first-task TDD sequencing through `implement-next` and hand
  substantial completed work to `code-review`.

## Failed Approaches

- No candidate-specific implementation failure occurred. Existing frontend,
  design, motion, UI-system, and browser-test contracts were used as comparison
  material without changing application code.

## Validation

- `bash validate-skills.sh` passed for the current checkout.
- An isolated disposable-Git validator fixture containing the candidate passed.
- Custom frontmatter and trailing-whitespace checks passed.
- `git diff --check` and an untracked-file whitespace check passed.
- Trigger and exclusion behavior was reviewed manually; no live frontend
  implementation, browser session, or harness discovery was exercised.

## Open Questions

- The eventual root promotion should add this candidate only after the final
  `code-review` review and full cutover dependencies are settled.

## Next Steps

Review `code-review` next and keep the queue in SESSION_STATE.md current.

## Relevant Files

- `skills/new-skills-to-add/frontend-feature/SKILL.md` — finalized candidate.
- `skills/frontend-design/SKILL.md` — page-specific design boundary.
- `skills/frontend-motion-review/SKILL.md` — motion-specific boundary.
- `skills/webapp-testing/SKILL.md` — browser-test approval and evidence
  contract.
- `skills/new-skills-to-add/project-init/templates/docs/rules/FRONTEND.md` —
  frontend implementation rules used for comparison.
- `SESSION_STATE.md` — persistent review queue and current handoff.
