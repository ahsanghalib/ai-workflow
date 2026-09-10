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
while IFS= read -r skill_file; do
  skill_dir="${skill_file%/SKILL.md}"
  [[ -s "$skill_file" ]] || {
    printf 'empty skill entrypoint: %s\n' "$skill_file" >&2
    failures=$((failures + 1))
    continue
  }

  while IFS= read -r reference; do
    target="${reference#*](}"
    target="${target%%\)*}"
    case "$target" in
    references/*)
      [[ -f "$skill_dir/$target" ]] || {
        printf 'missing reference: %s -> %s\n' "$skill_file" "$target" >&2
        failures=$((failures + 1))
      }
      ;;
    esac
  done < <(rg -o '\]\(references/[^)]+' "$skill_file" || true)
done < <(find "$skills_root" -mindepth 2 -maxdepth 2 -name SKILL.md -print | sort)

while IFS= read -r reference_file; do
  skill_dir="${reference_file%/references/*}"
  base_name="${reference_file##*/}"
  [[ -f "$skill_dir/SKILL.md" ]] || {
    printf 'orphan reference without entrypoint: %s\n' "$reference_file" >&2
    failures=$((failures + 1))
    continue
  }
  rg -Fq "references/$base_name" "$skill_dir/SKILL.md" || {
    printf 'orphan reference not routed by entrypoint: %s\n' "$reference_file" >&2
    failures=$((failures + 1))
  }
done < <(find "$skills_root" -mindepth 3 -maxdepth 3 -type f -path '*/references/*' -print | sort)

if ((failures)); then
  printf 'validate-skills: %d failure(s)\n' "$failures" >&2
  exit 1
fi

printf '%s\n' 'validate-skills: entrypoints and routed references passed'
