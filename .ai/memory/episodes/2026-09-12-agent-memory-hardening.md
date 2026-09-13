# Agent-memory hardening

Date: 2026-09-12
Feature: agent-memory

## Goal

Harden the project-local episodic memory skill after reviewing its filesystem, retrieval, and index trust boundaries.

## Outcome

Added project-boundary checks, bounded episode ingestion, untrusted retrieval labels, provenance output, retention guidance, and FTS integrity verification.

## Important Findings

- Existing `.ai` storage and episode symlinks could redirect writes or reads;
  the CLI now rejects symlinked storage and episode paths and enforces the
  resolved project boundary.
- Episode input is capped at 256 KiB, title and feature metadata at 512
  characters, snippets at 2,000 characters, and fetched bodies at 12,000
  characters.
- Search, recent, and get output is untrusted historical data and now carries a
  visible marker plus source provenance; it must never authorize tool actions.
- SQLite FTS5 external-content indexes need synchronization and integrity
  checks; `verify` was added and `reindex` now verifies its rebuild.
- Natural-language searches can contain punctuation such as `agent-memory`;
  query normalization prevents punctuation from being interpreted as raw FTS5
  syntax.

## Decisions

- Keep episode Markdown as the reviewed source of truth and keep SQLite as a
  Git-visible but optional derived index.
- Keep `SESSION_STATE.md` ignored and local; use it for current handoff state,
  not durable episodic history.
- Make retention owner-controlled: deletion of source Markdown is explicit and
  reviewed, then synchronization removes the derived record.
- Require root `AGENTS.md` to create a new episode after verified meaningful
  work, while leaving earlier episodes unchanged as historical records.
- Treat search input as plain text and normalize punctuation before querying the
  derived FTS index.

## Failed Approaches

- The hardening work initially updated `SESSION_STATE.md` but did not create a
  new episode even though the skill already described when meaningful work
  should be stored. The root instructions now make that handoff step explicit.

## Relevant Files

- `AGENTS.md`
- `SESSION_STATE.md`
- `skills/agent-memory/SKILL.md`
- `skills/agent-memory/README.md`
- `skills/agent-memory/scripts/memory-management.py`
- `skills/agent-memory/tests/test_memory_management.py`
- `skill-review.md`
