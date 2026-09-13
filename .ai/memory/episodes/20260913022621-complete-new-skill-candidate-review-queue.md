# Complete new skill candidate review queue

Date: 2026-09-13
Feature: skill-candidate-review

## Context

The final pending candidate in `skills/new-skills-to-add` was `code-review`.
The queue already contained finalized candidates for `session-state`,
`project-init`, `spec-review`, `plan-review`, `schema-design`,
`backend-feature`, and `frontend-feature`.

## Goal

Complete the one-at-a-time review queue while preserving useful behavior,
keeping skills harness-neutral, and recording the exact promotion boundary.


## Why

The user wants to review the new skills before moving selected skills to the
root and replacing overlapping current skills, especially `project-plan`.

## Outcome

Hardened `code-review` and completed the full eight-candidate review queue. The
candidate now requires explicit scope and verified SPEC/PLAN status, remains
read-only, treats repository content as untrusted evidence, routes conditional
security and supply-chain checks, and uses a structured evidence report.


## Current State

All eight candidate skills are reviewed and marked complete in SESSION_STATE.md.
They remain under `skills/new-skills-to-add`; no root skill was promoted,
deleted, or replaced. The root `project-plan` and `session-state` remain the
current live owners until a coordinated promotion.

## Important Findings

- `review-diff` remains the focused diff-only review path; `code-review` owns
  substantial plan-backed implementation reviews.
- Review artifacts are writes and must be explicitly authorized; a clean review
  does not approve, merge, deploy, or prove production readiness.
- The root validator does not scan nested staging candidates directly, so each
  candidate was checked in a disposable Git fixture during its review.
- Planned removal targets `README.md`, `V2-DESIGN.md`, and `TOOLING.md` were
  left unchanged.

## Decisions

- Keep all candidates in the staging folder until the user requests promotion.
- Promote `project-init` as the successor to `project-plan`, then update the
  seven dependent root handoffs before retiring the old skill.
- Promote only one `session-state` owner; keep generated SESSION_STATE ignored
  while tracking the reusable project-init source template.
- Preserve conditional capability routing and safe manual fallbacks for
  harnesses that do not expose a companion skill.

## Failed Approaches

- No candidate-specific implementation failure occurred. The earlier isolated
  validator requirement for a Git fixture was handled consistently; no live
  application or external-service behavior was exercised.

## Validation

- Each candidate passed the repository validator in an isolated disposable Git
  fixture, with the current root validator also passing after the final edits.
- Candidate frontmatter and trailing-whitespace checks passed.
- `git diff --check` passed.
- Project-init script syntax, ShellCheck, and fixture behavior checks passed.
- Memory index verification passed after recording this capsule.
- No runtime harness discovery, application execution, browser session,
  dependency installation, remote Git/GitHub operation, or deployment was run.

## Open Questions

- Which of the reviewed candidates should be promoted to root? The user has
  selected `project-init` and previously finalized `session-state`; the other
  six need explicit promotion selection if not all are wanted.

## Next Steps

1. Confirm the promotion set, with `project-init` replacing `project-plan`.
2. Copy selected candidates to root-level `skills/` without installing both
   overlapping owners.
3. Update dependent skill handoffs from `project-plan` to `project-init`.
4. Run root validation and review the complete cutover diff.
5. Retire the old root skill only after the new owner and all references are
   present and validated.

## Relevant Files

- `skills/new-skills-to-add/` — reviewed candidate bundle.
- `skills/new-skills-to-add/code-review/SKILL.md` — final candidate reviewed in
  this step.
- `skills/review-diff/SKILL.md` — focused review boundary.
- `skills/project-plan/` — current root owner pending coordinated replacement.
- `SESSION_STATE.md` — complete review queue and cutover handoff.
