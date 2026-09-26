# Harden technical design handoff contract

Date: 2026-09-26
Feature: prompt-v3 §54 technical design

## Context

Prompt-v3 §54 required tests for technical-design handoff, approval, and
artifact boundaries. The existing skill prose covered most of the contract,
but its regression test checked only a subset of those guarantees.

## Goal

Make the §54 contract executable without changing the user-directed
no-commit workflow or the existing technical-design scope.

## Why

Without focused assertions, later edits could restore a separate design
artifact, a second approval gate, or obsolete project-init/PLAN routing while
the broader skill checks still passed.

## Outcome

Expanded the design/completion contract test to require same-SPEC `# Execution`
and `## Technical Design` recording, read-only behavior, no standalone
technical-design artifact, ordinary approval inheritance, and escalation for
contract-changing or user-owned decisions. The test also rejects
project-init/PLAN routing in technical-design.

## Current State

The §54 changes are uncommitted for user review. The technical-design skill
already satisfies the strengthened assertions; no skill prose change was
needed. The review cursor is now prompt-v3 §55.

## Important Findings

- The gap was regression coverage rather than a missing technical-design rule.
- Technical-design conclusions remain feature-local in the active SPEC, while
  durable cross-feature knowledge is only a conditional documentation
  promotion.
- Behavior-preserving design inherits the approved contract; user-owned or
  contract-changing decisions return through the SPEC workflow.

## Decisions

- Keep the technical-design skill read-only and avoid creating a second design
  record by default.
- Prove the absence of project-init/PLAN routing with a negative assertion,
  while retaining only the required SPEC workflow handoff.
- Preserve all unrelated worktree changes and do not commit.

## Failed Approaches

None. The focused test passed after the assertion update.

## Validation

- Passed focused `test-design-completion-contract.sh`.
- Passed SPEC contract, lifecycle, cross-skill, and design/completion tests.
- Passed project-init traceability and disposable-suite tests.
- Passed `validate-skills.sh`, Bash syntax, ShellCheck, and `git diff --check`.
- Markdownlint and memory verification passed after this entry was filled.

## Open Questions

None for §54. Live harness discovery and runtime technical-design execution
remain outside this repository validation.

## Next Steps

- Continue with prompt-v3 §55 when the user requests the next section.

## Relevant Files

- `skills/technical-design/SKILL.md`
- `skills/spec-workflow/tests/test-design-completion-contract.sh`
- `todo.md`
- `SESSION_STATE.md`
