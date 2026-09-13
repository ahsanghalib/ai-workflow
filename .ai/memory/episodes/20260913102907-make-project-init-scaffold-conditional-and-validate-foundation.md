# Make project-init scaffold conditional and validate foundation

Date: 2026-09-13
Feature: project-init conditional scaffold

## Context

The remaining open findings in `gpt-sol-5-6-findings.md` concerned profile-
conditional scaffold output, optional engineering rules and helper prompts,
strict rerun idempotency, foundational document consistency, and keeping the
project-init entrypoint concise. Prior duplicate-policy cleanup had already
routed detailed procedure through `references/workflow.md`.

## Goal

Finish Group 12 of `IMPLEMENTATION_PLAN.md` without committing: implement the
conditional scaffold and profile contract, preserve explicit schema approval,
make unchanged reruns safe no-ops, add a read-only foundation validator, and
cover the behavior with disposable tests and acceptance documentation.

## Why

Every repository should receive useful universal project-control documents,
but a CLI, library, API, service, and web app do not all need the same user
flow, UI, API, schema, rule, or prompt documents. The bootstrap should not
silently create irrelevant files or force later agents to maintain dead links.

## Outcome

Added `references/project-profiles.md` with project-shape and concern
applicability questions. The initializer now creates only the base control
files, `GENERAL.md`, templates, planning directories, and `.gitignore` by
default. USER_FLOW, specialized rules, `.ai/prompts`, and DB_SCHEMA are
explicit selected outputs; DB_SCHEMA retains its exact separate gate.

Repeated runs on a complete recognized scaffold report a no-op without
writing. Unrelated existing projects remain rejected without `--only`, while
selected paths remain copy-if-missing. Explicit `--init-git` still works when
added after a complete scaffold.

Added read-only `scripts/validate-foundation.sh`, routed it before feature
planning, and added base/optional/schema/inconsistent-reference acceptance
coverage. Updated manifest, output boundary, workflow, entrypoint, README,
AGENTS, MASTER_PLAN, prompt contract, and acceptance docs to remove
unconditional optional-output claims.

## Current State

Group 12 TASK-0070 through TASK-0075 is complete and recorded in
`IMPLEMENTATION_PLAN.md`. No commit or remote operation was performed.

## Important Findings

- A project-init scaffold can be recognized safely from known output paths and
  directory structure without reading `.env` or any secret content.
- The foundation validator proves structural cross-document references only;
  it cannot prove product meaning, architecture correctness, or user approval.
- Optional output selection is a policy/orchestration concern; the bundled
  shell initializer can enforce selected paths but cannot ask the profile
  questions itself.
- A completed scaffold without `.git` must remain eligible for a later,
  separately approved `--init-git` operation.

## Decisions

- `GENERAL.md` is universal; specialized rules are selected by concern and
  explicit review.
- `.ai/prompts/` is optional to avoid unnecessary duplication/version drift.
- USER_FLOW is conditional on actor or system journeys; DB_SCHEMA follows
  reviewed user flow and separate persistence approval.
- Unknown profile concerns remain unresolved instead of being inferred from
  project type alone.

## Failed Approaches

The first initializer no-op condition accidentally rejected `--init-git` when
the target already contained a complete scaffold but no Git metadata. The
condition was split so recognized scaffolds no-op unless explicit Git
initialization is requested without existing `.git`, in which case the normal
copy-if-missing path continues to `git init`.

## Validation

Passed:

- `bash skills/project-init/tests/test-project-init.sh`
- `bash -n script.sh bin/* skills/project-init/scripts/*.sh skills/project-init/tests/*.sh`
- `shellcheck skills/project-init/scripts/*.sh skills/project-init/tests/*.sh`
- `bash validate-skills.sh`
- `git diff --check`

The disposable tests covered base/optional outputs, selected reruns, schema
sequencing, delayed Git initialization, foundation success/failure, and `.env`
sentinel exclusion. Live harness discovery, conversation approval, and actual
application behavior remain untested.

## Open Questions

None for this repair group. Live harness behavior still needs an environment-
specific check after reloading generated project instructions.

## Next Steps

Review the final diff, then optionally reload the target harness and exercise
the profile questions and foundation-validation handoff. Keep the repository
uncommitted unless the user separately requests a logical commit.

## Relevant Files

- `skills/project-init/references/project-profiles.md` — profile and optional-output contract.
- `skills/project-init/scripts/init-project.sh` — base selection and idempotent scaffold behavior.
- `skills/project-init/scripts/validate-foundation.sh` — structural foundation validator.
- `skills/project-init/references/template-manifest.md` and `output-boundary.md` — output ownership and safety boundary.
- `skills/project-init/templates/README.md`, `AGENTS.md`, `MASTER_PLAN.md`, and architecture template — generated-document wording.
- `skills/project-init/tests/` — disposable regression and contract coverage.
