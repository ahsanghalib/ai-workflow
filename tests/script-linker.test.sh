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
	"$linker" >/dev/null

for helper in worktree-new worktree-close; do
	target="$bin_dir/$helper"
	[[ -L "$target" ]] || fail "missing helper link: $target"
	[[ "$(readlink "$target")" == "$repo_root/bin/$helper" ]] ||
		fail "helper link points to the wrong source: $target"
done

for source in "$repo_root"/skills/*; do
	[[ -d $source ]] || continue
	skill_name=${source##*/}
	target="$temp_root/claude/skills/$skill_name"
	[[ -L $target ]] || fail "missing Claude Code skill link: $target"
	[[ "$(readlink "$target")" == "$source" ]] ||
		fail "Claude Code skill link points to the wrong source: $target"
done

printf 'ok: script linker worktree helper and Claude Code skill links\n'
