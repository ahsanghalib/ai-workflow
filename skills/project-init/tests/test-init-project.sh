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

target="$temp_root/target with spaces"
output="$(bash "$initializer" "$target")"
grep -Fxq "target: $target" <<<"$output" || fail 'did not report the canonical target'
if grep -Eiq 'baseline schema|schema design|schema-design' <<<"$output"; then
  fail 'bootstrap ran or reported baseline schema design'
fi
for path in AGENTS.md SESSION_STATE.md .gitignore; do
  [[ -f "$target/$path" ]] || fail "missing generated file: $path"
done
for path in .ai/memory docs/specs; do
  [[ -d "$target/$path" ]] || fail "missing generated directory: $path"
done
grep -Fxq '.env' "$target/.gitignore" || fail 'missing .env ignore rule'
for forbidden in README.md MASTER_PLAN.md DB_SCHEMA.md USER_FLOW.md \
  PROJECT_ARCHITECTURE.md docs/DB_SCHEMA.md docs/USER_FLOW.md \
  docs/PROJECT_ARCHITECTURE.md docs/user-flows.md docs/architecture.md \
  docs/decisions docs/schema docs/plans docs/reviews docs/rules .ai/prompts \
  GENERAL.md BACKEND.md FRONTEND.md DATABASE.md API.md AUTH.md SECURITY.md \
  TESTING.md CONTRACTS.md; do
  [[ ! -e "$target/$forbidden" ]] || fail "created forbidden output: $forbidden"
done
for conditional in docs/schema/context.md docs/user-flows.md \
  docs/architecture.md docs/rules/api.md docs/rules/database.md; do
  [[ -f "$script_dir/templates/$conditional" ]] ||
    fail "missing retained conditional template: $conditional"
done
[[ ! -e "$target/.git" ]] || fail 'initialized Git without explicit selection'

before_manifest="$(find "$target" -mindepth 1 -print | LC_ALL=C sort)"
before_content="$(find "$target" -type f -print0 | LC_ALL=C sort -z | xargs -0 sha256sum)"
new_custom_spec="$temp_root/new-custom-spec"
if bash "$initializer" --spec-dir specs "$new_custom_spec" >/dev/null 2>&1; then
  fail 'accepted a custom SPEC root for a new repository'
fi
[[ ! -e "$new_custom_spec" ]] ||
  fail 'created a new repository while rejecting its custom SPEC root'

second_output="$(bash "$initializer" "$target")"
grep -Fq 'skip: AGENTS.md' <<<"$second_output" || fail 'rerun did not preserve AGENTS.md'
grep -Fq 'skip: SESSION_STATE.md' <<<"$second_output" || fail 'rerun did not preserve SESSION_STATE.md'
after_manifest="$(find "$target" -mindepth 1 -print | LC_ALL=C sort)"
after_content="$(find "$target" -type f -print0 | LC_ALL=C sort -z | xargs -0 sha256sum)"
[[ "$before_manifest" == "$after_manifest" ]] ||
  fail 'rerun changed the project-control file set'
[[ "$before_content" == "$after_content" ]] ||
  fail 'rerun changed existing project-control contents'

existing="$temp_root/existing"
mkdir -p "$existing/src" "$existing/docs/specs" "$existing/docs/rules" \
  "$existing/docs/plans" "$existing/docs/reviews"
printf 'keep me\n' > "$existing/README.md"
printf 'legacy backend rules\n' > "$existing/docs/rules/BACKEND.md"
printf 'legacy root API rules\n' > "$existing/API.md"
printf 'legacy roadmap\n' > "$existing/MASTER_PLAN.md"
printf 'legacy schema\n' > "$existing/docs/DB_SCHEMA.md"
printf 'legacy flow\n' > "$existing/docs/USER_FLOW.md"
printf 'legacy architecture\n' > "$existing/docs/PROJECT_ARCHITECTURE.md"
printf 'generated legacy plan\n' > "$existing/docs/plans/generated.md"
printf 'user review history\n' > "$existing/docs/reviews/user-review.md"
printf 'source\n' > "$existing/src/main.ts"
printf 'do-not-print-this-secret\n' > "$existing/.env"
existing_output="$(bash "$initializer" "$existing")"
if grep -Fq 'do-not-print-this-secret' <<<"$existing_output"; then
  fail 'printed existing .env contents during reconciliation'
fi
grep -Fxq 'keep me' "$existing/README.md" || fail 'rewrote existing README'
grep -Fxq 'legacy backend rules' "$existing/docs/rules/BACKEND.md" ||
  fail 'rewrote existing user-owned legacy rule location'
grep -Fxq 'legacy root API rules' "$existing/API.md" ||
  fail 'rewrote existing user-owned legacy root rule file'
grep -Fxq 'legacy roadmap' "$existing/MASTER_PLAN.md" || fail 'rewrote existing MASTER_PLAN.md'
grep -Fxq 'legacy schema' "$existing/docs/DB_SCHEMA.md" || fail 'rewrote existing DB_SCHEMA.md'
grep -Fxq 'legacy flow' "$existing/docs/USER_FLOW.md" || fail 'rewrote existing USER_FLOW.md'
grep -Fxq 'legacy architecture' "$existing/docs/PROJECT_ARCHITECTURE.md" ||
  fail 'rewrote existing PROJECT_ARCHITECTURE.md'
grep -Fxq 'generated legacy plan' "$existing/docs/plans/generated.md" ||
  fail 'removed or rewrote an uncertain-ownership legacy plan artifact'
grep -Fxq 'user review history' "$existing/docs/reviews/user-review.md" ||
  fail 'removed or rewrote existing review history'
grep -Fxq 'source' "$existing/src/main.ts" || fail 'rewrote existing source'
grep -Fq 'do-not-print-this-secret' "$existing/.env" ||
  fail 'changed existing .env contents'

gitless="$temp_root/gitless"
bash "$initializer" "$gitless" >/dev/null
bash "$initializer" --init-git "$gitless" >/dev/null
[[ -f "$gitless/.git/HEAD" ]] || fail 'did not initialize Git after explicit request'
[[ -z "$(git -C "$gitless" remote)" ]] || fail 'created a remote'
if git -C "$gitless" rev-parse --verify HEAD >/dev/null 2>&1; then
  fail 'created a commit'
fi

existing_git="$temp_root/existing-git"
mkdir -p "$existing_git"
git -C "$existing_git" init --quiet
printf 'history fixture\n' > "$existing_git/history.txt"
git -C "$existing_git" add history.txt
git -C "$existing_git" -c user.name='Project Init Test' \
  -c user.email='project-init-test@example.invalid' \
  -c commit.gpgSign=false \
  commit --quiet -m 'preserve history fixture'
existing_git_head="$(git -C "$existing_git" rev-parse HEAD)"
printf 'keep me\n' > "$existing_git/.git/project-init-test-marker"
bash "$initializer" --init-git "$existing_git" >/dev/null
grep -Fxq 'keep me' "$existing_git/.git/project-init-test-marker" ||
  fail 'reinitialized existing Git metadata'
[[ "$(git -C "$existing_git" rev-parse HEAD)" == "$existing_git_head" ]] ||
  fail 'changed existing Git history'
git -C "$existing_git" log -1 --format=%s | grep -Fxq 'preserve history fixture' ||
  fail 'lost existing Git history'

mapped="$temp_root/mapped-existing"
mkdir -p "$mapped/specifications"
printf '# existing SPEC source\n' > "$mapped/specifications/SPEC-0001.md"
if bash "$initializer" "$mapped" >/dev/null 2>&1; then
  fail 'guessed a competing SPEC directory for an existing source'
fi
[[ ! -e "$mapped/AGENTS.md" ]] || fail 'wrote before explicit SPEC mapping approval'
bash "$initializer" --spec-dir specifications "$mapped" >/dev/null
[[ -f "$mapped/specifications/SPEC-0001.md" ]] || fail 'lost existing SPEC source'
[[ ! -e "$mapped/docs/specs" ]] || fail 'created competing docs/specs directory'
grep -Fq 'specifications' "$mapped/AGENTS.md" ||
  fail 'mapped AGENTS.md does not route to existing SPEC source'

symlink_target="$temp_root/symlink-target"
mkdir -p "$symlink_target/real-ai"
ln -s "$symlink_target/real-ai" "$symlink_target/.ai"
if bash "$initializer" "$symlink_target" >/dev/null 2>&1; then
  fail 'accepted a symlinked scaffold parent'
fi
[[ ! -e "$symlink_target/real-ai/memory" ]] ||
  fail 'created below a symlinked parent'

regular_blocker="$temp_root/regular-blocker"
mkdir -p "$regular_blocker"
printf 'not a directory\n' > "$regular_blocker/docs"
if bash "$initializer" "$regular_blocker" >/dev/null 2>&1; then
  fail 'accepted a regular-file scaffold parent'
fi
[[ ! -e "$regular_blocker/AGENTS.md" ]] ||
  fail 'partially wrote before detecting a regular-file parent'

missing_parent="$temp_root/missing-parent/new-project"
bash "$initializer" "$missing_parent" >/dev/null
[[ -f "$missing_parent/AGENTS.md" ]] || fail 'did not create missing target'

printf 'ok: project-init minimal scaffold and safety contract\n'
