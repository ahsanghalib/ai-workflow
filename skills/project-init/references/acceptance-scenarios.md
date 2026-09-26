# Project-Init Acceptance Scenarios

These scenarios define observable acceptance evidence for bootstrap and
reconciliation. They distinguish disposable helper evidence from behavior that
still needs a live harness and user review.

## No write before approval

**Given** an empty or existing target, **when** the read-only inspector or
inventory runs, **then** it reports the canonical target and
`write: none (inspection only)`, and the target remains unchanged.

Automated evidence: the inspector and inventory tests. Live evidence requires
checking that the conversation presents the proposal and waits for approval.

## Target reporting and nested safety

**Given** an explicit target, **when** inspection runs, **then** it reports the
canonical target, worktree root, mode, and nested-target state. **When** the
target is nested, initialization stops until the exact target receives the
approved `--allow-nested` handoff.

Automated evidence: `test-inspect-project.sh` and `test-init-project.sh`.

## Existing-project reconciliation

**Given** a non-empty target, **when** inventory runs, **then** it classifies
safe filename evidence and the workflow proposes keep, create, revise,
preserve, or conflict actions without creating a second source of truth.

Automated evidence: `test-inventory-project.sh` and
`test-reconciliation-scenarios.sh`. Live evidence requires reviewing the
per-file proposal and approving each revision separately.

## `.env` exclusion

**Given** a target containing `.env` or a secret-looking path, **when** the
target is inspected or inventoried, **then** only name-level classification is
reported. Contents are never read, copied, printed, or used to populate a
document.

Automated evidence: sentinel-content assertions in the inspector, inventory,
and validator tests.

## Reload after instruction changes

**Given** an approved change to `AGENTS.md` or equivalent routing, **when**
project-init hands off, **then** it reports the exact diff and recommends a
harness reload or fresh session before relying on the new rules.

Automated evidence: the compatibility reference and acceptance-test
assertions. Live evidence requires a fresh-session or reload check.

## Minimal output boundary

**Given** approved bootstrap, **when** the initializer runs, **then** it
creates only `AGENTS.md`, `SESSION_STATE.md`, `.ai/memory/`, `docs/specs/`, an
optional missing `.gitignore`, and separately approved local Git metadata. It
does not create roadmap, plan, review, schema, flow, architecture, decision,
rule, prompt, application, framework, dependency, migration, secret, commit,
branch, remote, or push output.

Automated evidence: the initializer and aggregate disposable suites. Live
evidence requires reviewing the final diff.

## Conditional reconciliation

**Given** a project gains a frontend, persistence, authentication, public API,
monorepo, deployment, background jobs, multiple deployables, or AI subsystem,
**when** project-init is run, **then** it asks whether durable repository-wide
knowledge or routing is not already represented clearly, and proposes only the
smallest missing control supported by evidence. If none is needed, it does
nothing; a capability signal alone does not create a document.

Automated evidence: `test-reconciliation-scenarios.sh`. Live evidence requires
reviewing the evidence-to-change proposal. The scenario test also preserves
existing justified frontend/database controls and root monorepo routing while
rejecting speculative documents and nested `AGENTS.md` files.

## Idempotent rerun

**Given** a target containing the minimal scaffold, **when** project-init runs
again, **then** it reports copy-if-missing skips and preserves existing files.
Unrelated existing content is not rewritten.

Automated evidence: `test-init-project.sh`. Live evidence requires checking the
target diff.

## Existing SPEC source mapping

**Given** an existing target contains `specifications/`, `specs/`, or
`docs/specifications/`, **when** the helper runs without an explicit mapping,
**then** it refuses to guess and writes nothing. With an approved
`--spec-dir` mapping, it preserves that source and does not create a competing
`docs/specs/` directory.

Automated evidence: `test-init-project.sh` and `test-validate-foundation.sh`.

## Foundation validation

**Given** the minimal control documents, **when** `scripts/validate-foundation.sh`
runs, **then** it verifies `AGENTS.md`, `SESSION_STATE.md`, `.ai/memory/`, and
`docs/specs/`, or the explicitly mapped SPEC source. A failure reports
actionable control-level findings. The check proves structural consistency
only.

Automated evidence: `test-validate-foundation.sh`.

## Substantive work handoff

**Given** a feature or other substantive request, **when** project-init
finishes bootstrap or reconciliation, **then** it hands the request to
`spec-workflow` and does not create a SPEC, task list, execution document, or
implementation itself.

Automated evidence: the project-init skill contract and aggregate test.
