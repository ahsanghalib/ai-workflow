# Harden existing-repository tests

Date: 2026-09-26
Feature: project-init prompt-v3 reconciliation

## Context

Prompt-v3 section 47 required existing-repository tests to prove preservation,
safe reconciliation, idempotent reruns, and secret/convention boundaries.

## Goal

Compare the existing fixtures with every §47 criterion and add only the missing
behavioral evidence.

## Why

A project initializer can satisfy new-project tests while still rewriting
user-owned rules, changing files on rerun, or exposing secret contents during
existing-project reconciliation.

## Outcome

Extended `test-init-project.sh` to preserve a user-owned `docs/rules/BACKEND.md`,
reject `.env` content in reconciliation output, verify its contents remain
unchanged, and compare the complete file manifest and SHA-256 content hashes
before and after a rerun.

## Current State

Section 47 is complete and section 48 is the next review target. No commit was
created.

## Important Findings

- Existing tests already preserved source/configuration, authored documents,
  legacy artifacts, Git metadata, and alternate SPEC sources.
- The missing evidence was concentrated in legacy rule preservation, stronger
  idempotence proof, and explicit reconciliation-output secrecy.

## Decisions

- Strengthen the existing disposable fixture rather than add a second
  reconciliation harness; the current aggregate test already runs in CI.
- Use manifest and content-hash comparison for rerun evidence while keeping
  secret values confined to the temporary fixture and assertion, never output.

## Failed Approaches

- No implementation approach failed. The first review identified coverage gaps
  without requiring an initializer behavior change.

## Validation

- Passed the existing-repository test, project-init aggregate, all SPEC and
  cross-skill contracts, `validate-skills.sh`, Bash syntax, ShellCheck,
  Markdownlint, memory verification, and `git diff --check`.
- Live harness reload and application/runtime behavior were not exercised.

## Open Questions

- None for §47. Section 48 remains to be reviewed.

## Next Steps

- Review §48 and continue evidence-led gap fixing.

## Relevant Files

- `skills/project-init/tests/test-init-project.sh`
- `SESSION_STATE.md`
- `todo.md`
