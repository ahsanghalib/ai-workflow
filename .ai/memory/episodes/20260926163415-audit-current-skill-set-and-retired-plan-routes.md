# Audit current skill set and retired PLAN routes

Date: 2026-09-26
Feature: project-init prompt-v3 reconciliation

## Context

Prompt-v3 section 41 required inspection of the minimum project-control and
implementation skill set plus any skills referencing planning, SPEC state,
schema approval, user flows, task execution, or completion lifecycle. The
repository had already removed the dedicated PLAN-review skills.

## Goal

Audit the current entrypoints and ensure the retired PLAN lifecycle cannot be
silently restored or referenced as an active approval workflow.

## Why

The new SPEC lifecycle depends on clear cross-skill ownership while preserving
generic research/design language that is not itself a legacy PLAN artifact.

## Outcome

Inspected all §41 required skill entrypoints and related references. No active
skill retained the old PLAN approval routes; generic planning language in
repository research and design skills remains scoped to research/design rather
than a separate project PLAN. Added
`skills/project-init/tests/test-skill-audit.sh`, which requires the current
entrypoints, confirms the three retired PLAN entrypoints are absent, and rejects
stale PLAN verdict/routing phrases. Included it in the project-init suite.

## Current State

Section 41 is complete and the worktree remains intentionally uncommitted.
Prompt-v3 section 42 is the next review target.

## Important Findings

- Deleted Git-tracked skill files can leave empty directories in the working
  tree; absence of `SKILL.md`, not directory absence, is the correct retirement
  invariant.
- Generic terms such as “planning implications” in repository research do not
  create a PLAN lifecycle when the skill explicitly hands durable work to
  `spec-workflow`.

## Decisions

- Do not restore `plan-review`, `plan-consistency-review`, or
  `plan-convergence`; §41's names are audit targets from the historical prompt,
  not current skill requirements.
- Add a small structural audit rather than deleting acceptable generic research
  and design terminology.

## Failed Approaches

- The first audit checked retired directories and failed because deleted Git
  files left empty directories. It was corrected to check for retired
  `SKILL.md` entrypoints.

## Validation

- Passed the new §41 skill audit and aggregate project-init suite.
- Passed all SPEC lifecycle, cross-skill, design-completion, project-init, and
  traceability suites, plus `validate-skills.sh`.
- Passed Markdownlint, Bash syntax, ShellCheck, and `git diff --check`.
- Live harness reload and skill-trigger behavior were not exercised.

## Open Questions

- None for section 41.

## Next Steps

1. Review prompt-v3 section 42 and fix concrete gaps in place.
2. Keep temporary `prompt-v3.md` and `todo.md` uncommitted.

## Relevant Files

- `skills/project-init/tests/test-skill-audit.sh` — §41 audit.
- `skills/project-init/tests/test-project-init.sh` — aggregate invocation.
- `skills/repository-research/SKILL.md` — inspected generic research routing.
- `skills/spec-workflow/SKILL.md` — current SPEC lifecycle owner.
- `SESSION_STATE.md` — current handoff state (ignored).
