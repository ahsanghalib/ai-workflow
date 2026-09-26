# Prompt v3 artifact decision review

Date: 2026-09-26
Feature: project-init artifact decisions

## Context

Prompt-v3 §64 requires one gate before creating or requiring an artifact:
confirm durable information the project needs and the absence of a clearer
existing source of truth. A negative answer means no artifact.

## Goal

Audit current project-init/source-of-truth/reconciliation guidance and tests
for that decision rule, including preservation of clearer existing sources and
the owning-workflow approval boundary.

## Why

Without this gate, progressive documentation can turn into speculative files or
duplicate state even when the project already has a better authority.

## Outcome

Added an Artifact Decision Rule to the existing project-init workflow
reference. It now requires demonstrated durable need, no clearer authoritative
source, preservation/reference of existing sources, and the owning workflow's
approval before writing; otherwise it must not create or require the artifact.
Added focused safeguards assertions, §64 tracking, and session handoff
updates. No artifact was created in a target project.

## Current State

Section 64 is complete and the worktree remains intentionally uncommitted.
Section 65 is the next review target. Temporary `prompt-v3.md` and `todo.md`
remain untracked by design.

## Important Findings

- Existing source-of-truth and output-boundary references already handled many
  cases, but the exact durable-need question and explicit no-create/no-require
  outcome were not centralized in the workflow reference.
- The existing safeguards contract test is the right regression seam because
  it already protects source-of-truth, approval, and output boundaries.

## Decisions

- Extend the existing project-init workflow reference rather than adding a new
  artifact-policy file or registry.
- Use “needs” in the question for grammatical correctness while preserving the
  prompt's meaning.

## Failed Approaches

- None. The focused safeguards and project-init suites passed after the rule
  and assertions were added.

## Validation

- `bash skills/project-init/tests/test-safeguards-contract.sh` — passed.
- `bash skills/project-init/tests/test-project-init.sh` — passed, including all
  project-init child contracts.
- Full suite, structural checks, Markdownlint, memory verification, and diff
  checks remain part of the final post-edit pass.

## Open Questions

- None for §64. The next section defines knowledge placement.

## Next Steps

- Review prompt-v3 §65, audit temporary state versus SPEC/design/rules/source
  placement, then rerun focused and full validation after any edits.

## Relevant Files

- `skills/project-init/references/workflow.md` — artifact decision rule.
- `skills/project-init/tests/test-safeguards-contract.sh` — regression checks.
- `todo.md` — §36 tracking checklist.
- `SESSION_STATE.md` — current handoff and next section.
