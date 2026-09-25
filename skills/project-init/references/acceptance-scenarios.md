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
**then** it creates only `AGENTS.md`, `SESSION_STATE.md`, `.ai/memory/`,
`docs/specs/`, optional missing `.gitignore`, and separately approved local Git
metadata. Legacy documents, rules, prompts, plan/review directories, and
schema outputs are separate explicit selections. It does not create application
source, framework files, dependencies, migrations, secrets, commits, branches,
remotes, or pushes.

Automated evidence: the aggregate disposable suite and initializer tests. Live
evidence still requires reviewing the final diff and reporting unexercised
runtime behavior separately.

## Selected reconciliation outputs

**Given** an existing target or an established planning layout, **when** a
bootstrap write is approved, **then** the full new-project scaffold is refused
and only explicitly selected `--only RELPATH` outputs are eligible. Existing
legacy files and layouts remain preserved; the helper does not create a
competing plan, schema, or instruction tree.

**Given** a reviewed user flow and approved persistence, **when** schema output
is explicitly requested and approved, **then** it is a separate exact
selection of `docs/DB_SCHEMA.md --with-schema`; the initial scaffold does not
create the schema as a side effect or require it for a later SPEC.

Automated evidence: initializer tests cover existing `PLANS.md`, selected
output, schema sequencing, copy failure, traversal failure, and symlink
boundaries. Live evidence still requires reviewing the per-file approval scope.

## Conditional scaffold profile

**Given** a project shape and concern answers, **when** the base scaffold is
approved, **then** it creates only the minimal control plane. Legacy documents,
specialized rules, and `.ai/prompts/` are added only after a concrete need is
reviewed and the exact outputs are selected. Unknown concerns remain
unresolved rather than being inferred from a project type.

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
runs after bootstrap or reconciliation, **then** it verifies `AGENTS.md`,
`SESSION_STATE.md`, `.ai/memory/`, and `docs/specs/` (or explicitly mapped
equivalents). Optional legacy paths are checked only when explicitly selected.
A failure reports actionable control-level findings. The check proves
structural consistency only; it does not prove product meaning, architecture,
or approvals are correct.

Automated evidence: `test-validate-foundation.sh` covers base, selected flow,
selected schema, inconsistent references, and `.env` exclusion. Live evidence
still requires user review of the documents and approval state.

## Existing-layout foundation mapping

**Given** an existing project whose equivalent control documents live at
project-specific paths, **when** reconciliation identifies those files,
**then** the validator accepts an explicit mapping through `--readme`,
`--agents`, `--session-state`, `--specs`, and `--memory` without forcing
duplicate canonical files. Legacy `--master-plan`, `--architecture`,
`--user-flow`, `--schema`, `--plans`, and `--reviews` paths are optional and
checked only when selected.

Automated evidence: `test-validate-foundation.sh` validates a renamed and
nested existing layout. Live evidence still requires reviewing the mapping and
the resulting document-level findings.

## Decided versus explored

**Given** a feature request, **when** it has not yet been decided, **then** the
workflow does not plan it internally; **then** project-init completes only the
control bootstrap/reconciliation and routes the request to
`spec-workflow`. Exploration may still use `brainstorming` or
`product-discovery`, but project-init creates no SPEC or PLAN.

## Review ceremony preview

**Given** a request that may enter Standard or Strict, **when** the mode is
selected, **then** the handoff states that project-init owns only
`inspect → propose → explicit approval → bootstrap/reconcile → validate`, and
that substantive work routes to `spec-workflow` before any SPEC or
implementation lifecycle.

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
