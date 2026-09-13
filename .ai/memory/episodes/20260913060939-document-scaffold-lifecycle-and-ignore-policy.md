# Document scaffold lifecycle and ignore policy

Date: 2026-09-13
Feature: project-init

## Context

TASK-0009 and TASK-0010 complete the first project-init template/documentation
group after prompts and generated-agent routing were added.

## Goal

Explain the scaffold lifecycle in generated README content and confirm the
ignore policy for real `.env` files and tracked `.ai/` documentation.


## Why

New users need to understand which document owns each decision, while the
initializer must protect secrets without hiding the helper-prompt directory.

## Outcome

Expanded the generated README with structure, prompt usage, `.env` safety,
schema/user-flow sequence, and SPEC/PLAN review gates. Confirmed the ignore
template excludes real `.env` files, permits safe example variants, contains no
`.env` template files, and has no active `.ai/` ignore rule.


## Current State

TASK-0001 through TASK-0010 are complete. TASK-0011 is next. No application
code, dependencies, Git mutation, or remote operation was performed.

## Important Findings

- README should explain ownership and lifecycle without duplicating detailed
  architecture or roadmap content.
- The `.gitignore.template` policy is correct when comments explicitly protect
  tracked `.ai/` and distinguish real `.env` files from safe examples.

## Decisions

- Keep real `.env` files ignored and out of project-init inputs/outputs.
- Keep `.ai/` tracked and document it as helper prompts/project memory, not a
  secret store or authority source.

## Failed Approaches

Initial README lint found a pre-existing long comment; it was wrapped without
changing the template's meaning.

## Validation

- `markdownlint skills/project-init/templates/README.md` passed.
- Exact ignore rules, absence of `.env` template files, and absence of active
  `.ai/` ignore rules were verified.

## Open Questions

No new design questions.

## Next Steps

Continue with TASK-0011: preserve and test copy-if-missing behavior, including
hidden `.ai/prompts/` paths.
-

## Relevant Files

- `skills/project-init/templates/README.md` — generated user guide.
- `skills/project-init/templates/.gitignore.template` — generated ignore rules.
- `IMPLEMENTATION_PLAN.md` — task order and activity evidence.
- `SESSION_STATE.md` — current short-term handoff state.
