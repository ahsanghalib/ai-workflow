#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
repo_root="$(git -C "$script_dir" rev-parse --show-toplevel 2>/dev/null)" || {
  printf '%s\n' 'validate-skills: script must be inside a Git worktree' >&2
  exit 1
}

if [[ "$repo_root" != "$script_dir" ]]; then
  printf '%s\n' 'validate-skills: script must be at the repository root' >&2
  exit 1
fi

skills_root="$repo_root/skills"
if [[ ! -d "$skills_root" ]]; then
  printf 'validate-skills: missing repository skills directory: %s\n' "$skills_root" >&2
  exit 1
fi

failures=0

validate_frontmatter() {
  local skill_file="$1"
  local skill_name="$2"
  local metadata declared_name description_length

  if ! metadata="$(awk '
    BEGIN {
      in_frontmatter = 0
      closed = 0
      description_mode = ""
      description = ""
    }
    NR == 1 {
      if ($0 != "---") {
        print "frontmatter must start with ---: " FILENAME > "/dev/stderr"
        exit 1
      }
      in_frontmatter = 1
      next
    }
    in_frontmatter && $0 == "---" {
      closed = 1
      in_frontmatter = 0
      next
    }
    !in_frontmatter {
      next
    }
    $0 ~ /^name:[[:space:]]*/ {
      declared_name = $0
      sub(/^name:[[:space:]]*/, "", declared_name)
      next
    }
    $0 ~ /^description:[[:space:]]*/ {
      value = $0
      sub(/^description:[[:space:]]*/, "", value)
      if (value ~ /^>[+-]?$/) {
        description_mode = "folded"
        next
      }
      if (value ~ /^\|[+-]?$/) {
        description_mode = "literal"
        next
      }
      description = value
      description_mode = ""
      next
    }
    description_mode != "" && $0 ~ /^[[:space:]]/ {
      value = $0
      sub(/^[[:space:]]+/, "", value)
      if (description_mode == "folded") {
        if (value != "") {
          description = description " " value
        }
      } else {
        description = description "\n" value
      }
      next
    }
    description_mode = ""
    END {
      if (!closed) {
        print "frontmatter is not closed: " FILENAME > "/dev/stderr"
        exit 1
      }
      if (declared_name == "") {
        print "frontmatter is missing name: " FILENAME > "/dev/stderr"
        exit 1
      }
      if (description == "") {
        print "frontmatter is missing description: " FILENAME > "/dev/stderr"
        exit 1
      }
      print declared_name "\t" length(description)
    }
  ' "$skill_file")"; then
    return 1
  fi

  IFS=$'\t' read -r declared_name description_length <<< "$metadata"

  if [[ "$declared_name" != "$skill_name" ]]; then
    printf 'frontmatter name does not match directory: %s -> %s\n' \
      "$skill_file" "$declared_name" >&2
    return 1
  fi
  if (( ${#declared_name} < 1 || ${#declared_name} > 64 )); then
    printf 'skill name must be 1-64 characters: %s\n' "$skill_file" >&2
    return 1
  fi
  if [[ ! "$declared_name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    printf 'skill name must use lowercase letters, numbers, and single hyphens: %s\n' \
      "$skill_file" >&2
    return 1
  fi
  if (( description_length < 1 || description_length > 1024 )); then
    printf 'skill description must be 1-1024 characters: %s\n' "$skill_file" >&2
    return 1
  fi
}

while IFS= read -r skill_file; do
  skill_dir="${skill_file%/SKILL.md}"
  [[ -s "$skill_file" ]] || {
    printf 'empty skill entrypoint: %s\n' "$skill_file" >&2
    failures=$((failures + 1))
    continue
  }
  skill_name="${skill_dir##*/}"
  validate_frontmatter "$skill_file" "$skill_name" || failures=$((failures + 1))

  while IFS= read -r reference; do
    target="${reference#*](}"
    target="${target%%\)*}"
    target="${target%%#*}"
    case "$target" in
    references/*)
      [[ -f "$skill_dir/$target" ]] || {
        printf 'missing reference: %s -> %s\n' "$skill_file" "$target" >&2
        failures=$((failures + 1))
      }
      ;;
    esac
  done < <(grep -oE '\]\(references/[^)]+' "$skill_file" || true)
done < <(find "$skills_root" -mindepth 2 -maxdepth 2 -name SKILL.md -print | sort)

while IFS= read -r reference_file; do
  skill_dir="${reference_file%/references/*}"
  base_name="${reference_file##*/}"
  [[ -f "$skill_dir/SKILL.md" ]] || {
    printf 'orphan reference without entrypoint: %s\n' "$reference_file" >&2
    failures=$((failures + 1))
    continue
  }
  grep -Fq "references/$base_name" "$skill_dir/SKILL.md" || {
    printf 'orphan reference not routed by entrypoint: %s\n' "$reference_file" >&2
    failures=$((failures + 1))
  }
done < <(find "$skills_root" -mindepth 3 -maxdepth 3 -type f -path '*/references/*' -print | sort)

if ((failures)); then
  printf 'validate-skills: %d failure(s)\n' "$failures" >&2
  exit 1
fi

printf '%s\n' 'validate-skills: entrypoints and routed references passed'
