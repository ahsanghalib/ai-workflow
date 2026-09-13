# Review spec-review candidate

Date: 2026-09-13
Feature: spec-review

## Context

The first pending skill candidate after `session-state` and `project-init` was
`spec-review`. No repository-root or installed counterpart exists, so the
candidate was reviewed against the project-init SPEC template and adjacent
product-discovery and technical-design boundaries.

## Goal

Make `spec-review` a focused, harness-neutral reviewer for one user-authored
feature SPEC without allowing it to become product discovery, technical
design, planning, or implementation.


## Why

The review queue is being handled one candidate at a time, with the best
existing and new behavior preserved and progress tracked in SESSION_STATE.md.

## Outcome

Hardened the candidate's inputs, workflow, checklist, output contract, and
explicit edit path. It now requires actor/permission and behavior-to-acceptance
tracing, records evidence and unchecked areas, distinguishes a ready verdict
from approval, and verifies structure, terminology, coverage, references, and
implementation leakage after an approved edit.


## Current State

`spec-review` is complete in the staging folder. The queue has five remaining
candidates: `plan-review`, `schema-design`, `backend-feature`,
`frontend-feature`, and `code-review`. No root skill was promoted or removed.

## Important Findings

- The project-init SPEC template defines the core fields that the reviewer
  should cover: actors/permissions, behavior, invariants, validation, states,
  failures, edge cases, security/tenant boundaries, compatibility, and
  acceptance criteria.
- `ready` means sufficiently specified for planning; it does not authorize
  implementation or approve the product decision.
- The repository validator does not scan nested staging candidates directly,
  so an isolated disposable Git fixture is required to validate this candidate.

## Decisions

- Keep the default output read-only and in chat; create review artifacts only
  when explicitly requested.
- Preserve the SPEC's intent and structure during an explicitly requested edit;
  never change approval/status on the user's behalf or turn the SPEC into a
  PLAN.
- Keep references to `project-init` as the planning handoff because it is the
  selected successor to `project-plan`.

## Failed Approaches

- An initial custom AWK frontmatter check used `close` as a variable name,
  conflicting with AWK's built-in function. The check was corrected with a
  `closed` variable; the candidate itself was unaffected.

## Validation

- `bash validate-skills.sh` passed for the current checkout.
- An isolated disposable-Git validator fixture containing the candidate passed.
- A custom frontmatter and trailing-whitespace check passed.
- `git diff --check` passed.
- Trigger and exclusion behavior was reviewed manually; no live harness
  discovery or document-edit fixture was exercised.

## Open Questions

- The eventual root promotion should add this candidate with the other selected
  skills; no root `spec-review` currently exists.

## Next Steps

Review `plan-review` next, then continue the queue in SESSION_STATE.md without
  reviewing multiple candidates in the same pass.

## Relevant Files

- `skills/new-skills-to-add/spec-review/SKILL.md` — finalized candidate.
- `skills/new-skills-to-add/project-init/templates/docs/templates/SPEC.md` —
  SPEC contract used for coverage comparison.
- `SESSION_STATE.md` — persistent review queue and current handoff.
