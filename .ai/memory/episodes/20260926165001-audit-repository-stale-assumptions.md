# Audit repository stale assumptions

Date: 2026-09-26
Feature: project-init prompt-v3 reconciliation

## Context

Prompt-v3 section 44 required a whole-repository search for retired PLAN,
legacy artifact, and old project-control assumptions after the workflow
refactor.

## Goal

Classify every remaining match as an active defect, intentional preservation or
test evidence, or unrelated language, then close any active-contract gap.

## Why

Broad replacement could damage legitimate safety fixtures and unrelated uses
of planning terminology, while an incomplete search could leave an old route
available to future work.

## Outcome

The audit found no active stale lifecycle contract. Extended the skill audit to
scan all active skill entrypoints, runtime profiles, README, global guidance,
and project-init scripts for stale lifecycle phrases and legacy artifact paths.
Updated the TODO and session handoff with the classification result.

## Current State

Section 44 is complete and section 45 is the next review target. No commit was
created.

## Important Findings

- Legacy artifact names remain only in preservation guidance and negative tests
  that prove they are not generated or overwritten.
- Generic planning language in motion, performance, product, diagram, and
  runtime workflows is unrelated to the retired project PLAN lifecycle.

## Decisions

- Preserve intentional safety and test references; do not replace every
  occurrence of `PLAN` or `project-init` without contract evidence.
- Treat active skill/runtime/control surfaces as the regression boundary and
  keep the full-repository classification in the temporary TODO and handoff.

## Failed Approaches

- No implementation approach failed. The initial broad search produced noisy
  matches from unrelated planning language and fixtures, so results were
  narrowed by exact legacy terms and active contract surfaces before editing.

## Validation

- Passed all SPEC and project-init contract suites, the skill validator, Bash
  syntax, ShellCheck, targeted Markdownlint, memory verification, and
  `git diff --check`.
- Live harness reload and external runtime behavior were not exercised.

## Open Questions

- None for §44. Section 45 remains to be reviewed.

## Next Steps

- Review §45 and continue the same evidence-led gap-fixing process.

## Relevant Files

- `skills/project-init/tests/test-skill-audit.sh`
- `SESSION_STATE.md`
- `todo.md`
