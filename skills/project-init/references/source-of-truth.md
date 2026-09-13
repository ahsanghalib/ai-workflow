# Existing Source-of-Truth Detection

Use this reference during reconciliation after the safe inventory. Detection
finds candidates; it does not authorize edits or decide that one document is
correct when the project has conflicting sources.

## Candidate groups

Report every relevant candidate with its exact path and current status:

- **Instructions:** applicable `AGENTS.md` files, README guidance, and other
  repository instruction files. Apply normal directory precedence; a nested
  instruction file is more specific for files below it, but it does not erase
  the root project rules.
- **Planning:** `MASTER_PLAN.md`, `PLANS.md`, `plans/`, `docs/plans/`, SPEC
  directories, PLAN files, indexes, and project-roadmap equivalents.
- **Architecture:** `docs/PROJECT_ARCHITECTURE.md`, architecture decision
  records, design documents, diagrams, and equivalent architecture paths.
- **User behavior:** `docs/USER_FLOW.md`, journey documents, product-flow
  notes, and equivalent behavior sources.
- **Persisted data:** `docs/DB_SCHEMA.md`, schema files, migration directories,
  ORM schema sources, and database-design documents.
- **Repository and operations:** `.gitignore`, manifests, lockfiles, build/test
  configuration, local-development instructions, and validation commands.

Do not open `.env`, credentials, private keys, browser state, or other secret
material while making this inventory. A filename is safe evidence; its content
is not automatically safe.

## Selection and preservation

1. List all candidates, including missing expected documents and conflicting
   names, before proposing a change.
2. If one established source clearly owns a document type, preserve its exact
   name and location. Do not silently create `MASTER_PLAN.md`,
   `docs/PROJECT_ARCHITECTURE.md`, or a new plan tree beside it.
3. If several candidates exist, report their paths, apparent roles, status, and
   conflict; ask the user which source is authoritative or whether a deliberate
   compatibility plan is wanted.
4. If a candidate is generated, identify its generator and update the generator
   rather than editing generated output directly. If ownership is unknown,
   report that as an open decision.
5. A missing document may be proposed for creation only after the existing
   source-of-truth scan. Creating a missing file and revising an existing file
   remain separate approval scopes.

## Reconciliation report fields

For each candidate, record:

- exact path and candidate group;
- keep unchanged, preserve as source of truth, create missing, revise after
  approval, or conflict status;
- evidence used without secret contents;
- generator or owner, when known;
- compatibility impact of creating or revising it; and
- the user's pending decision, if more than one source remains plausible.
