#!/usr/bin/env bash
set -euo pipefail

test_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
repo_root=$(cd -- "$test_dir/.." && pwd -P)
linker="$repo_root/scripts/script.sh"
temp_root=$(mktemp -d "$repo_root/.script-linker-test.XXXXXX")
trap 'rm -r -- "$temp_root"' EXIT

fail() {
	printf 'not ok: %s\n' "$1" >&2
	exit 1
}

home_dir="$temp_root/home"
bin_dir="$temp_root/bin"
mkdir -p "$home_dir" "$bin_dir"

HOME="$home_dir" \
	CODEX_HOME="$temp_root/codex" \
	XDG_CONFIG_HOME="$temp_root/config" \
	CLAUDE_CONFIG_DIR="$temp_root/claude" \
	AI_WORKFLOW_BIN_DIR="$bin_dir" \
	WORKMUX_HOME="$temp_root/workmux" \
	"$linker" >/dev/null

workmux_config="$temp_root/workmux/config.yaml"
[[ -L "$workmux_config" ]] || fail "missing Workmux config link: $workmux_config"
[[ "$(readlink "$workmux_config")" == "$repo_root/workmux/config.yaml" ]] ||
	fail "Workmux config link points to the wrong source: $workmux_config"

for helper in worktree-new worktree-close; do
	target="$bin_dir/$helper"
	[[ -L "$target" ]] || fail "missing helper link: $target"
	[[ "$(readlink "$target")" == "$repo_root/bin/$helper" ]] ||
		fail "helper link points to the wrong source: $target"
done

while IFS= read -r -d '' entrypoint; do
	source=${entrypoint%/SKILL.md}
	skill_name=${source##*/}
	for target_dir in "$home_dir/.agents/skills" "$temp_root/claude/skills"; do
		target="$target_dir/$skill_name"
		[[ -L $target ]] || fail "missing skill link: $target"
		[[ "$(readlink "$target")" == "$source" ]] ||
			fail "skill link points to the wrong source: $target"
	done
done < <(find "$repo_root/skills" -type f -name SKILL.md -print0)

printf 'ok: script linker Workmux config, helpers, and shared skill links\n'
