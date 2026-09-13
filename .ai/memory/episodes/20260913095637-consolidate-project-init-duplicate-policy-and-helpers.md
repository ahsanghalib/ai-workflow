# Consolidate project-init duplicate policy and helpers

Date: 2026-09-13
Feature: project-init cleanup

## Context

The project-init skill had no exact duplicate files, but its entrypoint and
workflow reference repeated policy, three shell scripts copied safety helpers,
and API/CONTRACTS templates repeated pagination concepts with different cursor
nullability.

## Goal

Remove duplicate maintenance authorities without changing project-init's
approval, output, or safety behavior.

## Why

Repeated policy can drift, and copied shell helpers can receive inconsistent
security fixes. The API decision already requires optional `next`, `prev`, and
`limit` cursor fields.

## Outcome

Completed Group 11 in `IMPLEMENTATION_PLAN.md`. `SKILL.md` now routes detailed
procedure to `references/workflow.md`; the workflow's duplicate scaffold layout
was removed in favor of `template-manifest.md`; `scripts/common.sh` owns the
shared `path_has_symlink` and `escape_output` helpers; and API/CONTRACTS
ownership plus cursor optionality are explicit.

## Current State

Project-init remains harness-neutral and copy-if-missing. Existing files and
approval boundaries are unchanged. No commit, push, remote, or application
change was made.

## Important Findings

- The validator requires direct entrypoint routing for branch-specific
  references even when `workflow.md` links them, so concise routing links remain
  in `SKILL.md`.
- Generated README and helper prompts intentionally repeat standalone user
  guidance; they are not duplicate policy authorities for the skill itself.

## Decisions

- Keep `workflow.md` as the detailed procedural authority and
  `template-manifest.md` as the scaffold inventory authority.
- Keep API.md authoritative for HTTP envelope/status/endpoint pagination and
  CONTRACTS.md authoritative for reusable shared shapes; align both to omitted
  cursor fields rather than `null`.
- Use a sourced shell helper rather than copying functions or broadening the
  refactor to all shared argument-parsing code.

## Failed Approaches

- The first focused validation run failed because shortening `SKILL.md` removed
  direct links that the repository validator treats as required routing. The
  links were restored without reintroducing the detailed duplicate prose.

## Validation

- Red check: `test-traceability-contract.sh` failed on the old cursor shape.
- Green checks: `bash validate-skills.sh`,
  `bash skills/project-init/tests/test-project-init.sh`, Bash syntax checks,
  ShellCheck, and `git diff --check` all passed.
- A post-change scan found no exact duplicate file hashes, duplicate shell
  helper bodies, or repeated large sentence-like lines in `skills/project-init`.
- Live harness conversation and provider discovery remain untested.

## Open Questions

- None for this cleanup. The disposable implementation plan and review ledger
  remain user-owned cleanup artifacts.

## Next Steps

- Future work should begin from a new focused plan if additional deduplication
  is desired; do not recreate the removed scaffold inventory in another
  operational reference.

## Relevant Files

- `skills/project-init/SKILL.md`
- `skills/project-init/references/workflow.md`
- `skills/project-init/references/template-manifest.md`
- `skills/project-init/scripts/common.sh`
- `skills/project-init/scripts/{init-project,inspect-project,inventory-project}.sh`
- `skills/project-init/templates/docs/rules/{API,CONTRACTS}.md`
- `skills/project-init/tests/test-traceability-contract.sh`
