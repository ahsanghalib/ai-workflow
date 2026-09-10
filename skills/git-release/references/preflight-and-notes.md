# Git-release preflight and notes reference

Use this reference for the detailed read-only and preview workflow. The
entrypoint remains the authoritative scope and trigger contract.

## Scope and input

- Accept no argument, `patch`, `minor`, `major`, or one explicit SemVer tag in
  the form `vMAJOR.MINOR.PATCH`. An explicitly supplied prerelease or build
  suffix is allowed. An optional `--draft` flag is allowed once. Reject every
  other input and stop.
- Do not infer prerelease semantics. A version with a prerelease suffix is a
  prerelease only when the user explicitly supplied it. Pass `--prerelease`
  only for that version. Pass `--draft` only when explicitly supplied.
- Prepare exactly one annotated tag, tag push, and matching GitHub Release for
  the user to run manually. Never commit, stage, modify source files, switch
  branches, merge, rebase, reset, delete tags, force-push, push normal commits,
  or use `git push --tags`.
- `github-cli-workflow` excludes release creation. Do not invoke it as the
  active workflow for this task or broaden it.

## Read-only preflight

Start at the Git worktree root. Preflight must not modify the working tree,
index, local history, tags, or remote Git/GitHub state. A branch-only,
no-tag fetch may refresh the approved remote-tracking reference.

Determine and report:

1. Current branch and `origin` URLs. Inspect both
   `git remote get-url --all origin` and
   `git remote get-url --push --all origin`. Require exactly one regular URL
   and one effective push destination. Multiple push URLs are forbidden
   because `git push origin` sends to every one. Normalize both URLs using only
   supported GitHub HTTPS, `ssh://git@`, or `git@host:` forms with an
   `owner/repository` path. Require the same normalized
   `GITHUB_HOST/GITHUB_REPO`; reject unsupported, non-GitHub, mismatched, or
   ambiguous URLs. Pin both exact URLs for the handoff. Reject HTTPS userinfo
   before displaying or embedding a URL. The `git@` SSH username is allowed
   in supported SSH forms. Use `GH_REPO="$GITHUB_HOST/$GITHUB_REPO"` for every
   repository-scoped GitHub CLI invocation and confirm the canonical target
   matches the normalized remote. Query the canonical repository with:

   ```bash
   GH_REPO="$GITHUB_HOST/$GITHUB_REPO" gh repo view \
     --json nameWithOwner,url,sshUrl,defaultBranchRef
   ```

   Require `nameWithOwner`, the canonical HTTPS/SSH URLs, and
   `defaultBranchRef.name` to match the normalized target and branch policy.
2. Full state from `git status --short` and `git status --branch --short`,
   including staged, unstaged, and untracked files. Stop if any exist.
3. That `gh` is on `PATH` and `gh auth status --hostname "$GITHUB_HOST"`
   succeeds. Never print authentication tokens or credential data.
4. Whether the checkout is linked. Compare the absolute paths from
   `git rev-parse --path-format=absolute --git-dir` and
   `git rev-parse --path-format=absolute --git-common-dir`. If they differ,
   stop and require a regular checkout. Determine the primary branch from
   GitHub's authoritative `defaultBranchRef.name`; use
   `refs/remotes/origin/HEAD` only as a consistency check. If GitHub has no
   default branch, ask the user to identify the release branch. Never assume
   `main`.
5. The branch upstream. If there is none, stop with the exact setup command
   the user must perform. Require its remote to be exactly `origin`. Capture
   `EXPECTED_UPSTREAM_REMOTE=origin` and
   `EXPECTED_UPSTREAM_BRANCH`. Fetch only that branch with `--no-tags` and the
   explicit refspec
   `refs/heads/$EXPECTED_UPSTREAM_BRANCH:refs/remotes/origin/$EXPECTED_UPSTREAM_BRANCH`.
   Use `git rev-list --left-right --count
   refs/remotes/origin/$EXPECTED_UPSTREAM_BRANCH...HEAD` to identify ahead,
   behind, or diverged state. Stop unless `HEAD` exactly equals the refreshed
   upstream tip. Capture `EXPECTED_BRANCH` and the full `EXPECTED_SHA`.
6. The latest reachable annotated or lightweight tag, using
   `git describe --tags --abbrev=0 HEAD` when one exists, and existing GitHub
   releases using `GH_REPO="$GITHUB_HOST/$GITHUB_REPO" gh release list`.
   Distinguish absence from inspection failure.

Release from the detected primary branch by default. If the current branch is
not that branch, stop unless the user explicitly identified this exact branch
as the intended release branch. A version argument alone is not branch
approval. Never switch branches automatically. Follow the active harness's
permission policy; workflow approval never bypasses a denied mutation.

## Select a version and prevent duplicates

- For `patch`, `minor`, or `major`, derive the next stable version from the
  highest reachable stable tag matching exactly `vMAJOR.MINOR.PATCH`, using
  SemVer precedence and standard increments. Do not use tag date, commit
  distance, or `git describe` proximity. Build metadata and prerelease tags do
  not qualify. With no stable tag, recommend `v1.0.0` and require it in the
  preview rather than guessing.
- With no argument, recommend the same next patch version, or `v1.0.0` for a
  first release. Validate explicit versions before proceeding.
- Check the proposed tag locally with `git show-ref --tags --verify`,
  remotely with `git ls-remote --tags origin refs/tags/<version>` and
  `refs/tags/<version>^{}`, and the matching GitHub Release through
  `gh api --hostname "$GITHUB_HOST" --include --silent
  "repos/$GITHUB_REPO/releases/tags/$VERSION"`, not `gh release view`. HTTP
  200 means it exists, HTTP 404 means it is absent, and any other response or
  failure stops preparation. Never overwrite, force-update, recreate, or
  delete an existing tag or release.
- Treat absence separately from command, authentication, network, or API
  failure. A successful `git ls-remote` with no matching ref proves absence;
  a failed inspection does not. Never parse human-readable CLI diagnostics as
  proof of absence.

## Validate and draft notes

Discover the repository's authoritative validation entry point from its
documentation, task runner, package scripts, or CI workflow. Run that entry
point before any tag is created. Do not substitute a partial ad-hoc command
when an authoritative check exists. Stop on validation failure.

For a stable release, use the latest reachable stable SemVer tag as the notes
baseline. For an explicitly requested prerelease, use the most recent
appropriate reachable tag preceding it when available. Keep version and notes
baselines explicit. Never silently use an arbitrary newer prerelease tag as a
stable-release baseline.

Draft concise notes from `<release-notes-baseline>..HEAD`; for the first
release, inspect documented capabilities. Use only current repository evidence:
documentation, Git history, configuration, commands, skills, helper scripts,
validation files, and inspected source. Verify every meaningful claim,
including named commands, agents, skills, helpers, browser support, safety
boundaries, validation behavior, and this release workflow. Remove or rewrite
unsupported claims. Do not infer a compatibility range from metadata, local
tools, history, or assumptions. Use only sections with content:

```markdown
## Highlights

- ...

## Changes

- ...

## Fixes

- ...
```

Do not dump raw commit messages, fabricate user impact, expose unnecessary
internal details, or commit a release-notes file. Temporary notes may exist
only inside Git metadata for the user-run script and must never be staged or
written into the working tree.

## Mandatory preview and approval

Before creating anything, present the complete preview:

- repository, release branch, upstream, and expected commit SHA;
- absolute repository root, exact regular `origin` URL, and its one effective
  push URL;
- previous and proposed versions;
- validation command and successful result;
- release title, defaulting to `Release <version>`, and complete notes;
- exact user-run mutations: `git tag -a`, the exact tag ref push, and the
  repository-targeted GitHub Release command, including stable/prerelease and
  draft flags; and
- version-specific private artifact paths resolved through Git metadata.

Ask for explicit approval of that exact preview and stop until it is given.
Approval of a version or a general request to release is not approval of the
preview. Preserve normal harness permission prompts.
