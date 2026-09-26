# Project-Init Profiles

Use this reference only when reconciliation or an explicitly requested
project-control output needs a concern check. Project type is a discovery
input, not permission to invent a stack, product behavior, or documentation.

## Profile discovery

Ask the user to choose the closest project shape:

- `web-app` — a user-facing web application;
- `api` — an HTTP or other network API without a required user interface;
- `cli` — a command-line application or tool;
- `library` — a reusable package or SDK;
- `service` — a background, scheduled, worker, or event-driven service;
- `monorepo` — multiple coordinated applications or packages; or
- `unknown/other` — not yet clear or not represented above.

Then record each applicability answer as `yes`, `no`, or `unknown` for:

<!-- markdownlint-disable MD013 -->
| Concern | Why it selects documents |
| --- | --- |
| Consequential architecture decision | Consider one `docs/decisions/<adr>.md` only when a material decision is worth preserving separately. |
| Actor or user flow | Consider contextual flow documentation only when several features share a non-trivial lifecycle. |
| Persistence | Consider database rules or schema context only when executable schema leaves durable invariants unclear. |
| HTTP or OpenAPI | Select `docs/rules/api.md`. |
| Frontend or UI | Select `docs/rules/frontend.md` and, when a shared visual system exists, `ui.md`. |
| Authentication or authorization | Select `docs/rules/auth.md` and `security.md`. |
| Shared client/server contracts | Select `docs/rules/contracts.md`. |
| Non-trivial testing | Select `docs/rules/testing.md`. |
| Backend or server implementation | Select `docs/rules/backend.md`. |
| Security-sensitive work | Select `docs/rules/security.md`. |
| Database or schema work | Select `docs/rules/database.md`. |
<!-- markdownlint-enable MD013 -->

Do not infer `yes` from a project type alone. If the answer is `unknown`, keep
the output unselected, record the unresolved question in the handoff, and ask
before adding a specialized document. A concern may exist without justifying a
new Markdown artifact.

## Base scaffold

Every approved new-project scaffold normally creates only `AGENTS.md`,
`SESSION_STATE.md`, `.ai/memory/`, and `docs/specs/`. It may also copy the
`.gitignore.template` source as `.gitignore` when that file is missing.

The initializer does not choose a profile or write optional outputs silently.
`README.md`, architecture/decision/flow/schema-context files, rules, and
templates require an evidence-backed proposal and explicit approval.

## Optional outputs

After the profile and concern answers are reviewed, propose an actually
justified output individually:

- contextual flow documentation when several features share a non-trivial
  lifecycle;
- an ADR when one consequential decision needs a durable rationale and
  consequence record;
- the specialized rule files selected by the concern answers;
- the optional architecture, shared-flow, or schema-context template when its
  exact purpose and preferred target path are recorded; and
- any other bundled engineering-rule template only when its exact purpose and
  approval are recorded.

Optional files are copy-if-missing and are never a license to overwrite an
existing project document. Existing-project reconciliation still requires
preserve-first review. Feature requests hand off to `spec-workflow`, not to
this profile interview.
