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

[[ -f "$acceptance" ]] || fail 'missing acceptance-scenarios reference'
grep -Fq 'No write before approval' "$acceptance" ||
  fail 'acceptance reference omitted no-write scenario'
grep -Fq 'Reload after instruction changes' "$acceptance" ||
  fail 'acceptance reference omitted reload scenario'
grep -Fq 'Default mode and escalation' "$script_dir/SKILL.md" ||
  fail 'skill omitted adaptive mode acceptance contract'
grep -Fq 'Decided versus explored' "$acceptance" ||
  fail 'acceptance reference omitted the discovery gate scenario'
grep -Fq 'Review ceremony preview' "$acceptance" ||
  fail 'acceptance reference omitted the ceremony preview scenario'
grep -Fq 'Risk-based escalation' "$acceptance" ||
  fail 'acceptance reference omitted risk escalation'
grep -Fq 'Approval acknowledgement' "$acceptance" ||
  fail 'acceptance reference omitted approval acknowledgement'
grep -Fq 'Conditional scaffold profile' "$acceptance" ||
  fail 'acceptance reference omitted conditional scaffold scenario'
grep -Fq 'Idempotent unchanged rerun' "$acceptance" ||
  fail 'acceptance reference omitted idempotent rerun scenario'
grep -Fq 'Foundational consistency validation' "$acceptance" ||
  fail 'acceptance reference omitted foundation validation scenario'
grep -Fq 'Existing-layout foundation mapping' "$acceptance" ||
  fail 'acceptance reference omitted existing-layout validator mapping'

empty_target="$temp_root/empty target"
mkdir -p "$empty_target"
empty_output="$(bash "$inspector" "$empty_target")"
grep -Fxq "target: $empty_target" <<<"$empty_output" ||
  fail 'did not report the canonical target before approval'
grep -Fxq 'write: none (inspection only)' <<<"$empty_output" ||
  fail 'inspection did not report the no-write state'
[[ -z "$(find "$empty_target" -mindepth 1 -print -quit)" ]] ||
  fail 'inspection wrote to the empty target'

existing_target="$temp_root/existing"
mkdir -p "$existing_target/src" "$existing_target/docs"
printf 'existing project\n' > "$existing_target/README.md"
printf 'instruction\n' > "$existing_target/AGENTS.md"
printf 'direction\n' > "$existing_target/MASTER_PLAN.md"
printf 'source\n' > "$existing_target/src/app.ts"
printf 'do-not-print-this-secret\n' > "$existing_target/.env"
inventory_output="$(bash "$inventory" "$existing_target")"
grep -Fq '| instruction' <<<"$inventory_output" ||
  fail 'did not classify existing instructions'
grep -Fq '| planning' <<<"$inventory_output" ||
  fail 'did not classify existing planning evidence'
if grep -Fq 'do-not-print-this-secret' <<<"$inventory_output"; then
  fail 'inventory printed .env contents'
fi
[[ ! -e "$existing_target/docs/USER_FLOW.md" ]] ||
  fail 'inventory wrote a missing document before approval'

prompt_root="$script_dir/templates/.ai/prompts"
for prompt in "$prompt_root"/*.md; do
  if [[ "$(basename "$prompt")" == 'README.md' ]]; then
    continue
  fi
  grep -Fq 'Provenance: bundled project-init template.' "$prompt" ||
    fail "missing prompt provenance: $prompt"
done
grep -Fq 'automatic runtime instructions' "$prompt_root/README.md" ||
  fail 'prompt routing index omitted non-discovery boundary'
grep -Fq 'prompt-contract.md' "$script_dir/SKILL.md" ||
  fail 'skill omitted prompt-contract routing'

if ! grep -Fq 'fresh' "$script_dir/references/init-compatibility.md" ||
   ! grep -Fq 'session' "$script_dir/references/init-compatibility.md"; then
  fail 'reload guidance omitted fresh-session handoff'
fi
grep -Fq 'approval' "$script_dir/references/init-compatibility.md" ||
  fail 'reload guidance omitted approval context'

printf 'ok: project-init conversational acceptance scenarios\n'
