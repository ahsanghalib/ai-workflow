# Add adaptive project-init modes and approval gates

Date: 2026-09-13
Feature: project-init

## Context

`claude-findins.md` proposed five workflow changes to reduce wasted ceremony
for solo-founder iteration while preserving rigor for foundational and risky
work.

## Goal

Create the follow-up implementation plan and begin the adaptive mode, discovery,
ceremony, risk, and approval changes without committing or performing remote
operations.


## Why

The previous project-init wording made Strict the default for too many requests,
which could make small reversible work slower than necessary and could turn
exploratory ideas into formal SPEC/PLAN artifacts too early.

## Outcome

Added TASK-0059 through TASK-0064 to the disposable `IMPLEMENTATION_PLAN.md`.
Implemented all six tasks: ordinary reversible or exploratory work defaults to
Light, explicit bootstrap/reconciliation remains Strict, ambiguity resolves
lighter, exploratory features stop before SPEC creation, the review ceremony is
previewed, high-risk work escalates one mode level, and high-impact approvals
require an `Approving:` acknowledgement.


## Current State

The project-init focused suite and contract tests pass. The root skill validator,
Bash syntax, ShellCheck, and `git diff --check` pass. `SESSION_STATE.md` records
the current handoff. No commit, branch, remote, deployment, or application
implementation was performed.

## Important Findings

- Explicit project bootstrap is a foundational exception to the Light default;
  “use project-init to create an expense app” remains Strict.
- The Light default applies to ordinary change discussion and planning, not to
  high-impact persistence, public contract, auth, permission, actor, migration,
  or existing-source-of-truth work.
- Discovery and durable feature formalization are separate: an explored idea
  may inform a loose MASTER_PLAN proposal but does not receive a SPEC.
- Approval acknowledgement is intentionally limited to high-impact scopes so
  it does not recreate the ceremony the change is reducing.

## Decisions

- Use Light by default for small, reversible, exploratory, or non-durable work.
- Keep explicit new-project bootstrap and existing-project reconciliation in
  Strict mode.
- Resolve ambiguity toward Light unless the request clearly names a
  foundational operation.
- Escalate Light to Standard and Standard to Strict for specified risk signals.
- Require `Approving:` plus exact scope and forbidden-side-effect boundaries for
  high-impact writes; low-impact work keeps lightweight approval.

## Failed Approaches

- The first contract test expected the ceremony phrase in the workflow while
  it existed only in SKILL.md; the rule was made visible in both entrypoints so
  the routed reference and entry skill cannot drift.
- The first acceptance assertion expected a heading named `Default mode and
  escalation`; the heading was aligned with the durable contract instead of
  weakening the test.

## Validation

- `bash skills/project-init/tests/test-project-init.sh` passed.
- `bash -n skills/project-init/scripts/*.sh skills/project-init/tests/*.sh`
  passed.
- `shellcheck skills/project-init/scripts/*.sh skills/project-init/tests/*.sh`
  passed.
- `bash validate-skills.sh` passed.
- `git diff --check` passed.
- No live harness mode-selection or user-approval interaction was exercised.

## Open Questions

- Whether future user telemetry or examples should refine the boundary between
  Light discussion and Standard durable planning; current rules use explicit
  risk signals and user wording.

## Next Steps

- Keep the disposable implementation plan and review ledger available until the
  user confirms they can be removed.
- On the next session, read `SESSION_STATE.md` before continuing and verify the
  adaptive-mode references against current skill text.
- Do not commit unless the user later requests a scoped logical commit.

## Relevant Files

- `IMPLEMENTATION_PLAN.md` — TASK-0059 through TASK-0064.
- `skills/project-init/SKILL.md` — entry behavior, default mode, discovery,
  ceremony, and approval contract.
- `skills/project-init/references/workflow.md` — mode selection, risk
  escalation, and approval acknowledgement.
- `skills/project-init/references/feature-lifecycle.md` — decided-versus-
  explored gate.
- `skills/project-init/references/acceptance-scenarios.md` and
  `skills/project-init/tests/` — contract and acceptance evidence.
