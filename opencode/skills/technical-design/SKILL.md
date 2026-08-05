---
name: technical-design
description: Use when proposing or comparing repository-grounded architecture, module boundaries, APIs, interfaces, seams, dependency strategies, migrations, or technical validation. Do not use for product discovery, founder decisions, repository inventory, delivery planning, or implementation.
license: MIT; adapted from Matt Pocock's codebase-design, domain-modeling, and to-spec workflows; see upstream metadata
compatibility: OpenCode Agent Skills; no bundled executable dependencies
metadata:
  upstream: https://github.com/mattpocock/skills/tree/2ab958093e83e0ec752e6c1c5932da465bf23e0c/skills/engineering
  upstream-license: MIT
  modified-for: OpenCode
---

# Technical Design

Produce a repository-grounded technical proposal before implementation. Treat
the proposal as a decision aid: distinguish observed facts from inference and
state missing evidence directly.

## Boundaries

- Do not discover customer problems, market demand, or product requirements; use
  `product-discovery` when those inputs are unknown.
- Do not make founder-level prioritization, hiring, pricing, or runway decisions;
  use `founder-decision` for those trade-offs.
- Do not perform general repository inventory; use `repository-research` when
  the task is evidence collection without a technical proposal.
- Do not create tickets, milestones, estimates, dependency graphs, or delivery
  sequencing; use `/project-plan` after approving a design.
- Do not edit files, run generators, migrations, tests, prototypes, network
  calls, or deployments without explicit approval.

## Design workflow

### 1. Establish repository evidence

Inspect only the code, tests, configuration, documentation, and history needed
to ground the proposal. Cite relevant paths and reuse established repository
conventions. Separate observed constraints from assumptions and inference.

Reuse canonical domain language when it exists. Flag overloaded or conflicting
terms; propose glossary or ADR changes separately and never create them
automatically.

### 2. Frame the design

State the problem, non-goals, callers, invariants, compatibility constraints,
and candidate test seam. Classify dependencies as in-process, locally
substitutable, remote-but-owned, or external. Prefer the highest existing seam
and avoid adding indirection without a demonstrated boundary.

An interface includes more than types: specify operations, inputs and outputs,
invariants, ordering, errors, configuration, performance expectations, and
compatibility behavior.

### 3. Propose modules and contracts

For each proposed module or API, describe:

- The public interface and its callers.
- Hidden implementation complexity and module responsibility.
- Dependency and adapter strategy, including production and test seams when
  external behavior must be isolated.
- Failure modes, error handling, observability, and security boundaries.
- Data/API compatibility, migration, rollout, rollback, and deprecation needs
  when relevant.

Use concrete edge cases to test whether domain relationships and invariants are
unambiguous. Do not treat a two-adapter design as mandatory; justify adapters by
the actual dependency boundary.

### 4. Compare alternatives when material

For consequential or hard-to-reverse choices, compare two or three materially
different designs. Include interface shape, seam placement, hidden complexity,
dependency strategy, trade-offs, reversibility, and validation impact.

Compare depth, leverage, locality, coupling, operational risk, and migration
cost. Recommend one option and state unresolved questions; do not generate
alternatives merely to fill a template.

### 5. Define approval-gated validation

Describe behavioral tests at the proposed interface and the acceptance evidence
needed before implementation is complete. Propose prototypes, migrations, load
tests, or security review only when they resolve a named uncertainty. Each such
action requires explicit approval before execution.

### 6. Synthesize and pause

Return a concise technical-design brief:

```markdown
## Decision and Scope

## Repository Evidence and Domain Terms

## Constraints and Invariants

## Proposed Modules and Contracts

## Dependencies and Seams

## Alternatives and Trade-offs

## Failure, Security, and Compatibility Considerations

## Migration and Rollback

## Validation Strategy

## Open Questions, Non-Goals, and Required Approval
```

Stop at the approved proposal. Hand off task decomposition to `/project-plan`
and code changes to an implementation workflow.
