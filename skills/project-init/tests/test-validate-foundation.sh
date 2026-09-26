#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
initializer="$script_dir/scripts/init-project.sh"
validator="$script_dir/scripts/validate-foundation.sh"
temp_root="$(mktemp -d)"
trap 'rm -rf "$temp_root"' EXIT

fail() {
  printf 'not ok: %s\n' "$1" >&2
  exit 1
}

base_target="$temp_root/base"
bash "$initializer" "$base_target" >/dev/null
base_output="$(bash "$validator" "$base_target")"
grep -Fxq 'foundation: consistent' <<<"$base_output" ||
  fail 'base scaffold failed foundation validation'

broken_target="$temp_root/broken"
bash "$initializer" "$broken_target" >/dev/null
rm -f "$broken_target/SESSION_STATE.md"
printf 'do-not-print-this-secret\n' > "$broken_target/.env"
set +e
broken_output="$(bash "$validator" "$broken_target" 2>&1)"
broken_status=$?
set -e
[[ "$broken_status" -ne 0 ]] || fail 'inconsistent foundation was accepted'
grep -Fq 'foundation: inconsistent' <<<"$broken_output" ||
  fail 'validator did not report inconsistent foundation'
grep -Fq 'missing required project-control document: SESSION_STATE.md' <<<"$broken_output" ||
  fail 'validator omitted actionable missing-control finding'
if grep -Fq 'do-not-print-this-secret' <<<"$broken_output"; then
  fail 'validator printed .env contents'
fi

if bash "$validator" --agents AGENTS.md "$base_target" >/dev/null 2>&1; then
  fail 'validator accepted removed path-mapping options'
fi

mapped_target="$temp_root/mapped"
mkdir -p "$mapped_target/specifications"
bash "$initializer" --spec-dir specifications "$mapped_target" >/dev/null
bash "$validator" --spec-dir specifications "$mapped_target" >/dev/null ||
  fail 'validator rejected an explicitly mapped SPEC source'
if bash "$validator" "$mapped_target" >/dev/null 2>&1; then
  fail 'validator accepted an alternate SPEC source without mapping'
fi

printf 'ok: project-init foundation validator\n'
