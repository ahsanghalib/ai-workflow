<!-- markdownlint-disable MD013 -->

# Git-release handoff reference

This reference describes the deterministic handoff contract. Keep it separate
from the skill entrypoint because it is needed only after preview approval.

## Private artifacts

Resolve the artifact directory through Git metadata, not a hard-coded `.git`
path. The generated artifact is a Bash script; the shown implementation
requires Bash 4+ for arrays, `[[ ]]`, `mapfile`, and `set -o pipefail`. Use the
active environment's equivalent only when it preserves the same checks and
approved values:

```bash
RELEASE_DIR="$(git rev-parse --git-path "ai-workflow/releases/$VERSION")"
SCRIPT_FILE="$RELEASE_DIR/release.sh"
NOTES_FILE="$RELEASE_DIR/notes.md"
mkdir -p "$RELEASE_DIR"
```

Resolve absolute paths. Write the exact approved notes, hash them with
`git hash-object`, and embed the expected hash in the script. Never put these
artifacts in the working tree.

## Script contract

Generate a Bash script with `set -euo pipefail` and safely serialize every
preview-pinned value with `printf '%q'`, including repository, exact remote
URLs, normalized GitHub target, branch/upstream, SHA, version, notes path,
notes hash, validation result, and approved release flags. Serialize a
`RELEASE_FLAGS` Bash array the same way, containing only explicitly approved
`--prerelease` and `--draft` flags, and keep it valid for paths containing
spaces or apostrophes.

Before any mutation, re-check:

- repository root and exact origin and push URLs;
- normalized GitHub target and authenticated `gh` access;
- regular checkout, approved branch, SHA, clean worktree, and upstream;
- refreshed upstream tip equals the approved SHA;
- notes hash matches the approved preview;
- local and remote tag state is absent or the exact approved annotated object;
- matching GitHub Release is absent.

Only after those checks may the user-run script create the annotated tag, push
that exact tag ref, verify the remote object and peeled target, and create the
matching GitHub Release with the approved title, notes, and flags. If any
mutation partially succeeds, stop and report the exact recovery state. Never
adopt or overwrite an unexpected tag or release.

## Required inspection helpers

The generated script must define `die`, then a URL-normalization helper that
implements the same supported-GitHub forms as preflight and rejects HTTPS
userinfo before any URL is printed or persisted. Define these read-only
inspection helpers before the mutation section:

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

## Required order before mutation

Before any mutation, the generated script must use `git -C "$REPO_ROOT"` for
every Git command, an explicit repository target for repository-scoped GitHub
CLI commands, and `gh api --hostname "$GITHUB_HOST"` for API queries. It must
perform this order:

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
[[ "$(git -C "$REPO_ROOT" rev-parse "refs/remotes/origin/$EXPECTED_UPSTREAM_BRANCH")" == "$EXPECTED_SHA" ]] || die "origin/$EXPECTED_UPSTREAM_BRANCH changed since this release was approved. Regenerate the git-release handoff."
[[ -f "$NOTES_FILE" ]] || die 'approved release notes are missing'
ACTUAL_NOTES_HASH="$(git -C "$REPO_ROOT" hash-object "$NOTES_FILE")"
[[ "$ACTUAL_NOTES_HASH" == "$EXPECTED_NOTES_HASH" ]] || die 'release notes changed after approval; regenerate the release'
inspect_local_tag
inspect_remote_tag
if [[ -z "$LOCAL_TAG_OBJECT" && -n "$REMOTE_TAG_OBJECT" ]]; then
  die "remote tag $VERSION appeared after approval; inspect it manually. Do not adopt or overwrite it."
fi
if [[ -n "$LOCAL_TAG_OBJECT" && -n "$REMOTE_TAG_OBJECT" ]]; then
  [[ "$REMOTE_TAG_OBJECT" == "$LOCAL_TAG_OBJECT" ]] || die "remote $VERSION is not the exact local annotated tag object"
fi
require_release_absent

# ---------- NO MUTATIONS ABOVE THIS POINT ----------
```

## Mutation and recovery sequence

Only after the complete pre-mutation sequence may the user-run script execute:

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
  --verify-tag --title "Release $VERSION" --notes-file "$NOTES_FILE" \
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

Never fetch a tag, overwrite, force-update, recreate, or delete one. If a
valid remote annotated tag exists without a local tag, stop instead of creating
another object. If local tag creation succeeds but push fails, report that the
local tag exists and the remote tag/release were not completed; never delete it.
If push succeeds but release creation fails, call `release_state` again and
report existing, confirmed absent, or indeterminate state. Every rerun repeats
all repository, branch, upstream, `HEAD`, notes, tag, and release inspections.

After writing the script, run `chmod 700 "$SCRIPT_FILE"` and require
`[[ -x "$SCRIPT_FILE" ]]`. Report `SCRIPT_FILE`, `NOTES_FILE`, and the exact
user command. State that the harness prepared the handoff only; the user must
run it to create and verify the release.

## Validate the handoff

Inspect generated files, run `bash -n "$SCRIPT_FILE"`, and run `shellcheck
"$SCRIPT_FILE"` when available, explicitly reporting when it is unavailable.
Confirm the embedded hash equals `git -C "$REPO_ROOT" hash-object
"$NOTES_FILE"`.

Use disposable repositories and a mocked GitHub CLI, never a real tag or
release, to test: successful pre-mutation checks; advanced upstream; changed or
deleted notes; existing remote tags; same-target different annotated tag
objects; release HTTP 200; API failure other than 404; dirty tree; wrong
branch; wrong origin/repository; mismatched or multiple push destinations;
non-`origin` upstream; a remote tag appearing after approval; linked worktree;
HTTPS fetch or push URLs with userinfo; highest-reachable-SemVer selection when
tag dates and commit proximity disagree; and paths containing spaces and an
apostrophe. Each rejection must happen before local tag creation.

Search for stale implementation patterns such as `gh -R`, hard-coded release
artifact paths, `git push --tags`, and flags or variables that treat an
inspection failure as confirmed absence. Remove them unless they occur only in
prose describing a forbidden pattern. Run the repository's authoritative
validation, `git diff --check`, and a complete diff review.
