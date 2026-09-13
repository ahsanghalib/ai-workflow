# Shared skill install layout

Date: 2026-09-12
Feature: agent-memory

## Context

The optional `skills/agent-memory/README.md` package file was removed. During
the cleanup, the installation smoke test still modeled provider-specific
`.codex/skills` and `.config/opencode/skills` directories, although this
repository's installer places shared skills under `~/.agents/skills`.

## Goal

Keep installation smoke coverage aligned with the shared ~/.agents/skills location after removing the optional package README.

## Why

Tests should exercise the filesystem layout users actually receive from the
installer. The skill's portable entrypoint should not depend on a package README
that is not part of the installed resource set.

## Outcome

Removed the optional package README, changed the smoke test to copy only
`SKILL.md`, `AGENTS-SNIPPET.md`, `scripts/`, and `templates/` into a shared
`.agents/skills/agent-memory` layout, and updated the review ledger and session
state to reflect the current contract.


## Current State

The skill package uses `SKILL.md` as its single installed entrypoint. The
installer-aligned smoke test passes against the shared skills layout. Older
episodes may still mention the README because they record earlier repository
states.

## Important Findings

- `README.md` at the repository root documents the installer-owned shared
  `~/.agents/skills` location.
- Provider runtime configuration directories remain relevant to separate
  runtime setup, but they are not the shared skill installation fixture.
- Removing an optional package document requires checking tests and current
  review evidence for stale assumptions; historical episodes should remain
  unchanged.

## Decisions

- Keep `SKILL.md` as the only installed skill entrypoint and keep
  `AGENTS-SNIPPET.md` as separate optional reference material.
- Model the install smoke test with `.agents/skills/agent-memory` under a
  disposable temporary home equivalent.
- Do not rewrite older episodes merely because they refer to files that existed
  when those episodes were recorded.

## Failed Approaches

- The previous smoke fixture tested `.codex/skills` and
  `.config/opencode/skills`, which did not match the repository installer’s
  shared skill destination.
- Keeping README in the copied resource list made the smoke test fail after
  the intentional package cleanup.

## Validation

- The shared-layout installation smoke test passed after the fixture update.
- The full suite ran 24 tests: 23 passed and one FTS5-conditional test was
  skipped because this SQLite runtime provides FTS5.
- Ruff, Pyright, `bash validate-skills.sh`, `bash -n bin/*`, Python compilation,
  and `git diff --check` passed.

## Open Questions

- None for the current installation and skill-entrypoint contract.

## Next Steps

- If the installer layout changes, update the smoke fixture and root install
  documentation together.
- Keep later documentation cleanup separate from runtime skill behavior.

## Relevant Files

- `skills/agent-memory/SKILL.md` — single installed entrypoint.
- `skills/agent-memory/tests/test_memory_management.py` — shared-layout smoke
  test.
- `script.sh` — installer that creates shared `~/.agents/skills` links.
- `README.md` — root installation documentation.
- `skill-review.md` — current review resolutions.
