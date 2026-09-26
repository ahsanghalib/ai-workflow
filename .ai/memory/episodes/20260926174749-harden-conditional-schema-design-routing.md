# Harden conditional schema-design routing

Date: 2026-09-26
Feature: schema-design prompt-v3 persistence contract

## Context

Prompt-v3 §52 covers conditional schema-design invocation, authoritative
executable persistence sources, approval inheritance, and risky decision
escalation. The repository already had a detailed schema-design skill and
design-completion contract test.

## Goal

Find and fix gaps in the schema-design bypass and approval boundaries without
creating schema artifacts or broadening the workflow.

## Why

Non-persistent work and obvious persistence changes should not incur heavy
design ceremony, while destructive or contract-changing decisions must return
to the approved SPEC and explicit user decision boundary.

## Outcome

Added explicit non-persistent-work bypass and explicit approval language for
risky schema decisions. Added regression checks for behavior-preserving
approval inheritance, executable schema/migration precedence, and the fact
that a schema-design handoff is not approval. Updated the checklist and session
handoff.

## Current State

Section 52 is complete and the worktree remains uncommitted for user review.
The next prompt-v3 section to review is §53.

## Important Findings

- Existing tests rejected legacy schema terminology and baseline initialization,
  but did not assert every positive routing boundary from the prompt.
- The schema skill is design-only and has no bundled runtime; static contract
  assertions are the appropriate local evidence.

## Decisions

- Keep executable schema and migrations as structural truth and Markdown as
  secondary context.
- Require explicit user approval for risky decisions while preserving the
  approved SPEC for ordinary behavior-preserving design.

## Failed Approaches

- The first test phrase crossed a Markdown line wrap and failed; it was changed
  to assert stable fragments separately without altering the policy wording.

## Validation

- `bash skills/spec-workflow/tests/test-design-completion-contract.sh` — passed.
- Full contract suites, project-init tests, skill validation, Bash syntax,
  ShellCheck, targeted Markdownlint, memory verification, and
  `git diff --check` — passed.

## Open Questions

- Live schema-design invocation and database behavior remain untested because
  the skill is read-only and no project schema is in scope.

## Next Steps

- Review prompt-v3 §53, fix concrete gaps, and rerun focused plus full checks.

## Relevant Files

- `skills/schema-design/SKILL.md` — conditional design and approval rules.
- `skills/spec-workflow/tests/test-design-completion-contract.sh` — schema,
  technical-design, and completion assertions.
- `skills/project-init/tests/test-init-project.sh` — bootstrap no-schema proof.
- `skills/project-init/templates/docs/schema/context.md` — optional context
  template and second-approval boundary.
- `SESSION_STATE.md` — current section and validation handoff.
- `todo.md` — temporary prompt-v3 checklist.
