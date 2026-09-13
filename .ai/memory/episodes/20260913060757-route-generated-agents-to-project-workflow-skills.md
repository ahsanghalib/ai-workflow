# Route generated agents to project workflow skills

Date: 2026-09-13
Feature: project-init

## Context

TASK-0008 updates the generated `AGENTS.md` after adding user-flow, schema,
and helper-prompt project documents.

## Goal

Give generated projects an explicit, harness-neutral routing map for prompts,
project documents, and companion skills.


## Why

Agents need to know which document owns each kind of decision without treating
helper prompts as automatic authority or duplicating skill procedures.

## Outcome

Added routing for `.ai/prompts/`, `docs/USER_FLOW.md`, `docs/DB_SCHEMA.md`,
technical comparisons, schema design, SPEC/PLAN review, implementation, and
session/memory continuity. Added the intended document sequence for persisted
features.


## Current State

TASK-0001 through TASK-0008 are complete. TASK-0009 is next. No application
code, dependencies, Git mutation, or remote operation was performed.

## Important Findings

- `AGENTS.md` should explain document ownership and route to skills, not copy
  their full instructions.
- `.ai/prompts/` is tracked documentation but not automatic skill discovery or
  an authority source.

## Decisions

- Route product direction to `MASTER_PLAN.md`, behavior to `USER_FLOW.md`,
  persisted data to `DB_SCHEMA.md`, and execution to approved SPEC/PLAN gates.
- Keep the generated routing harness-neutral.

## Failed Approaches

The template has pre-existing Markdown line-length violations. Validation
disabled only MD013 for this template; no unrelated reformatting was applied.

## Validation

- `markdownlint --disable MD013 -- skills/project-init/templates/AGENTS.md`
  passed.
- Focused routing inspection passed.
- Full skill validation remains part of the final task checkpoints.

## Open Questions

No new design questions.

## Next Steps

Continue with TASK-0009: update the generated README template.
-

## Relevant Files

- `skills/project-init/templates/AGENTS.md` — generated routing contract.
- `IMPLEMENTATION_PLAN.md` — task order and activity evidence.
- `SESSION_STATE.md` — current short-term handoff state.
