#!/usr/bin/env bash
set -euo pipefail

test_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
script_dir="$(cd "$test_dir/.." && pwd)"
initializer="$script_dir/scripts/init-project.sh"
output_boundary="$script_dir/references/output-boundary.md"
temp_root="$(mktemp -d)"
trap 'rm -rf "$temp_root"' EXIT

fail() {
  printf 'not ok: %s\n' "$1" >&2
  exit 1
}

[[ -f "$output_boundary" ]] || fail 'missing output-boundary reference'
grep -Fq 'No application source' "$output_boundary" ||
  fail 'output boundary omitted application-source prohibition'
grep -Fq 'No framework or dependency files' "$output_boundary" ||
  fail 'output boundary omitted framework/dependency prohibition'

bash "$test_dir/test-inspect-project.sh"
bash "$test_dir/test-inventory-project.sh"
bash "$test_dir/test-init-project.sh"
bash "$test_dir/test-validate-foundation.sh"
bash "$test_dir/test-acceptance-scenarios.sh"
bash "$test_dir/test-traceability-contract.sh"

output_target="$temp_root/output-target"
output="$(bash "$initializer" --init-git "$output_target")"
grep -Fxq "target: $output_target" <<<"$output" ||
  fail 'did not report the canonical output target'
[[ -f "$output_target/README.md" ]] || fail 'missing generated README'
[[ -f "$output_target/docs/rules/GENERAL.md" ]] || fail 'missing general engineering rules'
[[ ! -e "$output_target/docs/USER_FLOW.md" ]] || fail 'created optional user-flow document by default'
[[ ! -e "$output_target/.ai/prompts" ]] || fail 'created optional prompts by default'
bash "$initializer" --only docs/USER_FLOW.md --only .ai/prompts "$output_target" >/dev/null
[[ -f "$output_target/docs/USER_FLOW.md" ]] || fail 'missing explicitly selected user-flow document'
bash "$initializer" --only docs/DB_SCHEMA.md --with-schema "$output_target" >/dev/null
[[ -f "$output_target/docs/DB_SCHEMA.md" ]] || fail 'missing selected schema document'
[[ -d "$output_target/.ai/prompts" ]] || fail 'missing tracked helper prompts'
[[ -d "$output_target/.git" ]] || fail 'missing explicitly selected Git metadata'
git -C "$output_target" check-ignore -q --no-index .env ||
  fail 'real .env is not ignored'
if git -C "$output_target" check-ignore -q --no-index .ai/prompts/README.md; then
  fail 'tracked .ai prompt is ignored'
fi
[[ ! -e "$output_target/.env" ]] || fail 'created .env'

for forbidden in .env package.json pnpm-lock.yaml src migrations Dockerfile; do
  [[ ! -e "$output_target/$forbidden" ]] || fail "generated application output: $forbidden"
done
[[ -z "$(git -C "$output_target" remote)" ]] || fail 'generated a remote'
if git -C "$output_target" rev-parse --verify HEAD >/dev/null 2>&1; then
  fail 'generated a commit'
fi

nested_worktree="$temp_root/nested-worktree"
mkdir -p "$nested_worktree/selected project"
git -C "$nested_worktree" init --quiet
nested_target="$nested_worktree/selected project"
if bash "$initializer" "$nested_target" >/dev/null 2>&1; then
  fail 'initialized a nested target without override'
fi
[[ ! -e "$nested_target/README.md" ]] ||
  fail 'wrote nested target before override'
bash "$initializer" --allow-nested "$nested_target" >/dev/null
[[ -f "$nested_target/README.md" ]] || fail 'did not accept explicit nested override'

nested_missing="$nested_worktree/new nested project"
if bash "$initializer" "$nested_missing" >/dev/null 2>&1; then
  fail 'created a missing nested target without override'
fi
[[ ! -e "$nested_missing" ]] || fail 'created nested target before approval'
bash "$initializer" --allow-nested "$nested_missing" >/dev/null
[[ -f "$nested_missing/README.md" ]] ||
  fail 'did not initialize approved missing nested target'

alias_target="$temp_root/missing-alias-parent/../nested-worktree/alias project"
if bash "$initializer" "$alias_target" >/dev/null 2>&1; then
  fail 'accepted a missing target alias nested in a Git worktree'
fi
[[ ! -e "$nested_worktree/alias project/README.md" ]] ||
  fail 'wrote through a missing target alias before nested approval'

printf 'ok: project-init disposable suite and Markdown-only output\n'
