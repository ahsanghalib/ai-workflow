---
description: Plan worktree isolation using workmux
argument-hint: "<branch-or-task>"
---

For $@ inspect current branch, worktree list, and repository conventions.
Prefer `workmux add --dry-run` followed by `workmux add` for creation, then use
`workmux open`, `workmux status`, and `workmux close` to manage the window.
Review configured file operations and hooks; do not use `--with-changes` or
copy secrets without explicit approval. If workmux is unavailable, use
`worktree-new` only when isolation is authorized. After the user merges, close
the workmux window and use `worktree-close` for guarded cleanup. Agents must
not run workmux merge or rebase workflows; never force-remove a worktree.
