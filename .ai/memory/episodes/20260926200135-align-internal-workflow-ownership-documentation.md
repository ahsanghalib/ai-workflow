# Align internal workflow ownership documentation

Date: 2026-09-26
Feature: prompt-v3 §59 internal documentation

## Context

Prompt-v3 §59 requires internal documentation to describe the routed skill
ownership model and avoid implying that every skill runs for every change. The
README had workflow examples but no single explicit conceptual model.

## Goal

Align the README and its skill catalog with the current SPEC/task lifecycle and
protect the documented ownership boundaries with a regression assertion.

## Why

Readers could infer that project-init planned features, schema-design was
always required before service changes, or review/verification skills had
approval or implementation ownership.

## Outcome

Added a README workflow-ownership table covering project-init, spec-workflow,
SPEC, spec-review, SPEC-local tasks, technical/schema design, implement-next,
GitHub tracking, and final verification. Corrected the skill catalog wording
and explicitly stated that routing is by need. Added cross-skill assertions for
the documented model.

## Current State

The §59 changes remain uncommitted for user review. The review cursor is now
prompt-v3 §60, and no application or remote state was changed.

## Important Findings

- README was the main repository documentation describing the architecture;
  supporting lifecycle references already matched the intended model.
- The schema-design catalog entry was the clearest stale implication because
  it read as a prerequisite for service or route changes.
- The new table distinguishes optional tracking and conditional design from
  the normal SPEC/task lifecycle.

## Decisions

- Keep the conceptual model in README near the explanation of how the pieces
  fit together, with the existing detailed skill files as procedural sources.
- Use the cross-skill contract test to protect documentation ownership and the
  routed-by-need rule without adding another test runner.
- Preserve unrelated worktree changes and do not commit.

## Failed Approaches

The first README patch was rejected because the patch tool does not allow two
operations targeting the same file in one patch. The changes were split into
valid surgical patches; no content was lost.

## Validation

- Passed the focused cross-skill contract test, Bash syntax, ShellCheck, and
  Markdownlint for README.
- Passed the full available repository checks, Markdownlint, memory-index
  verification, and `git diff --check`.

## Open Questions

None for §59. Live runtime skill discovery was not exercised.

## Next Steps

- Continue with prompt-v3 §60 when the user requests the next section.

## Relevant Files

- `README.md`
- `skills/spec-workflow/tests/test-cross-skill-contract.sh`
- `skills/project-init/references/feature-lifecycle.md`
- `todo.md`
- `SESSION_STATE.md`
