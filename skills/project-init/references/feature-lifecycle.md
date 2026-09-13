# Feature Map and SPEC Lifecycle

Use this reference after the product direction and relevant user-flow/schema
contracts have been reviewed. The initial project schema is an exception to
feature-SPEC ordering: `schema-design` may review that baseline from approved
project direction plus reviewed `docs/USER_FLOW.md`. Feature-specific schema
changes still require their Proposed/approved feature SPEC before review.

## Feature-map proposal

### Decided versus explored

Before deriving a feature candidate or drafting a SPEC, ask one bounded
question: **Is this feature already decided or still being explored?** If it is
still being explored, keep the work in Light mode or route it to
`brainstorming`/`product-discovery`; exploratory work does not create a SPEC.
The initial `MASTER_PLAN.md` may still record the user's idea as a loose,
clearly marked proposal.

1. Read `MASTER_PLAN.md`, `docs/USER_FLOW.md`, the approved schema when
   persistence is relevant, architecture, rules, and the existing plan index.
2. Derive candidate features only from confirmed outcomes and clearly labelled
   proposed behavior. Do not invent priorities, entities, screens, routes, or
   implementation tasks.
3. For each candidate, show its goal, user-flow references, data dependencies,
   dependencies on other features, open decisions, risks, and suggested order.
4. Label the map **Proposed** and ask the user to select the feature to define.

## SPEC creation

For the selected feature:

1. Use the existing SPEC path and naming convention; do not create a second
   SPEC tree.
2. Read relevant flows, schema entities, architecture, rules, and existing
   behavior before drafting.
3. Create only the requested SPEC from the template with status `Proposed`.
4. Define observable behavior, actors, authorization, invariants, validation,
   states, failure/recovery, edge cases, compatibility, and acceptance
   criteria. Trace persisted data to approved schema entities and identify
   schema-impact review when needed.
5. Keep open decisions visible and stop for user review. Route to `spec-review`
   when requested; do not create a PLAN or implement code in this step.

The same flow applies to later requests such as adding income details: confirm
whether it is a new feature or SPEC revision, update only the requested SPEC,
and stop for review before planning.

## SPEC review, PLAN, and approval

1. Route the exact `Proposed` SPEC to `spec-review` when requested. A review
   reports findings; it does not approve or edit the SPEC.
2. After the user accepts the SPEC, the user owns the approval transition:
   change its Status to `Approved`, fill the review date, and record explicit
   approval evidence. Project-init must not make that transition on the user's
   behalf. Create a PLAN only after that approved SPEC exists. Allocate the next
   stable plan ID in the existing plan layout and update its index without replacing
   unrelated rows.
3. Keep the new PLAN `Proposed`, with dependency-ordered observable tasks,
   architecture/schema impact, environments, migrations, tests, validation, and
   TDD or alternative-validation evidence.
4. Route the exact PLAN to `plan-review` and use `plan-consistency-review` when
   multiple documents interact. These reviews do not approve or edit the plan.
5. Stop until the user explicitly marks the PLAN `Approved`. Project-init must
   never set that status for the user or begin implementation.

## Approved implementation handoff

After explicit PLAN approval, hand off only the next bounded task to
`implement-next` and the relevant `backend-feature` or `frontend-feature`
skill. Use TDD for testable behavior, keep the task scope bounded, and do not
let project-init implement it. After implementation, route to `code-review` or
`review-diff`, run `verification-before-completion`, and update
`SESSION_STATE.md` and project memory with `session-state` and `agent-memory`
when those capabilities and the separately approved session-state scope are
available. Otherwise provide the complete handoff inline or in another
approved project document. Report any unavailable capability and use the
documented manual equivalent.
