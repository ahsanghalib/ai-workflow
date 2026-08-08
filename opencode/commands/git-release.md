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
  build suffix is allowed), optionally with one `--draft` flag. Reject every
  other input and stop.
- Do not infer prerelease semantics. A version with a prerelease suffix is a
  prerelease only when the user explicitly supplied it; pass `--prerelease` for
  that version. Otherwise create a stable release. Pass `--draft` only when the
  user explicitly supplied that flag.
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
inspection and a branch-only, no-tag `git fetch origin` for refreshing the
approved remote-tracking reference are permitted. Determine and report:

1. Current branch and `origin` URLs. Inspect both `git remote get-url --all
origin` and `git remote get-url --push --all origin`. Require exactly one
   regular `origin` URL and exactly one effective push destination; multiple
   push URLs are forbidden because `git push origin` pushes to every one. Derive
   `GITHUB_HOST` and `GITHUB_REPO` (`owner/repository`) from each URL using only
   supported GitHub HTTPS, `ssh://git@`, or `git@host:` forms with an
   `owner/repository` path. Require the regular and effective push URLs to
   normalize to the same `GITHUB_HOST/GITHUB_REPO`; reject unsupported,
   non-GitHub, mismatched, or ambiguous URLs rather than guessing. Pin both
   exact URLs for the handoff. For HTTPS URLs, reject any userinfo (either
   `username@` or `username:password@`) before displaying or embedding a URL;
   require credential helpers, SSH authentication, or another non-embedded
   authentication mechanism. Continue allowing the `git@` SSH username in
   supported SSH URL forms. Set `GH_REPO="$GITHUB_HOST/$GITHUB_REPO"` for every
   repository-scoped `gh` invocation so repository targeting remains explicit
   and works consistently across GitHub CLI command groups. Query
   `GH_REPO="$GITHUB_HOST/$GITHUB_REPO" gh repo view --json
nameWithOwner,url,sshUrl,defaultBranchRef` and require its canonical host and
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
   active worktree. Otherwise, determine the primary branch from GitHub's
   authoritative `defaultBranchRef.name`. When `refs/remotes/origin/HEAD` is
   available, use it only as a consistency check against that GitHub value. If
   GitHub provides no default branch, ask the user to identify the release
   branch and stop. Do not assume `main`.
5. The branch's upstream. If none exists, stop with the exact upstream setup
   the user must perform. Require its remote to be exactly `origin`; stop when
   the current branch tracks another remote. Capture
   `EXPECTED_UPSTREAM_REMOTE='origin'` and the upstream branch name as
   `EXPECTED_UPSTREAM_BRANCH`. Fetch only that branch with `--no-tags` and the
   explicit refspec `refs/heads/$EXPECTED_UPSTREAM_BRANCH:refs/remotes/origin/$EXPECTED_UPSTREAM_BRANCH`,
   then use `git rev-list --left-right --count
refs/remotes/origin/$EXPECTED_UPSTREAM_BRANCH...HEAD` to identify ahead,
   behind, or diverged state. Stop unless `HEAD` is exactly the refreshed
   upstream tip; do not treat an unpushed local commit as releasable. Capture
   `EXPECTED_BRANCH` and the full `EXPECTED_SHA` for the approved handoff.
6. The latest reachable annotated or lightweight tag, using `git describe
--tags --abbrev=0 HEAD` when one exists, and existing GitHub releases using
   `GH_REPO="$GITHUB_HOST/$GITHUB_REPO" gh release list`. Clearly distinguish no tag
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
  highest reachable stable tag matching exactly `vMAJOR.MINOR.PATCH`, using
  SemVer precedence and standard SemVer increments. Do not use tag creation
  date, commit distance, or `git describe` proximity for this version baseline;
  build metadata and prerelease tags do not qualify. If no previous stable tag
  exists, recommend `v1.0.0` and require it in the preview rather than guessing
  a different baseline.
- With no argument, recommend the same next patch version, or `v1.0.0` for a
  first release. With an explicit version, validate SemVer before proceeding.
- Check the proposed tag locally (`git show-ref --tags --verify`) and remotely
  (`git ls-remote --tags origin refs/tags/<version>` and
  `refs/tags/<version>^{}`). Check the matching GitHub Release through
  `gh api --hostname "$GITHUB_HOST" --include --silent
"repos/$GITHUB_REPO/releases/tags/$VERSION"`, not `gh release view`. An HTTP
  200 means it exists, HTTP 404 means it is absent, and every other response or
  failure stops preparation. If a tag or release exists, stop and report it.
  Never overwrite, force-update, recreate, or delete it.
- Treat “resource does not exist” separately from command, authentication,
  network, or API failure. A successful `git ls-remote` with no matching ref
  means the remote tag is absent; a failed `git ls-remote` is an inspection
  failure and must stop the workflow. Never parse human-readable GitHub CLI
  diagnostics or interpret an inspection failure as proof of absence.

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
first release, inspect the repository's documented capabilities. Use only
current repository evidence: documentation, Git history, configuration,
commands, skills, helper scripts, validation files, and inspected source. Verify
every meaningful claim (including named commands, agents, skills, helpers,
Playwright support, safety boundaries, validation behavior, and `/git-release`
behavior); remove or rewrite unsupported claims. Do not infer a compatibility
range from package metadata, local tools, history, or assumptions. Group
user-relevant changes under only the sections that have content:

```markdown
## Highlights

- ...

## Changes

- ...

## Fixes

- ...
```

Do not dump raw commit messages, fabricate user impact, expose unnecessary
internal details, or commit a release-notes file. For this repository's first
stable release, evidence supports concise highlights about the safety-first
OpenCode workflow, model-tier and Git-worktree helpers, opt-in Playwright, and
an approval-gated `/git-release` workflow that prepares a user-run release
script while keeping remote publishing outside the OpenCode agent. A temporary
notes file may be written only inside Git metadata for the user-run script; it
must never be staged or written into the working tree.

## 4. Mandatory preview and approval

Before creating a tag, present this complete preview:

- repository, release branch, upstream, and expected commit SHA;
- absolute repository root and the regular `origin` URL plus its one effective
  push URL that the user-run script will pin;
- previous version and proposed version;
- validation command and successful result;
- release title (default `Release <version>`) and complete release notes; and
- exact user-run mutations: `git tag -a`,
  `git push origin "refs/tags/<version>:refs/tags/<version>"`, and
  `GH_REPO="$GITHUB_HOST/$GITHUB_REPO" gh release create --verify-tag --title
--notes-file`, including whether the
  release is stable or explicitly requested as a prerelease/draft; and
- the version-specific `ai-workflow/releases/<version>/release.sh` and
  `ai-workflow/releases/<version>/notes.md` paths, resolved through Git metadata.

Ask for explicit approval of that exact preview. Invocation of `/git-release`,
approval of a version, or a general request to release is not approval. Stop
until the user approves. Preserve normal OpenCode tool permission prompts; an
approval to the workflow never bypasses a protected or denied command.

## 5. Approved handoff script

After explicit preview approval, resolve the private artifact namespace through
Git metadata, never a hard-coded `.git` path:

```bash
RELEASE_DIR="$(git rev-parse --git-path "ai-workflow/releases/$VERSION")"
SCRIPT_FILE="$RELEASE_DIR/release.sh"
NOTES_FILE="$RELEASE_DIR/notes.md"
mkdir -p "$RELEASE_DIR"
```

Resolve all three paths to absolute paths. Write the exact previewed notes bytes
to `NOTES_FILE`, then compute `EXPECTED_NOTES_HASH="$(git -C "$REPO_ROOT"
hash-object "$NOTES_FILE")"`. The approval preview and the file supplied to GitHub must be
byte-for-byte identical. Write no artifact into the working tree, and only
replace an existing artifact after approval.

Generate `SCRIPT_FILE` with `#!/usr/bin/env bash` followed by `set -euo
pipefail`. Serialize every pinned value with Bash's `printf '%q'`, not naïve
single quotes: `REPO_ROOT`, `ORIGIN_URL`,
`PUSH_URL`, `GITHUB_HOST`, `GITHUB_REPO`, `EXPECTED_BRANCH`,
`EXPECTED_UPSTREAM_REMOTE`, `EXPECTED_UPSTREAM_BRANCH`, `EXPECTED_SHA`,
`VERSION`, absolute `NOTES_FILE`, `EXPECTED_NOTES_HASH`, and the successful
`VALIDATION_RESULT`. Use the same mechanism for a
`RELEASE_FLAGS` Bash array containing only approved `--prerelease` and `--draft`
flags. This must remain valid for paths with spaces or apostrophes.

The generated script must define `die`, then a `normalize_github_url` helper
that implements the same supported-GitHub-URL normalization as preflight and
emits `GITHUB_HOST/GITHUB_REPO`. The helper must reject HTTPS URLs containing
userinfo before any URL is printed or persisted, while continuing to allow the
`git@` SSH username in supported SSH forms. Define it before these read-only
inspection helpers:

```bash
inspect_local_tag() {
  LOCAL_TAG_OBJECT=''
  LOCAL_TAG_TARGET=''
  if git -C "$REPO_ROOT" show-ref --tags --verify --quiet "refs/tags/$VERSION"; then
    [[ "$(git -C "$REPO_ROOT" cat-file -t "refs/tags/$VERSION")" == tag ]] || die "existing local $VERSION is not annotated"
    LOCAL_TAG_OBJECT="$(git -C "$REPO_ROOT" rev-parse "refs/tags/$VERSION")"
    LOCAL_TAG_TARGET="$(git -C "$REPO_ROOT" rev-parse "refs/tags/$VERSION^{}")"
    [[ "$LOCAL_TAG_TARGET" == "$EXPECTED_SHA" ]] || die "existing local $VERSION does not target $EXPECTED_SHA"
  else
    local status=$?
    [[ "$status" -eq 1 ]] || die "could not inspect local tag $VERSION"
  fi
}

inspect_remote_tag() {
  local refs object_id ref_name
  REMOTE_TAG_OBJECT=''
  REMOTE_TAG_TARGET=''
  refs="$(git -C "$REPO_ROOT" ls-remote --tags origin "refs/tags/$VERSION" "refs/tags/$VERSION^{}")" || die "could not inspect remote tag $VERSION"
  while IFS=$'\t' read -r object_id ref_name; do
    case "$ref_name" in
      "refs/tags/$VERSION") REMOTE_TAG_OBJECT="$object_id" ;;
      "refs/tags/$VERSION^{}") REMOTE_TAG_TARGET="$object_id" ;;
    esac
  done <<< "$refs"
  if [[ -n "$REMOTE_TAG_OBJECT" || -n "$REMOTE_TAG_TARGET" ]]; then
    [[ -n "$REMOTE_TAG_OBJECT" && -n "$REMOTE_TAG_TARGET" ]] || die "remote $VERSION is not an annotated tag with a peeled target"
    [[ "$REMOTE_TAG_TARGET" == "$EXPECTED_SHA" ]] || die "remote $VERSION does not target $EXPECTED_SHA"
  fi
}

release_state() {
  local response status api_exit
  if response="$(gh api --hostname "$GITHUB_HOST" --include --silent "repos/$GITHUB_REPO/releases/tags/$VERSION" 2>&1)"; then
    api_exit=0
  else
    api_exit=$?
  fi
  if [[ "$response" =~ HTTP/[0-9.]+[[:space:]]+([0-9]{3}) ]]; then
    status="${BASH_REMATCH[1]}"
  else
    RELEASE_STATE='indeterminate'
    return 1
  fi
  case "$status" in
    200) [[ "$api_exit" -eq 0 ]] || { RELEASE_STATE='indeterminate'; return 1; }; RELEASE_STATE='exists' ;;
    404) [[ "$api_exit" -eq 1 ]] || { RELEASE_STATE='indeterminate'; return 1; }; RELEASE_STATE='absent' ;;
    *) RELEASE_STATE='indeterminate'; return 1 ;;
  esac
}

require_release_absent() {
  release_state || die "could not inspect GitHub Release $VERSION"
  [[ "$RELEASE_STATE" == absent ]] || die "GitHub Release $VERSION already exists"
}

verify_local_tag() {
  inspect_local_tag
  [[ -n "$LOCAL_TAG_OBJECT" && "$LOCAL_TAG_TARGET" == "$EXPECTED_SHA" ]] || die "local tag $VERSION verification failed"
}

verify_remote_tag() {
  inspect_remote_tag
  [[ "$REMOTE_TAG_OBJECT" == "$LOCAL_TAG_OBJECT" ]] || die "remote $VERSION is not the exact local annotated tag object"
  [[ "$REMOTE_TAG_TARGET" == "$EXPECTED_SHA" ]] || die "remote $VERSION verification failed"
}
```

Before any mutation, the generated script must perform this exact order, using
`git -C "$REPO_ROOT"` for every Git command, `GH_REPO="$GITHUB_HOST/$GITHUB_REPO"
gh ...` for repository-scoped commands, and `gh api --hostname "$GITHUB_HOST"`
for API queries:

```bash
cd "$REPO_ROOT" || die "repository mismatch: cannot enter $REPO_ROOT"
[[ "$(git -C "$REPO_ROOT" rev-parse --show-toplevel)" == "$REPO_ROOT" ]] || die 'repository mismatch'
origin_urls_output="$(git -C "$REPO_ROOT" remote get-url --all origin)" || die 'could not inspect origin URLs'
mapfile -t ORIGIN_URLS <<< "$origin_urls_output"
[[ "${#ORIGIN_URLS[@]}" -eq 1 && "${ORIGIN_URLS[0]}" == "$ORIGIN_URL" ]] || die 'origin URL mismatch'
push_urls_output="$(git -C "$REPO_ROOT" remote get-url --push --all origin)" || die 'could not inspect origin push URLs'
mapfile -t PUSH_URLS <<< "$push_urls_output"
[[ "${#PUSH_URLS[@]}" -eq 1 && "${PUSH_URLS[0]}" == "$PUSH_URL" ]] || die 'origin push destination mismatch'
origin_identity="$(normalize_github_url "$ORIGIN_URL")" || die 'origin URL is unsupported'
push_identity="$(normalize_github_url "$PUSH_URL")" || die 'origin push URL is unsupported'
[[ "$origin_identity" == "$GITHUB_HOST/$GITHUB_REPO" && "$push_identity" == "$origin_identity" ]] || die 'origin push target mismatch'
command -v gh >/dev/null || die 'GitHub CLI is unavailable'
gh auth status --hostname "$GITHUB_HOST" || die 'GitHub authentication failed'
[[ "$(GH_REPO="$GITHUB_HOST/$GITHUB_REPO" gh repo view --json nameWithOwner -q .nameWithOwner)" == "$GITHUB_REPO" ]] || die 'GitHub target mismatch'
GIT_DIR="$(git -C "$REPO_ROOT" rev-parse --path-format=absolute --git-dir)"
COMMON_DIR="$(git -C "$REPO_ROOT" rev-parse --path-format=absolute --git-common-dir)"
[[ "$GIT_DIR" == "$COMMON_DIR" ]] || die 'release must run from the approved regular checkout'
[[ "$(git -C "$REPO_ROOT" branch --show-current)" == "$EXPECTED_BRANCH" ]] || die "current branch is not approved release branch $EXPECTED_BRANCH"
[[ "$(git -C "$REPO_ROOT" rev-parse HEAD)" == "$EXPECTED_SHA" ]] || die "HEAD is not approved commit $EXPECTED_SHA"
[[ -z "$(git -C "$REPO_ROOT" status --porcelain)" ]] || die 'working tree is not clean'
[[ "$EXPECTED_UPSTREAM_REMOTE" == origin ]] || die 'approved upstream remote is not origin'
current_upstream="$(git -C "$REPO_ROOT" rev-parse --abbrev-ref --symbolic-full-name '@{upstream}')" || die 'current branch has no upstream'
[[ "$current_upstream" == "origin/$EXPECTED_UPSTREAM_BRANCH" ]] || die 'current branch upstream changed after approval'
git -C "$REPO_ROOT" fetch --no-tags origin "refs/heads/$EXPECTED_UPSTREAM_BRANCH:refs/remotes/origin/$EXPECTED_UPSTREAM_BRANCH" || die 'could not fetch approved origin branch'
git -C "$REPO_ROOT" rev-parse --verify --quiet "refs/remotes/origin/$EXPECTED_UPSTREAM_BRANCH^{commit}" >/dev/null || die "approved upstream origin/$EXPECTED_UPSTREAM_BRANCH no longer exists"
[[ "$(git -C "$REPO_ROOT" rev-parse "refs/remotes/origin/$EXPECTED_UPSTREAM_BRANCH")" == "$EXPECTED_SHA" ]] || die "origin/$EXPECTED_UPSTREAM_BRANCH changed since this release was approved. Regenerate the release with /git-release."
[[ -f "$NOTES_FILE" ]] || die 'approved release notes are missing'
ACTUAL_NOTES_HASH="$(git -C "$REPO_ROOT" hash-object "$NOTES_FILE")"
[[ "$ACTUAL_NOTES_HASH" == "$EXPECTED_NOTES_HASH" ]] || die 'release notes changed after approval; regenerate the release'
umask 077
NOTES_SNAPSHOT="$(mktemp "${NOTES_FILE%/*}/release-notes.XXXXXX")" || die 'could not create release-notes snapshot'
trap 'rm -f "$NOTES_SNAPSHOT"' EXIT
cp -- "$NOTES_FILE" "$NOTES_SNAPSHOT" || die 'could not snapshot approved release notes'
[[ "$(git -C "$REPO_ROOT" hash-object "$NOTES_SNAPSHOT")" == "$EXPECTED_NOTES_HASH" ]] || die 'release notes changed while creating the snapshot; regenerate the release'
exec {NOTES_FD}<"$NOTES_SNAPSHOT"
rm -f "$NOTES_SNAPSHOT" || die 'could not secure release-notes snapshot'
NOTES_STREAM="/dev/fd/$NOTES_FD"
inspect_local_tag
inspect_remote_tag
if [[ -z "$LOCAL_TAG_OBJECT" && -n "$REMOTE_TAG_OBJECT" ]]; then
  die "remote tag $VERSION appeared after approval; this handoff is invalid. Inspect the tag manually. /git-release will not adopt or overwrite an existing remote tag."
fi
if [[ -n "$LOCAL_TAG_OBJECT" && -n "$REMOTE_TAG_OBJECT" ]]; then
  [[ "$REMOTE_TAG_OBJECT" == "$LOCAL_TAG_OBJECT" ]] || die "remote $VERSION is not the exact local annotated tag object"
fi
require_release_absent

# ---------- NO MUTATIONS ABOVE THIS POINT ----------
```

Only then may the script use this mutation and recovery sequence:

```bash
if [[ -z "$LOCAL_TAG_OBJECT" ]]; then
  git -C "$REPO_ROOT" tag -a "$VERSION" -m "Release $VERSION" "$EXPECTED_SHA" || die "could not create local annotated tag $VERSION"
  verify_local_tag
fi
if [[ -z "$REMOTE_TAG_OBJECT" ]]; then
  if ! git -C "$REPO_ROOT" push origin "refs/tags/$VERSION:refs/tags/$VERSION"; then
    printf 'release: local tag %s exists; push failed; remote tag and GitHub Release were not completed.\n' "$VERSION" >&2
    exit 1
  fi
fi
verify_remote_tag
require_release_absent
if ! GH_REPO="$GITHUB_HOST/$GITHUB_REPO" gh release create "$VERSION" \
  --verify-tag --title "Release $VERSION" --notes-file "$NOTES_STREAM" \
  "${RELEASE_FLAGS[@]}"; then
  printf 'release: remote tag %s exists; GitHub Release creation failed.\n' "$VERSION" >&2
  if release_state; then
    case "$RELEASE_STATE" in
      exists) printf 'release: observed an existing GitHub Release.\n' >&2 ;;
      absent) printf 'release: confirmed no GitHub Release exists for %s.\n' "$VERSION" >&2 ;;
    esac
  else
    printf 'release: GitHub Release state is indeterminate; inspect it before retrying.\n' >&2
  fi
  exit 1
fi
verify_local_tag
verify_remote_tag
release_state || die "could not verify GitHub Release $VERSION"
[[ "$RELEASE_STATE" == exists ]] || die "GitHub Release $VERSION is missing after creation"
release_json="$(GH_REPO="$GITHUB_HOST/$GITHUB_REPO" gh release view "$VERSION" --json tagName,targetCommitish,url)" || die "could not verify GitHub Release $VERSION"
release_url="$(gh api --hostname "$GITHUB_HOST" "repos/$GITHUB_REPO/releases/tags/$VERSION" --jq .html_url)" || die "could not resolve GitHub Release URL"
printf 'Release created and verified: %s\nExpected commit: %s\nURL: %s\nValidation: %s\n' "$VERSION" "$EXPECTED_SHA" "$release_url" "$VALIDATION_RESULT"
printf 'Release verification: %s\n' "$release_json"
```

Never fetch a tag, overwrite, force-update, recreate, or delete a tag. If a valid
remote annotated tag exists without a local tag, stop with the recovery
instruction above rather than creating another annotated object. The sequence
rechecks exact remote object identity and release absence immediately before
`gh release create`, retains `--verify-tag`, and reports a created—not merely
prepared—release after final verification.

If local tag creation succeeded but push fails, report the local tag exists and
the remote tag/release were not completed; never delete it. If the push
succeeded but release creation fails, report the remote tag and call
`release_state` again: report existing, confirmed absent, or indeterminate
state distinctly. Every rerun must repeat all repository, branch, upstream,
HEAD, notes, local-tag, remote-tag, and release-state inspections before any
mutation.

After writing the script, run `chmod 700 "$SCRIPT_FILE"` and require
`[[ -x "$SCRIPT_FILE" ]]`. Report `SCRIPT_FILE`, `NOTES_FILE`, and the exact
user command `bash "$SCRIPT_FILE"` to run it. The script must provide `gh` an
unlinked, inherited-file-descriptor snapshot whose hash was verified against
the approved notes before any mutation, rather than the mutable `NOTES_FILE`
path. State that OpenCode prepared the handoff only; the user must run the
script to create and verify the release.

## 6. Validate the handoff

Inspect the generated files, run `bash -n "$SCRIPT_FILE"`, and run
`shellcheck "$SCRIPT_FILE"` when available (otherwise explicitly say it was
unavailable). Confirm the embedded hash equals `git -C "$REPO_ROOT" hash-object
"$NOTES_FILE"`.
Use disposable repositories and a mocked `gh` without pushing a real tag or
creating a real release to test: happy pre-mutation checks; advanced upstream;
changed/deleted notes; existing remote tag; same-target different annotated tag
objects; release HTTP 200; API failure other than 404; dirty tree; wrong branch;
wrong origin/repository; mismatched or multiple origin push destinations;
non-`origin` upstream; a remote tag appearing after approval; linked worktree;
HTTPS fetch or push URLs with userinfo; highest-reachable-SemVer selection when
tag dates and commit proximity disagree; and paths containing spaces and an
apostrophe. Each rejection must happen before local tag creation.

Search for stale implementation patterns: `gh -R`, `ai-workflow/releases`,
`.git/ai-workflow/releases`, `git push --tags`, and
`confirmed_release_not_found`. Remove them unless they occur only in prose that
describes a forbidden pattern. Run the repository's authoritative validation,
`git diff --check`, and review the complete diff.
