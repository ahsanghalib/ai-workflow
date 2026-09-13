# Reconciliation Proposal Report

Produce this report before changing an existing project. It is a proposal, not
approval and not a changelog.

## Header

Record:

- exact canonical target path;
- detected mode and safe Git state;
- inspection date;
- existing source-of-truth candidates and conflicts;
- whether local `git init` is proposed as a separate operation; and
- the fact that `.env`, credentials, private keys, browser state, and secret
  contents were not read.

## Per-file table

Use one row for every relevant existing or proposed path:

| Path | Kind | Evidence | Action | Owner | Approval | Impact |
| --- | --- | --- | --- | --- | --- | --- |
| `path` | `kind` | `safe` | `action` | `path/unknown` | `scope` | `impact` |

Rules for the table:

- `keep unchanged` means no content change is proposed.
- `create missing` means the path does not exist and needs a separate creation
  approval; identify the template and evidence sources.
- `revise after approval` means an existing file would change; never combine it
  with missing-file approval.
- `preserve` means an existing source of truth remains authoritative even when
  the bundled template uses another name.
- `conflict` means multiple sources or incompatible instructions need a user
  decision before any write.
- List existing symlinks as preserved or blocked; never follow them implicitly.

## Decision and handoff sections

After the table, list:

1. confirmed facts and evidence-to-field mappings;
2. inferred details, recommendations, assumptions, and unknowns separately;
3. `.gitignore` missing-rule proposals without editing the existing file;
4. conditional persistence/schema proposal and user-flow prerequisite;
5. validation commands and expected evidence;
6. approvals requested, one scope at a time; and
7. the exact next review action.

The report must state that project-init will not create application source,
framework files, dependencies, migrations, secrets, commits, remotes, branches,
or pushes as part of reconciliation.
