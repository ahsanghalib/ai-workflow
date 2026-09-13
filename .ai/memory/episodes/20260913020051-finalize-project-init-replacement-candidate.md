# Finalize project-init replacement candidate

Date: 2026-09-13
Feature: project-init

## Context

The repository is evaluating skills under `skills/new-skills-to-add`. The
`project-init` candidate is intended to replace the existing root
`skills/project-plan` skill and owns project-document bootstrap, planning, and
separately approved local setup preparation.

## Goal

Make the candidate complete enough for a coordinated replacement while
preserving useful behavior from `project-plan` and keeping generated session
state local.


## Why

The user selected `project-init` because it has the broader project-control
scaffold and more complete rules/templates. Existing planning behavior must not
be lost during the replacement.

## Outcome

The candidate was finalized with its SKILL.md, detailed workflow reference,
copy-if-missing scaffold script, and reusable templates for project control,
architecture, rules, SPEC/PLAN/REVIEW documents, and session continuity. The
PLAN template retains the useful legacy headings. The session-state candidate
is updater-only; project-init owns creation from templates.


## Current State

All project-init candidate files and the source SESSION_STATE template are
staged. The root `project-plan` skill remains intact, and root consumers still
reference it intentionally until project-init is promoted and the handoffs are
updated together. The root generated `SESSION_STATE.md` remains ignored, while
the reusable source template is explicitly trackable.

## Important Findings

- The bundled script copies only missing files, preserves existing files and
  leaf symlinks, and does not follow symlinked parent directories.
- Strict bootstrap requires the exact target root and approval before the
  script writes; it reports missing generated-project ignore coverage instead
  of silently changing user policy.
- The validator proves entrypoints and routed references, not runtime behavior,
  actual project bootstrap, GitHub issue creation, or deployment behavior.

## Decisions

- Keep `project-init` under `skills/new-skills-to-add` until the user performs
  the coordinated root promotion.
- Preserve the existing root `project-plan` during review; do not leave live
  root references pointing at a skill that has not yet been promoted.
- Track only the reusable `project-init/templates/SESSION_STATE.md`; generated
  project SESSION_STATE files remain ignored.

## Failed Approaches

- An isolated validator run against a non-Git temporary fixture failed because
  the validator expects a Git worktree. Repeating it with a disposable Git
  fixture passed; no repository content was changed by the fixture.

## Validation

- `bash validate-skills.sh` passed for the current checkout.
- An isolated disposable-Git validation of the candidate passed.
- `bash -n skills/new-skills-to-add/project-init/scripts/init-project.sh`
  passed.
- Script tests passed for help/error handling, complete copy, idempotency,
  existing-file preservation, spaces in paths, leaf symlinks, and symlinked
  parents.
- `git diff --cached --check` and `git diff --check` passed.
- No runtime application, external provider, remote Git, or deployment path was
  exercised.

## Open Questions

- The promotion step must add the candidate as `skills/project-init`, update
  active handoffs currently naming `project-plan`, rerun validation, and only
  then retire the old root skill.

## Next Steps

1. Promote the finalized candidate to the root skill directory when the user
   is ready.
2. Update the eight active root skill handoffs from `project-plan` to
   `project-init` in the same cutover.
3. Rerun validation and review the cutover diff before removing the old skill.

## Relevant Files

- `skills/new-skills-to-add/project-init/SKILL.md` — candidate contract and
  routing.
- `skills/new-skills-to-add/project-init/references/workflow.md` — detailed
  bootstrap, planning, setup, and validation workflow.
- `skills/new-skills-to-add/project-init/scripts/init-project.sh` — safe
  copy-if-missing scaffold helper.
- `skills/new-skills-to-add/project-init/templates/` — reusable project
  documentation templates.
- `.gitignore` — keeps generated SESSION_STATE local while tracking the source
  template.
