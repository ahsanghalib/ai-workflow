# SPEC-EXAMPLE-001: Documentation labels

Status: Approved
Approval: Explicit user approval — 2026-10-01

## Behavioral contract

The docs directory index must identify the glossary as the canonical term list.

# Execution

## Tasks

- [x] T0: Confirm the documentation scope.
- [ ] T1: Add a glossary parser test. Depends on external parser contract, not yet available.
- [ ] T2: Update `evals/files/README-fragment.md` to say the glossary is the canonical term list. Depends on T0.
- [ ] T3: Add cross-links from the API guide. Depends on T2.

### Evidence and exceptions

T0 is complete. T1 remains unchecked and blocked on the unavailable external parser contract, while T2 is the first dependency-ready task. Documentation wording has no meaningful automated test seam; T2 has an explicit TDD exception. Alternative validation: inspect the changed sentence against the behavioral contract and run `git diff --check`.
