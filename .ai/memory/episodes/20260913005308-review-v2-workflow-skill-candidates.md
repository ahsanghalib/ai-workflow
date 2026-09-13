# Review v2 workflow skill candidates

Date: 2026-09-13
Feature: skill-candidate-review

## Context

Reviewed the untracked workflow candidates under `skills/new-skills-to-add/`
against the current root skills, repository rules, and project-init templates.

## Goal

Keep the strongest compatible behavior from the existing and candidate skills,
with `project-init` replacing `project-plan` as the eventual planning owner.


## Why

The candidate bundle adds a broader project scaffold and workflow, but several
names overlap existing skills. Promotion must not create duplicate owners or
silently lose planning, safety, or continuity rules.

## Outcome

Hardened the staging documentation and initializer. `project-init` now carries
the useful legacy planning gates and owns project-control bootstrap/planning;
the other candidates have explicit boundaries and handoffs. No root skill or
runtime configuration was promoted or changed.


## Current State

The staging bundle is ready for final user review. Root `project-plan` and
`session-state` remain active for compatibility. Promotion and dependent-route
updates are still pending.

## Important Findings

- The root validator scans only `skills/<name>/SKILL.md` and does not validate
  nested staging candidates directly.
- `session-state` is an exact collision; the root skill's required AGENTS
  continuity behavior is stronger, while the candidate contributes a useful
  state-field checklist.
- `review-diff` remains appropriate for quick diff-only review; candidate
  `code-review` is limited to substantial plan-backed review.
- The initializer must skip existing intermediate symlinked directories to
  avoid writing outside the selected target.

## Decisions

- Treat `project-init` as the future canonical successor to `project-plan`.
- Keep existing project artifact layouts when present; do not create a second
  plan tree implicitly.
- Keep `session-state` as one root owner and merge only useful candidate fields
  during promotion.
- Keep schema, feature execution, and review candidates as distinct specialist
  boundaries.

## Failed Approaches

- An initial untracked-file whitespace check exposed intentional Markdown
  trailing spaces in the PLAN template; removing them made the repository
  check clean.
- An inline environment assignment did not expand the project-root variable
  for the memory command; the retry used an explicit shell variable.

## Validation

- `bash validate-skills.sh` passed for the root set and for an isolated copy of
  all eight candidates.
- `bash -n bin/*`, Bash syntax, and ShellCheck passed for the initializer.
- Temporary initializer tests passed for required files, idempotency, extra
  arguments, broken leaf symlinks, and symlinked parents.
- Untracked candidate files passed `git diff --no-index --check`; tracked
  changes passed `git diff --check`.
- Runtime harness discovery, application/browser behavior, dependencies, and
  remote Git/GitHub operations were not exercised.

## Open Questions

- Which candidates should be promoted in the next change, and should the
  candidate session-state fields be merged into the root skill at that time?

## Next Steps

- Promote selected candidates only after final review.
- Update dependent root references from `project-plan` to `project-init`, then
  retire or reduce the legacy skill and re-run root validation.

## Relevant Files

- `skills/new-skills-to-add/project-init/SKILL.md` and `references/workflow.md`:
  canonical successor workflow.
- `skills/new-skills-to-add/project-init/scripts/init-project.sh`: safe,
  copy-if-missing scaffold initializer.
- `skills/new-skills-to-add/README.md`: overlap and promotion decisions.
- `skills/project-plan/`, `skills/session-state/`, and related planning skills:
  existing owners used for comparison.
