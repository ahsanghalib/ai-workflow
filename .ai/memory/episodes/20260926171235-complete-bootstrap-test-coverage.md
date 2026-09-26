# Complete bootstrap test coverage

Date: 2026-09-26
Feature: project-init prompt-v3 reconciliation

## Context

Prompt-v3 section 46 defined the required bootstrap outputs and the legacy or
speculative artifacts that a new empty repository must not receive.

## Goal

Compare the existing disposable bootstrap tests with every §46 acceptance
criterion and close any untested boundary.

## Why

Bootstrap output is the first workflow boundary; missing a negative assertion
could reintroduce project-wide planning, schema, or rule ceremony.

## Outcome

Confirmed the tests already cover the minimal control plane, forbidden legacy
and root-rule outputs, conditional-template non-generation, rerun preservation,
Git behavior, and safe failure cases. Added an explicit assertion that
initialization does not run or report baseline schema design.

## Current State

Section 46 is complete and section 47 is the next review target. No commit was
created.

## Important Findings

- `test-init-project.sh` verifies `AGENTS.md`, `SESSION_STATE.md`, `.ai/memory/`,
  and `docs/specs/` on a new target.
- The same test preserves existing files and rejects legacy artifacts,
  `docs/rules`, conditional documents, remotes, commits, unsafe nesting, and
  unapproved alternate SPEC roots.

## Decisions

- Keep bootstrap behavior minimal and assert the output boundary in the
  disposable test rather than invoking schema design or adding a new runtime
  integration fixture.
- Treat the initializer's observable output and filesystem state as the
  evidence for the no-baseline-schema requirement.

## Failed Approaches

- No implementation approach failed. The initial review found one implicit
  requirement, so a narrow output assertion was added instead of changing the
  initializer.

## Validation

- Passed the bootstrap test, project-init aggregate suite, all SPEC and
  cross-skill contracts, `validate-skills.sh`, Bash syntax, ShellCheck,
  Markdownlint, memory verification, and `git diff --check`.
- Live harness reload and application/runtime behavior were not exercised.

## Open Questions

- None for §46. Section 47 remains to be reviewed.

## Next Steps

- Review §47 and continue evidence-led gap fixing.

## Relevant Files

- `skills/project-init/tests/test-init-project.sh`
- `skills/project-init/tests/test-project-init.sh`
- `SESSION_STATE.md`
- `todo.md`
