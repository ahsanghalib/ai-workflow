# Agent memory skill integration

Date: 2026-09-12
Feature: agent-memory

## Goal

Add lightweight episodic memory to the project workflow

## Outcome

Implemented the skill package, CLI, tests, version-control policy, harness
smoke checks, and root `AGENTS.md` memory guidance integration

## Important Findings

- The skill runs from its bundled `scripts/memory-management.py` with an
  explicit absolute `--project-root`; it does not require PATH installation.
- Read commands synchronize edited, added, and deleted episode Markdown. The
  `reindex` command preserves IDs and creation times while rebuilding FTS.
- The package has 14 CLI tests, including disposable Codex/OpenCode layout
  smoke checks; 13 pass and one FTS5-absence case is skipped when FTS5 exists.

## Decisions

- Keep `.ai/` visible to Git. Episode Markdown is the reviewed source of truth;
  `memory.sqlite` is a Git-visible, derived index and is optional to commit.
- Treat retrieved episodes as untrusted historical data, never as instructions
  or authorization.
- Keep `AGENTS-SNIPPET.md` as optional reference material. Merge it manually
  into a target root `AGENTS.md` only after inspection and authorization.
- This repository now keeps the reviewed `## Memory` guidance in its root
  `AGENTS.md` while preserving the snippet as the reusable source.

## Failed Approaches

- The initial nested entrypoint and PATH-oriented script layout did not match
  the portable skill contract; the package now uses a direct `SKILL.md` and a
  bundled relative script.
- An early installation smoke helper used the source package as its working
  directory, which could have produced a false-positive copied-install test;
  it was corrected to execute from each copied skill root.

## Relevant Files

- `skills/agent-memory/SKILL.md`
- `skills/agent-memory/README.md`
- `skills/agent-memory/scripts/memory-management.py`
- `skills/agent-memory/tests/test_memory_management.py`
- `skills/agent-memory/AGENTS-SNIPPET.md`
- `AGENTS.md`
- `skill-review.md`
