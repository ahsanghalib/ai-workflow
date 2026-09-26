# Align GitHub Project dashboard boundaries

Date: 2026-09-26
Feature: project-init prompt-v3 reconciliation

## Context

During the prompt-v3 reconciliation, section 37 refined the optional GitHub
Project boundary after section 36 established the local SPEC tracking model.
The repository worktree remained uncommitted and existing user changes were
preserved.

## Goal

Align skill references, project-init output rules, tests, and public README
guidance with the section 37 dashboard-only model.

## Why

GitHub Projects must remain optional coordination views and must not become
requirements infrastructure or an implicit project-init output.

## Outcome

Updated `github-tracking.md` with the three allowed Project triggers, the
simple default status model, optional `Type`, `Priority`, `SPEC`, and `Area`
fields, and the prohibition on creating or requiring a Project during
`project-init`. Added `projects` to project-init's forbidden remote outputs,
updated the README, and added regression assertions.

## Current State

Section 37 is complete. The worktree is intentionally uncommitted and section
38 is the next review target.

## Important Findings

- A Project is allowed only when requested by the user, already used by the
  repository, or explicitly selected by an authorized workflow.
- Project statuses and optional fields are dashboard conveniences, not
  requirements, architecture, data design, SPEC status, approval, or
  completion authority.
- Project-init already rejected remote Issues; its boundary now explicitly
  rejects Projects as well.

## Decisions

- Keep the provider-specific dashboard guidance in the routed GitHub tracking
  reference and mirror only the project-init prohibition in its output rules
  and public README.
- Preserve a small default model and avoid estimates, story points,
  iterations, roadmaps, milestones, and complex automations unless an actual
  repository/team convention justifies them.

## Failed Approaches

- An initial contract assertion searched for a phrase split across Markdown
  lines and triggered ShellCheck because a single-quoted test contained
  backticks. The assertion was changed to line-safe, shell-safe checks.

## Validation

- Passed all SPEC lifecycle, cross-skill, design-completion, and project-init
  contract suites.
- Passed the project-init disposable/acceptance suites and `validate-skills.sh`.
- Passed Markdownlint for README and all affected references, Bash syntax,
  ShellCheck, and `git diff --check`.
- Live GitHub Project access and harness reload were not exercised.

## Open Questions

- None for section 37.

## Next Steps

1. Review prompt-v3 section 38 and fix concrete gaps in place.
2. Keep temporary `prompt-v3.md` and `todo.md` uncommitted.

## Relevant Files

- `skills/spec-workflow/references/github-tracking.md` — Project policy.
- `skills/spec-workflow/tests/test-contract.sh` — regression assertions.
- `skills/project-init/references/output-boundary.md` — forbidden outputs.
- `skills/project-init/references/template-manifest.md` — helper boundary.
- `skills/project-init/references/workflow.md` — bootstrap handoff boundary.
- `skills/project-init/tests/test-project-init.sh` — disposable assertions.
- `README.md` — public workflow guidance.
- `SESSION_STATE.md` — current handoff state (ignored).
