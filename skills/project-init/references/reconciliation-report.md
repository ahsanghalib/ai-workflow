# Reconciliation Proposal Report

Produce this report before changing an existing project. It is a proposal, not
approval and not a changelog. It covers the minimal control plane and any
explicitly approved routing or rule revision; it does not create a work
contract or implementation task.

## Header

Record:

- exact canonical target path;
- detected mode and safe Git state;
- inspection date;
- existing control candidates and conflicts;
- whether local `git init` is proposed separately;
- whether a substantive request is being handed to `spec-workflow`; and
- that `.env`, credentials, private keys, browser state, and secret contents
  were not read.

## Per-file table

Use one row for every relevant existing or proposed path:

| Path | Kind | Evidence | Action | Owner | Approval | Impact |
| --- | --- | --- | --- | --- | --- | --- |
| `path` | `kind` | `safe` | `action` | `path/unknown` | `scope` | `impact` |

Rules:

- `keep unchanged` means no content change is proposed;
- `create missing` means the path does not exist and has its own approval;
- `revise after approval` means an exact existing-file diff is proposed;
- `preserve` means an existing source of truth remains authoritative; and
- `conflict` means multiple sources need a user decision before writing.

List existing symlinks as preserved or blocked; never follow them implicitly.

## Decision and handoff

After the table, list confirmed facts, evidence-to-field mappings,
recommendations, assumptions, unknowns, validation commands, approvals
requested, and the exact next review action. State that project-init will not
create application source, dependencies, migrations, secrets, commits,
remotes, branches, or pushes. If the request also contains substantive work,
name the `spec-workflow` handoff and state that project-init did not create a
SPEC, task list, or implementation.
