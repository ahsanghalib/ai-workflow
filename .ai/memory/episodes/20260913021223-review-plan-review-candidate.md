# Review plan-review candidate

Date: 2026-09-13
Feature: plan-review

## Context

The second pending skill candidate was `plan-review`. No repository-root or
installed counterpart exists. It was compared with the existing
`plan-consistency-review`, `plan-convergence`, `project-plan`, and the
finalized project-init PLAN template to keep responsibilities distinct.

## Goal

Make `plan-review` a focused, harness-neutral, read-only reviewer for one
implementation PLAN before implementation.


## Why

The candidate queue is being reviewed one skill at a time. `plan-review` must
preserve the distinction between reviewing one plan, checking cross-artifact
consistency, reconciling implementation convergence, and authoring plans.

## Outcome

Hardened the candidate to require an exact PLAN and referenced SPEC, check the
SPEC approval/status gate without approving it, protect secrets and unrelated
history, and review plan metadata, stable IDs, TDD ordering, environment
boundaries, migrations, rollback, and validation. The read-only boundary and
project-init refinement handoff remain explicit.


## Current State

`plan-review` is complete in the staging folder. The queue now has four
completed candidates (`session-state`, `project-init`, `spec-review`, and
`plan-review`) and four pending candidates: `schema-design`, `backend-feature`,
`frontend-feature`, and `code-review`. No root skill was promoted or removed.

## Important Findings

- `plan-review` owns executability and coverage of one PLAN; cross-plan
  traceability belongs to `plan-consistency-review`, and plan-to-code
  reconciliation belongs to `plan-convergence`.
- A ready verdict is advisory and does not approve the SPEC, PLAN, code, or
  implementation.
- The repository validator does not scan nested staging candidates directly,
  so the candidate was checked in a disposable Git fixture.

## Decisions

- Keep plan authoring and refinement under `project-init`; `plan-review` must
  not edit plans or create review artifacts by default.
- Require exact target selection rather than silently choosing among multiple
  plans.
- Treat an unapproved SPEC as a separately reported limitation, not as settled
  requirements.

## Failed Approaches

- No candidate-specific implementation failure occurred. The review used the
  existing project-plan workflow and adjacent read-only skills as comparison
  material rather than introducing a second planning system.

## Validation

- `bash validate-skills.sh` passed for the current checkout.
- An isolated disposable-Git validator fixture containing the candidate passed.
- Custom frontmatter and trailing-whitespace checks passed.
- `git diff --check` and an untracked-file whitespace check passed.
- Trigger and exclusion behavior was reviewed manually; no live harness
  discovery or plan-review document fixture was exercised.

## Open Questions

- The eventual root promotion should add this candidate only after the full
  review queue and cutover dependencies are settled.

## Next Steps

Review `schema-design` next and keep the queue in `SESSION_STATE.md` current.

## Relevant Files

- `skills/new-skills-to-add/plan-review/SKILL.md` — finalized candidate.
- `skills/plan-consistency-review/SKILL.md` — cross-artifact review boundary.
- `skills/plan-convergence/SKILL.md` — plan-to-code reconciliation boundary.
- `skills/new-skills-to-add/project-init/templates/docs/templates/PLAN.md` —
  PLAN metadata and section contract.
- `SESSION_STATE.md` — persistent review queue and current handoff.
