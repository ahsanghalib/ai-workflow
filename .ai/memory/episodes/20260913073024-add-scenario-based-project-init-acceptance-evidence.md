# Add scenario-based project-init acceptance evidence

Date: 2026-09-13
Feature: project-init

## Context

The workflow had safety rules and disposable helper tests, but its
conversational acceptance criteria were spread across several documents.

## Goal

Complete TASK-0048 by defining and testing acceptance scenarios for the conversational bootstrap and reconciliation workflow.

## Why

Scenario-based evidence makes the approval boundary and the difference between
automated structural evidence and live harness behavior explicit.

## Outcome

Added acceptance-scenarios.md and a disposable test covering no-write inspection, target reporting, reconciliation classification, .env exclusion, prompt routing/provenance, reload guidance, and output boundaries.

## Current State

TASK-0048 is complete. The acceptance reference and disposable test cover the
approved bootstrap/reconciliation scenarios and identify the live checks that
remain unexercised.

## Important Findings

- Read-only inspection can prove target reporting and no writes, but it cannot
  prove that a conversation actually waited for user approval.
- Prompt routing and reload guidance can be structurally checked; live skill
  discovery and fresh-session behavior remain harness-specific.

## Decisions

- Keep acceptance scenarios in a routed reference rather than hiding them only
  in test code.
- Mark automated helper assertions separately from live approval, review,
  harness, and reload checks.
- Include `.env` exclusion and the output boundary as explicit scenarios.

## Failed Approaches

- The first acceptance assertion used an inventory label that the helper does
  not emit; it was corrected to assert the helper's actual `| instruction` and
  `| planning` evidence format.

## Validation

- Red -> Green: the acceptance test first failed because its reference was
  absent, then passed after the scenario document was added.
- The acceptance test, aggregate disposable suite, Bash syntax, and ShellCheck
  pass.
- Targeted Markdown lint and routed-reference validation pass.

## Open Questions

- Live conversational approval, skill discovery, and reload behavior remain
  unexercised in an installed harness.

## Next Steps

- Continue with TASK-0049: add traceability from user flow and approved schema
  into API, frontend, SPEC, and PLAN documents.

## Relevant Files

- `skills/project-init/references/acceptance-scenarios.md`
- `skills/project-init/tests/test-acceptance-scenarios.sh`
- `skills/project-init/tests/test-project-init.sh`
- `skills/project-init/SKILL.md`
- `skills/project-init/references/workflow.md`
