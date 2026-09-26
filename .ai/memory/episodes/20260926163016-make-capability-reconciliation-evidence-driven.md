# Make capability reconciliation evidence-driven

Date: 2026-09-26
Feature: project-init prompt-v3 reconciliation

## Context

Prompt-v3 section 40 defined how `project-init` should respond when an
existing repository gains capabilities such as frontend, persistence, auth,
public API, monorepo, deployment, background jobs, AI, or multiple deployables.
The existing workflow was close but used a shorter signal list and implied the
decision rule rather than stating it directly.

## Goal

Make capability reconciliation evidence-driven, minimal, and explicitly
no-op-able when no durable repository-wide knowledge or routing is missing.

## Why

Capability signals alone must not create speculative documents or nested
instructions; the workflow should update only the smallest justified artifact.

## Outcome

Updated the project-init entrypoint, workflow reference, and acceptance
scenario to include background jobs and multiple deployables and to ask whether
durable repository-wide knowledge or routing is not already represented clearly.
The workflow now says to update the smallest appropriate artifact when needed
and do nothing otherwise. Added traceability assertions for these rules.

## Current State

Section 40 is complete and the worktree remains intentionally uncommitted.
Prompt-v3 section 41 is the next review target.

## Important Findings

- “Workers” was not an exact substitute for the prompt's “background jobs” in
  the durable capability list; the wording is now explicit.
- The no-op outcome is important: a detected capability is evidence to ask a
  question, not authorization to create a project document.

## Decisions

- Keep the decision rule in `workflow.md` as the reference authority and mirror
  the concise signal boundary in `SKILL.md` and acceptance scenarios.
- Test semantic phrases in the contract suite so future edits cannot silently
  remove the no-op or smallest-artifact behavior.

## Failed Approaches

- An initial test searched for multi-word phrases split across wrapped Markdown
  lines. It was narrowed to line-safe fragments while preserving coverage.

## Validation

- Passed all SPEC lifecycle, cross-skill, design-completion, project-init, and
  traceability suites.
- Passed `validate-skills.sh`, Markdownlint, Bash syntax, ShellCheck, and
  `git diff --check`.
- Live reconciliation against a repository with a genuinely new capability
  was not exercised beyond disposable fixtures.

## Open Questions

- None for section 40.

## Next Steps

1. Review prompt-v3 section 41 and fix concrete gaps in place.
2. Keep temporary `prompt-v3.md` and `todo.md` uncommitted.

## Relevant Files

- `skills/project-init/SKILL.md` — entrypoint decision rule.
- `skills/project-init/references/workflow.md` — reconciliation authority.
- `skills/project-init/references/acceptance-scenarios.md` — observable rule.
- `skills/project-init/tests/test-traceability-contract.sh` — assertions.
- `SESSION_STATE.md` — current handoff state (ignored).
