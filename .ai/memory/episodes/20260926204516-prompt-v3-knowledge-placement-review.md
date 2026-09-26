# Prompt v3 knowledge placement review

Date: 2026-09-26
Feature: knowledge placement and source of truth

## Context

Prompt-v3 §65 assigns each kind of knowledge to one authoritative location:
short-term session state, SPEC contract/execution, cross-feature project docs,
agent memory, or structural source code/configuration truth.

## Goal

Audit whether the repository exposes that placement map consistently and
prevents duplicate facts across project-control artifacts.

## Why

Without an explicit map, assistants may put feature behavior in permanent
rules, put temporary state in a SPEC, or duplicate executable schema facts in
Markdown documents.

## Outcome

Added a repository-wide Knowledge Placement section to `README.md` covering
temporary state, SPEC contract/execution, cross-feature rules/architecture,
agent memory, and structural truth. Added a no-duplicate-facts statement and
cross-skill regression assertions. Added §65 tracking and session handoff
updates. Existing skill-specific ownership rules remain authoritative for
their branches; no new storage system was introduced.

## Current State

Section 65 is complete and the worktree remains intentionally uncommitted.
Section 66 is the next review target. Temporary `prompt-v3.md` and `todo.md`
remain untracked by design.

## Important Findings

- Session-state, source-of-truth, conditional-document, and SPEC skills already
  encoded most placement decisions, but the repository lacked one cross-workflow
  map and regression seam.
- The agent-memory SQLite file remains a derived local index; it is not a
  replacement for semantic project truth or a new project knowledge store.

## Decisions

- Put the concise placement map in `README.md`, the repository's stable user-
  facing documentation, and assert it from the existing cross-skill test.
- Keep detailed branch behavior in the owning skills rather than duplicating
  all of their workflows in the README.

## Failed Approaches

- The first README table exceeded the repository's Markdown line-length limit;
  the long task row was shortened and its full placement statement moved into
  wrapped prose without changing the rule.

## Validation

- `bash skills/spec-workflow/tests/test-cross-skill-contract.sh` — passed.
- `markdownlint README.md todo.md` — passed.
- Full project-init/spec-workflow tests, agent-memory tests, structural checks,
  Markdownlint, memory verification, and diff checks remain part of the final
  post-edit pass.

## Open Questions

- None for §65. The next section defines the repository refactor's completion
  criteria.

## Next Steps

- Review prompt-v3 §66, compare every completion criterion with current
  contracts and evidence, and run focused/full validation after any fixes.

## Relevant Files

- `README.md` — repository-wide knowledge-placement map.
- `skills/spec-workflow/tests/test-cross-skill-contract.sh` — placement and
  no-duplication regression assertions.
- `skills/session-state/SKILL.md`, `skills/project-init/references/source-of-truth.md`,
  and `skills/project-init/references/conditional-documents.md` — branch-owned
  placement rules.
- `todo.md` — §37 tracking checklist.
- `SESSION_STATE.md` — current handoff and next section.
