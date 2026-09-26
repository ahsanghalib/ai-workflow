# Harden optional GitHub tracking boundaries

Date: 2026-09-26
Feature: project-init prompt-v3 reconciliation

## Context

While reconciling the public skill repository with prompt-v3, section 36
defined the boundary between local SPEC requirements and optional GitHub
tracking. The worktree already contained a broad uncommitted prompt-v3
reconciliation; this section was handled without staging or committing it.

## Goal

Make the reusable SPEC workflow reference and its regression coverage fully
match prompt-v3 section 36 without enabling remote mutations.

## Why

The repository must remain usable without GitHub, and remote Issues, Projects,
and Pull Requests must not become a second requirements source or acquire
invented identifiers and status.

## Outcome

Added and hardened `skills/spec-workflow/references/github-tracking.md` with
optional zero/one/multiple Issue mapping, compact Issue context plus an exact
SPEC reference, optional Project dashboard use, verified references under
`# Execution` → `## Tracking`, and explicit capability/approval/verification
boundaries for remote actions. Added contract assertions covering these rules.
Fixed the reference's Markdown line-length violation and advanced
`SESSION_STATE.md` through section 36.

## Current State

Section 36 is complete and the worktree remains intentionally uncommitted.
Prompt-v3 section 37 is the next review target.

## Important Findings

- A SPEC may have no GitHub mapping; creating an Issue is not implied by SPEC
  existence.
- GitHub Projects are dashboards only and do not own requirements, SPEC status,
  approval, or completion.
- Remote references are recorded only when verified; missing capability or
  approval leaves tracking unset.

## Decisions

- Keep GitHub guidance in a routed SPEC-workflow reference instead of embedding
  provider-specific behavior into the core local workflow.
- Require exact remote references and explicit user approval before any remote
  mutation; delegate GitHub CLI actions to the dedicated adapter skill.

## Failed Approaches

- The first documentation edit exceeded the repository's Markdownlint line
  length; it was split and linted again.

## Validation

- Passed `bash skills/spec-workflow/tests/test-contract.sh`.
- Passed `bash skills/spec-workflow/tests/test-cross-skill-contract.sh`.
- Passed lifecycle, design-completion, project-init contract, and project-init
  test suites.
- Passed `bash validate-skills.sh`, Markdownlint for all affected references,
  Bash syntax checks, ShellCheck, and `git diff --check`.
- Live GitHub access and harness reload were not exercised.

## Open Questions

- None for section 36; section 37 may add project-specific dashboard guidance
  that must preserve the same local-authority boundary.

## Next Steps

1. Review prompt-v3 section 37 and fix concrete gaps in place.
2. Keep the temporary prompt and todo artifacts uncommitted.

## Relevant Files

- `skills/spec-workflow/references/github-tracking.md` — GitHub boundary
  reference.
- `skills/spec-workflow/tests/test-contract.sh` — regression assertions.
- `skills/spec-workflow/SKILL.md` — routed reference entrypoint.
- `SESSION_STATE.md` — current handoff state (ignored).
