#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
temporary="$(mktemp -d)"
trap 'rm -rf -- "$temporary"' EXIT

assert_contains() {
	local expected="$1"
	local actual="$2"

	[[ "$actual" == *"$expected"* ]] || {
		printf 'Expected output to contain: %s\nActual output:\n%s\n' "$expected" "$actual" >&2
		exit 1
	}
}

git -C "$temporary" init --initial-branch main repository >/dev/null
git -C "$temporary/repository" config user.email test@example.invalid
git -C "$temporary/repository" config user.name test
touch "$temporary/repository/README.md"
git -C "$temporary/repository" add README.md
git -C "$temporary/repository" commit -m initial >/dev/null

mkdir "$temporary/bin"
cp "$repo_root/bin/worktree-new" "$temporary/bin/worktree-new"
chmod +x "$temporary/bin/worktree-new"

output="$(cd "$temporary/repository" && PATH=/usr/bin:/bin "$temporary/bin/worktree-new" feature/optional-launcher main 2>&1)"
assert_contains "Created worktree:" "$output"
assert_contains "dev-session is unavailable; start work in:" "$output"
[[ -d "$temporary/repository.worktrees/feature/optional-launcher" ]] || {
	printf 'Expected worktree was not created.\n' >&2
	exit 1
}

printf 'worktree helper tests passed\n'
