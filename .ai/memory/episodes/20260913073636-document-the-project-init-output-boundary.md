# Document the project-init output boundary

Date: 2026-09-13
Feature: project-init

## Context

Earlier workflow and template documents described a documentation-only
bootstrap, and tests checked several forbidden files, but the complete allowed
versus forbidden output boundary was not one routed contract.

## Goal

Complete TASK-0050 by making the documentation-only bootstrap output boundary explicit and verifiable.

## Why

Make it impossible to confuse project-control initialization with application
scaffolding, dependency setup, database implementation, or bundled Git work.

## Outcome

Added output-boundary.md, routed it from the skill/workflow/manifest, repeated the user-facing rule in README and generated AGENTS, and extended the aggregate suite to verify allowed and forbidden outputs.

## Current State

TASK-0050 is complete and all tasks in the approved implementation plan are
checked off. The output-boundary reference and aggregate suite are the final
project-init scope evidence. Final verification is complete and the worktree
remains intentionally uncommitted.

## Important Findings

- Allowed outputs include project-control Markdown, empty documentation
  directories, tracked helper prompts, a missing `.gitignore`, and separately
  approved local Git metadata.
- Existing-project reconciliation may document safe evidence but must not copy
  or rewrite application files implicitly.

## Decisions

- No application source, framework/dependency files, persistence implementation,
  deployment configuration, secrets, commits, branches, remotes, or pushes are
  project-init outputs.
- `docs/DB_SCHEMA.md` remains conditional on approved persistence and reviewed
  user flow.
- Final handoff must list created, preserved, skipped, blocked, and unresolved
  items and distinguish structural evidence from runtime behavior.

## Failed Approaches

-

## Validation

- Red -> Green: the aggregate suite first failed because the output-boundary
  reference was absent, then passed after the reference and routing were added.
- Aggregate disposable tests, targeted Markdown lint, root validation, Bash
  syntax/ShellCheck, memory verification, and whitespace checks pass.

## Open Questions

- Live application/runtime behavior is intentionally not exercised because this
  repository generates project-control documentation only.

## Next Steps

- Hand off the uncommitted diff for user review; optionally reload the target
  harness and verify live skill discovery, approval, and fresh-session behavior.

## Relevant Files

- `skills/project-init/references/output-boundary.md`
- `skills/project-init/SKILL.md`
- `skills/project-init/references/workflow.md`
- `skills/project-init/references/template-manifest.md`
- `skills/project-init/templates/AGENTS.md`
- `README.md`
- `skills/project-init/tests/test-project-init.sh`
- `IMPLEMENTATION_PLAN.md`
- `SESSION_STATE.md`
