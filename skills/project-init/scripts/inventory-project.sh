#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'usage: %s [target-directory]\n' "$0"
  printf '%s\n' 'Inventory safe project evidence without reading file contents.'
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
printf 'inventory: read-only\n'
printf 'inventory: file contents, .env values, credentials, and keys were not read\n'

evidence_list="$(mktemp)"
cleanup() {
  rm -f "$evidence_list"
}
trap cleanup EXIT
if ! find -P "$target" -mindepth 1 -maxdepth 4 \
    \( -type d \( -name .git -o -name node_modules -o -name vendor \
       -o -name .next -o -name dist -o -name build -o -name coverage \) \
       -o -path "$target/.ai/memory" \) -prune \
    -o \( -type f -o -type l \) -print0 > "$evidence_list"; then
  printf 'error: could not inventory project paths; no evidence was produced\n' >&2
  exit 1
fi

paths=()
while IFS= read -r -d '' path; do
  paths+=("${path#"$target"/}")
done < "$evidence_list"

classify() {
  local rel="$1"
  case "$rel" in
    .env|.env.*|*.pem|*.key|*.p12|*.pfx|id_rsa|id_rsa.*|*credentials*|*secret*)
      printf 'sensitive-name-only'
      ;;
    */AGENTS.md|AGENTS.md|README.md|README.*|CLAUDE.md|GEMINI.md|.cursorrules|.windsurfrules)
      printf 'instruction'
      ;;
    docs/USER_FLOW.md|*USER_FLOW.md|*user-flow*)
      printf 'user-flow'
      ;;
    MASTER_PLAN.md|PLANS.md|*MASTER_PLAN*|*plans/*|*plan*|*SPEC*|*specs/*)
      printf 'planning'
      ;;
    *ARCHITECTURE*|*architecture*)
      printf 'architecture'
      ;;
    docs/DB_SCHEMA.md|*DB_SCHEMA*|*schema.prisma|*schema*|*migrations/*|*migration*)
      printf 'schema'
      ;;
    package.json|package-lock.json|yarn.lock|pnpm-lock.yaml|bun.lockb|pyproject.toml|poetry.lock|requirements*.txt|Pipfile*|Cargo.toml|Cargo.lock|go.mod|go.sum|Gemfile*|composer.json|composer.lock)
      printf 'manifest'
      ;;
    src/*|app/*|apps/*|packages/*|server/*|backend/*|frontend/*|client/*|lib/*)
      printf 'source'
      ;;
    tests/*|test/*|spec/*|*.test.*|*.spec.*|pytest.ini|jest.config.*|vitest.config.*|playwright.config.*)
      printf 'validation'
      ;;
    .gitignore|.gitattributes|.gitmodules)
      printf 'repository'
      ;;
    Dockerfile*|Makefile|justfile|Taskfile*|*.yml|*.yaml|*.toml|*.ini|tsconfig*.json|eslint.config.*|.eslintrc*|prettier.config.*|.prettierrc*)
      printf 'configuration'
      ;;
    *)
      printf 'other'
      ;;
  esac
}

if [[ "${#paths[@]}" -eq 0 ]]; then
  printf 'evidence: (none)\n'
else
  for rel in "${paths[@]}"; do
    escaped_rel="$(escape_output "$rel")"
    if [[ -L "$target/$rel" ]]; then
      printf 'evidence: %s | symlink-not-followed\n' "$escaped_rel"
    else
      printf 'evidence: %s | %s\n' "$escaped_rel" "$(classify "$rel")"
    fi
  done
fi
