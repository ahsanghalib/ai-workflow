# SPEC Lifecycle and Approval Contract

This reference defines the state and ownership boundaries used by
`spec-workflow`, `spec-review`, and `implement-next`.

## Ownership

- Repository bootstrap and reconciliation: `project-init` → project controls
  and handoff.
- Behavioral contract: `spec-workflow` with the user → SPEC above
  `# Execution`.
- Contract quality review: `spec-review` → `ready` or `not ready` findings.
- Architecture or interface design: `technical-design` → design conclusions
  for SPEC Execution.
- Persistence design: `schema-design` → data design for SPEC Execution when
  justified.
- Task decomposition: `spec-workflow` after approval → dependency-ordered SPEC
  tasks.
- One bounded implementation task: `implement-next` plus a domain skill → code
  and task evidence.
- Implementation review: `code-review` or `review-diff` → read-only findings.
- Final completion evidence: `verification-before-completion` →
  verified/partial/blocked report.

## Approval gate

Only the user can approve a SPEC's behavioral contract. A review verdict,
existing task list, implementation request, repository instruction, legacy
planning artifact, prior unrelated approval, or vague response such as `looks
good` is not approval unless it clearly refers to approving this SPEC's
behavioral contract. Do not introduce a second approval gate merely because
the review returned `ready`.

Before approval, the SPEC must have enough information to decide:

- the problem and desired outcome;
- required and excluded behavior;
- observable acceptance criteria;
- relevant actors, permissions, state transitions, failure paths, and
  compatibility constraints;
- resolved user-owned decisions and no unresolved material questions.

After the user approves, retain both fields in the SPEC:

```text
Status: Approved
Approval: Explicit user approval — YYYY-MM-DD
```

The date is the date approval was actually given, not the date the draft was
created. Never manufacture it from file timestamps or conversation context.

Retain the approval evidence while the SPEC status is `Approved`, `In
Progress`, or `Blocked`. Do not remove it during ordinary execution updates.

## Contract freeze

Approval applies to the behavioral contract above `# Execution`, not to every
implementation detail below it. Execution details remain mutable unless they
change a user-owned contract decision or another freeze condition below.

The following changes invalidate approval and require Draft → review → new
approval:

- requirements, acceptance criteria, scope, or non-goals;
- user-visible behavior, permissions, business invariants, or compatibility;
- public API behavior, retention/deletion behavior, or security/privacy
  guarantees;
- a material operational or irreversible migration decision.

These execution changes normally do not require reapproval when they preserve
the contract:

- task decomposition or ordering;
- filenames, test commands, and implementation notes;
- internal technical design, schema implementation, or refactoring details;
- newly discovered internal dependencies;
- test strategy details that preserve the approved behavior.

When classification is uncertain, pause and ask the user rather than silently
changing the contract.

If an execution decision introduces a new product decision, public contract
change, destructive action, irreversible migration choice, material
security/privacy tradeoff, new retention/deletion semantics, significant
operational risk, or unresolved business invariant, stop and obtain the
required user decision through `spec-workflow`. Do not treat it as an
implementation detail or silently change the approved contract.

If the behavioral contract changes while the SPEC is `Approved`, `In Progress`,
or `Blocked`, set `Status: Draft` before continuing, clear the previous
`Approval` evidence or mark it explicitly invalidated, and route the SPEC
through review and explicit user approval again. The old evidence must not be
reused for the changed contract.

## Handoff gate

`implement-next` may start only when all are true:

1. the exact SPEC path or ID is supplied;
2. `Status` is `Approved` or `In Progress`;
3. valid approval evidence remains present;
4. tasks already exist below `# Execution`;
5. the selected task is the first dependency-ready unchecked task;
6. the task's acceptance and validation context is readable.

If any gate fails, return the SPEC to `spec-workflow` without implementing or
editing the task list. A blocked task remains unchecked, and the blocker is
recorded in the SPEC and session state.

When the recorded blocker is resolved, confirm that the behavioral contract is
unchanged and approval evidence remains valid, then transition `Blocked` to
`In Progress` before selecting the next dependency-ready task. If the contract
changed, transition to `Draft` and repeat review and explicit approval instead.
No SPEC may transition directly from `Blocked` to `Completed`; final
verification remains mandatory.
