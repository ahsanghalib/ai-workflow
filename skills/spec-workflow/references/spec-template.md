# SPEC Template

Use this template for substantive work. Remove optional sections that do not
carry a real decision. Do not add a separate PLAN for the normal workflow.

```markdown
# SPEC-0001 — <short title>

Status: Draft
Type: <one supported work type>

## Problem

<What problem exists, for whom, and what evidence supports it?>

## Goal

<Observable outcome this SPEC must achieve.>

## Context / Evidence
<!-- Optional. Include only relevant repository, user, or research evidence. -->

## Requirements

- <The behavior that must exist.>

## Acceptance Criteria

- [ ] <Observable success or failure condition.>

## Non-goals
<!-- Optional. State explicit exclusions when scope could be confused. -->

## Constraints
<!-- Optional. Include user, product, compatibility, security, or operational
constraints. -->

## Impact
<!-- Optional. Mention API, persistence, frontend, security, or compatibility
impact. -->

## Open Questions
<!-- Optional. Material user-owned decisions must be resolved before approval. -->

---

# Execution

## Technical Design
<!-- Optional. Record only approved or behavior-preserving design conclusions. -->

## Data Design
<!-- Optional. Use when persistence design is justified. Prefer executable
schema as structural truth. -->

## Tasks

- [ ] TASK-001 — <first dependency-ready action>

## Validation

- <Focused command or inspection and the evidence it must produce.>

## Implementation Notes

<Short-lived decisions, blockers, and task evidence.>

## Tracking
<!-- Optional. GitHub issue/project/PR references are tracking metadata, not
requirements. -->
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
