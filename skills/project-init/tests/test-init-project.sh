#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
initializer="$script_dir/scripts/init-project.sh"
temp_root="$(mktemp -d)"
trap 'rm -rf "$temp_root"' EXIT

fail() {
  printf 'not ok: %s\n' "$1" >&2
  exit 1
}

assert_file() {
  [[ -f "$1" ]] || fail "missing file: $1"
}

assert_symlink() {
  [[ -L "$1" ]] || fail "missing symlink: $1"
}

target="$temp_root/target with spaces"
bash "$initializer" "$target" >/dev/null

assert_file "$target/.gitignore"
grep -Fxq '.env' "$target/.gitignore" || fail 'missing .env ignore rule'
assert_file "$target/docs/rules/GENERAL.md"
[[ ! -e "$target/.ai/prompts" ]] || fail 'copied optional helper prompts by default'
[[ ! -e "$target/docs/USER_FLOW.md" ]] || fail 'copied optional user flow by default'
[[ ! -e "$target/docs/rules/API.md" ]] || fail 'copied specialized API rule by default'
[[ ! -e "$target/docs/DB_SCHEMA.md" ]] || fail 'copied optional schema by default'
[[ ! -e "$target/.git" ]] || fail 'initialized Git without explicit selection'

second_output="$(bash "$initializer" "$target")"
grep -Fq 'no-op: project-init base scaffold already exists' <<<"$second_output" ||
  fail 'repeated unchanged base scaffold was not an explicit no-op'

populated_scaffold="$temp_root/populated-scaffold"
bash "$initializer" "$populated_scaffold" >/dev/null
printf '# user-owned specification\n' > "$populated_scaffold/docs/specs/user-spec.md"
if bash "$initializer" "$populated_scaffold" >/dev/null 2>&1; then
  fail 'treated user content inside scaffold directories as a recognized no-op'
fi

bash "$initializer" --only docs/USER_FLOW.md --only docs/rules/API.md \
  --only .ai/prompts "$target" >/dev/null
assert_file "$target/.ai/prompts/README.md"
assert_file "$target/.ai/prompts/bootstrap-project.md"
assert_file "$target/docs/USER_FLOW.md"
assert_file "$target/docs/rules/API.md"
selected_second_output="$(bash "$initializer" --only docs/USER_FLOW.md --only docs/rules/API.md \
  --only .ai/prompts "$target")"
grep -Fq 'skip: docs/USER_FLOW.md' <<<"$selected_second_output" ||
  fail 'repeated selected user-flow output was not skipped'
grep -Fq 'skip: .ai/prompts/README.md' <<<"$selected_second_output" ||
  fail 'repeated selected prompt output was not skipped'

gitless_scaffold="$temp_root/gitless-scaffold"
bash "$initializer" "$gitless_scaffold" >/dev/null
bash "$initializer" --init-git "$gitless_scaffold" >/dev/null
[[ -f "$gitless_scaffold/.git/HEAD" ]] ||
  fail 'did not initialize Git for a recognized scaffold when explicitly requested'

no_git_bin="$temp_root/no-git-bin"
mkdir -p "$no_git_bin"
for utility in basename dirname mkdir cp find mktemp rm; do
  ln -s "$(command -v "$utility")" "$no_git_bin/$utility"
done
no_git_target="$temp_root/no-git-target"
bash_path="$(command -v bash)"
if PATH="$no_git_bin" "$bash_path" "$initializer" --init-git "$no_git_target" >/dev/null 2>&1; then
  fail 'accepted --init-git without Git'
fi
[[ ! -e "$no_git_target" ]] || fail 'partially wrote target without Git capability'

git_target="$temp_root/git-target"
bash "$initializer" --init-git "$git_target" >/dev/null
assert_file "$git_target/.git/HEAD"
git -C "$git_target" rev-parse --is-inside-work-tree | grep -Fxq true ||
  fail 'did not initialize a local Git repository'
[[ -z "$(git -C "$git_target" remote)" ]] || fail 'created a remote'
if git -C "$git_target" rev-parse --verify HEAD >/dev/null 2>&1; then
  fail 'created a commit'
fi

existing_git_target="$temp_root/existing-git-target"
mkdir -p "$existing_git_target"
git -C "$existing_git_target" init --quiet
printf 'keep me\n' > "$existing_git_target/.git/project-init-test-marker"
bash "$initializer" --init-git "$existing_git_target" >/dev/null
grep -Fxq 'keep me' "$existing_git_target/.git/project-init-test-marker" ||
  fail 'reinitialized or removed existing Git metadata'

schema_target="$temp_root/schema-target"
schema_full_target="$temp_root/schema-full-target"
if bash "$initializer" --with-schema "$schema_full_target" >/dev/null 2>&1; then
  fail 'allowed schema creation in the initial full-scaffold approval'
fi
[[ ! -e "$schema_full_target" ]] ||
  fail 'created a target before separate schema approval'
schema_combined_target="$temp_root/schema-combined-target"
if bash "$initializer" --only docs/USER_FLOW.md --only docs/DB_SCHEMA.md --with-schema \
  "$schema_combined_target" >/dev/null 2>&1; then
  fail 'combined user-flow and schema selection in one approval'
fi
[[ ! -e "$schema_combined_target" ]] ||
  fail 'created a target before separate schema invocation'
bash "$initializer" "$schema_target" >/dev/null
bash "$initializer" --only docs/DB_SCHEMA.md --with-schema "$schema_target" >/dev/null
assert_file "$schema_target/docs/DB_SCHEMA.md"

existing_target="$temp_root/existing-target"
mkdir -p "$existing_target"
printf 'user content\n' > "$existing_target/README.md"
if bash "$initializer" "$existing_target" >/dev/null 2>&1; then
  fail 'allowed an unselected full scaffold on an existing target'
fi
bash "$initializer" --only README.md "$existing_target" >/dev/null
grep -Fxq 'user content' "$existing_target/README.md" || fail 'existing file overwritten'

ignore_target="$temp_root/ignore-target"
mkdir -p "$ignore_target"
printf '# user ignore policy\n' > "$ignore_target/.gitignore"
if bash "$initializer" "$ignore_target" >/dev/null 2>&1; then
  fail 'allowed an unselected full scaffold on an existing ignore target'
fi
bash "$initializer" --only .gitignore "$ignore_target" >/dev/null
grep -Fxq '# user ignore policy' "$ignore_target/.gitignore" ||
  fail 'existing .gitignore overwritten'

mkdir -p "$temp_root/canonical"
canonical_target="$temp_root/canonical/../canonical-project"
canonical_output="$(bash "$initializer" "$canonical_target")"
canonical_path="$temp_root/canonical-project"
grep -Fxq "target: $canonical_path" <<<"$canonical_output" ||
  fail 'did not report canonical target'

parent_target="$temp_root/parent-target"
mkdir -p "$parent_target"
printf 'linked content\n' > "$temp_root/linked-readme"
ln -s "$temp_root/linked-readme" "$parent_target/README.md"
if bash "$initializer" "$parent_target" >/dev/null 2>&1; then
  fail 'allowed an unselected full scaffold on an existing symlink target'
fi
bash "$initializer" --only README.md "$parent_target" >/dev/null
assert_symlink "$parent_target/README.md"
grep -Fxq 'linked content' "$parent_target/README.md" || fail 'changed symlink'

blocked_target="$temp_root/blocked-target"
mkdir -p "$blocked_target/.ai-parent"
ln -s "$blocked_target/.ai-parent" "$blocked_target/.ai"
if bash "$initializer" --only .ai/prompts/README.md "$blocked_target" >/dev/null 2>&1; then
  fail 'accepted a symlinked scaffold parent'
fi
assert_symlink "$blocked_target/.ai"
[[ ! -e "$blocked_target/.ai-parent/prompts/README.md" ]] ||
  fail 'created below symlinked parent'
[[ ! -e "$blocked_target/README.md" ]] ||
  fail 'partially wrote before detecting symlinked parent'

regular_blocker="$temp_root/regular-blocker"
mkdir -p "$regular_blocker"
printf 'not a directory\n' > "$regular_blocker/docs"
if bash "$initializer" --init-git "$regular_blocker" >/dev/null 2>&1; then
  fail 'accepted a regular-file scaffold parent'
fi
[[ ! -e "$regular_blocker/README.md" ]] ||
  fail 'partially wrote before detecting regular-file parent'
[[ ! -e "$regular_blocker/.git" ]] ||
  fail 'initialized Git before scaffold preflight completed'

plan_target="$temp_root/existing-plan-layout"
mkdir -p "$plan_target"
printf '# Existing plan index\n' > "$plan_target/PLANS.md"
if bash "$initializer" "$plan_target" >/dev/null 2>&1; then
  fail 'allowed full scaffold beside an existing planning layout'
fi
bash "$initializer" --only README.md "$plan_target" >/dev/null
[[ ! -e "$plan_target/docs/plans/INDEX.md" ]] ||
  fail 'created a competing plan tree during selected reconciliation'

cp_failure_bin="$temp_root/cp-failure-bin"
mkdir -p "$cp_failure_bin"
ln -s "$(type -P false)" "$cp_failure_bin/cp"
cp_failure_target="$temp_root/cp-failure-target"
if PATH="$cp_failure_bin:$PATH" bash "$initializer" "$cp_failure_target" >/dev/null 2>&1; then
  fail 'reported success after a failed template copy'
fi
[[ ! -e "$cp_failure_target/README.md" ]] ||
  fail 'created output after a failed template copy'

find_failure_bin="$temp_root/find-failure-bin"
mkdir -p "$find_failure_bin"
ln -s "$(type -P false)" "$find_failure_bin/find"
find_failure_target="$temp_root/find-failure-target"
if PATH="$find_failure_bin:$PATH" bash "$initializer" "$find_failure_target" >/dev/null 2>&1; then
  fail 'reported success after failed template traversal'
fi
[[ ! -e "$find_failure_target" ]] ||
  fail 'created a target after failed template traversal'

symlink_target="$temp_root/symlink-target"
mkdir -p "$symlink_target"
ln -s "$symlink_target" "$temp_root/symlink-project"
if bash "$initializer" "$temp_root/symlink-project" >/dev/null 2>&1; then
  fail 'accepted a symlinked target'
fi
[[ ! -e "$symlink_target/README.md" ]] || fail 'followed symlinked target'

mkdir -p "$temp_root/real-parent"
ln -s "$temp_root/real-parent" "$temp_root/symlink-parent"
if bash "$initializer" "$temp_root/symlink-parent/child" >/dev/null 2>&1; then
  fail 'accepted a symlinked target parent'
fi
[[ ! -e "$temp_root/real-parent/child/README.md" ]] ||
  fail 'created below symlinked target parent'

if bash "$initializer" "$temp_root/extra" unexpected >/dev/null 2>&1; then
  fail 'accepted an extra argument'
fi

printf 'ok: project-init copy-if-missing and path safety\n'
