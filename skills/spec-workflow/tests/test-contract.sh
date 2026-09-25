#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
skill_dir=$(cd -- "$script_dir/.." && pwd)
skill="$skill_dir/SKILL.md"
template="$skill_dir/references/spec-template.md"
lifecycle="$skill_dir/references/lifecycle-and-approval.md"

fail() {
  printf 'fail: %s\n' "$1" >&2
  exit 1
}

[[ -f "$skill" ]] || fail 'missing SKILL.md'
[[ -f "$template" ]] || fail 'missing SPEC template'
[[ -f "$lifecycle" ]] || fail 'missing lifecycle reference'

grep -Fq 'name: spec-workflow' "$skill" || fail 'missing portable frontmatter name'
grep -Fq 'spec-review' "$skill" || fail 'missing spec-review handoff'
grep -Fq 'implement-next' "$skill" || fail 'missing implement-next handoff'
grep -Fq 'Do not create a normal-work PLAN' "$skill" || fail 'normal PLAN prohibition missing'
grep -Fq 'Approval: Explicit user approval' "$skill" || fail 'approval evidence missing'
grep -Fq 'everything above it is' "$skill" ||
  fail 'contract/execution boundary missing'
grep -Fq 'Status: Draft' "$template" || fail 'template draft status missing'
grep -Fq '# Execution' "$template" || fail 'template execution boundary missing'
grep -Fq 'Only the user can approve' "$lifecycle" || fail 'user approval ownership missing'
grep -Fq 'Status' "$lifecycle" ||
  fail 'implementation handoff gate missing'

printf 'ok: spec-workflow contract\n'
