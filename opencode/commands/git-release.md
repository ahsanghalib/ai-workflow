---
description: Prepare an approved user-run script for one annotated Git tag and GitHub release without changing branches or normal commits.
agent: engineer
---

Run the `/git-release` workflow for:

```text
$ARGUMENTS
```

## Scope and input

- Accept no argument, `patch`, `minor`, `major`, or one explicit SemVer tag in
  the form `vMAJOR.MINOR.PATCH` (an explicitly supplied SemVer prerelease or
  build suffix is allowed). Reject every other input and stop.
- Do not infer prerelease semantics. A version with a prerelease suffix is a
  prerelease only when the user explicitly supplied it; pass `--prerelease` for
  that version. Otherwise create a stable release. Do not create a draft unless
  the user explicitly requests one.
- This command may prepare exactly one annotated tag, tag push, and matching
  GitHub Release for the user to run manually. It must never commit, stage,
  modify source files, switch branches, merge, rebase, reset, delete tags,
  force-push, push normal commits, or use `git push --tags`.
- Follow the repository's established GitHub CLI safety conventions for
  repository targeting, authentication, duplicate checks, explicit mutation
  approval, and post-mutation verification.
- `github-cli-workflow` explicitly excludes release creation, so do not invoke
  it as an active skill for this command. Do not modify or broaden that skill.

## 1. Read-only preflight

Start at the Git worktree root. During preflight, do not modify the working
tree, index, local branch history, tags, or remote Git/GitHub state. Read-only
inspection and `git fetch origin` for refreshing remote-tracking references are
permitted. Determine and report:

1. Current branch and `origin` URL. Derive `GITHUB_HOST` and `GITHUB_REPO`
   (`owner/repository`) from a supported
   GitHub `origin` URL: HTTPS, `ssh://git@`, or `git@host:` form, each with an
   `owner/repository` path. Use `GITHUB_HOST/GITHUB_REPO` as the `gh -R` target
   so GitHub Enterprise remains explicit. Reject unsupported or non-GitHub
   origins rather than guessing. Query `gh -R "$GITHUB_HOST/$GITHUB_REPO" repo
   view --json nameWithOwner,url,sshUrl` and require its canonical host and
   `nameWithOwner` to match the normalized `origin` identity. Stop on any
   mismatch or ambiguity.
2. Full working-tree state with `git status --short` and `git status --branch
   --short`, including staged, unstaged, and untracked files. Stop if any exist.
3. Whether `gh` is on `PATH` and whether `gh auth status --hostname
   "$GITHUB_HOST"` succeeds. Stop if either fails; never print authentication
   tokens or credential data.
4. Whether this is a linked worktree: compare the absolute paths returned by
   `git rev-parse --path-format=absolute --git-dir` and `git rev-parse
   --path-format=absolute --git-common-dir`. If they differ, stop before preview
   and require a regular checkout; do not write release artifacts outside the
   active worktree. Otherwise, determine the primary branch, preferring
   `refs/remotes/origin/HEAD`; if unavailable, use `gh -R
   "$GITHUB_HOST/$GITHUB_REPO" repo view --json defaultBranchRef`. If neither
   is available, ask the user to identify the release branch and stop. Do not
   assume `main`.
5. The branch's upstream. If none exists, stop with the exact upstream setup
   the user must perform. Fetch `origin` without pushing so upstream state is
   current, then use `git rev-list --left-right --count <upstream>...HEAD` to
   identify ahead, behind, or diverged state. Stop when behind or diverged.
   Require the current commit to be present on the refreshed upstream; do not
   treat an unpushed local commit as releasable.
6. The latest reachable annotated or lightweight tag, using `git describe
   --tags --abbrev=0 HEAD` when one exists, and existing GitHub releases using
   `gh -R "$GITHUB_HOST/$GITHUB_REPO" release list`. Clearly distinguish no tag
   from command failure.

Release from the detected primary branch by default. If the current branch is
not that branch, stop unless the user explicitly identified this exact current
branch as the intended release branch in the request or surrounding
conversation. A version argument alone is not branch approval. Never switch
branches automatically.

Respect the active OpenCode permission policy before any mutation. `git push *`
remains denied. Do not weaken or bypass that rule. After the approved preview,
prepare the user-run script described below instead of creating a local tag.
Do not leave a local tag merely because the remote steps are prohibited.

## 2. Select a version and prevent duplicates

- With `patch`, `minor`, or `major`, derive the next stable version from the
  latest stable `vMAJOR.MINOR.PATCH` tag using standard SemVer increments. If
  no previous stable tag exists, recommend `v1.0.0` and require it in the
  preview rather than guessing a different baseline.
- With no argument, recommend the same next patch version, or `v1.0.0` for a
  first release. With an explicit version, validate SemVer before proceeding.
- Check the proposed tag locally (`git show-ref --tags --verify`) and remotely
  (`git ls-remote --tags origin refs/tags/<version>`). Check for a matching
  GitHub Release with `gh -R "$GITHUB_HOST/$GITHUB_REPO" release view <version>
  --json tagName`. If any already exists, stop and report which resource exists.
  Never overwrite or recreate it.
- Treat “resource does not exist” separately from command, authentication,
  network, or API failure. A successful `git ls-remote` with no matching ref
  means the remote tag is absent; a failed `git ls-remote` is an inspection
  failure and must stop the workflow. A confirmed GitHub “release not found”
  response means the release is absent; any other `gh -R
  "$GITHUB_HOST/$GITHUB_REPO" release view` failure must stop the workflow.
  Never interpret an inspection failure as proof that a tag or release does not
  exist.

## 3. Validate and draft notes

Discover the repository's authoritative validation entry point from its
documentation, task runner, package scripts, or CI workflow. Run that entry
point before any tag is created. Do not substitute a partial ad-hoc command
when an authoritative check exists. Stop on validation failure.

For a stable release, use the latest reachable stable SemVer tag as the release
notes baseline. For an explicitly requested prerelease, use the most recent
appropriate reachable tag preceding that prerelease when available. Keep the
version-increment and release-notes baselines explicit; never silently use an
arbitrary newer prerelease tag as the baseline for a stable release.

Draft concise release notes from `<release-notes-baseline>..HEAD`; for the
first release, inspect the repository's documented capabilities. Use Git and
GitHub history as evidence, then group user-relevant changes under only the
sections that have content:

```markdown
## Highlights

- ...

## Changes

- ...

## Fixes

- ...
```

Do not dump raw commit messages, fabricate user impact, or commit a release
notes file. A temporary notes file may be written only inside Git metadata for
the user-run script; it must never be staged or written into the working tree.

## 4. Mandatory preview and approval

Before creating a tag, present this complete preview:

- repository, release branch, and expected commit SHA;
- absolute repository root and `origin` URL that the user-run script will pin;
- previous version and proposed version;
- validation command and successful result;
- release title (default `Release <version>`) and complete release notes; and
- exact user-run mutations: `git tag -a`, `git push origin <version>`, and
  `gh release create --verify-tag --title --notes-file`, including whether the
  release is stable or explicitly requested as a prerelease/draft; and
- the version-specific script and notes-file paths that the command will write
  inside Git metadata.

Ask for explicit approval of that exact preview. Invocation of `/git-release`,
approval of a version, or a general request to release is not approval. Stop
until the user approves. Preserve normal OpenCode tool permission prompts; an
approval to the workflow never bypasses a protected or denied command.

## 5. Approved handoff script

After explicit preview approval, use `git rev-parse --git-path` to create a
version-specific executable script and notes file inside Git metadata at
`opencode/releases/<version>/release.sh` and
`opencode/releases/<version>/notes.md`. Never write them into the working tree,
stage them, or run the script. If either file already exists, replace it only
after the new preview is approved.

The script must use `set -euo pipefail` and retain the approved release notes.
Embed the approved absolute repository root, `origin` URL, GitHub host,
`owner/repository`, expected SHA, and version as quoted variables. Before any
mutation, it must:

```bash
cd "$REPO_ROOT"
[[ "$(git -C "$REPO_ROOT" rev-parse --show-toplevel)" == "$REPO_ROOT" ]]
[[ "$(git -C "$REPO_ROOT" remote get-url origin)" == "$ORIGIN_URL" ]]
command -v gh >/dev/null
gh auth status --hostname "$GITHUB_HOST"
[[ "$(gh -R "$GITHUB_HOST/$GITHUB_REPO" repo view --json nameWithOwner -q .nameWithOwner)" == "$GITHUB_REPO" ]]
```

On any failure, print a repository, remote, GitHub authentication, or target
mismatch error and exit without changing anything. Use `git -C "$REPO_ROOT"`
for every Git command and `gh -R "$GITHUB_HOST/$GITHUB_REPO"` for every
repository-scoped GitHub CLI command, even after changing directory. Use
`gh api --hostname "$GITHUB_HOST" "repos/$GITHUB_REPO/..."` for API queries.
The script must then perform only this sequence when the user runs it manually:

1. Recheck that `HEAD` is the approved SHA and the working tree is clean using
   `git -C "$REPO_ROOT"`.
2. Create `git -C "$REPO_ROOT" tag -a <version> -m "Release <version>"
   <expected-sha>` only if the tag is absent. If it exists, require `git -C
   "$REPO_ROOT" cat-file -t "refs/tags/<version>"` to return `tag` and verify
   that its peeled target is the expected SHA; otherwise stop without changing
   it.
3. Immediately before pushing, use `git -C "$REPO_ROOT" ls-remote --tags` to
   recheck the remote tag. If it is absent, push only that tag with `git -C
   "$REPO_ROOT" push origin <version>`; never use `--tags`. If it exists,
   require both `refs/tags/<version>` and `refs/tags/<version>^{}` in the
   `ls-remote` result, then verify that the peeled ref resolves to the expected
   SHA before continuing. Otherwise stop without changing it. Treat an
   `ls-remote` failure as an inspection failure, not an absent tag.
4. Immediately before release creation, use `gh -R "$GITHUB_HOST/$GITHUB_REPO"
   release view` to recheck the matching GitHub Release. Create it with `gh -R
   "$GITHUB_HOST/$GITHUB_REPO" release create <version> --verify-tag --title
   "Release <version>" --notes-file <notes-file>` only on a confirmed "release
   not found" response. If it exists, stop and report it; any other `gh release
   view` failure must stop the script. Add `--prerelease` whenever the approved
   version has a prerelease suffix. Add `--draft` only when the user explicitly
   requested it.
5. Verify the local tag and remote tag with `git -C "$REPO_ROOT" show-ref` and
   `git -C "$REPO_ROOT" ls-remote`. Verify the GitHub Release and resolve its
   browser URL with:

   ```bash
   gh -R "$GITHUB_HOST/$GITHUB_REPO" release view <version> --json tagName,targetCommitish,url
   gh api --hostname "$GITHUB_HOST" "repos/$GITHUB_REPO/releases/tags/<version>" --jq .html_url
   ```

   Then report the version, expected commit, URL, and validation result.

Report the script path and the exact command to run it. State that OpenCode did
not create a tag, push, or GitHub Release, and that the user must run the script
manually. Do not claim release success from script generation.

## Failure handling

- If the script creates a local tag but its push fails, it must report that the
  local tag exists and no GitHub Release was created. It must not delete the tag.
- If the script pushes the tag but release creation fails, it must report that
  the remote tag exists, then immediately re-query `gh -R
  "$GITHUB_HOST/$GITHUB_REPO" release view <version>` and report the observed
  state. Report that no release exists only on a confirmed "release not found"
  response; report an existing release or an indeterminate inspection failure
  distinctly. Re-running the script is safe only after it re-inspects tag and
  release state; never assume a failed command had no effect.
