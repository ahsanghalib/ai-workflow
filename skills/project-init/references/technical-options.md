# Technical Option Comparison Handoff

Use this reference when the user has not selected a technical direction or
asks for recommendations. Project-init coordinates the decision; it does not
silently choose an option.

## Comparison procedure

1. Read the approved product direction, reviewed user flow, relevant schema
   decision, existing repository evidence, and local rules.
2. State the exact decision to make and the constraints that matter.
3. Ask `technical-design` to compare a bounded set of options, interfaces,
   boundaries, trade-offs, migration implications, and validation needs.
4. Ask `source-driven-development` to verify current documented behavior when a
   framework, library, runtime, API, version, or provider convention affects
   the comparison. Prefer authoritative primary documentation.
5. Return an options table with evidence, benefits, costs, risks, reversibility,
   operational impact, and a recommendation only when the user requested one.
6. Keep the selected option **Proposed** until the user explicitly approves it.
7. Record the approved result in the owning project documents through the
   `record-technical-decisions` prompt.

After approval, record the selected value, rationale, evidence, approval state,
and boundary in the relevant document. Leave every unanswered option as
**Open** or **Unknown**; never fill it from a framework default or a common
convention. Update operational commands in `AGENTS.md` only after they are
verified for the selected local toolchain.

## Required decision coverage

When relevant, compare:

- repository shape and application boundaries;
- language, runtime, framework, package manager, and workspace tooling;
- database/storage and local emulation;
- ORM, query builder, raw SQL, or an approved mixed strategy;
- migration tool, ownership, forward-only policy, rollback/compatibility
  handling, and generated versus hand-written queries;
- authentication, authorization, session/token handling, and privacy;
- API and shared-contract strategy;
- local development, test data, test/lint/type-check/build commands;
- browser, accessibility, performance, availability, CI, and deployment scope.

Do not install packages, scaffold application code, create migrations, access
remote services, inspect `.env` values, or treat a recommendation as approval.
