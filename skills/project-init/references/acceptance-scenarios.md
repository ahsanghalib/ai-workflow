# Project-Init Acceptance Scenarios

These scenarios define observable acceptance evidence for the conversational
bootstrap and reconciliation workflow. They distinguish disposable helper
evidence from behavior that still needs a live harness and user review.

## No write before approval

**Given** an empty or existing target, **when** the read-only inspector or
inventory runs before approval, **then** it reports the canonical target and
`write: none (inspection only)`, and the target remains unchanged.

Automated evidence: `tests/test-acceptance-scenarios.sh` and the focused
inspector/inventory tests. Live evidence still requires checking that the
conversation presents the proposal and waits for the user's approval.

## Target reporting and nested safety

**Given** an explicit target, **when** inspection runs, **then** it reports the
canonical target, enclosing worktree root, mode, and nested-target approval
state. **When** the target is nested, initialization stops until the exact
target receives the approved `--allow-nested` handoff.

Automated evidence: `test-inspect-project.sh`, `test-init-project.sh`, and the
aggregate disposable suite.

## Existing-project reconciliation

**Given** a non-empty target, **when** inventory runs, **then** it classifies
safe filename evidence and the workflow proposes keep, create, revise,
preserve, or conflict actions without creating a second source of truth.

Automated evidence: `test-inventory-project.sh` and the acceptance scenario
test. Live evidence still requires reviewing the per-file proposal and
approving each existing-file revision separately.

## `.env` exclusion

**Given** a target containing `.env` or a secret-looking path, **when** the
target is inspected or inventoried, **then** only the name-level classification
is reported. Contents are never read, copied, printed, or used to populate a
document.

Automated evidence: sentinel-content assertions in the inspector, inventory,
initializer, aggregate, and acceptance tests.

## Prompt routing and provenance

**Given** the tracked `.ai/prompts/` library, **when** a project-control request
arrives, **then** the routing index selects only the needed prompt and the
prompt routes to the named skill. Prompt provenance remains visible, and the
prompt is not treated as an automatically discovered skill or authority.

Automated evidence: provenance-comment and routing-boundary assertions in the
acceptance test, plus the routed-reference validator. Live evidence still
requires confirming the harness loaded the named skill.

## Reload after instruction changes

**Given** an approved change to `AGENTS.md` or equivalent instruction routing,
**when** project-init hands off, **then** it reports the exact diff and
recommends a harness reload or fresh session before relying on the new rules.
The current session does not claim that the new instructions governed earlier
actions.

Automated evidence: the compatibility reference and acceptance-test assertions
for reload and approval language. Live evidence still requires a fresh-session
or harness-reload check in the target environment.

## Output boundary after approval

**Given** approved documentation bootstrap, **when** the initializer runs,
**then** it creates only the base project-control Markdown, optional
`.gitignore`, empty documentation directories, and separately approved local
Git metadata. Profile-selected user-flow, specialized rules, prompts, and
schema are separate outputs. It does not create application source, framework
files, dependencies, migrations, secrets, commits, branches, remotes, or
pushes.

Automated evidence: the aggregate disposable suite and initializer tests. Live
evidence still requires reviewing the final diff and reporting unexercised
runtime behavior separately.

## Selected reconciliation outputs

**Given** an existing target or an established planning layout, **when** a
bootstrap write is approved, **then** the full new-project scaffold is refused
and only explicitly selected `--only RELPATH` outputs are eligible. The helper
does not create a competing plan, schema, or instruction tree.

**Given** a reviewed user flow and approved persistence, **when** schema output
is approved, **then** it is a separate exact selection of
`docs/DB_SCHEMA.md --with-schema`; the initial scaffold does not create the
schema as a side effect.

Automated evidence: initializer tests cover existing `PLANS.md`, selected
output, schema sequencing, copy failure, traversal failure, and symlink
boundaries. Live evidence still requires reviewing the per-file approval scope.

## Conditional scaffold profile

**Given** a project shape and concern answers, **when** the base scaffold is
approved, **then** it creates only universal control documents and
`GENERAL.md`. `USER_FLOW.md`, specialized rules, and `.ai/prompts/` are added
only after the profile is reviewed and the exact outputs are selected.
Unknown concerns remain unresolved rather than being inferred from a project
type. `DB_SCHEMA.md` remains a separate selection after user-flow review.

Automated evidence: the initializer and traceability tests check the base
outputs, optional selections, and schema gate. Live evidence still requires
reviewing the profile answers and the proposal before writing.

## Idempotent unchanged rerun

**Given** a target containing only a recognized project-init scaffold, **when**
project-init runs again without repository changes, **then** it reports an
explicit no-op and writes nothing. An unrelated existing project remains
rejected without an explicit `--only` selection. Repeating a selected output
reports copy-if-missing skips and preserves the target file.

Automated evidence: the initializer disposable suite checks the full no-op and
selected-output rerun paths. Live evidence still requires checking the final
diff in the target project.

## Foundational consistency validation

**Given** base control documents, **when** `scripts/validate-foundation.sh`
runs before feature planning, **then** it verifies the required references
among `MASTER_PLAN.md`, `AGENTS.md`, `docs/PROJECT_ARCHITECTURE.md`, and
`README.md`, plus selected `USER_FLOW.md` and `DB_SCHEMA.md` dependencies. A
failure stops the lifecycle at **Foundational review pending** with actionable
document-level findings. The check proves structural consistency only; it does
not prove that product meaning, architecture, or approvals are correct.

Automated evidence: `test-validate-foundation.sh` covers base, selected flow,
selected schema, inconsistent references, and `.env` exclusion. Live evidence
still requires user review of the documents and approval state.

## Existing-layout foundation mapping

**Given** an existing project whose equivalent control documents live at
project-specific paths, **when** reconciliation identifies those files,
**then** the validator accepts an explicit mapping through `--readme`,
`--agents`, `--master-plan`, `--architecture`, `--user-flow`, and `--schema`
without forcing duplicate canonical files. `none` disables an inapplicable
optional document, while selected paths must exist and satisfy the same
cross-document reference checks.

Automated evidence: `test-validate-foundation.sh` validates a renamed and
nested existing layout. Live evidence still requires reviewing the mapping and
the resulting document-level findings.

## Decided versus explored

**Given** a feature request, **when** it has not yet been decided, **then** the
workflow asks whether it is already decided or still being explored and routes
exploration to Light, `brainstorming`, or `product-discovery` without creating
a SPEC. A decided feature may continue to the proposed SPEC lifecycle.

## Review ceremony preview

**Given** a request that may enter Standard or Strict, **when** the mode is
selected, **then** the handoff states the expected
`SPEC → spec-review → PLAN → plan-review/plan-consistency-review → explicit
user approval` chain and waits before writing.

## Risk-based escalation

**Given** a request involving persisted data, public contracts, authentication,
authorization, actors, permissions, migrations, or an existing source-of-truth
revision, **when** the requested mode is too light for the risk, **then** the
workflow escalates at least one mode level before planning or writing.

## Approval acknowledgement

**Given** a high-impact write scope, **when** approval is requested, **then**
the user echoes an `Approving:` line naming the target, operation, and key
forbidden side effects. Low-impact reversible work remains lightweight.

Automated evidence: the project-init contract tests check the mode, discovery,
ceremony, escalation, and acknowledgement rules. Live evidence still requires
observing the conversation-level mode choice and approval response.

## Helper failure and unusual filenames

**Given** a failed bundled-template traversal or copy, **when** a helper runs,
**then** it exits nonzero and does not claim a successful complete operation.
**Given** a newline-containing filename, **when** inspection or inventory
reports it, **then** the name is escaped on one evidence line without reading
its contents.

Automated evidence: focused inspector, inventory, and initializer tests inject
failed `find`/`cp` commands and create newline-containing names. BSD/macOS
execution remains a CI/platform check rather than a claim made by these Linux
tests.
