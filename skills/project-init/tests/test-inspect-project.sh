#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
inspector="$script_dir/scripts/inspect-project.sh"
temp_root="$(mktemp -d)"
trap 'rm -rf "$temp_root"' EXIT

fail() {
  printf 'not ok: %s\n' "$1" >&2
  exit 1
}

empty_target="$temp_root/empty target"
mkdir -p "$empty_target"
empty_output="$(bash "$inspector" "$empty_target")"
grep -Fxq "mode: new/empty" <<<"$empty_output" ||
  fail 'did not classify empty target'
grep -Fxq 'proposal: new-project-bootstrap' <<<"$empty_output" ||
  fail 'did not propose new-project bootstrap'
grep -Fxq 'write: none (inspection only)' <<<"$empty_output" ||
  fail 'inspection wrote or omitted no-write state'

worktree="$temp_root/worktree"
mkdir -p "$worktree/nested target"
git -C "$worktree" init --quiet
nested_output="$(bash "$inspector" "$worktree/nested target")"
grep -Fxq "worktree-root: $worktree" <<<"$nested_output" ||
  fail 'did not report enclosing worktree root'
grep -Fxq 'nested-target: approval required for override' <<<"$nested_output" ||
  fail 'did not require nested-target approval'

git_target="$temp_root/git-only"
mkdir -p "$git_target"
git -C "$git_target" init --quiet
git_output="$(bash "$inspector" "$git_target")"
grep -Fxq 'mode: new/git-only' <<<"$git_output" ||
  fail 'did not classify .git-only target'
grep -Fxq 'git: preserve-existing' <<<"$git_output" ||
  fail 'did not preserve existing Git state in proposal'

existing_target="$temp_root/existing"
mkdir -p "$existing_target"
printf 'not-a-secret-file-content\n' > "$existing_target/README.md"
printf 'do-not-print-this-secret\n' > "$existing_target/.env"
newline_entry=$'name\nwith-newline'
touch "$existing_target/$newline_entry"
existing_output="$(bash "$inspector" "$existing_target")"
grep -Fxq 'mode: existing/reconciliation' <<<"$existing_output" ||
  fail 'did not classify existing target'
grep -Fxq 'entry: .env (name only; contents not inspected)' <<<"$existing_output" ||
  fail 'did not report .env safely'
if grep -Fq 'do-not-print-this-secret' <<<"$existing_output"; then
  fail 'printed .env contents'
fi
grep -Fxq 'entry: name\nwith-newline' <<<"$existing_output" ||
  fail 'did not preserve newline-containing entry as escaped evidence'

find_failure_bin="$temp_root/find-failure-bin"
mkdir -p "$find_failure_bin"
ln -s "$(type -P false)" "$find_failure_bin/find"
if PATH="$find_failure_bin:$PATH" bash "$inspector" "$empty_target" >/dev/null 2>&1; then
  fail 'reported success after failed target traversal'
fi

if bash "$inspector" "$temp_root/extra" unexpected >/dev/null 2>&1; then
  fail 'accepted an extra argument'
fi

printf 'ok: project-init inspection and proposal classification\n'
