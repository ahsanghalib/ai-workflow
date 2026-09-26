# Clarify conditional user-flow and architecture boundaries

Date: 2026-09-26
Feature: project-init prompt-v3 user-flow architecture contract

## Context

Prompt-v3 §53 requires user-flow and architecture documentation to remain
conditional: bootstrap must not create them, ordinary SPECs must not require
global flow context, and shared documents need demonstrated cross-feature value.

## Goal

Find and fix missing bootstrap and template-boundary coverage for user flows,
architecture documents, and ADRs.

## Why

The repository had newer lowercase conditional paths, but the bootstrap test
only rejected older uppercase paths. The shared-flow template also used
approval-gate language that could be mistaken for feature approval.

## Outcome

Bootstrap tests now reject lowercase user-flow, architecture, decisions, and
schema outputs. Traceability tests verify SPEC independence, conditional
architecture/ADR triggers, source ownership, and no separate flow approval
section. The shared-flow template now labels its review as context linkage and
explicitly keeps feature approval in the relevant SPEC.

## Current State

Section 53 is complete and the worktree remains uncommitted for user review.
The next prompt-v3 section to review is §54.

## Important Findings

- Conditional templates are resources, not bootstrap outputs, and both legacy
  and lowercase paths need negative output assertions.
- A project context document may have a review status, but that review must not
  become a second feature/SPEC approval gate.

## Decisions

- Keep ADR review language because it records a consequential decision, while
  clarify shared-flow review as linkage/context review rather than approval.
- Extend existing project-init traceability and bootstrap tests instead of
  adding a separate test runner.

## Failed Approaches

- Initial assertions used exact phrases split across wrapped Markdown lines;
  they were changed to stable fragments and case-insensitive checks where
  appropriate.

## Validation

- `bash skills/project-init/tests/test-init-project.sh` — passed.
- `bash skills/project-init/tests/test-traceability-contract.sh` — passed.
- Full contract suites, project-init tests, skill validation, Bash syntax,
  ShellCheck, targeted Markdownlint, memory verification, and
  `git diff --check` — passed.

## Open Questions

- Live conditional-document creation and user review remain untested because
  no external project or harness session is in scope.

## Next Steps

- Review prompt-v3 §54, fix concrete gaps, and rerun focused plus full checks.

## Relevant Files

- `skills/project-init/templates/docs/user-flows.md` — shared-flow review and
  SPEC approval boundary.
- `skills/project-init/tests/test-init-project.sh` — bootstrap output checks.
- `skills/project-init/tests/test-traceability-contract.sh` — conditional
  template and source-ownership checks.
- `skills/project-init/references/conditional-documents.md` — conditional
  document routing.
- `SESSION_STATE.md` — current section and validation handoff.
- `todo.md` — temporary prompt-v3 checklist.
