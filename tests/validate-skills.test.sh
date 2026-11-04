#!/usr/bin/env bash
set -euo pipefail

test_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
repo_root=$(cd -- "$test_dir/.." && pwd -P)
validator="$repo_root/scripts/validate-skills.sh"
real_find=$(command -v find)
temp_root=$(mktemp -d "$repo_root/.validate-skills-test.XXXXXX")
trap 'rm -rf -- "$temp_root"' EXIT

fail() {
	printf 'not ok: %s\n' "$1" >&2
	exit 1
}

run_case() {
	local name=$1
	local expected=$2
	local skill_body=$3
	local case_root="$temp_root/$name"
	local output status

	mkdir -p "$case_root/scripts" "$case_root/skills/example/references"
	cp "$validator" "$case_root/scripts/validate-skills.sh"
	chmod 755 "$case_root/scripts/validate-skills.sh"
	git init --quiet "$case_root"
	printf '%s\n\n[Guide](references/guide.md)\n' "$skill_body" >"$case_root/skills/example/SKILL.md"
	printf 'reference\n' >"$case_root/skills/example/references/guide.md"

	set +e
	output=$(
		cd "$case_root"
		PATH="$case_root/bin:$PATH" bash scripts/validate-skills.sh 2>&1
	)
	status=$?
	set -e

	if [[ "$expected" == pass && "$status" -ne 0 ]]; then
		printf '%s\n' "$output" >&2
		fail "$name unexpectedly failed"
	fi
	if [[ "$expected" == fail && "$status" -eq 0 ]]; then
		fail "$name unexpectedly passed"
	fi
}

run_case valid pass $'---\nname: example\ndescription: A valid skill.\nlicense: MIT\n---\n\n[Guide](references/guide.md "Read this")\n[Section](references/guide.md#section "Read the section")\n'

run_case malformed-frontmatter fail $'---\nname: example\ndescription: A valid skill.\nmetadata: ["unterminated]\n---\n'
run_case supported-spec-fields pass $'---\nname: example\ndescription: A valid skill.\ncompatibility: Requires an available browser adapter.\nallowed-tools: Read\nmetadata:\n  owner: example-team\n  version: "1.0"\n---\n\n[Guide](references/guide.md)\n'
run_case unsupported-top-level-key fail $'---\nname: example\ndescription: A valid skill.\nunknown-field: value\n---\n'
run_case numeric-metadata fail $'---\nname: example\ndescription: A valid skill.\nmetadata:\n  version: 2\n---\n'
run_case boolean-metadata fail $'---\nname: example\ndescription: A valid skill.\nmetadata:\n  enabled: true\n---\n'
run_case empty-metadata-value fail $'---\nname: example\ndescription: A valid skill.\nmetadata:\n  owner:\n---\n'

orphan_case="$temp_root/orphan-reference"
mkdir -p "$orphan_case/scripts" "$orphan_case/skills/example/references/nested"
cp "$validator" "$orphan_case/scripts/validate-skills.sh"
chmod 755 "$orphan_case/scripts/validate-skills.sh"
git init --quiet "$orphan_case"
printf '%s\n' $'---\nname: example\ndescription: A valid skill.\n---\n\n[Guide](references/guide.md)\n' >"$orphan_case/skills/example/SKILL.md"
printf 'reference\n' >"$orphan_case/skills/example/references/guide.md"
printf 'orphan\n' >"$orphan_case/skills/example/references/nested/orphan.md"
if (cd "$orphan_case" && bash scripts/validate-skills.sh >/dev/null 2>&1); then
	fail 'orphan reference unexpectedly passed'
fi

nested_reference_case="$temp_root/nested-reference"
mkdir -p "$nested_reference_case/scripts" "$nested_reference_case/skills/example/references/nested/references"
cp "$validator" "$nested_reference_case/scripts/validate-skills.sh"
chmod 755 "$nested_reference_case/scripts/validate-skills.sh"
git init --quiet "$nested_reference_case"
printf '%s\n' $'---\nname: example\ndescription: A valid skill.\n---\n\n[Guide](references/nested/references/guide.md)\n' >"$nested_reference_case/skills/example/SKILL.md"
printf 'reference\n' >"$nested_reference_case/skills/example/references/nested/references/guide.md"
if ! (cd "$nested_reference_case" && bash scripts/validate-skills.sh >/dev/null 2>&1); then
	fail 'valid nested reference unexpectedly failed'
fi

parentheses_case="$temp_root/parentheses-reference"
mkdir -p "$parentheses_case/scripts" "$parentheses_case/skills/example/references"
cp "$validator" "$parentheses_case/scripts/validate-skills.sh"
chmod 755 "$parentheses_case/scripts/validate-skills.sh"
git init --quiet "$parentheses_case"
printf '%s\n' $'---\nname: example\ndescription: A valid skill.\n---\n\n[Guide](<references/a(b).md>)\n' >"$parentheses_case/skills/example/SKILL.md"
printf 'reference\n' >"$parentheses_case/skills/example/references/a(b).md"
if ! (cd "$parentheses_case" && bash scripts/validate-skills.sh >/dev/null 2>&1); then
	fail 'valid parenthesized reference unexpectedly failed'
fi

escaped_case="$temp_root/escaped-reference"
mkdir -p "$escaped_case/scripts" "$escaped_case/skills/example/references"
cp "$validator" "$escaped_case/scripts/validate-skills.sh"
chmod 755 "$escaped_case/scripts/validate-skills.sh"
git init --quiet "$escaped_case"
printf '%s\n' $'---\nname: example\ndescription: A valid skill.\n---\n\n[Guide](references/a\(b\).md)\n' >"$escaped_case/skills/example/SKILL.md"
printf 'reference\n' >"$escaped_case/skills/example/references/a(b).md"
if ! (cd "$escaped_case" && bash scripts/validate-skills.sh >/dev/null 2>&1); then
	fail 'valid escaped reference unexpectedly failed'
fi

multiline_case="$temp_root/multiline-reference"
mkdir -p "$multiline_case/scripts" "$multiline_case/skills/example/references"
cp "$validator" "$multiline_case/scripts/validate-skills.sh"
chmod 755 "$multiline_case/scripts/validate-skills.sh"
git init --quiet "$multiline_case"
printf '%s\n' $'---\nname: example\ndescription: A valid skill.\n---\n\n[Guide](\nreferences/guide.md\n)\n' >"$multiline_case/skills/example/SKILL.md"
printf 'reference\n' >"$multiline_case/skills/example/references/guide.md"
if ! (cd "$multiline_case" && bash scripts/validate-skills.sh >/dev/null 2>&1); then
	fail 'valid multiline reference unexpectedly failed'
fi

reserved_name_case="$temp_root/references-skill-name"
mkdir -p "$reserved_name_case/scripts" "$reserved_name_case/skills/references"
cp "$validator" "$reserved_name_case/scripts/validate-skills.sh"
chmod 755 "$reserved_name_case/scripts/validate-skills.sh"
git init --quiet "$reserved_name_case"
printf '%s\n' $'---\nname: references\ndescription: A valid skill.\n---\n' >"$reserved_name_case/skills/references/SKILL.md"
if ! (cd "$reserved_name_case" && bash scripts/validate-skills.sh >/dev/null 2>&1); then
	fail 'skill named references unexpectedly failed'
fi

symlink_case="$temp_root/symlink-reference"
mkdir -p "$symlink_case/scripts" "$symlink_case/skills/example/references/nested" "$symlink_case/outside"
cp "$validator" "$symlink_case/scripts/validate-skills.sh"
chmod 755 "$symlink_case/scripts/validate-skills.sh"
git init --quiet "$symlink_case"
printf '%s\n' $'---\nname: example\ndescription: A valid skill.\n---\n\n[Guide](references/guide.md)\n' >"$symlink_case/skills/example/SKILL.md"
printf 'outside\n' >"$symlink_case/outside/guide.md"
ln -s ../../../outside/guide.md "$symlink_case/skills/example/references/guide.md"
ln -s ../../../../outside/guide.md "$symlink_case/skills/example/references/nested/orphan.md"
if (cd "$symlink_case" && bash scripts/validate-skills.sh >/dev/null 2>&1); then
	fail 'symlinked reference unexpectedly passed'
fi

symlink_skill_case="$temp_root/symlink-skill"
mkdir -p "$symlink_skill_case/scripts" "$symlink_skill_case/skills/real"
cp "$validator" "$symlink_skill_case/scripts/validate-skills.sh"
chmod 755 "$symlink_skill_case/scripts/validate-skills.sh"
git init --quiet "$symlink_skill_case"
printf '%s\n' $'---\nname: real\ndescription: A valid skill.\n---\n' >"$symlink_skill_case/skills/real/SKILL.md"
ln -s real "$symlink_skill_case/skills/alias"
if (cd "$symlink_skill_case" && bash scripts/validate-skills.sh >/dev/null 2>&1); then
	fail 'symlinked skill directory unexpectedly passed'
fi

find_failure_case="$temp_root/find-failure"
mkdir -p "$find_failure_case/bin" "$find_failure_case/scripts" "$find_failure_case/skills/example/references"
cp "$validator" "$find_failure_case/scripts/validate-skills.sh"
chmod 755 "$find_failure_case/scripts/validate-skills.sh"
git init --quiet "$find_failure_case"
printf '%s\n' $'---\nname: example\ndescription: A valid skill.\n---\n' >"$find_failure_case/skills/example/SKILL.md"
cat >"$find_failure_case/bin/find" <<'EOF'
#!/usr/bin/env bash
for argument in "$@"; do
  [[ "$argument" == */references ]] && exit 1
done
exec "$REAL_FIND" "$@"
EOF
chmod 755 "$find_failure_case/bin/find"
if (cd "$find_failure_case" && REAL_FIND="$real_find" PATH="$find_failure_case/bin:$PATH" bash scripts/validate-skills.sh >/dev/null 2>&1); then
	fail 'find failure unexpectedly passed'
fi


run_case metadata-prefix-strings pass $'---\nname: example\ndescription: A valid skill.\nmetadata:\n  summary: 2026 audit findings\n  label: true story\n---\n'

printf 'ok: skill validator regressions\n'
