---
description: Plan worktree isolation using existing helpers
argument-hint: "<branch-or-task>"
---

For $@ inspect current branch, worktree list, and repository conventions.
Prefer the already installed `worktree-new` / `worktree-close` helpers and
`AI_WORKFLOW_WORKTREE_ROOT`; do not assume another harness path. Ask/obtain
approval for creation or removal where needed. Never force-remove a worktree.
