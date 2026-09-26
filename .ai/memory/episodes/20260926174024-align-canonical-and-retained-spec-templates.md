# Align canonical and retained SPEC templates

Date: 2026-09-26
Feature: spec-workflow prompt-v3 template contract

## Context

Prompt-v3 §50 requires compact SPEC templates with a clear `# Execution`
boundary, optional context/impact sections, SPEC-local task IDs, and no PLAN
artifact requirement. Both the canonical and retained project templates are
part of that contract.

## Goal

Remove forced optional boilerplate and make both template variants test the
same required/optional boundaries.

## Why

The canonical template called `Context / Evidence` optional but included its
heading in the default skeleton. The retained template also lacked structural
tests proving optional headings were not before `# Execution`.

## Outcome

Removed the optional heading from the canonical default skeleton, clarified
that retained-template contract examples belong above `# Execution` only when
used, and added assertions for required sections, optional examples, local task
identity, and absent PLAN artifacts.

## Current State

Section 50 is complete and the worktree remains uncommitted for user review.
The next prompt-v3 section to review is §51.

## Important Findings

- Optional comments inside a default skeleton still create a visible section
  users may treat as required; the heading itself should be omitted.
- The project template is a retained resource, not bootstrap output, but its
  examples must still state where contract sections belong semantically.

## Decisions

- Keep optional sections in separate examples and validate the pre-`# Execution`
  contract region of both templates.
- Use the existing contract and traceability tests rather than adding another
  test runner.

## Failed Approaches

- No implementation approach failed. Review identified the canonical optional
  heading mismatch before the full validation pass.

## Validation

- Focused SPEC contract and project-init traceability tests — passed.
- Full contract suites, project-init tests, skill validation, Bash syntax,
  ShellCheck, Markdownlint, memory verification, and `git diff --check` —
  passed.

## Open Questions

- The templates are documentation/resources; actual user copy/adaptation is
  not exercised by a live harness.

## Next Steps

- Review prompt-v3 §51, fix concrete gaps, and rerun focused plus full checks.

## Relevant Files

- `skills/spec-workflow/references/spec-template.md` — canonical skeleton.
- `skills/project-init/templates/docs/templates/spec.md` — retained project
  starting point.
- `skills/spec-workflow/tests/test-contract.sh` — structural template checks.
- `skills/project-init/tests/test-traceability-contract.sh` — project template
  routing checks.
- `SESSION_STATE.md` — current section and validation handoff.
- `todo.md` — temporary prompt-v3 checklist.
