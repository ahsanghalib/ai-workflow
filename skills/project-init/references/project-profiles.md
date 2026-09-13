# Project-Init Profiles

Use this reference to decide which project-control documents apply before
copying optional scaffold outputs. Project type is a discovery input, not
permission to invent a stack or product behavior.

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

| Concern | Why it selects documents |
| --- | --- |
| Actor or user flow | Select `docs/USER_FLOW.md` for human or system journeys, permissions, and states. |
| Persistence | Select the reviewed `docs/DB_SCHEMA.md` step only after the flow and data needs are approved. |
| HTTP or OpenAPI | Select `docs/rules/API.md`. |
| Frontend or UI | Select `docs/rules/FRONTEND.md` and, when a shared visual system exists, `UI.md`. |
| Authentication or authorization | Select `docs/rules/AUTH.md` and `SECURITY.md`. |
| Shared client/server contracts | Select `docs/rules/CONTRACTS.md`. |
| Non-trivial testing | Select `docs/rules/TESTING.md`. |
| Backend or server implementation | Select `docs/rules/BACKEND.md`. |
| Security-sensitive work | Select `docs/rules/SECURITY.md`. |
| Database or schema work | Select `docs/rules/DATABASE.md`. |

Do not infer `yes` from a project type alone. If the answer is `unknown`, keep
the output unselected, record the unresolved question in the handoff, and ask
before adding the specialized document.

## Base scaffold

Every approved new-project scaffold may create these missing outputs:

- `README.md`, `AGENTS.md`, `MASTER_PLAN.md`, and `SESSION_STATE.md`;
- `docs/PROJECT_ARCHITECTURE.md` and `docs/plans/INDEX.md`;
- `docs/rules/GENERAL.md`;
- every `docs/templates/*.md` file;
- the `.gitignore.template` source as `.gitignore`; and
- empty `docs/specs/`, `docs/plans/`, and `docs/reviews/` directories.

The initializer copies this base only. It never chooses a profile or writes
optional outputs silently.

## Optional outputs

After the profile and concern answers are reviewed, select the applicable
outputs individually with `--only`:

- `docs/USER_FLOW.md` when actor or system journeys apply;
- the specialized rule files selected by the concern answers;
- `.ai/prompts/` when the project wants the tracked helper-prompt library;
- `docs/DB_SCHEMA.md` only with the separate exact command
  `--only docs/DB_SCHEMA.md --with-schema`, after persistence and user-flow
  review; and
- any other bundled file only when its exact purpose and approval are recorded.

Optional files are copy-if-missing and are never a license to overwrite an
existing project document. This profile contract controls bootstrap output;
existing-project reconciliation still requires explicit repeatable selections
and preserve-first review.
