# Rewrite README as a user guide

Date: 2026-09-13
Feature: Documentation and onboarding

## Context

The repository had a technically accurate but OpenCode-centric README. The
current checkout contains shared skills, parallel OpenCode/Codex profiles,
runtime configuration, an installer, worktree helpers, and project-local memory.

## Goal

Give a non-technical reader a clear way to understand the repository, install
only what they need, start safely, and find detailed reference material.

## Why

The repository is useful beyond its authoring environment, but machine-local
paths, runtime-specific settings, and the distinction between structural and
live validation are easy to misunderstand without an explicit guide.

## Outcome

Rewrote `README.md` as a user guide covering the quick start, installation,
OpenCode and Codex paths, first-run prompts, daily workflow, all current skills,
runtime files, safety model, worktree helpers, customization, maintenance,
validation, troubleshooting, glossary, sources, and license. The README now
marks the Codex configuration as machine-specific and keeps shared skill setup
separate from runtime configuration.

## Current State

The README change is uncommitted in the working tree. The earlier active
`project-init` wording cleanup remains uncommitted as a separate related change.
The ignored `SESSION_STATE.md` records the current handoff.

## Important Findings

- There are 49 active `SKILL.md` entrypoints, seven OpenCode profiles, and seven
  Codex profiles.
- `script.sh` links shared skills to `~/.agents/skills` and does not copy runtime
  configuration files.
- OpenCode's official documentation lists `~/.agents/skills` as a global skill
  location and `/connect` for provider connection.
- The Codex TOML contains local marketplace, plugin, executable, and MCP paths;
  it must be reviewed before copying to another machine.

## Decisions

- Keep the README friendly and explanatory while preserving copyable commands.
- Explain the minimal skills-only setup before the optional full runtime setup.
- Document live runtime, browser, provider, and application behavior as
  unverified unless the repository itself proves it.
- Keep historical memory records intact while scanning active content for stale
  runtime skill names.

## Failed Approaches

- The first large patch attempt was rejected because the patch encoded multiple
  operations for one file and two code-block lines lacked patch prefixes. The
  file was then replaced through separate delete and add patch operations.

## Validation

- `markdownlint README.md` passed.
- README internal-link and documented-path checks passed.
- README coverage check passed for all 49 active skills.
- Active-content scan found no retired planning-owner references.
- `bash validate-skills.sh` passed.
- `bash -n script.sh bin/*` and the project-init initializer syntax check passed.
- ShellCheck passed for the project-init initializer.
- Codex TOML parsing passed with Python `tomllib`.
- `git diff --check` passed.
- Runtime smoke checks confirmed the local OpenCode CLI exposes the documented
  `debug config` and `debug agent` commands. Provider authentication and live
  skill discovery were not exercised.

## Open Questions

- Whether the checked-in runtime model IDs remain available to every provider
  account is intentionally environment-specific.
- Codex skill discovery may vary by installed release and should be checked in
  the target environment after installation.

## Next Steps

- Review the complete README diff and commit only the intended documentation,
  project-init wording, and any explicitly approved memory history.
- Restart the selected runtime after installing or changing global skills.

## Relevant Files

- `README.md` — user-facing installation and usage guide.
- `script.sh` — shared agent, instruction, and skill linker.
- `validate-skills.sh` — structural skill validator.
- `opencode/opencode.json` — OpenCode permissions, providers, plugins, and MCP.
- `codex/config.toml` — Codex runtime defaults and machine-local integrations.
- `skills/*/SKILL.md` — portable task workflows.
