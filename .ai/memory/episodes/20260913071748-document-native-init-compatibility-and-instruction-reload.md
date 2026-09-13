# Document native init compatibility and instruction reload

Date: 2026-09-13
Feature: project-init

## Context

The workflow can run in harnesses that already provide `/init`, and a target
can contain root and nested `AGENTS.md` files with different scopes.

## Goal

Complete TASK-0044 by defining coexistence with native /init, AGENTS.md precedence, and the handoff after generated instruction changes.

## Why

Without an explicit compatibility contract, two initializers could overwrite
or duplicate project control, and a session could incorrectly assume that
newly generated instructions were already active.

## Outcome

Added a routed compatibility reference, linked it from the skill and workflow, and documented preservation, specificity, reload, and fresh-session rules in the generated AGENTS template and repository README.

## Current State

TASK-0044 is complete. Native output is inspected and preserved, applicable
instruction files are resolved by path specificity, and generated instruction
changes produce a reload or fresh-session handoff.

## Important Findings

- The nearest applicable `AGENTS.md` governs its path when rules differ, but
  it cannot weaken a broader safety rule.
- Native `/init` behavior is harness-specific, so project-init must not claim
  equivalent output without inspecting the result.

## Decisions

- Do not run two initializers against the same target without an inspection and
  reconciliation proposal between them.
- Preserve existing root and nested instruction files; revisions are separate
  approvals.
- Continue under the instructions already active until the harness reloads or
  a fresh session reads the changed files.

## Failed Approaches

-

## Validation

- Targeted Markdown lint passed for the changed documentation surface.
- `bash validate-skills.sh` passed with the new routed reference.
- Generated AGENTS and repository README contain the same reload and
  precedence boundary.

## Open Questions

- Live behavior of each installed harness's native `/init` and reload command
  remains environment-specific and was not exercised.

## Next Steps

- Continue with TASK-0045: make tracked `.ai/prompts/` provenance and routing
  explicit.

## Relevant Files

- `skills/project-init/references/init-compatibility.md`
- `skills/project-init/SKILL.md`
- `skills/project-init/references/workflow.md`
- `skills/project-init/templates/AGENTS.md`
- `README.md`
