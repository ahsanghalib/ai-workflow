# Remove obsolete staging overview files

Date: 2026-09-13
Feature: skill-candidate-review

## Context

The reviewed candidate bundle in `skills/new-skills-to-add` contained three
untracked staging-only overview files: `README.md`, `V2-DESIGN.md`, and
`TOOLING.md`. The eight skill entrypoints and project-init templates are the
durable content needed for promotion.

## Goal

Remove the three files if they are not required by active skills, templates, or
repository instructions, while preserving all reviewed candidates.


## Why

The user explicitly authorized removal after the candidate review and had
already identified these files as planned cleanup targets.

## Outcome

Removed exactly the three staging overview files. No active skill, template, or
repository instruction referenced them. The project-init template README was
preserved because it is part of the generated scaffold.


## Current State

All eight candidate `SKILL.md` entrypoints remain present. The removed files are
absent, and root skills have not been promoted or deleted. `project-plan` and
the root `session-state` remain live until coordinated cutover.

## Important Findings

- Active-reference scanning found no references outside historical memory
  entries, which are not runtime dependencies.
- The root validator still passes after deletion.
- A zsh inspection command initially used `path` as a loop variable and
  shadowed PATH only within that command; it caused no repository change.

## Decisions

- Delete only the three explicitly named staging files.
- Keep `project-init/templates/README.md`; it is a reusable generated-project
  artifact, not staging guidance.
- Update SESSION_STATE.md to record the deletion and preserve the promotion
  queue.

## Failed Approaches

- The first inspection loop used the zsh special `path` variable, causing
  `sed` lookup to fail in that subprocess. The check was repeated safely with
  `target_file`.

## Validation

- Confirmed all three exact paths are absent.
- Active-reference scan returned none outside `.ai/memory` history.
- `bash validate-skills.sh` passed.
- `git diff --check` passed.
- All eight candidate entrypoints were enumerated and remain present.
- No runtime application, browser, provider, or remote operation was needed.

## Open Questions

- Root promotion and `project-plan` retirement remain separate, pending user
  direction.

## Next Steps

Proceed with the coordinated promotion of selected reviewed skills when
requested.

## Relevant Files

- `skills/new-skills-to-add/` — remaining reviewed skill candidates.
- `skills/new-skills-to-add/project-init/templates/README.md` — preserved
  scaffold artifact.
- `SESSION_STATE.md` — current queue and promotion handoff.
