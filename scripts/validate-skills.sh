#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
repo_root="$(git -C "$script_dir/.." rev-parse --show-toplevel 2>/dev/null)" || {
	printf '%s\n' 'validate-skills: script must be inside a Git worktree' >&2
	exit 1
}

skills_root="$repo_root/skills"
if [[ ! -d "$skills_root" ]]; then
	printf 'validate-skills: missing repository skills directory: %s\n' "$skills_root" >&2
	exit 1
fi

failures=0
temp_root="$(mktemp -d "${TMPDIR:-/tmp}/validate-skills.XXXXXX")" || {
	printf '%s\n' 'validate-skills: could not create temporary directory' >&2
	exit 1
}
trap 'rm -rf -- "$temp_root"' EXIT

validate_frontmatter_shape() {
	local skill_file="$1"

	awk '
    BEGIN {
      in_frontmatter = 0
      closed = 0
      block_key = ""
    }
    NR == 1 {
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
    /^[[:space:]]*$/ || /^[[:space:]]*#/ {
      next
    }
    /^[[:space:]]/ {
      if (block_key == "") {
        print "indented frontmatter line has no mapping parent: " FILENAME > "/dev/stderr"
        exit 1
      }
      if (block_key == "metadata" &&
          $0 !~ /^[[:space:]]+[A-Za-z0-9_-]+:[[:space:]]*(.*)$/) {
        print "invalid metadata mapping line: " FILENAME > "/dev/stderr"
        exit 1
      }
      next
    }
    $0 !~ /^[A-Za-z][A-Za-z0-9_-]*:[[:space:]]*(.*)$/ {
      print "invalid frontmatter mapping line: " FILENAME > "/dev/stderr"
      exit 1
    }
    {
      key = $0
      sub(/:.*/, "", key)
      value = $0
      sub(/^[^:]*:[[:space:]]*/, "", value)
      if (value ~ /^[\[{]/) {
        print "flow collections are not supported in frontmatter: " FILENAME > "/dev/stderr"
        exit 1
      }
      if ((value ~ /^\047/ && value !~ /\047[[:space:]]*$/) ||
          (value ~ /^"/ && value !~ /"[[:space:]]*$/)) {
        print "unclosed frontmatter scalar: " FILENAME > "/dev/stderr"
        exit 1
      }
      if (value ~ /^[>|][+-]?[[:space:]]*$/) {
        block_key = key
      } else if (key == "metadata" && value == "") {
        block_key = key
      } else {
        block_key = ""
      }
    }
    END {
      if (!closed) {
        print "frontmatter is not closed: " FILENAME > "/dev/stderr"
        exit 1
      }
    }
  ' "$skill_file"
}

validate_frontmatter() {
	local skill_file="$1"
	local skill_name="$2"
	local metadata declared_name description_length

	validate_frontmatter_shape "$skill_file" || return 1

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

	IFS=$'\t' read -r declared_name description_length <<<"$metadata"

	if [[ "$declared_name" != "$skill_name" ]]; then
		printf 'frontmatter name does not match directory: %s -> %s\n' \
			"$skill_file" "$declared_name" >&2
		return 1
	fi
	if ((${#declared_name} < 1 || ${#declared_name} > 64)); then
		printf 'skill name must be 1-64 characters: %s\n' "$skill_file" >&2
		return 1
	fi
	if [[ ! "$declared_name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
		printf 'skill name must use lowercase letters, numbers, and single hyphens: %s\n' \
			"$skill_file" >&2
		return 1
	fi
	if ((description_length < 1 || description_length > 1024)); then
		printf 'skill description must be 1-1024 characters: %s\n' "$skill_file" >&2
		return 1
	fi
}

extract_reference_target() {
	local link="$1"
	local target suffix

	target="${link#*](}"
	target="${target%)}"
	target="${target#"${target%%[![:space:]]*}"}"
	if [[ "$target" == '<'*'>'* ]]; then
		target="${target#<}"
		target="${target%%>*}"
	else
		target="${target%%[[:space:]]*}"
	fi
	suffix=""
	while [[ -n "$target" ]]; do
		case "${target:0:1}" in
		\\)
			suffix+="${target:0:2}"
			target="${target:2}"
			;;
		\?)
			break
			;;
		\#)
			break
			;;
		*)
			suffix+="${target:0:1}"
			target="${target:1}"
			;;
		esac
	done
	target="$suffix"
	target="$(decode_markdown_escapes "$target")"
	printf '%s\n' "$target"
}

decode_markdown_escapes() {
	local value="$1"
	local result=""
	local i char next

	for ((i = 0; i < ${#value}; i++)); do
		char="${value:i:1}"
		if [[ "$char" == \\ && $((i + 1)) -lt ${#value} ]]; then
			next="${value:i+1:1}"
			if [[ "$next" == [[:punct:]] ]]; then
				result+="$next"
				i=$((i + 1))
				continue
			fi
		fi
		result+="$char"
	done

	printf '%s\n' "$result"
}

extract_reference_links() {
	awk '
  {
    text = text (NR > 1 ? "\n" : "") $0
  }
  END {
    text_length = length(text)
    for (i = 1; i < text_length; i++) {
      if (substr(text, i, 2) != "](") {
        continue
      }
      depth = 1
      angle = 0
      escaped = 0
      for (j = i + 2; j <= text_length; j++) {
        character = substr(text, j, 1)
        if (escaped) {
          escaped = 0
          continue
        }
        if (character == "\\") {
          escaped = 1
          continue
        }
        if (character == "<" && depth == 1) {
          angle = 1
          continue
        }
        if (character == ">" && angle) {
          angle = 0
          continue
        }
        if (!angle && character == "(") {
          depth++
        } else if (!angle && character == ")") {
          depth--
          if (depth == 0) {
            print substr(text, i, j - i + 1)
            i = j
            break
          }
        }
      }
    }
  }
  ' "$1"
}

validate_reference_target() {
	local skill_file="$1"
	local target="$2"
	local skill_dir="${skill_file%/SKILL.md}"
	local relative_path candidate component
	local -a components=()

	case "$target" in
	references/*) ;;
	*) return 0 ;;
	esac

	relative_path="${target#references/}"
	[[ -n "$relative_path" ]] || {
		printf 'empty reference target: %s\n' "$skill_file" >&2
		return 1
	}

	candidate="$skill_dir/references"
	if [[ -L "$candidate" ]]; then
		printf 'symlinked references directory is not allowed: %s\n' "$candidate" >&2
		return 1
	fi

	IFS=/ read -r -a components <<<"$relative_path"
	for component in "${components[@]}"; do
		if [[ -z "$component" || "$component" == . || "$component" == .. ]]; then
			printf 'unsafe reference path: %s -> %s\n' "$skill_file" "$target" >&2
			return 1
		fi
		candidate="$candidate/$component"
		if [[ -L "$candidate" ]]; then
			printf 'symlinked reference is not allowed: %s\n' "$candidate" >&2
			return 1
		fi
	done

	[[ -f "$candidate" ]] || {
		printf 'missing reference: %s -> %s\n' "$skill_file" "$target" >&2
		return 1
	}
}

validate_skill_references() {
	local skill_file="$1"
	local link target links
	local status=0

	if ! links="$(extract_reference_links "$skill_file")"; then
		return 1
	fi
	while IFS= read -r link; do
		target="$(extract_reference_target "$link")"
		if ! validate_reference_target "$skill_file" "$target"; then
			status=1
		fi
	done <<<"$links"

	return "$status"
}

reference_is_routed() {
	local skill_file="$1"
	local expected_target="$2"
	local link target links

	if ! links="$(extract_reference_links "$skill_file")"; then
		return 1
	fi
	while IFS= read -r link; do
		target="$(extract_reference_target "$link")"
		[[ "$target" == "$expected_target" ]] && return 0
	done <<<"$links"

	return 1
}

skill_files_list="$temp_root/skill-files"
if ! find "$skills_root" -mindepth 2 -maxdepth 2 -name SKILL.md -print0 >"$skill_files_list"; then
	printf 'validate-skills: could not scan skill entrypoints\n' >&2
	exit 1
fi

reference_files_list="$temp_root/reference-files"
: >"$reference_files_list"
while IFS= read -r -d '' skill_file; do
	skill_dir="${skill_file%/SKILL.md}"
	references_dir="$skill_dir/references"
	[[ -d "$references_dir" && ! -L "$references_dir" ]] || continue
	if ! find "$references_dir" -mindepth 1 \
		\( -type f -o -type l \) -print0 >>"$reference_files_list"; then
		printf 'validate-skills: could not scan skill references\n' >&2
		exit 1
	fi
done <"$skill_files_list"

skill_dirs_list="$temp_root/skill-directories"
if ! find "$skills_root" -mindepth 1 -maxdepth 1 -type l -print0 >"$skill_dirs_list"; then
	printf 'validate-skills: could not scan skill directories\n' >&2
	exit 1
fi
while IFS= read -r -d '' skill_dir; do
	printf 'symlinked skill directory is not allowed: %s\n' "$skill_dir" >&2
	failures=$((failures + 1))
done <"$skill_dirs_list"

while IFS= read -r -d '' skill_file; do
	skill_dir="${skill_file%/SKILL.md}"
	[[ -s "$skill_file" ]] || {
		printf 'empty skill entrypoint: %s\n' "$skill_file" >&2
		failures=$((failures + 1))
		continue
	}
	if [[ -L "$skill_file" ]]; then
		printf 'symlinked skill entrypoint is not allowed: %s\n' "$skill_file" >&2
		failures=$((failures + 1))
		continue
	fi
	if [[ -L "$skill_dir/references" ]]; then
		printf 'symlinked references directory is not allowed: %s\n' "$skill_dir/references" >&2
		failures=$((failures + 1))
	fi
	skill_name="${skill_dir##*/}"
	validate_frontmatter "$skill_file" "$skill_name" || failures=$((failures + 1))
	validate_skill_references "$skill_file" || failures=$((failures + 1))
done <"$skill_files_list"

while IFS= read -r -d '' reference_file; do
	relative_reference="${reference_file#"$skills_root/"}"
	skill_name="${relative_reference%%/*}"
	skill_dir="$skills_root/$skill_name"
	if [[ -L "$reference_file" ]]; then
		printf 'symlinked reference is not allowed: %s\n' "$reference_file" >&2
		failures=$((failures + 1))
		continue
	fi
	[[ -f "$skill_dir/SKILL.md" ]] || {
		printf 'orphan reference without entrypoint: %s\n' "$reference_file" >&2
		failures=$((failures + 1))
		continue
	}
	reference_target="${reference_file#"$skill_dir/"}"
	reference_is_routed "$skill_dir/SKILL.md" "$reference_target" || {
		printf 'orphan reference not routed by entrypoint: %s\n' "$reference_file" >&2
		failures=$((failures + 1))
	}
done <"$reference_files_list"

if ((failures)); then
	printf 'validate-skills: %d failure(s)\n' "$failures" >&2
	exit 1
fi

printf '%s\n' 'validate-skills: entrypoints and routed references passed'
