# Define project API response envelope

Date: 2026-09-13
Feature: project-init

## Context

The project-init API engineering rule already covered resource design,
contracts, status codes, and pagination but did not define the shared response
envelope requested for generated projects.

## Goal

Record the shared API response contract in the project-init API engineering rule.

## Why

All API consumers need predictable success, messaging, request-correlation,
result, pagination, and error fields.

## Outcome

Added success and error envelopes with request correlation, data/error fields,
and endpoint-selected pagination metadata.

## Current State

`skills/project-init/templates/docs/rules/API.md` now documents one envelope
for successful and failed responses. The working tree remains uncommitted.

## Important Findings

- Every response carries boolean `success`, a top-level `message`, and a
  `requestId` for correlation.
- Successful responses carry object/array `data`; errors carry an object or
  array of structured `error` details and do not return `data` by default.
- `meta` supports either offset fields (`total`, `limit`, `offset`) or cursor
  fields (`next`, `prev`, `limit`) per list endpoint, not both shapes together.

## Decisions

- Use `200` with `data: {}` for successful operations without meaningful result
  data; do not use `204 No Content` under this envelope contract.
- Keep machine-readable error codes stable and prevent internal details from
  leaking through messages or details.

## Failed Approaches

- The first lint command omitted the argument terminator for the Markdown
  disable flags; rerunning with the repository's established command shape
  produced the valid result.

## Validation

- `markdownlint --disable MD013 MD032 --
  skills/project-init/templates/docs/rules/API.md` passed.
- `git diff --check` passed.
- Full repository validation from the preceding project-init follow-up had
  passed; runtime API behavior is not exercised in this documentation repo.

## Open Questions

- Individual projects still choose their pagination strategy per list endpoint
  and must document any additional metadata beyond this envelope.

## Next Steps

- When an application project is initialized, copy this rule and define its
  concrete request/response schemas and OpenAPI examples against this envelope.

## Relevant Files

- `skills/project-init/templates/docs/rules/API.md` — shared API rule and
  response envelope.
- `SESSION_STATE.md` — current project handoff and durable decision summary.
