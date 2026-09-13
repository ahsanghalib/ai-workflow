# Verify project-init policy boundaries

Date: 2026-09-13
Feature: project-init

## Context

TASK-0039 adds semantic policy assertions to the disposable project-init test
suite.

## Goal

Complete TASK-0039 with semantic checks for ignore, env, prompts, schema, and Git behavior.

## Why

Structural copying tests alone do not prove secret-ignore, tracked-prompt,
conditional-schema, or no-commit/no-remote policy.

## Outcome

Aggregate disposable tests verify .env is ignored but never created/read, .ai/prompts stays trackable, schema is conditional, and explicit Git init creates no commit or remote.

## Current State

TASK-0001 through TASK-0039 are complete. TASK-0040, broad static and semantic
validation, is next.

## Important Findings

- `git check-ignore --no-index` can verify `.env` policy without creating or
  reading an `.env` file.
- The same check confirms `.ai/prompts/` remains trackable.
- Temporary Git repositories can prove explicit init creates metadata only,
  without commits or remotes.

## Decisions

- Keep semantic policy assertions in the aggregate disposable suite.
- Continue using temporary directories only.
- Treat the absence of secret content and application files as required output
  boundaries.

## Failed Approaches

No implementation approach failed; the added assertions passed with the
existing helper behavior.

## Validation

- `bash skills/project-init/tests/test-project-init.sh` passed, including
  ignore, env, tracked prompt, conditional schema, and Git checks.

## Open Questions

Interactive approval and fresh-harness behavior remain manual checks.

## Next Steps

Implement TASK-0040 with complete Markdown, shell, validator, link, ID, status,
whitespace, and semantic checks.

## Relevant Files

- `skills/project-init/tests/test-project-init.sh` — semantic policy suite.
- `skills/project-init/templates/.gitignore.template` — ignore policy source.
- `skills/project-init/scripts/init-project.sh` — schema/Git behavior.
- `IMPLEMENTATION_PLAN.md` — task order and evidence.
