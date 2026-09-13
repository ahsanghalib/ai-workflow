# Project Technical Questionnaire

Use this questionnaire after the initial product-direction draft and before
recording technical decisions. Ask only the groups that affect the requested
project-control documents. The user may answer `unknown`, `not applicable`, or
`recommend options`; those answers remain open rather than becoming guesses.

## Project shape and ownership

- Is this a single full-stack repository, a frontend-only repository, a
  backend/API-only repository, or a monorepo?
- If it is a monorepo, which applications and shared packages belong in it?
- Which part owns the public API and shared contracts?
- Is there an existing repository layout or source of truth to preserve?

## Language, runtime, and tooling

- Which programming language and runtime should be used?
- Which frontend and backend frameworks are wanted, if any?
- Which package manager, workspace tool, and build tool should be used?
- What local commands should exist for development, tests, linting, formatting,
  type-checking, and builds?

## Persistence and data access

- Does the product need persistence? If so, which database or storage type is
  approved for local development?
- Should data access use an ORM, query builder, raw SQL, or an approved mix?
- Which layer owns hand-written queries, generated queries, and migrations?
- Which migration tool and forward-only migration policy are wanted?
- Are tenancy, organizations, ownership, audit history, money, time zones, or
  concurrency requirements already known?

Do not create `docs/DB_SCHEMA.md` until persistence is approved. When it is
approved, route the design to `schema-design` before API or frontend contracts
depend on it.

## Authentication, authorization, and sessions

- Are accounts, organizations, roles, or invitations required?
- Which authentication method is wanted: session cookies, bearer tokens,
  JWTs, an identity provider, or an unresolved option?
- Where may session material be stored, and what must never be stored there?
- Which operations require server-side authorization checks?

## Local development and environments

- Which development environment must work locally without deployed services?
- Are local database, cache, object-storage, mail, or identity-provider
  substitutes required?
- Is Docker acceptable, or should native/local emulation be preferred?
- Which environment variable names are needed? Record names and setup steps
  only; never request or copy values from `.env`.
- Are seed data, fixtures, or reset commands needed?

## Quality and delivery boundaries

- Which unit, integration, contract, browser, accessibility, or end-to-end
  tests are needed?
- Which browsers, platforms, accessibility level, performance targets, or
  availability expectations matter?
- Is CI required now? If so, which checks must run locally and in CI?
- Are deployment, hosting, observability, or release decisions in scope now?

## Recording answers

Record each answer in the appropriate project document as one of:

- **Confirmed:** explicitly chosen by the user or existing trusted project
  evidence.
- **Proposed:** a candidate option awaiting user approval.
- **Assumption:** needed to draft a document but not confirmed.
- **Recommendation:** a reasoned option that must not be treated as selected.
- **Open:** unanswered, intentionally deferred, or requiring research.

Use `technical-design` for architecture and option comparison, and
`source-driven-development` when a current framework, library, runtime, or API
behavior must be verified. Do not install packages or create application files
while collecting these answers.
