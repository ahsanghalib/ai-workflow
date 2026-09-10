#!/usr/bin/env bash

set -Eeuo pipefail

usage() {
  cat <<'EOF'
Usage: script.sh [repository]

Link the agents and skills from this repository into both runtimes.

The repository defaults to the directory containing this script. When the
script is stored elsewhere, pass the repository path or set AI_WORKFLOW_REPO.
EOF
}

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

if [[ ${1:-} == '-h' || ${1:-} == '--help' ]]; then
  usage
  exit 0
fi

if (($# > 1)); then
  usage >&2
  exit 2
fi

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
repository=${AI_WORKFLOW_REPO:-${1:-$script_dir}}
repository=$(cd -- "$repository" 2>/dev/null && pwd -P) || die "Repository does not exist: $repository"

home_dir=${HOME:?HOME must be set}
codex_home=${CODEX_HOME:-$home_dir/.codex}
opencode_home=${XDG_CONFIG_HOME:-$home_dir/.config}/opencode

link_path() {
  local source_path=$1
  local target_path=$2

  [[ -e $source_path || -L $source_path ]] || die "Source does not exist: $source_path"

  mkdir -p -- "$(dirname -- "$target_path")"

  if [[ -L $target_path ]]; then
    rm -f -- "$target_path"
  elif [[ -e $target_path ]]; then
    die "Target exists and is not a symlink: $target_path"
  fi

  ln -sfn -- "$source_path" "$target_path"
  printf 'Linked %s -> %s\n' "$target_path" "$source_path"
}

link_agents() {
  link_path "$repository/agents/codex" "$codex_home/agents"
  link_path "$repository/agents/opencode" "$opencode_home/agents"
  link_path "$repository/GLOBAL_AGENTS.md" "$codex_home/AGENTS.md"
  link_path "$repository/GLOBAL_AGENTS.md" "$opencode_home/AGENTS.md"
}

link_skills() {
  local source_path
  local skill_name

  [[ -d $repository/skills ]] || die "Skills directory does not exist: $repository/skills"

  mkdir -p -- "$codex_home/skills" "$opencode_home/skills"

  shopt -s nullglob
  for source_path in "$repository/skills"/*; do
    [[ -d $source_path ]] || continue
    skill_name=${source_path##*/}
    link_path "$source_path" "$codex_home/skills/$skill_name"
    link_path "$source_path" "$opencode_home/skills/$skill_name"
  done
}

link_agents
link_skills

printf 'Done. Existing %s/skills/.system was left untouched.\n' "$codex_home"
