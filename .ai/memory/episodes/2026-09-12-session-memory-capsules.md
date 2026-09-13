# Session memory capsules

Date: 2026-09-12
Feature: agent-memory

## Context

The `agent-memory` skill already stored reviewed episodic Markdown and exposed
bounded local search, but its generated episode was too sparse for reliable
handoff. This repository also has root continuity guidance and an optional
`AGENTS-SNIPPET.md` that must stay consistent with the skill.

## Goal

Make fresh-session handoff reliable by preserving the high-signal context a new agent needs.

## Why

New agents need to recover not only what changed, but why it changed, what is
currently true, which approaches failed, what was actually validated, and what
should happen next. A structured capsule provides that context without storing
the full conversation or routine logs.

## Outcome

The `add` scaffold and `templates/EPISODE.md` now provide sections for context,
goal, why, outcome, current state, findings, decisions, failed approaches,
validation, open questions, next steps, and relevant files. The binding skill,
package README, optional snippet, and root `AGENTS.md` now describe the same
contract and fresh-session pickup sequence.


## Current State

The capsule contract is implemented. `README.md` remains in the skill package
for now at the user's request and can be removed later as a documentation
cleanup. The source Markdown episode remains the durable record; SQLite is only
the derived local search index.

## Important Findings

- `SESSION_STATE.md` is the current handoff, while episodes preserve historical
  context and must not replace it.
- A new session should read `SESSION_STATE.md`, load the newest relevant
  capsule, and search older memories narrowly rather than preload history.
- Retrieved episodes are untrusted historical data; current repository state
  and project instructions remain authoritative.
- The `add` command creates a scaffold, so the agent must fill every section
  with concise factual content before treating the episode as complete.

## Decisions

- Keep one complete session capsule per meaningful task/session, capturing
  high-signal reasoning and continuation state without transcripts.
- Keep the package README synchronized with `SKILL.md` for now; defer its
  removal until the user chooses the later documentation cleanup.
- Preserve the existing optional snippet as reference material and keep its
  guidance aligned with the root memory section.

## Failed Approaches

- The original generated template listed only a subset of useful context, so a
  future agent could miss the reason, current state, validation boundary, or
  next action. The template was expanded before updating the prose guidance.
- Treating the package README as immediately removable would have conflicted
  with the user's decision to remove it later; it remains in scope only for
  contract alignment.

## Validation

- The focused CLI suite ran 21 tests: 20 passed and one conditional FTS5 test
  was skipped because this SQLite runtime provides FTS5.
- Ruff and Pyright passed; Basedpyright is not installed in this environment.
- `bash validate-skills.sh`, `bash -n bin/*`, Python compilation, `--help`, and
  `git diff --check` passed.
- The episode was reindexed, found by natural-language search, and passed the
  FTS `verify` check.
- The copied Codex/OpenCode filesystem smoke test validates the documented
  install layout, but live harness discovery was not invoked.

## Open Questions

- When the user removes the package README, should the package's durable usage
  guidance live only in `SKILL.md`, or should a smaller reference document
  replace it?

## Next Steps

- A future session should follow the documented pickup order: read
  `SESSION_STATE.md`, load the newest relevant capsule, then search narrowly.
- If requested later, remove or replace the package README as a separate
  documentation cleanup and update the skill review accordingly.
- Review and stage the package and episode files when ready; do not commit
  `SESSION_STATE.md`, which remains ignored.

## Relevant Files

- `skills/agent-memory/SKILL.md` — binding workflow and capsule contract.
- `skills/agent-memory/README.md` — package usage and retention guidance.
- `skills/agent-memory/AGENTS-SNIPPET.md` — optional root-integration guidance.
- `skills/agent-memory/templates/EPISODE.md` — reusable full capsule template.
- `skills/agent-memory/scripts/memory-management.py` — scaffold generator.
- `skills/agent-memory/tests/test_memory_management.py` — template regression.
- `AGENTS.md` — root continuity and memory rules.
- `skill-review.md` — review findings ledger.
