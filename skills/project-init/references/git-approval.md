# Local Git Approval and No-Git Fallback

Git is useful for project continuity, but it is not required to create the
project-control documents. Treat local Git setup as an optional, separate
operation.

## Approval matrix

- **Git already exists:** preserve `.git` and do not run `git init`. Report
  whether safe metadata shows an unborn, established, or unreadable state.
- **Git is absent and available:** propose `git init` for the exact canonical
  target. Show the target and command, then obtain separate approval before
  passing `--init-git`.
- **Git is absent or unavailable and the user does not approve initialization:**
  continue with the approved documentation-only bootstrap when it is otherwise
  safe. Report that the target remains outside Git and that Git state,
  branch status, and history could not be validated.
- **`--init-git` is approved but Git is unavailable:** stop before creating
  any target directory or scaffold file. Report the missing capability and
  leave the target unchanged.
- **Git metadata exists but the Git executable is unavailable:** preserve the
  metadata and continue only with operations that do not need Git. Report the
  Git-state limitation; never replace or repair `.git`.

## Exact operation boundary

An approved local initialization means only:

```text
git -C <exact-canonical-target> init
```

It does not authorize a commit, branch creation or rename, remote creation or
change, push, fetch, pull, issue operation, deployment, or cleanup. Those
operations need their own explicit request and approval. The project-init
initializer never performs them.

If the user later wants Git, they can initialize the exact target themselves
or return with a separate Git request. Until then, keep generated documents
usable without assuming a branch, remote, commit, or hosting provider.
