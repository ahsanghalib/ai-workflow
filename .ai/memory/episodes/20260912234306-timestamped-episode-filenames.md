# Timestamped episode filenames

Date: 2026-09-12
Feature: agent-memory

## Context

The `agent-memory` CLI generated episode names with a calendar-date prefix.
The skill now needs filenames that sort by creation time, while its centralized
limits should also cover the extra filename length and incoming search text.

## Goal

Use sortable UTC timestamps in episode filenames while keeping memory inputs and outputs bounded.

## Why

Date-only names do not preserve ordering within a day, and adding a fourteen-
digit prefix can make a previously accepted long title exceed common filesystem
component limits. Search input is also model-controlled and should fail before
an oversized query reaches SQLite.

## Outcome

`add` now creates UTC filenames in the form
`YYYYMMDDHHMMSS-<title-slug>.md`, while the Markdown `Date:` field stays in
readable `YYYY-MM-DD` form. `MemoryLimits` now also bounds generated filenames
to 240 characters and search queries to 512 characters, with concise errors.


## Current State

The timestamped naming and additional bounds are implemented and documented in
the skill and package README. Existing episodes retain their original paths;
the new naming applies to episodes created after this change.

## Important Findings

- UTC timestamps provide deterministic cross-machine ordering without relying
  on local timezone configuration.
- A 512-character title can produce a filename longer than the typical
  filesystem component limit after adding the timestamp and suffix.
- The existing 256 KiB source, 12,000-character body, 2,000-character snippet,
  20-result, and 512-character metadata bounds remain useful for this local
  skill; filename and query bounds close separate gaps.

## Decisions

- Use exactly fourteen UTC digits followed by a hyphen and the slug, preserving
  the requested `YYYYMMDDHHMMSS` prefix and chronological lexical sorting.
- Keep the human-readable `Date:` metadata unchanged for compatibility.
- Reject filenames over 240 characters instead of silently truncating a slug.
- Reject search queries over 512 characters before normalization and SQLite
  execution.

## Failed Approaches

- The previous `YYYY-MM-DD-<slug>.md` naming lost sub-day ordering and did not
  satisfy the requested timestamp prefix.
- Letting the filesystem reject long generated names exposed an opaque
  `File name too long` error; the CLI now validates the name first.
- Search previously had no explicit query-length bound even though other
  ingestion and retrieval paths were bounded.

## Validation

- The filename regression first failed against the old date-only format, then
  passed after the timestamp implementation.
- Filename-bound and query-bound regression tests first failed, then passed
  after explicit validation was added.
- The full suite ran 24 tests: 23 passed and one FTS5-conditional test was
  skipped because this SQLite runtime provides FTS5.
- Ruff, Pyright, `bash validate-skills.sh`, `bash -n bin/*`, Python compilation,
  CLI help, and `git diff --check` passed.

## Open Questions

- None for the current local-first scope.

## Next Steps

- Keep future filename or limit changes covered by CLI regression tests and
  update the skill, README, review ledger, and session capsule together.
- Handle the separately deferred package README cleanup only when requested.

## Relevant Files

- `skills/agent-memory/scripts/memory-management.py` — filename generation and
  centralized limit enforcement.
- `skills/agent-memory/tests/test_memory_management.py` — timestamp, filename,
  and query bound regressions.
- `skills/agent-memory/SKILL.md` — runtime limits and filename contract.
- `skills/agent-memory/README.md` — package usage and limit documentation.
- `skill-review.md` — review resolution and validation evidence.
