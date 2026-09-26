# Existing Source-of-Truth Detection

Use this reference during reconciliation after the safe inventory. Detection
finds candidates; it does not authorize edits, create missing documents, or
decide that one source is correct when the project has conflicts.

## Candidate groups

Report every relevant candidate with its exact path and current status:

- **Instructions:** applicable `AGENTS.md` files, README guidance, and other
  repository instruction files. Apply directory precedence without treating a
  nested file as permission to broaden scope.
- **Work contracts:** `docs/specs/`, SPEC files, issue references, and other
  explicitly named work-contract locations.
- **Architecture and decisions:** architecture documents, decision records,
  design documents, diagrams, and equivalent paths when they already exist.
- **User behavior:** journey documents, flow notes, acceptance references, and
  equivalent behavior sources when they already exist.
- **Persisted data:** executable schema, migrations, ORM schema sources, and
  database-design documents when they already exist.
- **Repository operations:** `.gitignore`, manifests, lockfiles, build/test
  configuration, local-development instructions, and validation commands.

Do not open `.env`, credentials, private keys, browser state, or other secret
material. A filename is safe evidence; its content is not automatically safe.

## Persisted-data source precedence

When executable schema, migrations, ORM schema sources, or entity definitions
exist, use the repository's current executable sources as the structural source
of truth for persisted data. Record their exact paths and revision or migration
boundary. Existing Markdown database documents are secondary context: link the
authoritative sources and record only durable invariants, ownership, retention,
concurrency, privacy, or compatibility information that is not obvious from
code or schema. Do not silently resolve conflicts by copying one source over
another; report the conflict and its owner.

## Selection and preservation

1. List candidates, including missing expected controls and conflicting names,
   before proposing a change.
2. If one established source clearly owns a concern, use its exact name and
   location rather than creating a duplicate.
3. If several candidates exist, report their paths, apparent roles, status,
   and conflict; ask the user which source is authoritative.
4. If a candidate is generated, identify its generator and update the generator
   rather than editing generated output directly.
5. Propose a missing document only after a concrete current need is shown. The
   minimal project controls are the only routine bootstrap outputs.

## Reconciliation fields

For each candidate, record:

- exact path and candidate group;
- keep unchanged, preserve, create missing, revise after approval, or conflict;
- evidence used without secret contents;
- generator or owner, when known;
- impact of creating or revising it; and
- the user's pending decision when more than one source remains plausible.
