#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'usage: %s [--spec-dir RELPATH] [project-directory]\n' "$0"
  printf '%s\n' 'Validate the minimal project-init control structure.'
}

spec_dir='docs/specs'
target=''
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --spec-dir)
      if [[ "$#" -lt 2 ]]; then
        usage >&2
        exit 64
      fi
      spec_dir="$2"
      shift
      ;;
    --*)
      usage >&2
      exit 64
      ;;
    *)
      if [[ -n "$target" ]]; then
        usage >&2
        exit 64
      fi
      target="$1"
      ;;
  esac
  shift
done

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
# shellcheck disable=SC1091
source "$script_dir/common.sh"

normalize_relative_path() {
  local raw="$1" component normalized=''
  local -a components

  if [[ -z "$raw" || "$raw" == /* || "$raw" == *$'\n'* || "$raw" == *$'\r'* ]]; then
    return 1
  fi
  IFS='/' read -r -a components <<< "$raw"
  for component in "${components[@]}"; do
    case "$component" in
      ''|.) continue ;;
      ..|.git|.env|.env.*) return 1 ;;
      *) normalized="${normalized:+$normalized/}$component" ;;
    esac
  done
  [[ -n "$normalized" ]] || return 1
  printf '%s\n' "$normalized"
}

if ! spec_dir="$(normalize_relative_path "$spec_dir")"; then
  printf 'error: --spec-dir must be a safe relative directory under the project: %s\n' "$spec_dir" >&2
  exit 64
fi

target="${target:-$PWD}"
base_dir="$(pwd -P)"
if [[ "$target" != /* ]]; then
  target="$base_dir/$target"
fi
target="${target%/}"
[[ -n "$target" ]] || target=/

if [[ ! -d "$target" || -L "$target" ]] || path_has_symlink "$target"; then
  printf 'error: project target is missing or uses a symlinked path: %s\n' "$target" >&2
  exit 65
fi
target="$(cd "$target" && pwd -P)"

errors=0
error() {
  printf 'error: %s\n' "$1" >&2
  errors=$((errors + 1))
}

require_file() {
  local relative="$1"
  if [[ ! -f "$target/$relative" || -L "$target/$relative" ]]; then
    error "missing required project-control document: $relative"
  fi
}

require_directory() {
  local relative="$1"
  if [[ ! -d "$target/$relative" || -L "$target/$relative" ]]; then
    error "missing required project-control directory: $relative"
  fi
}

require_file AGENTS.md
require_file SESSION_STATE.md
require_directory .ai/memory
require_directory "$spec_dir"

if [[ -f "$target/AGENTS.md" && ! -L "$target/AGENTS.md" ]]; then
  grep -Fq 'SESSION_STATE.md' "$target/AGENTS.md" ||
    error 'AGENTS.md must route to SESSION_STATE.md'
  grep -Fq "$spec_dir" "$target/AGENTS.md" ||
    error "AGENTS.md must route to $spec_dir"
fi

if [[ "$errors" -gt 0 ]]; then
  printf 'foundation: inconsistent (%d finding%s)\n' \
    "$errors" "$([[ "$errors" -eq 1 ]] || printf s)" >&2
  exit 1
fi

printf 'foundation: consistent\n'
