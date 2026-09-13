#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
inventory="$script_dir/scripts/inventory-project.sh"
temp_root="$(mktemp -d)"
trap 'rm -rf "$temp_root"' EXIT

fail() {
  printf 'not ok: %s\n' "$1" >&2
  exit 1
}

target="$temp_root/existing project"
mkdir -p "$target/docs/plans" "$target/src" "$target/tests" \
  "$target/node_modules/pkg" "$target/apps/web/node_modules/pkg" \
  "$target/apps/web/dist"
printf '# Read me\n' > "$target/README.md"
printf '# Rules\n' > "$target/AGENTS.md"
printf '# Master\n' > "$target/MASTER_PLAN.md"
printf '# Architecture\n' > "$target/docs/PROJECT_ARCHITECTURE.md"
printf '# Schema\n' > "$target/docs/DB_SCHEMA.md"
printf '{}\n' > "$target/package.json"
printf '{}\n' > "$target/package-lock.json"
printf 'export {}\n' > "$target/src/main.ts"
printf 'test\n' > "$target/tests/main.test.ts"
printf 'do-not-print-this-secret\n' > "$target/.env"
printf 'do-not-print-this-key\n' > "$target/server.pem"
newline_path=$'docs/evidence\nwith-newline.md'
touch "$target/$newline_path"
printf 'ignored dependency\n' > "$target/node_modules/pkg/index.js"
printf 'nested ignored dependency\n' > "$target/apps/web/node_modules/pkg/index.js"
printf 'nested generated output\n' > "$target/apps/web/dist/index.js"
ln -s README.md "$target/readme-link"

output="$(bash "$inventory" "$target")"
grep -Fxq 'inventory: read-only' <<<"$output" || fail 'missing read-only marker'
grep -Fxq 'evidence: README.md | instruction' <<<"$output" ||
  fail 'missed README evidence'
grep -Fxq 'evidence: MASTER_PLAN.md | planning' <<<"$output" ||
  fail 'missed master-plan evidence'
grep -Fxq 'evidence: docs/DB_SCHEMA.md | schema' <<<"$output" ||
  fail 'missed schema evidence'
grep -Fxq 'evidence: package.json | manifest' <<<"$output" ||
  fail 'missed manifest evidence'
grep -Fxq 'evidence: src/main.ts | source' <<<"$output" ||
  fail 'missed source evidence'
grep -Fxq 'evidence: tests/main.test.ts | validation' <<<"$output" ||
  fail 'missed validation evidence'
grep -Fxq 'evidence: .env | sensitive-name-only' <<<"$output" ||
  fail 'did not classify .env safely'
grep -Fxq 'evidence: server.pem | sensitive-name-only' <<<"$output" ||
  fail 'did not classify key-like file safely'
grep -Fxq 'evidence: readme-link | symlink-not-followed' <<<"$output" ||
  fail 'did not report symlink boundary'
if grep -Fq 'do-not-print-this-secret' <<<"$output" ||
   grep -Fq 'do-not-print-this-key' <<<"$output"; then
  fail 'printed sensitive contents'
fi
if grep -Fq 'node_modules/pkg/index.js' <<<"$output"; then
  fail 'included pruned dependency contents'
fi
if grep -Fq 'apps/web/dist/index.js' <<<"$output"; then
  fail 'included nested generated contents'
fi
grep -Fxq 'evidence: docs/evidence\nwith-newline.md | other' <<<"$output" ||
  fail 'did not preserve newline-containing path as escaped evidence'

find_failure_bin="$temp_root/find-failure-bin"
mkdir -p "$find_failure_bin"
ln -s "$(type -P false)" "$find_failure_bin/find"
if PATH="$find_failure_bin:$PATH" bash "$inventory" "$target" >/dev/null 2>&1; then
  fail 'reported success after failed project traversal'
fi

if bash "$inventory" "$target" unexpected >/dev/null 2>&1; then
  fail 'accepted an extra argument'
fi

printf 'ok: project-init safe evidence inventory\n'
