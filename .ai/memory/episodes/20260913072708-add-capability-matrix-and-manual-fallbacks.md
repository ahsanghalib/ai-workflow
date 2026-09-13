# Add capability matrix and manual fallbacks

Date: 2026-09-13
Feature: project-init

## Context

Project-init runs across harnesses with different approval, filesystem, shell,
Git, skill-routing, validation, continuity, and network capabilities.

## Goal

Complete TASK-0047 by defining capability states and safe fallbacks for missing approval, inspection, shell, Git, skill routing, validation, continuity, and research.

## Why

The workflow must degrade safely when a capability is unavailable without
silently writing, bypassing review, or claiming unperformed validation.

## Outcome

Added a routed capability-matrix reference and repeated its fallback boundary in the workflow, generated AGENTS template, and repository README.

## Current State

TASK-0047 is complete. The routed capability matrix defines available,
unavailable, and not-exercised states plus a bounded fallback and handoff for
each relevant capability.

## Important Findings

- A missing capability should block only the operation that depends on it; it
  must not broaden authorization for another operation.
- Manual fallbacks need to distinguish an unverified result from a successful
  helper or skill invocation.

## Decisions

- Approval and safe inspection are prerequisites for writes; without them,
  return a proposal only.
- Missing Git uses the existing documentation-only path and does not infer
  branch or history state.
- Missing named skills use a documented manual equivalent or stop, and never
  route to a retired planning name.
- Missing validation or continuity is explicitly reported as unverified or
  unpersisted.

## Failed Approaches

-

## Validation

- Targeted Markdown lint passed for the reference, skill, workflow, generated
  AGENTS template, README, plan, state, and helper prompts.
- `bash validate-skills.sh`, Bash syntax, ShellCheck, and the aggregate
  disposable suite passed.

## Open Questions

- Live capability discovery in each installed harness remains unexercised.

## Next Steps

- Continue with TASK-0048: add scenario-based acceptance evidence for the
  conversational workflow.

## Relevant Files

- `skills/project-init/references/capability-matrix.md`
- `skills/project-init/SKILL.md`
- `skills/project-init/references/workflow.md`
- `skills/project-init/templates/AGENTS.md`
- `README.md`
