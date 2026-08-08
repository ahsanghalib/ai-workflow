#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
temporary="$(mktemp -d)"
trap 'rm -rf -- "$temporary"' EXIT

assert_equals() {
	local expected="$1"
	local actual="$2"

	[[ "$actual" == "$expected" ]] || {
		printf 'Expected: %s\nActual: %s\n' "$expected" "$actual" >&2
		exit 1
	}
}

mkdir -p "$temporary/config/agents"
printf '{"model":"old/main","small_model":"old/small"}\n' >"$temporary/config/opencode.json"
cat >"$temporary/config/opencode-models.json" <<'EOF'
{
	"1": {
		"name": "test",
		"agents": { "main": ["custom-main"], "small": ["custom-small"] },
		"main": { "model": "new/main", "variant": "high" },
		"small": { "model": "new/small", "variant": "low" }
	}
}
EOF
for agent in custom-main custom-small; do
	cat >"$temporary/config/agents/$agent.md" <<EOF
---
description: Test agent
model: old/model
variant: medium
---

Test agent.
EOF
done

OPENCODE_CONFIG_ROOT="$temporary/config" "$repo_root/bin/opencode-model-switch" switch 1 >/dev/null

assert_equals "new/main" "$(jq -r '.model' "$temporary/config/opencode.json")"
assert_equals "new/small" "$(jq -r '.small_model' "$temporary/config/opencode.json")"
assert_equals "new/main" "$(awk '/^model:/ { print $2 }' "$temporary/config/agents/custom-main.md")"
assert_equals "new/small" "$(awk '/^model:/ { print $2 }' "$temporary/config/agents/custom-small.md")"
assert_equals "high" "$(awk '/^variant:/ { print $2 }' "$temporary/config/agents/custom-main.md")"
assert_equals "low" "$(awk '/^variant:/ { print $2 }' "$temporary/config/agents/custom-small.md")"

jq '."1".agents.main = [123]' "$temporary/config/opencode-models.json" >"$temporary/invalid-models.json"
if OPENCODE_CONFIG_ROOT="$temporary/config" OPENCODE_MODELS_FILE="$temporary/invalid-models.json" \
	"$repo_root/bin/opencode-model-switch" switch 1 >/dev/null 2>&1; then
	printf 'Expected an invalid agent mapping to fail.\n' >&2
	exit 1
fi

printf 'model switch tests passed\n'
