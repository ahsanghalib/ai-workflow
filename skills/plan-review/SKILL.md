---
name: plan-review
description: Review one user-authored implementation PLAN against an approved SPEC, repository rules, and current architecture before implementation. Use to find missing work, wrong ordering, scope creep, test/contract/schema/security gaps, or invalid assumptions. Do not edit plans; use project-init for plan authoring/refinement and plan-consistency-review for cross-artifact traceability.
license: MIT
compatibility: no bundled executable dependencies
---

# Plan Review

A PLAN answers **how this implementation slice will be built**.

## Boundaries

- Review one proposed PLAN for executability and coverage before implementation.
- Require the exact PLAN path or identifier from the user. If the target or its
  referenced SPEC is ambiguous, do not choose one from the repository.
- Use `project-init` when the user wants a plan created or edited; do not edit
  the PLAN in this skill.
- Use `plan-consistency-review` when several requirements, design, task, and
  validation artifacts need a traceability or contradiction review.
- Use `technical-design` when a missing architecture or interface decision must
  be proposed before the PLAN can be judged.
- Do not change plan or SPEC status, create branches or issues, or authorize
  implementation from a review verdict.

## Inputs

Read only what is needed:

- root `AGENTS.md` and `SESSION_STATE.md` when present
- the referenced SPEC (or the repository's equivalent), including its exact
  approval/status field when the project defines one
- proposed PLAN (or the repository's equivalent)
- relevant engineering rules
- project architecture documentation when materially relevant
- repository evidence needed to validate file/module assumptions

Use an available repository structural index, such as CodeGraph, for structural
code questions when the repository exposes one; otherwise use normal reads and
search. Do not repeat fresh indexed results with a second structural scan. Never
read secrets, credentials, `.env` files, browser state, or unrelated history.

## Workflow

1. Confirm the exact selected PLAN and its referenced SPEC before reviewing the
   current text. If either is missing or ambiguous, stop and report that
   condition.
2. Check the SPEC's approval/status gate when one exists. If the SPEC is not
   approved, report that limitation separately; do not treat an unapproved
   requirement as settled fact.
3. Trace each PLAN task to a requirement, dependency, test, or necessary
   operational concern; flag tasks without an observable reason.
4. Check repository assumptions against current evidence and classify them as
   confirmed, assumed, unresolved, or contradicted.
5. Check plan metadata, task order, dependency and TDD gates, scope, safety
   gates, environment/migration/rollback coverage, and validation commands.

## Check

- every plan step maps to SPEC behavior
- no unrequested feature expansion
- ordering/dependencies are correct
- schema/migration work appears before dependent services/routes when applicable
- shared contracts are planned when client/server shapes are shared
- backend-only types stay backend-local
- tests are placed at the appropriate layer
- authorization/security requirements are represented
- API/OpenAPI changes are represented
- rollback/data-migration concerns exist when needed
- frontend and backend work are separated for substantial features
- plan/SPEC status, stable PLAN and task IDs, branch/issue metadata, and
  approval gates are internally consistent
- Red/Green/Refactor ordering is present for testable behavior, or an explicit
  TDD exception and alternative evidence are recorded
- local-development and environment boundaries are explicit when remote or
  persistent resources could be involved
- validation commands are specific and sufficient
- plan references relevant rule files instead of copying them

## Output

Default: a read-only findings report and verdict in chat. For each actionable
finding include severity, PLAN location when available, evidence, impact, and
the smallest remediation. Separate confirmed coverage from assumptions,
unresolved decisions, and unverified paths. State whether the SPEC approval
gate was verified. A ready verdict means the PLAN is sufficiently actionable
for the next approved workflow; it does not approve the PLAN, SPEC, code, or
implementation. Do not create or edit a plan or review artifact in this skill.

If the user asks for refinement, hand the existing PLAN and findings to
`project-init`; preserve the user's structure and decisions unless an
authorized plan editor changes them.
