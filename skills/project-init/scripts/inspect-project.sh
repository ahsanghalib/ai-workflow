#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'usage: %s [target-directory]\n' "$0"
  printf '%s\n' 'Inspect project mode and print a no-write bootstrap proposal.'
}

target="$PWD"
if [[ "$#" -eq 1 && ( "$1" == '-h' || "$1" == '--help' ) ]]; then
  usage
  exit 0
fi
if [[ "$#" -eq 1 ]]; then
  target="$1"
elif [[ "$#" -gt 0 ]]; then
  usage >&2
  exit 64
fi

base_dir="$(pwd -P)"
if [[ "$target" != /* ]]; then
  target="$base_dir/$target"
fi
target="${target%/}"
[[ -n "$target" ]] || target="/"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
# shellcheck disable=SC1091
source "$script_dir/common.sh"

if [[ ! -d "$target" ]]; then
  printf 'error: target directory does not exist: %s\n' "$target" >&2
  exit 66
fi
if path_has_symlink "$target"; then
  printf 'error: target or parent is a symlink: %s\n' "$target" >&2
  exit 65
fi

target="$(cd "$target" && pwd -P)"
printf 'target: %s\n' "$target"

worktree_root=''
if command -v git >/dev/null 2>&1 &&
   worktree_root="$(git -C "$target" rev-parse --show-toplevel 2>/dev/null)"; then
  worktree_root="$(cd "$worktree_root" && pwd -P)"
  printf 'worktree-root: %s\n' "$worktree_root"
  if [[ "$worktree_root" != "$target" ]]; then
    printf 'nested-target: approval required for override\n'
  else
    printf 'nested-target: no override required\n'
  fi
else
  printf 'worktree-root: none\n'
  printf 'nested-target: no enclosing worktree\n'
fi

entry_list="$(mktemp)"
cleanup() {
  rm -f "$entry_list"
}
trap cleanup EXIT
if ! find "$target" -mindepth 1 -maxdepth 1 -print0 > "$entry_list"; then
  printf 'error: could not inspect target entries; no proposal was produced\n' >&2
  exit 1
fi

entries=()
while IFS= read -r -d '' entry; do
  entries+=("${entry##*/}")
done < "$entry_list"

if [[ "${#entries[@]}" -eq 0 ]]; then
  mode='new/empty'
elif [[ "${#entries[@]}" -eq 1 && "${entries[0]}" == '.git' ]]; then
  mode='new/git-only'
else
  mode='existing/reconciliation'
fi
printf 'mode: %s\n' "$mode"

if [[ "${#entries[@]}" -gt 0 ]]; then
  for entry in "${entries[@]}"; do
    escaped_entry="$(escape_output "$entry")"
    if [[ "$entry" == '.env' || "$entry" == .env.* ]]; then
      printf 'entry: %s (name only; contents not inspected)\n' "$escaped_entry"
    else
      printf 'entry: %s\n' "$escaped_entry"
    fi
  done
fi

if [[ -e "$target/.git" || -L "$target/.git" ]]; then
  printf 'git: preserve-existing\n'
  if ! command -v git >/dev/null 2>&1; then
    printf 'git-state: unavailable (git is not on PATH)\n'
  elif git -C "$target" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    if git -C "$target" rev-parse --verify HEAD >/dev/null 2>&1; then
      printf 'git-state: established\n'
    else
      printf 'git-state: unborn\n'
    fi
  else
    printf 'git-state: present-but-unreadable\n'
  fi
else
  if command -v git >/dev/null 2>&1; then
    printf 'git: absent (separate approval required for local init)\n'
  else
    printf 'git: absent (Git unavailable; documentation-only fallback)\n'
  fi
  printf 'git-state: absent\n'
fi

if [[ "$mode" == 'new/empty' || "$mode" == 'new/git-only' ]]; then
  printf 'proposal: new-project-bootstrap\n'
else
  printf 'proposal: existing-project-reconciliation\n'
fi
printf 'write: none (inspection only)\n'
printf 'proposal: review the file list and approvals before any write or Git mutation\n'
printf 'proposal: ask separately before creating docs/DB_SCHEMA.md for persisted data\n'
