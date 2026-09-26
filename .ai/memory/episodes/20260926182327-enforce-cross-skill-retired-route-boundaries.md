# Enforce cross-skill retired-route boundaries

Date: 2026-09-26
Feature: prompt-v3 §57 cross-skill tests

## Context

Prompt-v3 §57 requires cross-skill tests to ensure normal work no longer
enforces three retired lifecycle chains. Existing tests checked individual
skill ownership and removed PLAN entrypoints, but did not scan the exact
chains across active contract paths.

## Goal

Add a direct, harness-neutral negative scan for the retired routes without
reintroducing optional PLAN behavior into the normal workflow.

## Why

Individual skill assertions can pass while a runtime profile, reference, or
README quietly restores a required multi-skill route.

## Outcome

Expanded `test-cross-skill-contract.sh` to scan active skill entrypoints,
project-init/spec references, runtime profiles, and repository documentation
for `SPEC → PLAN → implementation`,
`project-init → USER_FLOW → DB_SCHEMA → SPEC`, and
`project-init → MASTER_PLAN`. The scan excludes test fixtures and does not
inspect retired optional PLAN skill paths.

## Current State

The §57 changes remain uncommitted for user review. The review cursor is now
prompt-v3 §58, and no application or remote state was changed.

## Important Findings

- Cross-skill ownership checks already covered most handoffs, but exact route
  enforcement was not directly regression-tested.
- The repository intentionally has no active optional PLAN skill entrypoints;
  the normal-path scan still preserves the prompt's optional-route boundary.
- The exact retired chains are absent from normal active paths after the new
  assertion runs.

## Decisions

- Keep the new check in the existing cross-skill contract test so current CI
  exercises it without a duplicate runner.
- Scan references and runtime/documentation paths in addition to SKILL.md
  entrypoints because routing can drift outside an entrypoint.
- Preserve unrelated worktree changes and do not commit.

## Failed Approaches

None. The focused cross-skill test and ShellCheck passed after the update.

## Validation

- Passed `test-cross-skill-contract.sh`.
- Passed Bash syntax and ShellCheck for the changed test.
- Passed the full available repository checks, Markdownlint, memory-index
  verification, and `git diff --check`.

## Open Questions

None for §57. Optional PLAN-specific skills are not present in this repository;
no live harness routing was exercised.

## Next Steps

- Continue with prompt-v3 §58 when the user requests the next section.

## Relevant Files

- `skills/spec-workflow/tests/test-cross-skill-contract.sh`
- `skills/spec-workflow/SKILL.md`
- `skills/project-init/SKILL.md`
- `todo.md`
- `SESSION_STATE.md`
