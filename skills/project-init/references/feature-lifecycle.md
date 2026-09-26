# Feature and SPEC Lifecycle

Use this reference when a substantive work request arrives during or after
project-control reconciliation. It describes the normal SPEC-driven lifecycle;
it does not create a separate planning artifact.

## Default lifecycle

```text
project-init
  → bootstrap or reconcile minimal controls
  → spec-workflow
  → SPEC Draft
  → spec-review: ready / not ready
  → explicit user approval
  → SPEC Approved
  → execution preparation inside the same SPEC
  → implement-next
  → one dependency-ready task
  → task validation and implementation review as needed
  → verification-before-completion
  → SPEC Completed
```

Project-init owns repository controls and handoff. `spec-workflow` owns the
behavioral contract, approval evidence, execution section, and SPEC-local task
list. `implement-next` executes exactly one existing dependency-ready task.
The final verification gate, not the last checkbox, permits `Completed`.

## Conditional project context

Before drafting a SPEC, inspect only the relevant existing source-of-truth
documents. Load architecture, shared-flow, schema-context, or engineering-rule
templates only when the project has durable cross-feature knowledge that needs
to be recorded. A project document never replaces the SPEC or approves work.

Feature-specific behavior belongs in the SPEC. Shared user journeys may use
the optional user-flow template; executable schema and migrations remain the
structural source of truth, with the optional schema template recording only
durable invariants that are otherwise difficult to infer.

## Handoff boundaries

1. Product uncertainty goes to `product-discovery` or `brainstorming`.
2. Contract quality goes to `spec-review`; `ready` is not approval.
3. Architecture and interface questions go to `technical-design`.
4. Non-trivial persistence questions go to `schema-design`.
5. Approved task execution goes to `implement-next` and the relevant domain
   implementation skill.
6. Implementation review and final verification remain separate read-only and
   evidence gates.

Do not infer approval from a review verdict, an implementation request, an
existing document, a legacy planning artifact, a prior unrelated approval, a
vague `looks good` response, or a completed task checkbox.
