---
name: git-worktree-workflow
description: Use when deciding whether to isolate substantial implementation work in a Git worktree and managing its lifecycle with workmux. Do not use for read-only research, planning, review, documentation-only changes, trivial edits, or arbitrary branch cleanup.
license: MIT
metadata:
  compatibility: Prefers Git and the workmux CLI; uses the repository's worktree-new helper only as a fallback and worktree-close for guarded cleanup
---

# Git Worktree Workflow

Use workmux to create, open, monitor, and temporarily close isolated
implementation worktrees. The repository's `worktree-close` helper provides
guarded final cleanup. This workflow does not authorize commits, pushes, pull
requests, merges, or rebases.

## Decide whether to isolate

Use a worktree when the task is substantial enough that keeping the current
checkout untouched is useful, especially for implementation, debugging, or
tests that may run for more than one session.

Do not create one for read-only research, planning, review, documentation-only
changes, or trivial edits unless the user explicitly requests isolation. If it
is unclear whether isolation is worthwhile, ask before creating it.

## Preflight

1. Confirm the current repository, branch, and working-tree state with
   `git status --short --branch`.
2. Confirm `workmux` resolves with `command -v` and inspect existing worktrees
   with `workmux list`.
3. Choose a full branch name using the repository's naming convention and an
   existing local base ref. Workmux uses the checked-out branch by default
   unless configuration or `--base` selects another ref.
4. Use `workmux add --dry-run` to inspect the target path, base, multiplexer
   target, configured file operations, and setup hooks before creation.
5. A new worktree does not inherit tracked uncommitted changes. Never use
   `workmux add --with-changes` unless the user explicitly approves moving
   changes out of the current checkout.
6. If `implement-next` will execute the task, complete worktree setup first and
   invoke it only from the selected checkout. `implement-next` executes an
   approved task; it does not create the worktree.

Never read or print `.env` contents, credentials, private keys, or other
secrets. Review active workmux `files.copy`, `files.symlink`, and `post_create`
settings before creation. Keep copied paths narrowly scoped, do not copy
secrets, and do not run untrusted setup hooks. Workmux does not copy ignored
files by default; project configuration can opt files in.

## Create and use the worktree

Run from the target repository, using a local base ref selected in preflight:

```bash
workmux add feature/my-change --base main --dry-run
workmux add feature/my-change --base main
```

Use the reported worktree path and confirm the branch before editing:

```bash
workmux path feature-my-change
git branch --show-current
```

Use `workmux open`, `workmux status`, and `workmux close` to resume, inspect,
and temporarily close the managed window. `workmux close` leaves the worktree
and branch in place.

If workmux is unavailable and isolation is authorized, use the installed
`worktree-new` helper:

```bash
worktree-new feature/my-change main
```

The fallback requires an absolute `AI_WORKFLOW_WORKTREE_ROOT` and does not
create a workmux window. If neither path is available, ask before using manual
Git worktree commands.

## Close the worktree

Cleanup removes the worktree directory and local branch. Only prepare or run it
after the branch is merged and the user has approved the exact target path,
branch, merge ref, and any remote verification. First close its managed window,
then run the helper from outside the target worktree:

```bash
workmux close feature-my-change
worktree-close /path/to/worktree origin/main
```

`worktree-close` refuses to remove the main checkout, a detached or dirty
worktree, a worktree containing ignored files, or a branch not proven merged.
For squash- or rebase-merged pull requests, its GitHub CLI fallback binds the
query to the selected repository and requires the merged PR head to match the
current local branch tip. It may fetch or query GitHub; check network policy
and obtain required approval before invoking it.

Agents must not invoke workmux `/merge`, `/rebase`, `workmux merge`, or
`workmux rebase`; the repository Git policy reserves commits, merges, and
rebases to the user. Do not use `workmux remove --force` or `--gone` for
routine cleanup. `--gone` fetches and prunes remote refs.

If the task requires creating, editing, commenting on, reviewing, or merging a
GitHub issue or pull request, load `github-cli-workflow`. Never bypass a
cleanup refusal with force removal or manual branch deletion. Resolve the
reported condition, re-check the target, and obtain fresh approval if the
cleanup target or merge evidence changes.

## Handoff checklist

- Record the worktree path and branch in the task handoff.
- Run task validation from inside the isolated checkout.
- Leave the checkout clean before requesting cleanup.
- Keep cleanup separate from commit, push, PR, merge, or release actions.
