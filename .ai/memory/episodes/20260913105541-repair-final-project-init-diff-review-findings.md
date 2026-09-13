# Repair final project-init diff review findings

Date: 2026-09-13
Feature: project-init final diff review

## Context

The final read-only diff review identified three project-init issues: the
foundation validator assumed canonical filenames, reconciliation wording made
user-flow and schema appear unconditional, and no-op detection accepted
arbitrary content below scaffold directories.

## Goal

Repair those findings without recreating disposable review/plan files or
committing the working tree.

## Why

Existing projects must keep their established source-of-truth paths, optional
documents must follow the selected project profile, and an initializer no-op
must not hide user content or prevent the required reconciliation review.

## Outcome

The validator now accepts safe relative mappings for README, AGENTS, master
plan, architecture, user flow, and schema documents, with `none` for
inapplicable optional documents. Workflow and acceptance references describe
the conditional behavior. No-op recognition now admits only exact known
scaffold paths and empty scaffold directories, so files such as
`docs/specs/user-spec.md` cause existing-project reconciliation instead.

## Current State

The working tree remains uncommitted. The temporary review and implementation
plan files remain absent. The project-init disposable tests, Bash syntax,
ShellCheck, skill validator, and `git diff --check` pass.

## Important Findings

- Existing-layout support belongs in the read-only foundation validator rather
  than by creating duplicate canonical documents.
- Explicit optional mappings must fail when selected files are missing, while
  `--user-flow none` and `--schema none` skip only their optional checks.
- Recognized scaffold detection must not treat arbitrary descendants of
  `docs/specs/`, `docs/plans/`, or `docs/reviews/` as bundled output.

## Decisions

- Required foundation documents retain canonical defaults for new projects.
- Existing projects can pass mapped relative paths without symlinks, absolute
  paths, parent traversal, or control characters.
- Structural validation remains evidence of document consistency, not proof of
  product correctness or user approval.

## Failed Approaches

- The first ShellCheck pass exposed unused explicit-state variables in the
  validator; they were removed rather than suppressing the warning.
- A traceability assertion initially depended on a phrase spanning a Markdown
  line wrap; it was changed to assert the stable semantic phrase instead.

## Validation

- `bash skills/project-init/tests/test-*.sh`
- `bash -n skills/project-init/scripts/*.sh skills/project-init/tests/*.sh`
- `bash -n bin/* script.sh`
- `shellcheck skills/project-init/scripts/*.sh skills/project-init/tests/*.sh`
- `bash validate-skills.sh`
- `git diff --check`

## Open Questions

- None for this repair pass. Live harness behavior and real existing-project
  reconciliation remain outside disposable shell-test coverage.

## Next Steps

- Review the complete working-tree diff and stage only logically related paths
  when the user is ready to commit.

## Relevant Files

- `skills/project-init/scripts/init-project.sh`
- `skills/project-init/scripts/validate-foundation.sh`
- `skills/project-init/references/workflow.md`
- `skills/project-init/references/acceptance-scenarios.md`
- `skills/project-init/tests/test-init-project.sh`
- `skills/project-init/tests/test-validate-foundation.sh`
- `skills/project-init/tests/test-traceability-contract.sh`
- `skills/project-init/tests/test-acceptance-scenarios.sh`
