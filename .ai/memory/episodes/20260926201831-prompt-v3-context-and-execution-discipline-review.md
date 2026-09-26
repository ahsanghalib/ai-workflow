# Prompt v3 context and execution discipline review

Date: 2026-09-26
Feature: project-init context discipline

## Context

Prompt-v3 §62 requires deterministic context gathering, smallest-coherent
edits, focused checkpoints, and a final full-validation/diff pass. The public
repository already had related guidance in global instructions and README.

## Goal

Find and close any gap between that distributed guidance and the enforceable
project-init workflow contract without creating parallel planning state.

## Why

Refactor work can pass an isolated test while missing a handoff, ownership,
stale-reference, or safety boundary. The workflow needs explicit checkpoints
that future changes can be regression-tested.

## Outcome

Added a context/execution-discipline section to the existing project-init
workflow reference. It now requires relevant-skill-graph, handoff-contract,
test-expectation, and artifact-ownership inspection; smallest coherent edits;
contract-test updates; focused tests after major areas; and full-suite,
stale-reference, legacy-dependency, and diff checks before handoff. Added
regression assertions, §62 tracking, and session handoff updates. No runtime
or remote mutation was performed.

## Current State

Section 62 is complete and the worktree remains intentionally uncommitted.
Section 63 is the next review target. Temporary `prompt-v3.md` and `todo.md`
remain untracked by design.

## Important Findings

- Existing global instructions and README guidance covered much of §62, but
  the project-init workflow reference did not present it as one contract.
- The existing safeguards contract test was the appropriate regression seam;
  a new reference or planning artifact would have duplicated ownership.

## Decisions

- Extend `skills/project-init/references/workflow.md` because it already owns
  inspect/reconcile/edit/validate/handoff discipline.
- Keep the rules harness-neutral and avoid adding provider-specific commands,
  a metadata registry, or a separate execution plan.

## Failed Approaches

- None. Focused safeguard and project-init tests passed after the contract
  additions.

## Validation

- `bash skills/project-init/tests/test-safeguards-contract.sh` — passed.
- `bash skills/project-init/tests/test-project-init.sh` — passed, including all
  child project-init contracts.
- Full suite and structural checks remain scheduled for the final pass after
  the session/episode edits.

## Open Questions

- None for §62. The next section covers anti-overengineering constraints.

## Next Steps

- Review prompt-v3 §63, check for unnecessary registries, duplicate state,
  mandatory external services, or speculative project artifacts, then rerun
  focused and full validation.

## Relevant Files

- `skills/project-init/references/workflow.md` — authoritative discipline
  contract.
- `skills/project-init/tests/test-safeguards-contract.sh` — regression
  assertions for the contract.
- `todo.md` — §34 tracking checklist.
- `SESSION_STATE.md` — current handoff and next section.
