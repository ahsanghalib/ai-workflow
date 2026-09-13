# Review schema-design candidate

Date: 2026-09-13
Feature: schema-design

## Context

The third pending candidate was `schema-design`. No repository-root or
installed counterpart exists. It was compared with the project-init database
rules and the existing `technical-design` boundary.

## Goal

Make `schema-design` a focused, SQL/ORM-agnostic data-model design and review
gate without allowing it to become implementation, migration execution, or
general architecture work.


## Why

The candidate queue is being handled one skill at a time, preserving useful
candidate behavior while keeping project-init responsible for durable PLAN and
migration-plan authoring.

## Outcome

Hardened the candidate to require exact SPEC and schema-source selection,
report unapproved SPECs as limitations, protect secrets and unrelated history,
and distinguish design readiness from approval. Added lifecycle/data handling,
constraint/index/concurrency, compatibility, forward-only migration,
backfill/rollback, and explicit output-contract guidance.


## Current State

`schema-design` is complete in the staging folder. The queue now has five
completed candidates (`session-state`, `project-init`, `spec-review`,
`plan-review`, and `schema-design`) and three pending candidates:
`backend-feature`, `frontend-feature`, and `code-review`. No root skill was
promoted or removed.

## Important Findings

- The skill owns data-model design and review; `technical-design` owns broader
  architecture/API choices, `project-init` owns durable plan authoring, and
  `backend-feature` is downstream implementation.
- A `ready for planning` verdict is advisory and does not authorize database or
  dependent-service changes.
- The repository validator does not scan nested staging candidates directly,
  so the candidate was checked in a disposable Git fixture.

## Decisions

- Preserve the candidate's useful relational schema checklist while adding
  source-of-truth, approval, security, compatibility, and rollback gates.
- Keep the workflow read-only for repository schema and migration files; do not
  create review artifacts unless explicitly asked.
- Require classification of confirmed facts, assumptions, unresolved decisions,
  contradictions, and stale findings for reviews.

## Failed Approaches

- No candidate-specific implementation failure occurred. Existing database
  rules and technical-design boundaries were used as comparison material.

## Validation

- `bash validate-skills.sh` passed for the current checkout.
- An isolated disposable-Git validator fixture containing the candidate passed.
- Custom frontmatter and trailing-whitespace checks passed.
- `git diff --check` passed.
- Trigger and exclusion behavior was reviewed manually; no live harness
  discovery or schema-design fixture was exercised.

## Open Questions

- The eventual root promotion should add this candidate only after the full
  queue and cutover dependencies are settled.

## Next Steps

Review `backend-feature` next and keep the queue in SESSION_STATE.md current.

## Relevant Files

- `skills/new-skills-to-add/schema-design/SKILL.md` — finalized candidate.
- `skills/new-skills-to-add/project-init/templates/docs/rules/DATABASE.md` —
  database rules used for comparison.
- `skills/technical-design/SKILL.md` — broader architecture boundary.
- `SESSION_STATE.md` — persistent review queue and current handoff.
