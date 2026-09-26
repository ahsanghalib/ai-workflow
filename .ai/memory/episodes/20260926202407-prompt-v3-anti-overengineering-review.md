# Prompt v3 anti-overengineering review

Date: 2026-09-26
Feature: project-init anti-overengineering

## Context

Prompt-v3 §63 prohibits speculative infrastructure and duplicate project
state: metadata registries/databases, global SPEC indexes, replacement plans,
mandatory services or stacks, blanket design gates, fabricated state, and
unnecessary deletion of useful legacy artifacts.

## Goal

Check the current project-init output, workflow references, tests, templates,
and documentation for those constraints and close any enforceability gaps.

## Why

The refactor is meant to simplify project control. New machinery or mandatory
dependencies would recreate the planning burden it is removing.

## Outcome

Added an anti-overengineering guardrails section to the existing project-init
workflow reference and regression assertions to the safeguards contract test.
The rules cover registries, duplicate state, mandatory GitHub/external services,
stack assumptions, speculative rules/nested instructions/architecture,
blanket schema or technical-design approval, fabricated state, and legacy
preservation. Added §63 tracking and session handoff updates. No new registry,
database, plan artifact, external service, or remote mutation was introduced.

## Current State

Section 63 is complete and the worktree remains intentionally uncommitted.
Section 64 is the next review target. Temporary `prompt-v3.md` and `todo.md`
remain untracked by design.

## Important Findings

- Existing output-boundary and README guidance already prohibited many
  speculative outputs, but the full anti-overengineering rule was not stated
  in the authoritative project-init workflow reference.
- The first focused run exposed only an assertion wording mismatch around
  “technical-design approval”; the reference wording was correct and the test
  was aligned to it.

## Decisions

- Extend the existing workflow reference and safeguards contract instead of
  creating a new anti-overengineering document or metadata registry.
- Keep agent-memory's derived local SQLite index out of this rule: it is an
  existing bounded runtime support index, not SPEC metadata or project state.

## Failed Approaches

- The initial focused assertion expected `blanket technical-design`, while the
  authoritative sentence uses `blanket schema or technical-design approval`.
  The assertion was corrected; no runtime rule was weakened.

## Validation

- `bash skills/project-init/tests/test-safeguards-contract.sh` — passed after
  the wording correction.
- `bash skills/project-init/tests/test-project-init.sh` — passed, including
  project-init child contracts.
- Full suite, structural checks, Markdownlint, memory verification, and diff
  checks remain part of the final post-edit pass.

## Open Questions

- None for §63. The next section defines the artifact decision rule.

## Next Steps

- Review prompt-v3 §64, check artifact-creation decisions against existing
  sources of truth, and run focused/full validation after any edits.

## Relevant Files

- `skills/project-init/references/workflow.md` — anti-overengineering rules.
- `skills/project-init/tests/test-safeguards-contract.sh` — regression checks.
- `todo.md` — §35 tracking checklist.
- `SESSION_STATE.md` — current handoff and next section.
