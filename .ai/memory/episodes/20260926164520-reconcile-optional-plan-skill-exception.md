# Reconcile optional plan skill exception

Date: 2026-09-26
Feature: project-init prompt-v3 reconciliation

## Context

Prompt-v3 section 43 permits optional PLAN skills, while the user explicitly
chose a no-legacy workflow and the repository had already retired those
entrypoints.

## Goal

Reconcile the section without restoring plan skills, and close any gap in the
repository checks that could allow an active skill to route to them.

## Why

Optional compatibility is not useful for this repository when the user has
explicitly excluded legacy planning; active references would still create a
hidden alternate lifecycle.

## Outcome

Kept `plan-review`, `plan-consistency-review`, and `plan-convergence` absent.
Extended the current skill audit to scan every present `SKILL.md` entrypoint
and reject references to those retired routes. Updated session continuity and
the temporary TODO with the explicit decision and evidence.

## Current State

Section 43 is complete and section 44 is the next review target. No commit was
created.

## Important Findings

- The prompt's optional PLAN allowance does not override the user's explicit
  no-legacy decision for this repository.
- Checking only required skill names was weaker than scanning all present skill
  entrypoints for references to retired PLAN routes.

## Decisions

- Preserve the user-directed no-plan workflow; do not resurrect optional PLAN
  skills merely because prompt-v3 describes them as permissible.
- Treat absence of retired entrypoints and absence of active routes to them as
  the repository contract.

## Failed Approaches

- No implementation approach failed. The initial audit gap was limited to
  checking retired entrypoint absence without checking active entrypoint
  references; the audit was strengthened in place.

## Validation

- Passed the skill audit, project-init aggregate suite, cross-skill contract,
  `validate-skills.sh`, Bash syntax, ShellCheck, Markdownlint, and
  `git diff --check`.
- Live harness discovery/reload and external PLAN compatibility behavior were
  not exercised; this repository intentionally has no active PLAN path.

## Open Questions

- None for the user-directed no-plan workflow. Prompt-v3 §44 remains to be
  reviewed for stale-reference classification.

## Next Steps

- Review §44 and classify or fix remaining stale references without widening
  the active workflow.

## Relevant Files

- `skills/project-init/tests/test-skill-audit.sh`
- `SESSION_STATE.md`
- `todo.md`
