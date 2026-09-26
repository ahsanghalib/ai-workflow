# Harden optional GitHub tracking contracts

Date: 2026-09-26
Feature: prompt-v3 §56 GitHub tests

## Context

Prompt-v3 §56 required contract-level GitHub tests without live credentials.
The repository already had optional tracking guidance and several static
assertions, but some requirements were not explicitly protected by tests.

## Goal

Close the GitHub contract-test gaps while preserving local-only SPEC work and
the no-remote-mutation boundary.

## Why

Unasserted wording could drift toward mandatory GitHub tracking, fabricated
Project or PR references, or remote commands in the core test suite.

## Outcome

Clarified that the local workflow and core contract tests work without live
credentials. Added assertions for GitHub optionality, requirements ownership,
verified capability and user authorization, Project/PR/status anti-fabrication,
and a negative scan for live GitHub or remote-mutation commands in core tests.
Issue zero/one/multiple mapping and Project dashboard boundaries remain
covered by the existing reference checks.

## Current State

The §56 changes remain uncommitted for user review. The review cursor is now
prompt-v3 §57, and no remote service or credential was accessed.

## Important Findings

- GitHub tracking is documentation/contract-only in this repository; no
  production GitHub adapter is exercised by the core suite.
- The SPEC remains the requirements, acceptance, status, approval, and
  completion source of truth.
- Missing capability or authorization leaves tracking unset rather than
  generating placeholder remote references.

## Decisions

- Keep the existing harness-agnostic reference as the authority and strengthen
  its exact testable wording instead of adding a provider-specific adapter.
- Scan core test files for GitHub CLI, credential, network, and remote Git
  mutation commands without requiring live authentication.
- Preserve all unrelated worktree changes and do not commit.

## Failed Approaches

The first focused run exposed a brittle exact-phrase assertion after the
reference sentence was clarified. The test now checks the independent contract
fragments and passes.

## Validation

- Passed `test-contract.sh` after the GitHub assertions and negative scan.
- Passed Bash syntax and ShellCheck for the changed contract test.
- Passed the full available repository checks, Markdownlint, and
  `git diff --check`.
- Passed memory-index verification.

## Open Questions

None for §56. Live GitHub credentials, remote APIs, and remote mutation were
intentionally not exercised.

## Next Steps

- Continue with prompt-v3 §57 when the user requests the next section.

## Relevant Files

- `skills/spec-workflow/references/github-tracking.md`
- `skills/spec-workflow/tests/test-contract.sh`
- `todo.md`
- `SESSION_STATE.md`
