#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
inspector="$script_dir/scripts/inspect-project.sh"
inventory="$script_dir/scripts/inventory-project.sh"
acceptance="$script_dir/references/acceptance-scenarios.md"
temp_root="$(mktemp -d)"
trap 'rm -rf "$temp_root"' EXIT

fail() {
  printf 'not ok: %s\n' "$1" >&2
  exit 1
}

for phrase in 'write: none (inspection only)' 'spec-workflow' \
  'Minimal output boundary' 'Conditional reconciliation' \
  'Foundation validation' 'Substantive work handoff'; do
  grep -Fq "$phrase" "$acceptance" || fail "acceptance reference omitted: $phrase"
done
grep -Fq 'spec-workflow' "$script_dir/SKILL.md" ||
  fail 'skill omitted substantive-work handoff'
grep -Fq 'fresh' "$script_dir/references/init-compatibility.md" ||
  fail 'reload guidance omitted fresh-session handoff'
grep -Fq 'session' "$script_dir/references/init-compatibility.md" ||
  fail 'reload guidance omitted session handoff'
grep -Fq 'approval' "$script_dir/references/init-compatibility.md" ||
  fail 'reload guidance omitted approval context'

empty_target="$temp_root/empty target"
mkdir -p "$empty_target"
empty_output="$(bash "$inspector" "$empty_target")"
grep -Fxq "target: $empty_target" <<<"$empty_output" ||
  fail 'did not report canonical target before approval'
grep -Fxq 'write: none (inspection only)' <<<"$empty_output" ||
  fail 'inspection did not report no-write state'
[[ -z "$(find "$empty_target" -mindepth 1 -print -quit)" ]] ||
  fail 'inspection wrote to empty target'

existing_target="$temp_root/existing"
mkdir -p "$existing_target/src" "$existing_target/docs"
printf 'existing project\n' > "$existing_target/README.md"
printf 'instruction\n' > "$existing_target/AGENTS.md"
printf 'source\n' > "$existing_target/src/app.ts"
printf 'do-not-print-this-secret\n' > "$existing_target/.env"
inventory_output="$(bash "$inventory" "$existing_target")"
grep -Fq '| instruction' <<<"$inventory_output" ||
  fail 'did not classify existing instructions'
if grep -Fq 'do-not-print-this-secret' <<<"$inventory_output"; then
  fail 'inventory printed .env contents'
fi
[[ ! -e "$existing_target/docs/specs/SPEC-0001.md" ]] ||
  fail 'inventory wrote a SPEC before approval'

printf 'ok: project-init acceptance scenarios\n'
