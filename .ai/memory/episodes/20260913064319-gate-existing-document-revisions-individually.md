# Gate existing-document revisions individually

Date: 2026-09-13
Feature: project-init

## Context

TASK-0026 strengthens the reconciliation approval boundary after the per-file
proposal report.

## Goal

Complete TASK-0026 with explicit approval before changing existing project-control or source-of-truth files.

## Why

Existing project-control files may encode deliberate decisions and local
conventions. A general bootstrap approval must not authorize rewriting them.

## Outcome

Added individual exact-diff approval rules for AGENTS, README, plans, architecture, user flow, schema, rules, indexes, .gitignore, and equivalents; declined revisions remain unchanged.

## Current State

TASK-0001 through TASK-0026 are complete. TASK-0027, existing-project Git
initialization and `.gitignore` proposal handling, is next. No existing file
was revised by this task.

## Important Findings

- The approval list must explicitly cover AGENTS, README, master plan,
  architecture, user flow, schema, rules, plans, indexes, `.gitignore`, and
  equivalent sources.
- Exact proposed diffs and compatibility impact are needed per file.
- Declining a revision must preserve that file byte-for-byte while allowing
  independent approved operations to continue.

## Decisions

- Treat every existing-file revision as its own approval scope.
- Keep missing-file creation approval separate from revision approval.
- Do not silently migrate a source-of-truth layout or merge ignore rules.

## Failed Approaches

No implementation approach failed; this was documentation-only approval and
preservation work with no meaningful runnable behavior seam.

## Validation

- Markdown lint and focused inspection of the approval list, exact-diff rule,
  compatibility requirement, and declined-revision behavior passed.

## Open Questions

Each reconciliation still needs user decisions for its proposed revisions and
any source-of-truth conflict.

## Next Steps

Implement TASK-0027 while keeping Git initialization and ignore-file proposals
separate from existing-file revisions.

## Relevant Files

- `skills/project-init/SKILL.md` — existing-file approval boundary.
- `skills/project-init/references/workflow.md` — approval sequence.
- `skills/project-init/templates/.ai/prompts/reconcile-existing-project.md` —
  per-file revision prompt.
- `IMPLEMENTATION_PLAN.md` — task order and evidence.
