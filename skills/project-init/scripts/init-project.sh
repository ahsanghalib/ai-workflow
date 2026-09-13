#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'usage: %s [target-directory]\n' "$0"
  printf 'Copy the project-init documentation scaffold into a target directory.\n'
}

if [[ "$#" -eq 1 && ( "$1" == '-h' || "$1" == '--help' ) ]]; then
  usage
  exit 0
fi

if [[ "$#" -gt 1 ]]; then
  usage >&2
  exit 64
fi

target="${1:-$PWD}"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
template_root="$(cd "$script_dir/../templates" && pwd)"

target="$(mkdir -p -- "$target" && cd -- "$target" && pwd -P)"
printf 'target: %s\n' "$target"

ensure_parent_dir() {
  local dir="$1" relative current component
  local -a components

  [[ "$dir" == "$target" ]] && return 0
  relative="${dir#"$target"/}"
  current="$target"
  IFS='/' read -r -a components <<< "$relative"

  for component in "${components[@]}"; do
    [[ -z "$component" ]] && continue
    current="$current/$component"
    if [[ -L "$current" ]]; then
      return 1
    fi
    mkdir -p -- "$current"
  done
}

copy_if_missing() {
  local src="$1" dst="$2"
  if ! ensure_parent_dir "$(dirname "$dst")"; then
    echo "skip: ${dst#"$target"/} (parent is a symlink)"
    return
  fi
  if [[ -e "$dst" || -L "$dst" ]]; then
    echo "skip: ${dst#"$target"/}"
  else
    cp "$src" "$dst"
    echo "create: ${dst#"$target"/}"
  fi
}

while IFS= read -r -d '' src; do
  rel="${src#"$template_root"/}"
  if [[ "$rel" == ".gitignore.template" ]]; then
    rel=".gitignore"
  fi
  copy_if_missing "$src" "$target/$rel"
done < <(find "$template_root" -type f -print0)

for directory in docs/specs docs/plans docs/reviews; do
  if ! ensure_parent_dir "$target/$directory"; then
    echo "skip: $directory (parent is a symlink)"
  fi
done

echo "Project documentation scaffold initialized. Fill MASTER_PLAN.md before asking AI to refine project-specific docs."
