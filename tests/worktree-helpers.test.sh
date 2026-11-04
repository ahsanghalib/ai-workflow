#!/usr/bin/env bash
set -euo pipefail

test_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
repo_root=$(cd -- "$test_dir/.." && pwd -P)
worktree_close="$repo_root/bin/worktree-close"
worktree_new="$repo_root/bin/worktree-new"
temp_root=$(mktemp -d "$repo_root/.worktree-helper-test.XXXXXX")
trap 'rm -r -- "$temp_root"' EXIT
export AI_WORKFLOW_WORKTREE_ROOT="$temp_root/worktrees"
mkdir -p "$AI_WORKFLOW_WORKTREE_ROOT"

fail() {
	printf 'not ok: %s\n' "$1" >&2
	exit 1
}

init_repo() {
	local repo=$1

	git init --quiet "$repo"
	git -C "$repo" config user.name 'Worktree helper test'
	git -C "$repo" config user.email 'worktree-helper-test@example.invalid'
	git -C "$repo" checkout --quiet -b main
}

commit_file() {
	local repo=$1
	local path=$2
	local contents=$3
	local message=$4

	printf '%s\n' "$contents" >"$repo/$path"
	git -C "$repo" add -- "$path"
	git -C "$repo" commit --quiet -m "$message"
}

assert_worktree_exists() {
	local target=$1
	local repo=$2
	local branch=$3

	[[ -d "$target" ]] || fail "worktree was removed unexpectedly: $target"
	git -C "$repo" rev-parse --git-dir >/dev/null 2>&1 ||
		fail "fixture repository is unavailable for $target"
	git -C "$repo" show-ref --verify --quiet "refs/heads/$branch" ||
		fail "branch was removed unexpectedly: $branch"
}

[[ ! -e "$repo_root/bin/dev-session" ]] || fail 'dev-session fixture assumption is stale'
if grep -Fq 'realpath -e' "$worktree_new" "$worktree_close"; then
	fail 'helpers still use GNU-only realpath -e'
fi

fake_bin="$temp_root/bin"
mkdir -p "$fake_bin"
fake_gh="$fake_bin/gh"

reused_repo="$temp_root/reused-repo"
mkdir -p "$reused_repo"
init_repo "$reused_repo"
commit_file "$reused_repo" .gitignore '*.ignored' 'ignore generated files'
commit_file "$reused_repo" base.txt base 'base commit'
git -C "$reused_repo" checkout --quiet -b feature/reused
commit_file "$reused_repo" old.txt old 'old PR head'
old_tip=$(git -C "$reused_repo" rev-parse HEAD)
git -C "$reused_repo" checkout --quiet main
git -C "$reused_repo" commit --quiet --allow-empty -m 'squash merge of old PR'
git -C "$reused_repo" remote add upstream 'https://github.com/example/upstream-repo.git'
git -C "$reused_repo" update-ref refs/remotes/upstream/main refs/heads/main

reused_target="$temp_root/reused-worktree"
git -C "$reused_repo" worktree add --quiet "$reused_target" feature/reused
commit_file "$reused_target" new.txt new 'new unmerged work'
current_tip=$(git -C "$reused_target" rev-parse HEAD)

fake_git_bin="$temp_root/fake-git-bin"
mkdir -p "$fake_git_bin"
cat >"$fake_git_bin/git" <<'EOF'
#!/usr/bin/env bash
for argument in "$@"; do
  [[ "$argument" == fetch ]] && exit 0
done
exec /usr/bin/git "$@"
EOF
chmod 755 "$fake_git_bin/git"

cat >"$fake_gh" <<EOF
#!/usr/bin/env bash
repo=''
while ((\$#)); do
  case "\$1" in
    --repo) repo=\$2; shift 2 ;;
    *) shift ;;
  esac
done
[[ "\$repo" == 'github.com/example/upstream-repo' ]] || exit 2
printf '101\\t$old_tip\\n'
EOF
chmod 755 "$fake_gh"

if PATH="$fake_git_bin:$fake_bin:$PATH" "$worktree_close" \
	"$reused_target" upstream/main >/dev/null 2>&1; then
	fail 'accepted a stale merged PR for a reused branch'
fi
assert_worktree_exists "$reused_target" "$reused_repo" feature/reused

cat >"$fake_gh" <<EOF
#!/usr/bin/env bash
repo=''
while ((\$#)); do
  case "\$1" in
    --repo) repo=\$2; shift 2 ;;
    *) shift ;;
  esac
done
[[ "\$repo" == 'github.com/example/upstream-repo' ]] || exit 2
printf '101\\t$current_tip\\n'
EOF
if ! PATH="$fake_git_bin:$fake_bin:$PATH" "$worktree_close" \
	"$reused_target" upstream/main >/dev/null; then
	fail 'rejected a merged PR matching the current branch tip'
fi
[[ ! -e "$reused_target" ]] || fail 'did not remove verified worktree'
if git -C "$reused_repo" show-ref --verify --quiet refs/heads/feature/reused; then
	fail 'did not remove verified local branch'
fi

new_repo="$temp_root/new-repo"
mkdir -p "$new_repo"
init_repo "$new_repo"
commit_file "$new_repo" .gitignore $'*.ignored\n.env\ncredentials.json\n*.pem\nid_ecdsa\n.docker/\nnode_modules/\n.venv/\npackages/\ntarget/' 'ignore local runtime files'
commit_file "$new_repo" base.txt base 'base commit'
printf 'runtime settings\n' >"$new_repo/.env"
printf 'local settings\n' >"$new_repo/local.ignored"
printf 'credential\n' >"$new_repo/credentials.json"
printf 'private key\n' >"$new_repo/private.pem"
printf 'ecdsa private key\n' >"$new_repo/id_ecdsa"
mkdir -p "$new_repo/.docker"
printf 'docker credential\n' >"$new_repo/.docker/config.json"
mkdir -p "$new_repo/local-config" "$new_repo/node_modules/pkg" \
	"$new_repo/.venv/lib" "$new_repo/packages/cache" "$new_repo/target/debug"
printf 'nested settings\n' >"$new_repo/local-config/runtime.ignored"
printf 'dependency\n' >"$new_repo/node_modules/pkg/index.js"
printf 'virtualenv\n' >"$new_repo/.venv/lib/site.py"
printf 'package output\n' >"$new_repo/packages/cache/index.js"
printf 'build output\n' >"$new_repo/target/debug/app"
if (
	cd "$new_repo"
	AI_WORKFLOW_WORKTREE_ROOT=relative-root PATH="$fake_bin:/usr/bin:/bin" \
		"$worktree_new" feature/relative-root main git >/dev/null 2>&1
); then
	fail 'accepted a relative worktree root'
fi
if git -C "$new_repo" show-ref --verify --quiet refs/heads/feature/relative-root; then
	fail 'created a branch for a rejected relative worktree root'
fi
if (
	cd "$new_repo"
	env -u AI_WORKFLOW_WORKTREE_ROOT PATH="$fake_bin:/usr/bin:/bin" \
		"$worktree_new" feature/missing-root main git >/dev/null 2>&1
); then
	fail 'accepted a missing worktree root variable'
fi
if git -C "$new_repo" show-ref --verify --quiet refs/heads/feature/missing-root; then
	fail 'created a branch when the worktree root variable was unset'
fi

created_root="$temp_root/created-worktrees"
created_target="$created_root/new-repo/feature/created-root"
created_output="$(
	cd "$new_repo"
	printf 'y\n' | AI_WORKFLOW_WORKTREE_ROOT="$created_root" \
		PATH="$fake_bin:/usr/bin:/bin" "$worktree_new" \
		feature/created-root main git
)"
grep -Fq "Created worktree: $created_target" <<<"$created_output" ||
	fail 'did not create the requested worktree root after confirmation'
[[ -d "$created_root" ]] || fail 'did not create the confirmed worktree root'
git -C "$new_repo" worktree remove "$created_target"
git -C "$new_repo" branch -D -- feature/created-root >/dev/null

declined_root="$temp_root/declined-worktrees"
if (
	cd "$new_repo"
	printf 'n\n' | AI_WORKFLOW_WORKTREE_ROOT="$declined_root" \
		PATH="$fake_bin:/usr/bin:/bin" "$worktree_new" \
		feature/declined-root main git >/dev/null 2>&1
); then
	fail 'continued after the user declined worktree root creation'
fi
[[ ! -e "$declined_root" ]] || fail 'created a worktree root after user declined'
if git -C "$new_repo" show-ref --verify --quiet refs/heads/feature/declined-root; then
	fail 'created a branch after user declined worktree root creation'
fi

new_target="$temp_root/worktrees/new-repo/feature/new"
new_output="$(
	cd "$new_repo"
	PATH="$fake_bin:/usr/bin:/bin" "$worktree_new" feature/new main git
)"
grep -Fq "Created worktree: $new_target" <<<"$new_output" ||
	fail 'did not create worktree with the portable path resolver'
[[ "$(git -C "$new_target" branch --show-current)" == feature/new ]] ||
	fail 'created worktree has the wrong branch'
[[ "$(cat "$new_target/.env")" == 'runtime settings' ]] ||
	fail 'did not copy an ignored runtime file'
[[ "$(cat "$new_target/local.ignored")" == 'local settings' ]] ||
	fail 'did not copy an ignored local file'
[[ "$(cat "$new_target/local-config/runtime.ignored")" == 'nested settings' ]] ||
	fail 'did not preserve nested ignored file paths'
[[ ! -e "$new_target/credentials.json" && ! -e "$new_target/private.pem" &&
	! -e "$new_target/id_ecdsa" &&
	! -e "$new_target/.docker" ]] ||
	fail 'copied a sensitive-looking ignored file'
for excluded in node_modules .venv packages target; do
	[[ ! -e "$new_target/$excluded" ]] ||
		fail "copied excluded dependency/generated directory: $excluded"
done
rm -f -- "$new_target/.env" "$new_target/local.ignored" \
	"$new_target/local-config/runtime.ignored"
rm -r -- "$new_target/local-config"
git -C "$new_repo" worktree remove "$new_target"
git -C "$new_repo" branch -D -- feature/new >/dev/null

custom_target="$temp_root/worktrees/new-repo/feature/exclude"
custom_output="$(
	cd "$new_repo"
	WORKTREE_COPY_EXCLUDE='././local-config//' PATH="$fake_bin:/usr/bin:/bin" \
		"$worktree_new" feature/exclude main git
)"
grep -Fq "Created worktree: $custom_target" <<<"$custom_output" ||
	fail 'did not create worktree with a custom copy exclusion'
[[ -f "$custom_target/.env" ]] || fail 'custom exclusion removed other runtime files'
[[ ! -e "$custom_target/local-config" ]] ||
	fail 'did not normalize a trailing-slash custom exclusion'
rm -f -- "$custom_target/.env"
git -C "$new_repo" worktree remove "$custom_target"
git -C "$new_repo" branch -D -- feature/exclude >/dev/null

sensitive_target="$temp_root/worktrees/new-repo/feature/sensitive"
sensitive_output="$(
	cd "$new_repo"
	WORKTREE_COPY_ALLOW_SENSITIVE=1 PATH="$fake_bin:/usr/bin:/bin" \
		"$worktree_new" feature/sensitive main git
)"
grep -Fq "Created worktree: $sensitive_target" <<<"$sensitive_output" ||
	fail 'did not create worktree with sensitive-file opt-in'
[[ -f "$sensitive_target/credentials.json" &&
	-f "$sensitive_target/private.pem" &&
	-f "$sensitive_target/id_ecdsa" &&
	-f "$sensitive_target/.docker/config.json" ]] ||
	fail 'sensitive-file opt-in did not copy the requested files'
rm -f -- "$sensitive_target/.env" "$sensitive_target/local.ignored" \
	"$sensitive_target/credentials.json" "$sensitive_target/private.pem" \
	"$sensitive_target/id_ecdsa" \
	"$sensitive_target/local-config/runtime.ignored"
rm -r -- "$sensitive_target/local-config" "$sensitive_target/.docker"
git -C "$new_repo" worktree remove "$sensitive_target"
git -C "$new_repo" branch -D -- feature/sensitive >/dev/null

output_symlink="$temp_root/worktrees/new-repo/symlinked"
output_outside="$temp_root/worktree-output-outside"
mkdir -p "$temp_root/worktrees/new-repo" "$output_outside"
ln -s "$output_outside" "$output_symlink"
output_symlink_target="$temp_root/worktrees/new-repo/symlinked/escaped"
if (
	cd "$new_repo"
	PATH="$fake_bin:/usr/bin:/bin" "$worktree_new" \
		symlinked/escaped main git >/dev/null 2>&1
); then
	fail 'followed a symlinked worktree output parent'
fi
[[ ! -e "$output_outside/escaped" ]] ||
	fail 'created a worktree outside the expected output directory'
[[ ! -e "$output_symlink_target" ]] ||
	fail 'left a target after rejecting a symlinked output parent'
if git -C "$new_repo" show-ref --verify --quiet refs/heads/symlinked/escaped; then
	fail 'left a branch after rejecting a symlinked output parent'
fi
rm -f -- "$output_symlink"

copy_failure_repo="$temp_root/copy-failure-repo"
mkdir -p "$copy_failure_repo"
init_repo "$copy_failure_repo"
commit_file "$copy_failure_repo" .gitignore '.env' 'ignore runtime settings'
commit_file "$copy_failure_repo" base.txt base 'base commit'
printf 'runtime settings\n' >"$copy_failure_repo/.env"
copy_failure_bin="$temp_root/copy-failure-bin"
mkdir -p "$copy_failure_bin"
cat >"$copy_failure_bin/cp" <<'EOF'
#!/usr/bin/env bash
exit 1
EOF
chmod 755 "$copy_failure_bin/cp"
copy_failure_target="$temp_root/worktrees/copy-failure-repo/feature/failure"
if (
	cd "$copy_failure_repo"
	PATH="$copy_failure_bin:/usr/bin:/bin" "$worktree_new" \
		feature/failure main git >/dev/null 2>&1
); then
	fail 'reported success after ignored-file copy failure'
fi
[[ ! -e "$copy_failure_target" ]] ||
	fail 'left a worktree after ignored-file copy failure'
if git -C "$copy_failure_repo" show-ref --verify --quiet refs/heads/feature/failure; then
	fail 'left a branch after ignored-file copy failure'
fi

enumeration_failure_bin="$temp_root/enumeration-failure-bin"
mkdir -p "$enumeration_failure_bin"
cat >"$enumeration_failure_bin/git" <<'EOF'
#!/usr/bin/env bash
for argument in "$@"; do
  [[ "$argument" == ls-files ]] && exit 1
done
exec /usr/bin/git "$@"
EOF
chmod 755 "$enumeration_failure_bin/git"
enumeration_failure_target="$temp_root/worktrees/copy-failure-repo/feature/enumeration"
if (
	cd "$copy_failure_repo"
	PATH="$enumeration_failure_bin:/usr/bin:/bin" "$worktree_new" \
		feature/enumeration main git >/dev/null 2>&1
); then
	fail 'reported success after ignored-file enumeration failure'
fi
[[ ! -e "$enumeration_failure_target" ]] ||
	fail 'left a worktree after ignored-file enumeration failure'
if git -C "$copy_failure_repo" show-ref --verify --quiet refs/heads/feature/enumeration; then
	fail 'left a branch after ignored-file enumeration failure'
fi

collision_repo="$temp_root/collision-repo"
mkdir -p "$collision_repo"
init_repo "$collision_repo"
commit_file "$collision_repo" collision.txt tracked 'tracked base file'
git -C "$collision_repo" checkout --quiet -b source
git -C "$collision_repo" rm --quiet collision.txt
commit_file "$collision_repo" .gitignore collision.txt 'ignore removed base file'
printf 'local replacement\n' >"$collision_repo/collision.txt"
collision_target="$temp_root/worktrees/collision-repo/feature/collision"
if (
	cd "$collision_repo"
	PATH="$fake_bin:/usr/bin:/bin" "$worktree_new" \
		feature/collision main git >/dev/null 2>&1
); then
	fail 'overwrote a tracked base file with an ignored source file'
fi
[[ ! -e "$collision_target" ]] ||
	fail 'left a worktree after tracked-path collision'
if git -C "$collision_repo" show-ref --verify --quiet refs/heads/feature/collision; then
	fail 'left a branch after tracked-path collision'
fi

parent_collision_repo="$temp_root/parent-collision-repo"
mkdir -p "$parent_collision_repo"
init_repo "$parent_collision_repo"
commit_file "$parent_collision_repo" config tracked 'tracked parent file'
git -C "$parent_collision_repo" checkout --quiet -b source
git -C "$parent_collision_repo" rm --quiet config
commit_file "$parent_collision_repo" .gitignore 'config/' 'ignore local config directory'
mkdir -p "$parent_collision_repo/config"
printf 'local runtime\n' >"$parent_collision_repo/config/runtime.ignored"
parent_collision_target="$temp_root/worktrees/parent-collision-repo/feature/parent-collision"
if (
	cd "$parent_collision_repo"
	PATH="$fake_bin:/usr/bin:/bin" "$worktree_new" \
		feature/parent-collision main git >/dev/null 2>&1
); then
	fail 'followed a tracked regular-file parent while copying ignored files'
fi
[[ ! -e "$parent_collision_target" ]] ||
	fail 'left a worktree after tracked regular-parent collision'
if git -C "$parent_collision_repo" show-ref --verify --quiet refs/heads/feature/parent-collision; then
	fail 'left a branch after tracked regular-parent collision'
fi

symlink_repo="$temp_root/symlink-repo"
symlink_outside="$temp_root/symlink-outside"
mkdir -p "$symlink_repo" "$symlink_outside"
init_repo "$symlink_repo"
printf 'outside\n' >"$symlink_outside/existing.txt"
ln -s "$symlink_outside" "$symlink_repo/config"
git -C "$symlink_repo" add -- config
git -C "$symlink_repo" commit --quiet -m 'tracked symlink base'
git -C "$symlink_repo" checkout --quiet -b source
git -C "$symlink_repo" rm --quiet -- config
commit_file "$symlink_repo" .gitignore 'config/' 'ignore local config directory'
mkdir -p "$symlink_repo/config"
printf 'local secret\n' >"$symlink_repo/config/runtime.env"
symlink_target="$temp_root/worktrees/symlink-repo/feature/symlink"
if (
	cd "$symlink_repo"
	PATH="$fake_bin:/usr/bin:/bin" "$worktree_new" \
		feature/symlink main git >/dev/null 2>&1
); then
	fail 'followed a tracked symlink while copying ignored files'
fi
[[ ! -e "$symlink_target" ]] ||
	fail 'left a worktree after tracked-symlink collision'
[[ ! -e "$symlink_outside/runtime.env" ]] ||
	fail 'copied an ignored file outside the new worktree'
if git -C "$symlink_repo" show-ref --verify --quiet refs/heads/feature/symlink; then
	fail 'left a branch after tracked-symlink collision'
fi

ignored_repo="$temp_root/ignored-repo"
mkdir -p "$ignored_repo"
init_repo "$ignored_repo"
commit_file "$ignored_repo" .gitignore '*.ignored' 'ignore generated files'
commit_file "$ignored_repo" base.txt base 'base commit'
git -C "$ignored_repo" checkout --quiet -b feature/ignored
commit_file "$ignored_repo" feature.txt feature 'feature commit'
git -C "$ignored_repo" checkout --quiet main
git -C "$ignored_repo" merge --quiet --no-ff feature/ignored -m 'merge feature'

ignored_target="$temp_root/ignored-worktree"
git -C "$ignored_repo" worktree add --quiet "$ignored_target" feature/ignored
printf 'generated\n' >"$ignored_target/build.ignored"
[[ -z "$(git -C "$ignored_target" status --porcelain)" ]] ||
	fail 'ignored fixture is not clean under normal status'

if PATH="$fake_bin:$PATH" "$worktree_close" "$ignored_target" main >/dev/null 2>&1; then
	fail 'removed a worktree containing ignored files'
fi
assert_worktree_exists "$ignored_target" "$ignored_repo" feature/ignored

printf 'ok: worktree helper safety regressions\n'
