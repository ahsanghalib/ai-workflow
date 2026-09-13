# Final project-init review findings after remediation

Date: 2026-09-13
Feature: project-init

## Context

Three independent read-only agents reran the final review of the current
`project-init` implementation after the earlier remediation pass. The user
identified `IMPLEMENTATION_PLAN.md` and `PROJECT_INIT_SUBAGENT_REVIEW.md` as
disposable and requested durable recording in project memory.

## Goal

Record the remaining findings from the final three-agent read-only review
without relying on disposable planning or review Markdown.

## Why

The repository needs a review record that survives deletion of planning and
review artifacts, while keeping this turn read-only unless a repair is
explicitly requested.

## Outcome

Three independent reviewers found twelve actionable gaps and several residual
validation risks; no implementation files were changed.

## Current State

No implementation files were changed during this review. The current tests and
structural validation were reported as passing by the reviewers, but the open
findings below remain unresolved.

## Important Findings

- Approval semantics: the initializer creates the full missing scaffold, while
  the workflow describes separate per-file approval scopes. Either define the
  full scaffold as one explicit approved bundle or add a selected-path mode.
- Reconciliation can create `docs/plans/` and its index beside an existing
  `PLANS.md` or `plans/` source of truth. Existing-project initialization needs
  a selected-output manifest or a new-project-only boundary.
- `--with-schema` can copy the schema in the same run as user flow, before the
  required user-flow review gate. The scaffold and schema approval phases need
  to be split or made explicit.
- The feature lifecycle says a user accepts a Proposed SPEC but does not define
  the status transition to `Approved` or the required approval evidence before
  PLAN creation.
- The initial-schema and no-persistence branches are inconsistent across the
  main workflow, database-design prompt, USER_FLOW template, and SPEC prompt.
- API cursor pagination uses `next`/`prev` in API.md but `nextCursor`/`hasMore`
  in the shared-contract rule.
- The shell initializer has a TOCTOU symlink race between path checks and
  filesystem writes, failed `cp` can be reported as success under the current
  conditional context, and failing `find` commands can be swallowed by process
  substitution loops.
- The scripts use GNU-style `--` options that are not portable to BSD/macOS,
  and newline-containing filenames can be corrupted when NUL-safe results are
  converted to newline-delimited sorting/output.
- The project-init disposable tests are not currently run by CI.

## Decisions

- Keep this review read-only; do not silently expand the request into a repair
  pass.
- Treat the two planning/review Markdown files as temporary records. Store the
  review findings, open status, and next actions in this episode and current
  session state instead.
- Treat TOCTOU behavior as a threat-model decision: either harden writes with
  descriptor-relative no-follow operations or explicitly document a
  non-hostile-directory boundary before claiming the risk is closed.

## Failed Approaches

- No implementation approach was attempted. All three agents were instructed
  to inspect only and not edit files or perform Git/remote operations.

## Validation

- All three read-only reviewers reported passing structural evidence including
  the disposable project-init suite, skill validator, shell syntax checks, and
  `git diff --check`.
- They also reported missing coverage for selective approvals, SPEC status
  transition, initial/no-persistence prompt routing, failure injection,
  unreadable paths, concurrent replacement, newline filenames, BSD/macOS, and
  CI execution.
- The findings are review evidence, not proof that runtime race behavior was
  reproduced in this turn.

## Open Questions

- Should full new-project scaffold creation be one approved bundle, or should
  the initializer accept an explicit allowlist of selected paths?
- Should the initializer be restricted to new projects, leaving reconciliation
  to the skill, or should it consume a selected-output manifest?
- Should cursor pagination use `next`/`prev` or `nextCursor`/`hasMore`?
- Is the target environment hostile/concurrent enough to require no-follow
  descriptor-relative writes, or is a documented local non-hostile boundary
  sufficient?

## Next Steps

- If the user requests remediation, create a new approved implementation plan
  for these findings, starting with approval scope and failed-copy/find error
  propagation, then contract consistency and portability/CI coverage.
- Until then, do not claim the final review is fully clean; the current state
  is reviewed with open findings.

## Relevant Files

- `skills/project-init/scripts/init-project.sh` — scaffold writes, path checks,
  schema flag, and process-substitution traversal.
- `skills/project-init/scripts/inspect-project.sh` and
  `inventory-project.sh` — discovery and filename handling.
- `skills/project-init/references/workflow.md` and
  `feature-lifecycle.md` — approval, reconciliation, and SPEC/PLAN gates.
- `skills/project-init/templates/.ai/prompts/` — schema and SPEC prompt
  branches.
- `skills/project-init/templates/docs/USER_FLOW.md` — schema reference
  placeholder behavior.
- `skills/project-init/templates/docs/rules/API.md` and `CONTRACTS.md` —
  pagination contract alignment.
- `.github/workflows/validate.yml` — CI validation coverage.
