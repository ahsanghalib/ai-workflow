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
grep -Fq 'application source, routes' "$output_boundary" ||
  fail 'output boundary omitted application-source prohibition'
grep -Fq 'framework scaffolds, package manifests' "$output_boundary" ||
  fail 'output boundary omitted framework/dependency prohibition'
grep -Fq 'roadmap, plan, review, schema' "$output_boundary" ||
  fail 'output boundary omitted obsolete-document prohibition'
grep -Fq 'bundled conditional templates remain' "$output_boundary" ||
  fail 'output boundary omitted conditional-template guidance'
grep -Fq 'issues, projects, deployments' "$output_boundary" ||
  fail 'output boundary omitted GitHub Project prohibition'

bash "$test_dir/test-inspect-project.sh"
bash "$test_dir/test-inventory-project.sh"
bash "$test_dir/test-init-project.sh"
bash "$test_dir/test-validate-foundation.sh"
bash "$test_dir/test-acceptance-scenarios.sh"
bash "$test_dir/test-reconciliation-scenarios.sh"
bash "$test_dir/test-skill-audit.sh"
bash "$test_dir/test-safeguards-contract.sh"
bash "$test_dir/test-ci-contract.sh"

output_target="$temp_root/output-target"
output="$(bash "$initializer" --init-git "$output_target")"
grep -Fxq "target: $output_target" <<<"$output" ||
  fail 'did not report the canonical output target'
[[ -d "$output_target/.git" ]] || fail 'missing explicitly requested Git metadata'
git -C "$output_target" check-ignore -q --no-index .env ||
  fail 'real .env is not ignored'
[[ ! -e "$output_target/.env" ]] || fail 'created .env'
for forbidden in README.md package.json pnpm-lock.yaml src migrations Dockerfile \
  MASTER_PLAN.md docs/DB_SCHEMA.md docs/USER_FLOW.md \
  docs/PROJECT_ARCHITECTURE.md docs/plans docs/reviews docs/rules .ai/prompts \
  GENERAL.md BACKEND.md FRONTEND.md DATABASE.md API.md AUTH.md SECURITY.md \
  TESTING.md CONTRACTS.md; do
  [[ ! -e "$output_target/$forbidden" ]] || fail "generated forbidden output: $forbidden"
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
[[ ! -e "$nested_target/AGENTS.md" ]] ||
  fail 'wrote nested target before override'
bash "$initializer" --allow-nested "$nested_target" >/dev/null
[[ -f "$nested_target/AGENTS.md" ]] || fail 'did not accept explicit nested override'

nested_missing="$nested_worktree/new nested project"
if bash "$initializer" "$nested_missing" >/dev/null 2>&1; then
  fail 'created a missing nested target without override'
fi
[[ ! -e "$nested_missing" ]] || fail 'created nested target before override'
bash "$initializer" --allow-nested "$nested_missing" >/dev/null
[[ -f "$nested_missing/AGENTS.md" ]] ||
  fail 'did not initialize approved missing nested target'

printf 'ok: project-init disposable suite and minimal-control contract\n'
