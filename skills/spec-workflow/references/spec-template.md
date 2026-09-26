# SPEC Template

Use this template for substantive work. The default skeleton contains only
required contract and execution sections. Add an optional section below only
when it carries a real decision. Keep execution tasks inside this SPEC.

```markdown
# SPEC-0001 — <short title>

Status: Draft
Type: <one supported work type>

## Problem

<What problem exists, for whom, and what evidence supports it?>

## Goal

<Observable outcome this SPEC must achieve.>

## Requirements

- <The behavior that must exist.>

## Acceptance Criteria

- [ ] <Observable success or failure condition.>

---

# Execution

## Tasks

- [ ] TASK-001 — <first dependency-ready action>

## Validation

- <Focused command or inspection and the evidence it must produce.>

## Implementation Notes

<Short-lived decisions, blockers, and task evidence.>

```

Optional contract sections (add only when applicable):

```markdown
## Context / Evidence
<!-- Relevant repository, user, or research evidence. -->

## Non-goals
<!-- Explicit exclusions when scope could be confused. -->

## Constraints
<!-- User, product, compatibility, security, or operational constraints. -->

## Impact
<!-- API, persistence, frontend, security, or compatibility impact. -->

## Open Questions
<!-- Material user-owned decisions that must be resolved before approval. -->
```

Optional execution sections (add only when justified):

```markdown
## Technical Design
<!-- Approved or behavior-preserving design conclusions. -->

## Data Design
<!-- Persistence design when justified; prefer executable schema as structural
truth. -->

## Tracking
<!-- Verified, user-approved Issue/Project/PR references only. -->
```

## Template rules

- Keep everything above `# Execution` limited to the behavioral contract.
- Supported work types are Feature, Bug, Improvement, Refactor, Performance,
  Security, Migration, Maintenance, and Technical Debt.
- Keep tasks local to this SPEC as `TASK-001`, `TASK-002`, and so on; the
  combined identity is `SPEC-####/TASK-###`.
- Replace the placeholder type with one concrete type; do not leave the pipe-
  separated choices in a real SPEC.
- Add `Approval: Explicit user approval — YYYY-MM-DD` only after the user
  explicitly approves the contract.
- Clear approval evidence and return to `Status: Draft` if the contract
  changes after approval.
