# Separate generated Markdown from application code

Date: 2026-09-13
Feature: project-init

## Context

TASK-0037 clarifies what project-init generates and what later implementation
work must own.

## Goal

Complete TASK-0037 by documenting the project-control output boundary.

## Why

Users can mistake a documentation scaffold for an application bootstrap. The
boundary must make clear that project-init organizes decisions but does not
create runnable product code.

## Outcome

README, AGENTS, and workflow now state that bootstrap creates only project-control Markdown, optional ignore/local Git metadata, tracked prompts, and empty docs directories; application source and frameworks require later approved work.

## Current State

TASK-0001 through TASK-0037 are complete. TASK-0038, focused temporary tests
for all bootstrap/reconciliation safety behavior, is next.

## Important Findings

- Bootstrap outputs are project-control Markdown, optional `.gitignore`, empty
  documentation directories, tracked prompts, and optional local Git metadata.
- Application source, framework files, package manifests, migrations, models,
  services, routes, UI, deployment, and secrets require later approved feature
  work.

## Decisions

- State the output boundary in generated README, AGENTS, and workflow guidance.
- Keep project-init implementation-free and preserve the SPEC/PLAN approval
  handoff for code.

## Failed Approaches

No implementation approach failed; this was documentation-only boundary work.

## Validation

- Markdown lint and focused output-boundary inspection passed.

## Open Questions

The remaining tests must prove the boundary operationally in disposable target
directories.

## Next Steps

Implement TASK-0038 with Red -> Green -> Refactor coverage for helper behavior.

## Relevant Files

- `skills/project-init/templates/README.md` — generated user guidance.
- `skills/project-init/templates/AGENTS.md` — generated operational boundary.
- `skills/project-init/references/workflow.md` — workflow output boundary.
- `IMPLEMENTATION_PLAN.md` — task order and evidence.
