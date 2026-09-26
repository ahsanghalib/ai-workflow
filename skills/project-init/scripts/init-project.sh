#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'usage: %s [--spec-dir RELPATH] [--init-git] [--allow-nested] [target-directory]\n' "$0"
  printf 'Copy the minimal project-init control scaffold into a target directory.\n'
  printf '%s\n' 'The helper creates no feature, plan, schema, flow, architecture, rule, or application files.'
  printf '%s\n' 'Use --spec-dir only for an explicitly approved existing SPEC source-of-truth mapping.'
  printf '%s\n' 'Use --init-git only after separate approval for this exact target; it creates no commit or remote.'
  printf '%s\n' 'Use --allow-nested only after separate approval to initialize inside another Git worktree.'
}

spec_dir='docs/specs'
spec_dir_explicit=false
initialize_git=false
allow_nested=false
target="$PWD"
positional_count=0

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
      spec_dir_explicit=true
      shift
      ;;
    --init-git)
      initialize_git=true
      ;;
    --allow-nested)
      allow_nested=true
      ;;
    --*)
      usage >&2
      exit 64
      ;;
    *)
      positional_count=$((positional_count + 1))
      if [[ "$positional_count" -gt 1 ]]; then
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
  printf 'error: --spec-dir must be a safe relative directory under the target: %s\n' "$spec_dir" >&2
  exit 64
fi

normalize_lexical_path() {
  local raw="$1" component normalized=''
  local -a raw_components parts=()

  IFS='/' read -r -a raw_components <<< "${raw#/}"
  for component in "${raw_components[@]}"; do
    case "$component" in
      ''|.) continue ;;
      ..)
        if [[ "${#parts[@]}" -gt 0 ]]; then
          parts=("${parts[@]:0:${#parts[@]}-1}")
        fi
        ;;
      *) parts+=("$component") ;;
    esac
  done
  for component in "${parts[@]}"; do
    normalized="$normalized/$component"
  done
  printf '%s\n' "${normalized:-/}"
}

canonicalize_target() {
  local raw="$1" parent name
  raw="$(normalize_lexical_path "$raw")"
  if [[ "$raw" == / ]]; then
    printf '/\n'
    return 0
  fi
  if [[ -d "$raw" ]]; then
    cd "$raw" && pwd -P
    return
  fi
  parent="$(dirname "$raw")"
  name="$(basename "$raw")"
  while [[ ! -d "$parent" && "$parent" != / ]]; do
    name="$(basename "$parent")/$name"
    parent="$(dirname "$parent")"
  done
  if [[ ! -d "$parent" ]]; then
    printf 'error: target parent is not a directory: %s\n' "$parent" >&2
    return 1
  fi
  parent="$(cd "$parent" && pwd -P)"
  printf '%s/%s\n' "$parent" "$name"
}

base_dir="$(pwd -P)"
if [[ "$target" != /* ]]; then
  target="$base_dir/$target"
fi
target="${target%/}"
[[ -n "$target" ]] || target=/

if path_has_symlink "$target"; then
  printf 'error: target or parent is a symlink: %s\n' "$target" >&2
  exit 65
fi
target="$(canonicalize_target "$target")"
if path_has_symlink "$target"; then
  printf 'error: target or parent is a symlink: %s\n' "$target" >&2
  exit 65
fi

worktree_root=''
worktree_probe="$target"
while [[ ! -d "$worktree_probe" && "$worktree_probe" != / ]]; do
  worktree_probe="$(dirname "$worktree_probe")"
done
if command -v git >/dev/null 2>&1 &&
   worktree_root="$(git -C "$worktree_probe" rev-parse --show-toplevel 2>/dev/null)"; then
  worktree_root="$(cd "$worktree_root" && pwd -P)"
  case "$target/" in
    "$worktree_root/"|"$worktree_root") nested_target=false ;;
    "$worktree_root/"*) nested_target=true ;;
    *) nested_target=false ;;
  esac
  if [[ "$nested_target" == true && "$allow_nested" != true ]]; then
    printf 'error: target is nested in another Git worktree; require --allow-nested after approval: %s\n' "$target" >&2
    exit 67
  fi
else
  nested_target=false
fi

existing_target=false
if [[ -d "$target" ]]; then
  shopt -s nullglob dotglob
  target_entries=("$target"/*)
  shopt -u nullglob dotglob
  for entry in "${target_entries[@]}"; do
    [[ "$(basename "$entry")" == '.git' ]] || existing_target=true
  done
fi

if [[ "$existing_target" == true && "$spec_dir_explicit" != true ]]; then
  for candidate in docs/specifications specifications specs; do
    if [[ -d "$target/$candidate" && ! -L "$target/$candidate" ]]; then
      printf 'error: existing SPEC source-of-truth detected at %s; rerun with --spec-dir %s after explicit approval\n' \
        "$candidate" "$candidate" >&2
      exit 66
    fi
  done
fi

if [[ "$existing_target" != true && "$spec_dir_explicit" == true ]]; then
  printf 'error: --spec-dir is only for an explicitly approved existing SPEC source mapping: %s\n' \
    "$spec_dir" >&2
  exit 66
fi

if [[ "$initialize_git" == true && ! -e "$target/.git" && ! -L "$target/.git" ]] &&
   ! command -v git >/dev/null 2>&1; then
  printf 'error: --init-git requires git on PATH; no files were written: %s\n' "$target" >&2
  exit 127
fi

template_root="$(cd "$script_dir/../templates" && pwd)"
template_files=(
  "$template_root/AGENTS.md"
  "$template_root/SESSION_STATE.md"
  "$template_root/.gitignore.template"
)
default_directories=(.ai/memory "$spec_dir")

preflight_directory() {
  local dir="$1" relative current component nearest
  local -a components

  if [[ -L "$dir" ]]; then
    printf 'error: scaffold directory is a symlink: %s\n' "$dir" >&2
    return 1
  fi
  if [[ -e "$dir" && ! -d "$dir" ]]; then
    printf 'error: scaffold path is not a directory: %s\n' "$dir" >&2
    return 1
  fi
  if [[ "$dir" != "$target" ]]; then
    relative="${dir#"$target"/}"
    current="$target"
    IFS='/' read -r -a components <<< "$relative"
    for component in "${components[@]}"; do
      [[ -z "$component" ]] && continue
      current="$current/$component"
      if [[ -L "$current" ]]; then
        printf 'error: scaffold parent is a symlink: %s\n' "$current" >&2
        return 1
      fi
      if [[ -e "$current" && ! -d "$current" ]]; then
        printf 'error: scaffold parent is not a directory: %s\n' "$current" >&2
        return 1
      fi
    done
  fi
  nearest="$dir"
  while [[ ! -e "$nearest" && "$nearest" != / ]]; do
    nearest="$(dirname "$nearest")"
  done
  if [[ -L "$nearest" || ! -d "$nearest" || ! -w "$nearest" ]]; then
    printf 'error: scaffold parent is not a writable directory: %s\n' "$nearest" >&2
    return 1
  fi
}

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
      printf 'error: scaffold parent is a symlink: %s\n' "$current" >&2
      return 1
    fi
    if [[ -e "$current" && ! -d "$current" ]]; then
      printf 'error: scaffold parent is not a directory: %s\n' "$current" >&2
      return 1
    fi
    mkdir -p "$current"
  done
}

preflight_directory "$target"
for src in "${template_files[@]}"; do
  rel="${src#"$template_root"/}"
  [[ "$rel" == .gitignore.template ]] && rel=.gitignore
  preflight_directory "$(dirname "$target/$rel")"
done
for directory in "${default_directories[@]}"; do
  preflight_directory "$target/$directory"
done

mkdir -p "$target"
if path_has_symlink "$target"; then
  printf 'error: target or parent became a symlink during setup: %s\n' "$target" >&2
  exit 65
fi
target="$(cd "$target" && pwd -P)"
printf 'target: %s\n' "$target"
if [[ -n "$worktree_root" ]]; then
  printf 'worktree-root: %s\n' "$worktree_root"
  [[ "$nested_target" == true ]] && printf 'nested-target: explicitly allowed after approval\n'
else
  printf 'worktree-root: none\n'
fi

copy_if_missing() {
  local src="$1" dst="$2"
  ensure_parent_dir "$(dirname "$dst")"
  if [[ -e "$dst" || -L "$dst" ]]; then
    printf 'skip: %s\n' "${dst#"$target"/}"
  else
    if [[ "$src" == "$template_root/AGENTS.md" && "$spec_dir" != 'docs/specs' ]]; then
      while IFS= read -r line || [[ -n "$line" ]]; do
        printf '%s\n' "${line//docs\/specs/$spec_dir}"
      done < "$src" > "$dst"
    else
      cp "$src" "$dst"
    fi
    printf 'create: %s\n' "${dst#"$target"/}"
  fi
}

for src in "${template_files[@]}"; do
  rel="${src#"$template_root"/}"
  destination_rel="$rel"
  [[ "$destination_rel" == .gitignore.template ]] && destination_rel=.gitignore
  copy_if_missing "$src" "$target/$destination_rel"
done
for directory in "${default_directories[@]}"; do
  ensure_parent_dir "$target/$directory"
done

if [[ "$initialize_git" == true ]]; then
  if [[ -e "$target/.git" || -L "$target/.git" ]]; then
    printf '%s\n' 'git: preserve existing metadata (not reinitialized)'
  else
    git -C "$target" init --quiet
    printf '%s\n' 'git: initialized local metadata (no commit or remote created)'
  fi
fi

printf '%s\n' 'Project-init minimal control scaffold initialized; substantive work hands off to spec-workflow.'
