#!/usr/bin/env bash
set -euo pipefail

die() {
	printf 'package-skills: %s\n' "$*" >&2
	exit 1
}

usage() {
	cat <<'EOF'
Usage: scripts/package-skills.sh [--clean]

Package the curated ChatGPT web bundle into zip/<skill-name>.zip.

  --clean  Remove existing zip archives in zip/ before packaging.
EOF
}

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
repo_root="$(cd -- "$script_dir/.." && pwd -P)"
skills_root="$repo_root/skills"
output_dir="$repo_root/zip"
clean_output=false

while (($# > 0)); do
	case "$1" in
		--clean)
			clean_output=true
			shift
			;;
		-h|--help)
			usage
			exit 0
			;;
		*)
			die "unknown option: $1"
			;;
	esac
done

# These workflows can operate from user-supplied content and connected ChatGPT
# apps. Repository, terminal, Codex-runtime, and local-browser workflows stay
# out of the web bundle. Add a skill here only after checking that boundary.
web_chat_skills=(
	brainstorming
	brand-guidelines
	copywriting
	founder-decision
	humanizer
	linkedin-engagement
	linkedin-lead-followup
	linkedin-post
	linkedin-publish
	linkedin-visual
	linkedin-workspace
	product-discovery
	research-brief
	social-content
)

[[ -d "$skills_root" ]] || die "missing skills directory: $skills_root"
command -v zip >/dev/null 2>&1 || die 'zip command is required'

mkdir -p -- "$output_dir"
if [[ "$clean_output" == true ]]; then
	find "$output_dir" -mindepth 1 -maxdepth 1 -type f -name '*.zip' -delete
fi
temp_root="$(mktemp -d "${TMPDIR:-/tmp}/package-skills.XXXXXX")"
trap 'rm -rf -- "$temp_root"' EXIT

skill_count=0

for skill_name in "${web_chat_skills[@]}"; do
	skill_dir="$skills_root/$skill_name"
	skill_file="$skill_dir/SKILL.md"
	[[ -f "$skill_file" ]] || die "web-chat skill is missing: $skill_name"
	archive_path="$temp_root/$skill_name.zip"
	files=()

	while IFS= read -r -d '' file; do
		files+=("${file#"$skills_root/"}")
	done < <(
		find "$skill_dir" -type f \
			! -name '.DS_Store' \
			! -name '*.pyc' \
			! -path '*/__pycache__/*' \
			-print0 | sort -z
	)

	((${#files[@]} > 0)) || die "skill has no packageable files: $skill_name"

	(
		cd -- "$skills_root"
		zip -q -X "$archive_path" "${files[@]}"
	)
	mv -- "$archive_path" "$output_dir/$skill_name.zip"
	printf 'packaged %s (%d files) -> %s\n' \
		"$skill_name" "${#files[@]}" "$output_dir/$skill_name.zip"
	skill_count=$((skill_count + 1))
done

((skill_count > 0)) || die 'web-chat skill list is empty'
printf 'packaged %d ChatGPT web skills into %s\n' "$skill_count" "$output_dir"
