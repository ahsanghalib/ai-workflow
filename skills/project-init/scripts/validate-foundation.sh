#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'usage: %s [--readme RELPATH] [--agents RELPATH]\n' "$0"
  printf '       [--master-plan RELPATH] [--architecture RELPATH]\n'
  printf '       [--user-flow RELPATH|none] [--schema RELPATH|none] [project-directory]\n'
  printf '%s\n' 'Validate the structural links among project-control documents.'
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
# shellcheck disable=SC1091
source "$script_dir/common.sh"

readme_path='README.md'
agents_path='AGENTS.md'
master_plan_path='MASTER_PLAN.md'
architecture_path='docs/PROJECT_ARCHITECTURE.md'
user_flow_path='docs/USER_FLOW.md'
schema_path='docs/DB_SCHEMA.md'
user_flow_explicit=false
schema_explicit=false
target=''
target_set=false

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --readme|--agents|--master-plan|--architecture|--user-flow|--schema)
      if [[ "$#" -lt 2 ]]; then
        usage >&2
        exit 64
      fi
      case "$1" in
        --readme) readme_path="$2" ;;
        --agents) agents_path="$2" ;;
        --master-plan) master_plan_path="$2" ;;
        --architecture) architecture_path="$2" ;;
        --user-flow) user_flow_path="$2"; user_flow_explicit=true ;;
        --schema) schema_path="$2"; schema_explicit=true ;;
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

normalize_document_path() {
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

for document_spec in readme agents master_plan architecture user_flow schema; do
  case "$document_spec" in
    readme) raw_path="$readme_path" ;;
    agents) raw_path="$agents_path" ;;
    master_plan) raw_path="$master_plan_path" ;;
    architecture) raw_path="$architecture_path" ;;
    user_flow) raw_path="$user_flow_path" ;;
    schema) raw_path="$schema_path" ;;
  esac
  if ! normalized_path="$(normalize_document_path "$raw_path")"; then
    printf 'error: invalid %s document path: %s\n' "$document_spec" "$raw_path" >&2
    exit 64
  fi
  case "$document_spec" in
    readme) readme_path="$normalized_path" ;;
    agents) agents_path="$normalized_path" ;;
    master_plan) master_plan_path="$normalized_path" ;;
    architecture) architecture_path="$normalized_path" ;;
    user_flow) user_flow_path="$normalized_path" ;;
    schema) schema_path="$normalized_path" ;;
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
    error "missing required foundation document: $relative"
  fi
}

require_reference() {
  local relative="$1" reference="$2" description="$3"
  if [[ -f "$target/$relative" && ! -L "$target/$relative" ]] &&
     ! grep -Fq -- "$reference" "$target/$relative"; then
    error "$relative must reference $reference ($description)"
  fi
}

reject_dead_optional_link() {
  local relative="$1" reference="$2"
  if [[ -f "$target/$relative" && ! -L "$target/$relative" ]] &&
     grep -Fq -- "$reference" "$target/$relative"; then
    error "$relative contains a link to an unselected optional document: $reference"
  fi
}

for required_path in "$readme_path" "$agents_path" "$master_plan_path" "$architecture_path"; do
  if [[ -z "$required_path" ]]; then
    error 'required foundation document paths cannot be none'
  else
    require_file "$required_path"
  fi
done

if [[ "$user_flow_explicit" == true && -n "$user_flow_path" &&
      ! -e "$target/$user_flow_path" ]]; then
  error "selected user-flow document is missing: $user_flow_path"
fi
if [[ "$schema_explicit" == true && -n "$schema_path" &&
      ! -e "$target/$schema_path" ]]; then
  error "selected schema document is missing: $schema_path"
fi

require_reference "$master_plan_path" "$agents_path" 'operating rules'
require_reference "$master_plan_path" "$architecture_path" 'technical architecture'
require_reference "$agents_path" "$master_plan_path" 'product direction'
require_reference "$agents_path" "$architecture_path" 'technical architecture'
require_reference "$architecture_path" "$master_plan_path" 'product direction'
require_reference "$architecture_path" "$agents_path" 'operating rules'
require_reference "$readme_path" "$master_plan_path" 'project direction'
require_reference "$readme_path" "$architecture_path" 'architecture'

if [[ -z "$user_flow_path" ]]; then
  for document in "$readme_path" "$master_plan_path" "$agents_path" "$architecture_path"; do
    reject_dead_optional_link "$document" '](./docs/USER_FLOW.md)'
    reject_dead_optional_link "$document" '](docs/USER_FLOW.md)'
  done
elif [[ -e "$target/$user_flow_path" ]]; then
  if [[ ! -f "$target/$user_flow_path" || -L "$target/$user_flow_path" ]]; then
    error "$user_flow_path must be a regular file when selected"
  else
    require_reference "$master_plan_path" "$user_flow_path" 'actor/system journeys'
    require_reference "$agents_path" "$user_flow_path" 'user-flow ownership'
    require_reference "$architecture_path" "$user_flow_path" 'architecture alignment'
  fi
fi

if [[ -z "$schema_path" ]]; then
  :
elif [[ ! -e "$target/$schema_path" ]]; then
  if [[ "$schema_explicit" != true ]]; then
    for document in "$readme_path" "$master_plan_path" "$agents_path" "$architecture_path"; do
      reject_dead_optional_link "$document" '](./docs/DB_SCHEMA.md)'
      reject_dead_optional_link "$document" '](docs/DB_SCHEMA.md)'
    done
  fi
elif [[ ! -f "$target/$schema_path" || -L "$target/$schema_path" ]]; then
  error "$schema_path must be a regular file when selected"
else
  if [[ -n "$user_flow_path" &&
        ! -f "$target/$user_flow_path" ]]; then
    error "$schema_path requires a selected user-flow document or --user-flow none"
  else
    require_reference "$master_plan_path" "$schema_path" 'persistence ownership'
    require_reference "$agents_path" "$schema_path" 'schema ownership'
    require_reference "$architecture_path" "$schema_path" 'data architecture alignment'
    if [[ -n "$user_flow_path" ]]; then
      require_reference "$user_flow_path" "$schema_path" 'flow/data dependency'
    fi
  fi
fi

if [[ "$errors" -gt 0 ]]; then
  printf 'foundation: inconsistent (%d finding%s)\n' "$errors" "$([[ "$errors" -eq 1 ]] || printf s)" >&2
  exit 1
fi

printf 'foundation: consistent\n'
