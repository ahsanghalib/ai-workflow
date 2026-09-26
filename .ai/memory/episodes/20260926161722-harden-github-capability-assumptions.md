# Harden GitHub capability assumptions

Date: 2026-09-26
Feature: project-init prompt-v3 reconciliation

## Context

Prompt-v3 section 38 required the public skills repository to remain
harness-agnostic around GitHub capability and remote mutation. Section 36's
tracking reference already had local-authority and approval rules, but its
non-assumptions were incomplete.

## Goal

Document the missing GitHub API, MCP/plugin, CLI, network, permission, and
tool-contract boundaries and protect them with regression assertions.

## Why

An unavailable integration must not be simulated with invented commands or
fake tracking data, and local SPEC work must remain usable without GitHub.

## Outcome

Updated `skills/spec-workflow/references/github-tracking.md` to state the
harness-agnostic capability assumptions and prohibit fake tool contracts or
shell behavior. Added assertions to `test-contract.sh` and kept the local
fallback and explicit-approval sequence intact. Advanced `SESSION_STATE.md`
through section 38.

## Current State

Section 38 is complete and the worktree remains intentionally uncommitted.
Prompt-v3 section 39 is the next review target.

## Important Findings

- Tool names do not prove that API, MCP/plugin, authenticated CLI, network,
  permissions, or remote mutation support is available.
- Missing capability or approval leaves remote tracking unset and must be
  reported; it does not block local SPEC work.

## Decisions

- Keep capability-safety rules in the routed GitHub tracking reference, while
  retaining provider-specific CLI execution in `github-cli-workflow`.
- Require both capability verification and exact user approval before a remote
  mutation, followed by verification of the resulting reference.

## Failed Approaches

- The first test searched for a phrase split across wrapped Markdown lines;
  it was replaced with line-safe assertions before the focused checks passed.

## Validation

- Passed SPEC lifecycle, cross-skill, design-completion, project-init, and
  traceability contract suites.
- Passed project-init disposable/acceptance tests and `validate-skills.sh`.
- Passed Markdownlint, Bash syntax, ShellCheck, and `git diff --check`.
- Live GitHub capability and harness reload were not exercised.

## Open Questions

- None for section 38.

## Next Steps

1. Review prompt-v3 section 39 and fix concrete gaps in place.
2. Keep temporary `prompt-v3.md` and `todo.md` uncommitted.

## Relevant Files

- `skills/spec-workflow/references/github-tracking.md` — capability boundary.
- `skills/spec-workflow/tests/test-contract.sh` — regression assertions.
- `skills/github-cli-workflow/SKILL.md` — conditional CLI adapter.
- `SESSION_STATE.md` — current handoff state (ignored).
