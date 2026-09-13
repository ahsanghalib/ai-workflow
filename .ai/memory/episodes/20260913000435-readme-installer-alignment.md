# README installer alignment

Date: 2026-09-13
Feature: repository-installation

## Context

The repository installer is `script.sh`. It links runtime-specific agents and
global instructions into the Codex/OpenCode locations, but links shared skills
into the common `~/.agents/skills` directory. The root README did not make that
mapping explicit and its runtime setup examples still suggested copying skills
again.

## Goal

Document the actual script.sh link destinations and keep runtime setup from reinstalling shared skills.

## Why

Installation documentation must describe the executable source of truth. A
future user should know which paths `script.sh` owns and which later steps only
configure runtime files, without creating duplicate skill installations.

## Outcome

The root README now includes the source-to-destination link table, identifies
`~/.agents/skills` as the canonical shared-skill location, and removes the
provider-specific skill-copy commands. `script.sh --help` now describes the
same behavior.


## Current State

The installer and README agree: shared skills are linked under
`~/.agents/skills/<skill-name>`, while agents and global instructions use their
runtime-specific directories. The agent-memory smoke test models this shared
layout, and the optional package README is not installed or required.

## Important Findings

- Runtime configuration and shared skill installation are separate concerns.
- `CODEX_HOME` and `XDG_CONFIG_HOME` affect runtime agent/instruction links;
  the shared skill destination remains under the user's home `.agents` folder.
- The smoke test should use a disposable equivalent of `~/.agents/skills`, not
  provider-specific skill directories.

## Decisions

- Keep `script.sh` as the installer source of truth and document its exact link
  mapping in the root README.
- Do not copy skills again during OpenCode or Codex configuration setup.
- Keep `SKILL.md` as the installed skill entrypoint; no package README is
  required.

## Failed Approaches

- The earlier README and smoke test treated `.codex/skills` and
  `.config/opencode/skills` as installation destinations, which did not match
  `script.sh`.
- A vague statement that the installer links skills "into both runtimes" hid
  the shared destination and could lead to duplicate copies.

## Validation

- `bash -n script.sh` and `bash script.sh --help` passed.
- The full agent-memory suite ran 24 tests: 23 passed and one FTS5-conditional
  test was skipped because this SQLite runtime provides FTS5.
- Ruff, Pyright, `bash validate-skills.sh`, and `git diff --check` passed.
- The episode was reindexed and passed the memory-index integrity check.

## Open Questions

- Live Codex/OpenCode discovery remains outside this repository-only validation.

## Next Steps

- If installer destinations change, update `script.sh`, the root README, and
  the shared-layout smoke test together.

## Relevant Files

- `script.sh` — installer implementation and help text.
- `README.md` — documented installation and link mapping.
- `skills/agent-memory/tests/test_memory_management.py` — installed shared
  layout smoke test.
- `skills/agent-memory/SKILL.md` — installed skill contract.
