#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
repo_root="$(cd -- "$script_dir/.." && pwd -P)"
temp_root="$(mktemp -d "$repo_root/.package-skills-test.XXXXXX")"
cleanup() {
	python3 -c 'import shutil, sys; shutil.rmtree(sys.argv[1])' "$temp_root"
}
trap cleanup EXIT

fixture_repo="$temp_root/repo"
mkdir -p -- "$fixture_repo/scripts" "$fixture_repo/skills"
cp -- "$repo_root/scripts/package-skills.sh" "$fixture_repo/scripts/package-skills.sh"
git -C "$fixture_repo" init -q

skills=(
	brainstorming brand-guidelines copywriting founder-decision humanizer
	linkedin-comments linkedin-hiring linkedin-lead-followup linkedin-post
	linkedin-visual linkedin-workspace product-discovery research-brief social-content
)
for skill in "${skills[@]}"; do
	skill_dir="$fixture_repo/skills/$skill"
	mkdir -p -- "$skill_dir/references/nested" "$skill_dir/assets"
	printf 'name: %s\n' "$skill" > "$skill_dir/SKILL.md"
	printf 'reference for %s\n' "$skill" > "$skill_dir/references/nested/guide.md"
	printf 'asset for %s\n' "$skill" > "$skill_dir/assets/template.txt"
	printf 'ignored\n' > "$skill_dir/.DS_Store"
	printf 'ignored\n' > "$skill_dir/cache.pyc"
	mkdir -p -- "$skill_dir/__pycache__"
	printf 'ignored\n' > "$skill_dir/__pycache__/module.pyc"
done

bash "$fixture_repo/scripts/package-skills.sh" > "$temp_root/package.log"

for skill in "${skills[@]}"; do
	archive="$fixture_repo/zip/$skill.zip"
	test -f "$archive"
	unzip -Z1 "$archive" | LC_ALL=C sort > "$temp_root/archive-files"
	(
		cd -- "$fixture_repo/skills"
		find "$skill" -type f \
			! -name '.DS_Store' \
			! -name '*.pyc' \
			! -path '*/__pycache__/*' \
			-print | LC_ALL=C sort
	) > "$temp_root/expected-files"
	if ! diff -u "$temp_root/expected-files" "$temp_root/archive-files"; then
		printf 'archive contents differ for %s\n' "$skill" >&2
		exit 1
	fi
	while IFS= read -r entry; do
		cmp -- "$fixture_repo/skills/$entry" <(unzip -p "$archive" "$entry")
	done < "$temp_root/expected-files"
	if unzip -Z1 "$archive" | rg -q '(^|/)(\.DS_Store|[^/]+\.pyc)$|(^|/)__pycache__(/|$)'; then
		printf 'archive contains an excluded cache file for %s\n' "$skill" >&2
		exit 1
	fi
done

archive_count="$(find "$fixture_repo/zip" -maxdepth 1 -type f -name '*.zip' | wc -l)"
test "$archive_count" -eq "${#skills[@]}"
printf 'ok: package archive completeness (%d skills)\n' "$archive_count"
