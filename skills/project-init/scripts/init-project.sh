#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'usage: %s [--with-schema] [--only RELPATH]... [--init-git] [--allow-nested] [target-directory]\n' "$0"
  printf 'Copy the project-init documentation scaffold into a target directory.\n'
  printf '%s\n' 'Use --only after reviewing and approving the exact selected output paths.'
  printf '%s\n' 'Use --with-schema only with --only docs/DB_SCHEMA.md after persistence and user-flow review.'
  printf '%s\n' 'Use --init-git only after separate approval for this exact target; it creates no commit or remote.'
  printf '%s\n' 'Use --allow-nested only after separate approval to initialize inside another Git worktree.'
}

include_schema=false
initialize_git=false
allow_nested=false
selected_mode=false
target="$PWD"
selected_paths=()

positional_count=0
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --with-schema)
      include_schema=true
      ;;
    --only)
      if [[ "$#" -lt 2 ]]; then
        usage >&2
        exit 64
      fi
      selected_mode=true
      selected_paths+=("$2")
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

normalize_lexical_path() {
  local raw="$1" component normalized=''
  local -a raw_components parts=()

  IFS='/' read -r -a raw_components <<< "${raw#/}"
  for component in "${raw_components[@]}"; do
    case "$component" in
      ''|.)
        continue
        ;;
      ..)
        if [[ "${#parts[@]}" -gt 0 ]]; then
          parts=("${parts[@]:0:${#parts[@]}-1}")
        fi
        ;;
      *)
        parts+=("$component")
        ;;
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

  [[ "$raw" == "/" ]] && {
    printf '/\n'
    return 0
  }

  if [[ -d "$raw" ]]; then
    cd "$raw" && pwd -P
    return
  fi

  parent="$(dirname "$raw")"
  name="$(basename "$raw")"
  while [[ ! -d "$parent" && "$parent" != "/" ]]; do
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
while [[ ! -d "$worktree_probe" && "$worktree_probe" != "/" ]]; do
  worktree_probe="$(dirname "$worktree_probe")"
done
if command -v git >/dev/null 2>&1 &&
   worktree_root="$(git -C "$worktree_probe" rev-parse --show-toplevel 2>/dev/null)"; then
  worktree_root="$(cd "$worktree_root" && pwd -P)"
  case "$target/" in
    "$worktree_root/")
      nested_target=false
      ;;
    "$worktree_root/"*)
      nested_target=true
      ;;
    *)
      nested_target=false
      ;;
  esac
  if [[ "$nested_target" == true && "$allow_nested" != true ]]; then
    printf 'error: target is nested in another Git worktree; require --allow-nested after approval: %s\n' "$target" >&2
    exit 67
  fi
else
  nested_target=false
fi

if [[ "$initialize_git" == true && ! -e "$target/.git" && ! -L "$target/.git" ]] &&
   ! command -v git >/dev/null 2>&1; then
  printf 'error: --init-git requires git on PATH; no files were written: %s\n' "$target" >&2
  exit 127
fi

template_root="$(cd "$script_dir/../templates" && pwd)"

normalize_selection() {
  local raw="$1" component normalized=''
  local -a components

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
  [[ "$normalized" == ".gitignore" ]] && normalized='.gitignore.template'
  printf '%s\n' "$normalized"
}

normalized_paths=()
if [[ "$selected_mode" == true ]]; then
  if [[ "${#selected_paths[@]}" -eq 0 ]]; then
    printf 'error: --only requires at least one relative path\n' >&2
    exit 64
  fi
  for selected_path in "${selected_paths[@]}"; do
    if ! normalized_path="$(normalize_selection "$selected_path")"; then
      printf 'error: invalid --only path; use a relative path without .. or control characters: %s\n' "$selected_path" >&2
      exit 64
    fi
    normalized_paths+=("$normalized_path")
  done
  selected_paths=("${normalized_paths[@]}")
fi

if [[ "$include_schema" == true ]]; then
  if [[ "$selected_mode" != true ]]; then
    printf 'error: schema creation is a separate reviewed step; select --only docs/DB_SCHEMA.md\n' >&2
    exit 64
  fi
  schema_selected=false
  for selected_path in "${selected_paths[@]}"; do
    [[ "$selected_path" == 'docs/DB_SCHEMA.md' ]] && schema_selected=true
  done
  if [[ "$schema_selected" != true || "${#selected_paths[@]}" -ne 1 ]]; then
    printf 'error: --with-schema requires the separate exact selection of docs/DB_SCHEMA.md\n' >&2
    exit 64
  fi
fi

if [[ "$selected_mode" == true ]]; then
  for selected_path in "${selected_paths[@]}"; do
    if [[ "$selected_path" == 'docs/DB_SCHEMA.md' && "$include_schema" != true ]]; then
      printf 'error: docs/DB_SCHEMA.md requires --with-schema after separate schema approval\n' >&2
      exit 64
    fi
  done
fi

target_entries=()
if [[ -d "$target" ]]; then
  shopt -s nullglob dotglob
  target_entries=("$target"/*)
  shopt -u nullglob dotglob
fi
new_project=true
for entry in "${target_entries[@]}"; do
  [[ "$(basename "$entry")" == '.git' ]] || new_project=false
done
template_list="$(mktemp)"
cleanup() {
  rm -f "$template_list"
}
trap cleanup EXIT
if ! find "$template_root" -type f -print0 > "$template_list"; then
  printf 'error: could not inspect bundled templates; no files were written\n' >&2
  exit 1
fi

template_files=()
while IFS= read -r -d '' src; do
  template_files+=("$src")
done < "$template_list"

selection_matches() {
  local rel="$1" selected_path
  if [[ "$selected_mode" != true ]]; then
    case "$rel" in
      README.md|AGENTS.md|MASTER_PLAN.md|SESSION_STATE.md|docs/PROJECT_ARCHITECTURE.md|docs/plans/INDEX.md|docs/rules/GENERAL.md|docs/templates/*|.gitignore.template)
        return 0
        ;;
      *)
        return 1
        ;;
    esac
  fi
  for selected_path in "${selected_paths[@]}"; do
    [[ "$rel" == "$selected_path" || "$rel" == "$selected_path/"* ]] && return 0
  done
  return 1
}

selection_matches_directory() {
  local directory="$1" selected_path
  if [[ "$selected_mode" != true ]]; then
    case "$directory" in
      docs/specs|docs/plans|docs/reviews)
        return 0
        ;;
      *)
        return 1
        ;;
    esac
  fi
  for selected_path in "${selected_paths[@]}"; do
    [[ "$selected_path" == "$directory" || "$selected_path" == "$directory/"* ]] && return 0
  done
  return 1
}

scaffold_path_is_known() {
  local relative="$1" src rel

  [[ "$relative" == .git || "$relative" == .git/* ]] && return 0
  case "$relative" in
    docs/specs|docs/plans|docs/reviews)
      return 0
      ;;
  esac
  for src in "${template_files[@]}"; do
    rel="${src#"$template_root"/}"
    [[ "$rel" == '.gitignore.template' ]] && rel='.gitignore'
    [[ "$relative" == "$rel" ]] && return 0
    if [[ -d "$target/$relative" && "$rel" == "$relative/"* ]]; then
      return 0
    fi
  done
  return 1
}

scaffold_contains_only_known_outputs() {
  local entry relative
  [[ -d "$target" ]] || return 0
  while IFS= read -r -d '' entry; do
    relative="${entry#"$target"/}"
    if ! scaffold_path_is_known "$relative"; then
      return 1
    fi
  done < <(find -P "$target" -mindepth 1 \( -path "$target/.git" -o -path "$target/.git/*" \) -prune -o -print0)
  return 0
}

base_scaffold_is_complete() {
  local src rel destination_rel directory
  for src in "${template_files[@]}"; do
    rel="${src#"$template_root"/}"
    if ! selection_matches "$rel"; then
      continue
    fi
    destination_rel="$rel"
    [[ "$destination_rel" == '.gitignore.template' ]] && destination_rel='.gitignore'
    [[ -e "$target/$destination_rel" || -L "$target/$destination_rel" ]] || return 1
  done
  for directory in docs/specs docs/plans docs/reviews; do
    [[ -d "$target/$directory" && ! -L "$target/$directory" ]] || return 1
  done
  return 0
}

if [[ "$selected_mode" != true && "$new_project" != true ]]; then
  if base_scaffold_is_complete && scaffold_contains_only_known_outputs; then
    if [[ "$initialize_git" != true || -e "$target/.git" || -L "$target/.git" ]]; then
      printf 'target: %s\n' "$target"
      printf 'no-op: project-init base scaffold already exists; no files written\n'
      exit 0
    fi
  else
    printf 'error: target is an existing project; review and select outputs with --only, no files were written: %s\n' "$target" >&2
    exit 66
  fi
fi

if [[ "$selected_mode" == true ]]; then
  for selected_path in "${selected_paths[@]}"; do
    selection_found=false
    case "$selected_path" in
      docs/specs|docs/plans|docs/reviews)
        selection_found=true
        ;;
    esac
    if [[ "$selection_found" != true ]]; then
      for src in "${template_files[@]}"; do
        rel="${src#"$template_root"/}"
        if [[ "$rel" == "$selected_path" || "$rel" == "$selected_path/"* ]]; then
          selection_found=true
          break
        fi
      done
    fi
    if [[ "$selection_found" != true ]]; then
      printf 'error: --only path is not provided by the bundled scaffold: %s\n' "$selected_path" >&2
      exit 66
    fi
  done
fi

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
  while [[ ! -e "$nearest" && "$nearest" != "/" ]]; do
    nearest="$(dirname "$nearest")"
  done
  if [[ -L "$nearest" || ! -d "$nearest" || ! -w "$nearest" ]]; then
    printf 'error: scaffold parent is not a writable directory: %s\n' "$nearest" >&2
    return 1
  fi
}

preflight_scaffold() {
  local src rel destination_rel directory

  preflight_directory "$target"
  for src in "${template_files[@]}"; do
    rel="${src#"$template_root"/}"
    if [[ "$rel" == 'docs/DB_SCHEMA.md' && "$include_schema" != true ]]; then
      continue
    fi
    if ! selection_matches "$rel"; then
      continue
    fi
    destination_rel="$rel"
    [[ "$destination_rel" == '.gitignore.template' ]] && destination_rel='.gitignore'
    directory="$(dirname "$target/$destination_rel")"
    preflight_directory "$directory"
  done

  for directory in docs/specs docs/plans docs/reviews; do
    if selection_matches_directory "$directory"; then
      preflight_directory "$target/$directory"
    fi
  done
}

preflight_scaffold
if ! mkdir -p "$target"; then
  printf 'error: could not create target directory: %s\n' "$target" >&2
  exit 1
fi
# The helper rejects static symlinks and rechecks after directory creation. It
# does not claim atomic protection from a hostile concurrent path replacement.
if path_has_symlink "$target"; then
  printf 'error: target or parent became a symlink during setup: %s\n' "$target" >&2
  exit 65
fi
target="$(cd "$target" && pwd -P)"
printf 'target: %s\n' "$target"

if [[ -n "$worktree_root" ]]; then
  printf 'worktree-root: %s\n' "$worktree_root"
  if [[ "$nested_target" == true ]]; then
    printf 'nested-target: explicitly allowed after approval\n'
  else
    printf 'nested-target: no override required\n'
  fi
else
  printf 'worktree-root: none\n'
fi

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
    if ! mkdir -p "$current"; then
      printf 'error: could not create scaffold directory: %s\n' "$current" >&2
      return 1
    fi
  done
}

copy_if_missing() {
  local src="$1" dst="$2"
  if ! ensure_parent_dir "$(dirname "$dst")"; then
    return 1
  fi
  if [[ -e "$dst" || -L "$dst" ]]; then
    echo "skip: ${dst#"$target"/}"
  elif ! cp "$src" "$dst"; then
    printf 'error: could not copy template: %s -> %s\n' "$src" "$dst" >&2
    return 1
  else
    echo "create: ${dst#"$target"/}"
  fi
}

for src in "${template_files[@]}"; do
  rel="${src#"$template_root"/}"
  if [[ "$rel" == 'docs/DB_SCHEMA.md' && "$include_schema" != true ]]; then
    echo "skip: $rel (optional schema not selected)"
    continue
  fi
  if ! selection_matches "$rel"; then
    continue
  fi
  destination_rel="$rel"
  [[ "$destination_rel" == '.gitignore.template' ]] && destination_rel='.gitignore'
  if ! copy_if_missing "$src" "$target/$destination_rel"; then
    exit 1
  fi
done

for directory in docs/specs docs/plans docs/reviews; do
  if selection_matches_directory "$directory" && ! ensure_parent_dir "$target/$directory"; then
    exit 1
  fi
done

if [[ "$initialize_git" == true ]]; then
  if [[ -e "$target/.git" || -L "$target/.git" ]]; then
    echo 'git: preserve existing metadata (not reinitialized)'
  elif git -C "$target" init --quiet; then
    echo 'git: initialized local metadata (no commit or remote created)'
  else
    echo "error: could not initialize local Git metadata: $target" >&2
    exit 1
  fi
fi

echo "Project documentation scaffold initialized. Fill MASTER_PLAN.md before asking AI to refine project-specific docs."
