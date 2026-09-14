# Update README for project-init and agent-memory

Date: 2026-09-13
Feature: documentation

## Context

The root README predated the latest project-init workflow repairs and did not
explain the project-local agent-memory CLI or the generated diagrams in
`assets/`.

## Goal

Update the README with current project-init behavior, agent-memory usage, and
links to the six generated project-init and agent-memory SVG assets.


## Why

The README is the user-facing entrypoint and must not describe stale scaffold,
approval, lifecycle, validation, or memory-index behavior.

## Outcome

README.md now documents adaptive modes, profile-selected outputs,
approval/foundation gates, feature traceability, API envelope defaults,
reconciliation inventory, the agent-memory CLI, and the Markdown-versus-ignored
SQLite boundary. All six SVG assets are linked with descriptive alt text.

The README and its six referenced SVG assets were committed as `3371430`
(`Document project-init and agent-memory workflows`). The Codex and OpenCode
engineer profiles were reviewed and committed separately as `e2c3c28`
(`Raise engineer profile reasoning depth`), changing both profiles from `high`
to `xhigh` reasoning depth.


## Current State

Both documentation and engineer-profile changes are committed locally. This
episode is committed as `ac80bd9`. The ignored `.ai/memory/memory.sqlite`
index remains local; episode Markdown is the durable source of truth.

## Important Findings

- Project-init now treats empty and `.git`-only targets as new projects and all
  other targets as existing/reconciliation targets.
- Optional user-flow, specialized rules, prompts, and schema outputs require
  profile review and explicit selections; foundation validation precedes
  feature planning.
- Feature planning keeps exploratory ideas out of SPEC creation and requires
  Proposed SPEC/PLAN review before user-owned approval transitions.

## Decisions

- Keep README guidance high-level and link the bundled helpers rather than
  duplicating their full procedures.
- Reference the generated SVGs in the relevant project-init and agent-memory
  sections so the assets explain the workflow where it is described.
- Keep `memory.sqlite` explicitly ignored and describe episode Markdown as the
  committable history.
- Commit the referenced SVG assets with the README so its local image links are
  complete, while keeping the engineer-profile behavior change in a separate
  focused commit.

## Failed Approaches

- The first memory examples relied on `memory_script` from an earlier code
  block; each later block was made self-contained.

## Validation

- `bash validate-skills.sh` passed.
- Bash syntax, the full project-init disposable/contract suite, and the
  24-test agent-memory suite passed; one FTS5-conditional test was skipped.
- All six SVGs parsed as well-formed XML, all referenced local paths exist, and
  `git diff --check` passed.
- Post-commit verification passed for both focused commits: the staged paths
  were exact, Codex TOML parsing passed, `bash validate-skills.sh` passed, and
  committed diff whitespace checks passed.
- The agent-memory index was reindexed and verified after this episode update.

## Open Questions

- Live harness reload, skill discovery, profile questioning, and approval
  behavior remain unverified; they are outside this repository-only commit.

## Next Steps

- No repository follow-up is required for this task. If needed later, restart
  or reload the target harness and verify live discovery and profile behavior.

## Relevant Files

- `README.md` — updated user-facing project-init and agent-memory guidance.
- `assets/*.svg` — six referenced workflow diagrams.
- `skills/project-init/` — current workflow, templates, helpers, and tests.
- `skills/agent-memory/` — current CLI, template, and tests.
