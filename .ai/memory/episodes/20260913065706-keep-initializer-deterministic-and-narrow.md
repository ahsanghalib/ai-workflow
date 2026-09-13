# Keep initializer deterministic and narrow

Date: 2026-09-13
Feature: project-init

## Context

TASK-0036 documents the boundaries of the three project-init helper scripts.

## Goal

Complete TASK-0036 by documenting inspect, inventory, and copy helper boundaries.

## Why

Deterministic scaffolding is easier to validate and safer to use when product
interpretation, reconciliation, and file copying are not mixed together.

## Outcome

Project-init now explicitly separates read-only inspection/inventory from deterministic copy-if-missing initialization, which never infers ideas, selects stack, rewrites docs, installs dependencies, scaffolds app code, or reads .env.

## Current State

TASK-0001 through TASK-0036 are complete. TASK-0037, documenting the boundary
between generated Markdown and later application code, is next.

## Important Findings

- Inspection and inventory are read-only; initialization is the only helper that
  writes project-control files.
- Copy-if-missing and symlink preservation do not imply document population or
  stack selection.
- The agent owns proposal, approval, interpretation, and handoff around the
  scripts.

## Decisions

- `inspect-project.sh` reports mode/proposal without writes.
- `inventory-project.sh` classifies safe evidence without contents.
- `init-project.sh` copies selected templates only and never infers or rewrites
  project documents.

## Failed Approaches

No implementation approach failed; this was documentation-only boundary work
with existing helper tests.

## Validation

- Markdown lint, shell syntax/ShellCheck, disposable helper tests, and focused
  deterministic-boundary inspection passed.

## Open Questions

The user-facing README may need one final pass after the remaining validation
and research-hardening tasks.

## Next Steps

Implement TASK-0037 and distinguish generated project-control Markdown from
later application source/framework output.

## Relevant Files

- `skills/project-init/scripts/inspect-project.sh` — read-only mode helper.
- `skills/project-init/scripts/inventory-project.sh` — read-only evidence helper.
- `skills/project-init/scripts/init-project.sh` — deterministic copier.
- `skills/project-init/SKILL.md` and `references/workflow.md` — boundaries.
- `IMPLEMENTATION_PLAN.md` — task order and evidence.
