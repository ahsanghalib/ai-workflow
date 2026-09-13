# Document the full project-init user journey

Date: 2026-09-13
Feature: project-init

## Context

TASK-0035 updates the root README after the project-init bootstrap,
reconciliation, technical, schema, and feature-lifecycle work.

## Goal

Complete TASK-0035 by updating the root README for non-technical new and existing project use.

## Why

The repository is used by non-technical users as well as engineers. The README
must explain what happens, what is safe, what needs approval, and what comes
next without requiring knowledge of internal skill names.

## Outcome

README now includes the plain-language entry prompt, mode detection, technical-question flow, USER_FLOW then conditional DB_SCHEMA order, tracked prompts, .env safety, approval gates, and SPEC/PLAN lifecycle.

## Current State

TASK-0001 through TASK-0035 are complete. TASK-0036, documenting the
deterministic initializer boundary, is next. The README remains documentation;
no application code or runtime behavior was changed.

## Important Findings

- The plain-language first prompt should route to inspection and proposal
  without requiring internal mode names.
- The user-facing order must be MASTER_PLAN -> USER_FLOW -> conditional
  DB_SCHEMA -> SPEC/review -> PLAN/review -> approved implementation.
- `.ai/prompts/` is tracked routing documentation, while `.env` values remain
  completely out of scope.

## Decisions

- Explain both new/empty and existing/reconciliation modes.
- Show technical questions and approval boundaries in plain language.
- Keep the script an optional implementation detail, not the primary workflow.

## Failed Approaches

No implementation approach failed; this was documentation-only README work
with no meaningful runnable behavior seam.

## Validation

- Markdown lint, link checks, retired-name scanning, and focused project-init
  lifecycle/safety inspection passed.

## Open Questions

The README can be refreshed again after final research-hardening tasks add the
compatibility matrix and conversational acceptance evidence.

## Next Steps

Implement TASK-0036 and keep the deterministic helper boundary clear in both
the skill reference and user guide.

## Relevant Files

- `README.md` — non-technical project-init guide.
- `skills/project-init/SKILL.md` — workflow source.
- `IMPLEMENTATION_PLAN.md` — task order and evidence.
