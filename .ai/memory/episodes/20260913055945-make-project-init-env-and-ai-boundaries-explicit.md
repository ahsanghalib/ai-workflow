# Make project-init env and ai boundaries explicit

Date: 2026-09-13
Feature: project-init

## Context

TASK-0004 of the approved project-init implementation plan follows the
proposal-state work. The repository needed explicit handling for real `.env`
files and intentionally tracked `.ai/` documentation.

## Goal

Define secret-file exclusion and tracked `.ai/` behavior consistently in the
skill, workflow reference, generated instructions, and ignore template.


## Why

The initializer must not expose or create local secrets, while helper prompts
and project memory under `.ai/` must remain visible, versionable, and preserved
during reconciliation.

## Outcome

Updated the project-init skill, workflow reference, generated `AGENTS.md`, and
`.gitignore.template`. Real `.env` files are excluded from creation, copying,
reading, parsing, printing, and project evidence. `.ai/` is explicitly tracked
and is never added to ignore rules.


## Current State

TASK-0001 through TASK-0004 are complete. No application code, dependency,
remote, commit, branch, or Git mutation was performed. TASK-0005 is next.

## Important Findings

- The existing ignore template already excluded `.env` and allowed safe example
  files; the missing piece was explicit policy language.
- Tracking `.ai/` does not make it a secret store or override `AGENTS.md`.
- Existing `.ai/` files must be preserved during reconciliation.

## Decisions

- Keep `.env` out of all initializer inputs and outputs while documenting only
  variable names when needed.
- Treat `.ai/` as ordinary tracked project documentation and preserve it.
- Leave broader README and helper-prompt documentation to their dedicated plan
  tasks.

## Failed Approaches

The first lint command included the `.gitignore.template` as Markdown and used
an unsupported option form for the installed markdownlint CLI. Validation was
rerun with the repository's existing Markdown files targeted and the
pre-existing line-length rule disabled only for the generated AGENTS template.

## Validation

- Markdown lint passed for changed Markdown documents; the generated AGENTS
  template passed with only its pre-existing MD013 line-length violations
  disabled.
- `bash validate-skills.sh` passed.
- `git diff --check` passed.
- The `.gitignore.template` contains no active `.ai/` ignore rule.
- Runtime secret-handling behavior remains unexercised.

## Open Questions

No new design questions. Broader prompt/template documentation remains future
work in later tasks.

## Next Steps

Continue with TASK-0005: add the DB schema and user-flow templates.

## Relevant Files

- `IMPLEMENTATION_PLAN.md` — approved task order and activity evidence.
- `skills/project-init/SKILL.md` — public secret and tracked-document policy.
- `skills/project-init/references/workflow.md` — detailed workflow invariants.
- `skills/project-init/templates/AGENTS.md` — generated project policy.
- `skills/project-init/templates/.gitignore.template` — generated ignore rules.
- `SESSION_STATE.md` — current short-term handoff state.
