# Complete promoted skill cutover

Date: 2026-09-13
Feature: skill-candidate-promotion

## Context

The reviewed skill candidates were moved from the staging area into root
`skills/`, while the former `project-plan` and `session-state` owners were
renamed with a `-remove` suffix for retirement.

## Goal

Complete the root-level promotion, route active consumers to `project-init`,
remove the duplicate legacy owners, and preserve the reusable project-init
SESSION_STATE template as trackable source content.



## Why

`project-init` is the selected replacement for `project-plan` and carries the
needed bootstrap, planning, approval, and template workflow. Keeping duplicate
owners would make skill discovery and validation ambiguous.


## Outcome

The eight reviewed skills are present at root level: `project-init`,
`session-state`, `spec-review`, `plan-review`, `schema-design`,
`backend-feature`, `frontend-feature`, and `code-review`. Active handoffs and
the README now identify `project-init` as the planning owner. The old
`project-plan-remove/` and `session-state-remove/` directories and the deleted
staging area are absent.



## Current State

The promoted files are untracked in the working tree, while earlier index
entries for the staging paths remain staged from before this cutover. No
staging, commit, push, issue, or remote operation was performed here.


## Important Findings

- The root `.gitignore` exception must target
  `skills/project-init/templates/SESSION_STATE.md` after promotion.
- A nested `templates/.gitignore` containing `SESSION_STATE.md` overrides the
  root exception and prevents the source template from being trackable.
- Renaming the source to `.gitignore.template` and mapping it to `.gitignore`
  in `init-project.sh` preserves generated-project behavior and makes the
  source SESSION_STATE template unignored.
- The only remaining `project-plan` reference outside history is the
  intentional supersession note in `skills/project-init/SKILL.md`.

## Decisions

- Use `project-init` as the canonical planning and initialization skill.
- Keep the promoted `session-state` as the updater-only owner; do not install
  the retired duplicate.
- Keep generated `SESSION_STATE.md` ignored, but track the reusable source
  template.

## Failed Approaches

- A root `.gitignore` negation alone did not work because the nested template
  `.gitignore` had higher directory-level precedence. Do not restore that
  source filename without the corresponding mapping or another equivalent
  separation.

## Validation

- `bash validate-skills.sh` passed for the promoted root skill set.
- `bash -n bin/*`, `bash -n skills/project-init/scripts/init-project.sh`, and
  `shellcheck skills/project-init/scripts/init-project.sh` passed.
- `git diff --check` passed.
- `git check-ignore -q` confirmed root `SESSION_STATE.md` is ignored and the
  promoted source template is not ignored.
- A disposable initializer run emitted `.gitignore` with the expected
  `SESSION_STATE.md` rule and created the expected scaffold files.
- Runtime harness discovery, application behavior, browser behavior,
  dependency installation, and remote Git/GitHub behavior were not exercised.

## Open Questions

- The intended final staging selection has not been made; the working tree
  still includes prior staged paths and promoted untracked paths.

## Next Steps

- Review the complete status and diff, then stage the intended root additions,
  replacements, and deletions as one logical Git change when ready.

## Relevant Files

- `skills/project-init/SKILL.md` — canonical planning/bootstrap workflow.
- `skills/project-init/scripts/init-project.sh` — copy-if-missing scaffold
  generator and `.gitignore.template` mapping.
- `skills/project-init/templates/.gitignore.template` — reusable generated
  ignore-file source.
- `.gitignore` — root source-template exception and local state ignore rule.
- `README.md` and the dependent planning/research skills — updated owner
  handoffs.
