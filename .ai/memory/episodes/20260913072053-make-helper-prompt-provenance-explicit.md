# Make helper prompt provenance explicit

Date: 2026-09-13
Feature: project-init

## Context

The bootstrap copies helper prompts into a tracked `.ai/prompts/` directory,
but prompt text could otherwise be mistaken for runtime skill discovery or
authority.

## Goal

Complete TASK-0045 by defining tracked .ai/prompts ownership, provenance, routing, and non-discovery boundaries.

## Why

Projects need to know where prompts came from, which skill owns their workflow,
and how target edits are governed without turning tracked documentation into
an unreviewed execution channel.

## Outcome

Added a prompt-contract reference, provenance comments to every bundled helper prompt, routing-index guidance, and manifest/skill/workflow links that keep prompts as documentation rather than skills or authorization.

## Current State

TASK-0045 is complete. Every bundled helper prompt has a provenance comment;
the routing index, template manifest, skill, and workflow define preserve-first
ownership and explicit loading through the named skill.

## Important Findings

- The target prompt directory is intentionally tracked and must not be added
  to `.gitignore`.
- Prompt provenance is useful per file, while the README remains the routing
  index and the prompt contract owns the detailed safety boundary.

## Decisions

- Prompts are documentation, not skills, executable code, hidden configuration,
  or automatic runtime instructions.
- Missing prompts may be copied from the bundled template; existing prompts are
  preserved and revised only through a reviewed project-control change.
- If a named skill is unavailable, report a manual fallback without bypassing
  approval, scope, or secret-safety rules.

## Failed Approaches

-

## Validation

- Targeted Markdown lint passed for the changed references, README, templates,
  and all helper prompts.
- Focused inspection confirmed provenance comments on every prompt and links
  from the skill, workflow, and manifest.

## Open Questions

- Runtime-specific prompt discovery remains intentionally untested; the
  contract requires that it not be assumed.

## Next Steps

- Continue with TASK-0046: document separate exact-target Git initialization
  approval and the no-Git fallback.

## Relevant Files

- `skills/project-init/references/prompt-contract.md`
- `skills/project-init/templates/.ai/prompts/README.md`
- `skills/project-init/templates/.ai/prompts/*.md`
- `skills/project-init/references/template-manifest.md`
- `skills/project-init/SKILL.md`
- `skills/project-init/references/workflow.md`
