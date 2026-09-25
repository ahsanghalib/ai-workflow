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

bash "$initializer" --only docs/USER_FLOW.md "$base_target" >/dev/null
flow_output="$(bash "$validator" --user-flow docs/USER_FLOW.md "$base_target")"
grep -Fxq 'foundation: consistent' <<<"$flow_output" ||
  fail 'selected user-flow scaffold failed foundation validation'

bash "$initializer" --only docs/DB_SCHEMA.md --with-schema "$base_target" >/dev/null
schema_output="$(bash "$validator" \
  --user-flow docs/USER_FLOW.md \
  --schema docs/DB_SCHEMA.md \
  "$base_target")"
grep -Fxq 'foundation: consistent' <<<"$schema_output" ||
  fail 'selected schema scaffold failed foundation validation'

custom_target="$temp_root/custom-layout"
bash "$initializer" "$custom_target" >/dev/null
mv "$custom_target/AGENTS.md" "$custom_target/INSTRUCTIONS.md"
mv "$custom_target/SESSION_STATE.md" "$custom_target/state.md"
sed -i 's/SESSION_STATE\.md/state.md/g' "$custom_target/INSTRUCTIONS.md"
custom_output="$(bash "$validator" \
  --agents INSTRUCTIONS.md \
  --session-state state.md \
  "$custom_target")"
grep -Fxq 'foundation: consistent' <<<"$custom_output" ||
  fail 'validator rejected an explicitly mapped existing-project layout'

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

printf 'ok: project-init foundation validator\n'
