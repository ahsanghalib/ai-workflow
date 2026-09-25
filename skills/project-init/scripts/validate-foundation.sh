#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'usage: %s [--agents RELPATH] [--session-state RELPATH]\n' "$0"
  printf '       [--specs RELPATH] [--memory RELPATH]\n'
  printf '       [--readme RELPATH] [--master-plan RELPATH]\n'
  printf '       [--architecture RELPATH] [--user-flow RELPATH|none]\n'
  printf '       [--schema RELPATH|none] [--plans RELPATH|none]\n'
  printf '       [--reviews RELPATH|none] [project-directory]\n'
  printf '%s\n' 'Validate the minimal project-control structure and explicitly selected legacy paths.'
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
# shellcheck disable=SC1091
source "$script_dir/common.sh"

agents_path='AGENTS.md'
session_state_path='SESSION_STATE.md'
specs_path='docs/specs'
memory_path='.ai/memory'
readme_path=''
master_plan_path=''
architecture_path=''
user_flow_path=''
schema_path=''
plans_path=''
reviews_path=''
target=''
target_set=false

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --agents|--session-state|--specs|--memory|--readme|--master-plan|\
    --architecture|--user-flow|--schema|--plans|--reviews)
      if [[ "$#" -lt 2 ]]; then
        usage >&2
        exit 64
      fi
      case "$1" in
        --agents) agents_path="$2" ;;
        --session-state) session_state_path="$2" ;;
        --specs) specs_path="$2" ;;
        --memory) memory_path="$2" ;;
        --readme) readme_path="$2" ;;
        --master-plan) master_plan_path="$2" ;;
        --architecture) architecture_path="$2" ;;
        --user-flow) user_flow_path="$2" ;;
        --schema) schema_path="$2" ;;
        --plans) plans_path="$2" ;;
        --reviews) reviews_path="$2" ;;
      esac
      shift
      ;;
    --*)
      usage >&2
      exit 64
      ;;
    *)
      if [[ "$target_set" == true ]]; then
        usage >&2
        exit 64
      fi
      target="$1"
      target_set=true
      ;;
  esac
  shift
done

if [[ "$target_set" != true ]]; then
  target="$PWD"
fi

normalize_path() {
  local raw="$1" component normalized=''
  local -a components

  [[ "$raw" == 'none' ]] && {
    printf '\n'
    return 0
  }
  if [[ -z "$raw" || "$raw" == /* || "$raw" == *$'\n'* || "$raw" == *$'\r'* ]]; then
    return 1
  fi
  IFS='/' read -r -a components <<< "$raw"
  for component in "${components[@]}"; do
    case "$component" in
      ''|.)
        continue
        ;;
      ..)
        return 1
        ;;
      *)
        normalized="${normalized:+$normalized/}$component"
        ;;
    esac
  done
  [[ -n "$normalized" ]] || return 1
  printf '%s\n' "$normalized"
}

for document_spec in agents session_state specs memory readme master_plan \
  architecture user_flow schema plans reviews; do
  case "$document_spec" in
    agents) raw_path="$agents_path" ;;
    session_state) raw_path="$session_state_path" ;;
    specs) raw_path="$specs_path" ;;
    memory) raw_path="$memory_path" ;;
    readme) raw_path="$readme_path" ;;
    master_plan) raw_path="$master_plan_path" ;;
    architecture) raw_path="$architecture_path" ;;
    user_flow) raw_path="$user_flow_path" ;;
    schema) raw_path="$schema_path" ;;
    plans) raw_path="$plans_path" ;;
    reviews) raw_path="$reviews_path" ;;
  esac
  if [[ -z "$raw_path" ]]; then
    normalized_path=''
  elif ! normalized_path="$(normalize_path "$raw_path")"; then
    printf 'error: invalid %s path: %s\n' "$document_spec" "$raw_path" >&2
    exit 64
  fi
  case "$document_spec" in
    agents) agents_path="$normalized_path" ;;
    session_state) session_state_path="$normalized_path" ;;
    specs) specs_path="$normalized_path" ;;
    memory) memory_path="$normalized_path" ;;
    readme) readme_path="$normalized_path" ;;
    master_plan) master_plan_path="$normalized_path" ;;
    architecture) architecture_path="$normalized_path" ;;
    user_flow) user_flow_path="$normalized_path" ;;
    schema) schema_path="$normalized_path" ;;
    plans) plans_path="$normalized_path" ;;
    reviews) reviews_path="$normalized_path" ;;
  esac
done

base_dir="$(pwd -P)"
if [[ "$target" != /* ]]; then
  target="$base_dir/$target"
fi
target="${target%/}"
[[ -n "$target" ]] || target="/"

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

require_optional_path() {
  local relative="$1" kind="$2"
  [[ -z "$relative" ]] && return 0
  if [[ "$kind" == directory && ! -d "$target/$relative" ]]; then
    error "selected project-control directory is missing: $relative"
  elif [[ "$kind" == file && ! -f "$target/$relative" ]]; then
    error "selected project-control document is missing: $relative"
  elif [[ -L "$target/$relative" ]]; then
    error "selected project-control path must not be a symlink: $relative"
  fi
}

require_file "$agents_path"
require_file "$session_state_path"
require_directory "$specs_path"
require_directory "$memory_path"

require_optional_path "$readme_path" file
require_optional_path "$master_plan_path" file
require_optional_path "$architecture_path" file
require_optional_path "$user_flow_path" file
require_optional_path "$schema_path" file
require_optional_path "$plans_path" directory
require_optional_path "$reviews_path" directory

if [[ -f "$target/$agents_path" && ! -L "$target/$agents_path" ]]; then
  grep -Fq -- "$session_state_path" "$target/$agents_path" ||
    error "$agents_path must route to $session_state_path"
  grep -Fq -- "$specs_path" "$target/$agents_path" ||
    error "$agents_path must route to $specs_path"
fi

if [[ "$errors" -gt 0 ]]; then
  printf 'foundation: inconsistent (%d finding%s)\n' \
    "$errors" "$([[ "$errors" -eq 1 ]] || printf s)" >&2
  exit 1
fi

printf 'foundation: consistent\n'
