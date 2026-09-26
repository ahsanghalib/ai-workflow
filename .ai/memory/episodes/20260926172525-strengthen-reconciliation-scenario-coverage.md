# Strengthen reconciliation scenario coverage

Date: 2026-09-26
Feature: project-init prompt-v3 reconciliation

## Context

The public `ai-workflow` repository is being reconciled with prompt-v3.
Section 48 covers progressive project-control reconciliation as frontend,
persistence, and monorepo capabilities appear.

## Goal

Close test-coverage gaps without changing the minimal initializer's output
boundary or creating speculative project documents.

## Why

Capability signals must not create documents by themselves, while existing
controls that are already justified must remain the repository owner's source
of truth.

## Outcome

The reconciliation scenario test now preserves existing frontend rules,
database rules, schema context, and root monorepo routing. It also continues to
reject automatic schema/flow/rules output and nested instructions without a
subtree-specific need. The acceptance reference documents this evidence.

## Current State

Section 48 is complete and the worktree remains uncommitted for user review.
The next prompt-v3 section to review is §49.

## Important Findings

- The initializer intentionally creates only the minimal control scaffold;
  conditional documents remain resources and existing-project evidence.
- A useful-control test should verify preservation, not imply that a
  capability signal authorizes automatic document creation.
- Root monorepo routing can remain in one user-owned `AGENTS.md`; nested files
  are unnecessary without distinct subtree instructions.

## Decisions

- Add positive preservation fixtures alongside negative capability-signal
  assertions. This matches the prompt's "only if useful" condition without
  broadening initializer behavior.
- Keep the change in the existing reconciliation test and acceptance reference
  rather than adding a new test runner or implementation path.

## Failed Approaches

- A first edit left an assertion expecting an existing frontend rule to be
  absent; the focused test exposed the contradiction, and the assertion was
  corrected to require preservation.

## Validation

- `bash skills/project-init/tests/test-reconciliation-scenarios.sh` — passed.
- `bash skills/project-init/tests/test-project-init.sh` — passed.
- Workflow contracts, `validate-skills.sh`, Bash syntax, ShellCheck,
  Markdownlint, memory verification, and `git diff --check` — passed.

## Open Questions

- Live harness reload and runtime behavior remain outside repository-local
  structural and contract checks.

## Next Steps

- Review prompt-v3 §49, fix concrete gaps, and rerun focused plus full checks.

## Relevant Files

- `skills/project-init/tests/test-reconciliation-scenarios.sh` — scenario
  fixtures and preservation assertions.
- `skills/project-init/references/acceptance-scenarios.md` — automated-evidence
  description for conditional reconciliation.
- `SESSION_STATE.md` — current section and validation handoff.
- `todo.md` — temporary prompt-v3 checklist.
