# Inventory existing project evidence safely

Date: 2026-09-13
Feature: project-init

## Context

TASK-0022 begins existing-project reconciliation with a deterministic,
read-only evidence inventory.

## Goal

Complete TASK-0022 with read-only evidence classification for reconciliation without reading secrets or following symlinks.

## Why

Project-init needs to find source-of-truth candidates without opening secrets,
walking dependency trees, or following symlinks into uncontrolled locations.

## Outcome

Added inventory-project.sh and disposable coverage for instructions, plans, architecture, schema, manifests, source, validation, sensitive names, symlinks, and pruned dependency directories.

## Current State

TASK-0001 through TASK-0022 are complete. TASK-0023, source-of-truth layout
detection and preservation, is next. Inventory does not write files or Git
state.

## Important Findings

- Relevant filenames are useful evidence for instructions, planning,
  architecture, user flow, schema, manifests, source, validation, repository
  metadata, and configuration.
- `.env`, key-like files, credentials, and secret-like names can be reported as
  names only; the test uses sentinels to ensure values never reach output.
- Common dependency/generated directories should be pruned, and symlink entries
  should be reported without following them.

## Decisions

- Use `inventory-project.sh` as an evidence-only helper after mode detection.
- Treat classifications as evidence, not authorization or proof of a source of
  truth; the agent must inspect relevant safe files under repository rules.
- Keep inventory depth bounded and prune common dependency/generated trees.

## Failed Approaches

The first test failed because the inventory helper did not exist; adding the
helper and its safe classification output made the test pass.

## Validation

- `bash skills/project-init/tests/test-inventory-project.sh` passed.
- `shellcheck skills/project-init/scripts/inventory-project.sh
  skills/project-init/tests/test-inventory-project.sh` passed.
- `bash -n skills/project-init/scripts/inventory-project.sh` passed.
- Sensitive-content, symlink, pruning, and extra-argument assertions passed.

## Open Questions

Reconciliation still needs explicit rules for choosing among multiple planning,
architecture, schema, and instruction sources.

## Next Steps

Implement TASK-0023 while preserving every existing source-of-truth name unless
the user approves a migration or compatibility decision.

## Relevant Files

- `skills/project-init/scripts/inventory-project.sh` — safe evidence inventory.
- `skills/project-init/tests/test-inventory-project.sh` — inventory coverage.
- `skills/project-init/SKILL.md` — reconciliation invocation.
- `skills/project-init/references/workflow.md` — evidence boundaries.
- `IMPLEMENTATION_PLAN.md` — task order and evidence.
