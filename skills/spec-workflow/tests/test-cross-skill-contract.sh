#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
fail() {
  printf 'not ok: %s\n' "$1" >&2
  exit 1
}

spec_workflow="$repo_root/skills/spec-workflow/SKILL.md"
spec_review="$repo_root/skills/spec-review/SKILL.md"
implement_next="$repo_root/skills/implement-next/SKILL.md"
schema_design="$repo_root/skills/schema-design/SKILL.md"
technical_design="$repo_root/skills/technical-design/SKILL.md"
backend="$repo_root/skills/backend-feature/SKILL.md"
frontend="$repo_root/skills/frontend-feature/SKILL.md"
verification="$repo_root/skills/verification-before-completion/SKILL.md"
project_init="$repo_root/skills/project-init/SKILL.md"

for file in "$spec_workflow" "$spec_review" "$implement_next" "$schema_design" \
  "$technical_design" "$backend" "$frontend" "$verification" "$project_init"; do
  [[ -f "$file" ]] || fail "missing cross-skill contract file: $file"
done

grep -Fq 'Do not create a normal-work PLAN' "$spec_workflow" ||
  fail 'SPEC workflow still permits a normal-work PLAN'
grep -Fq 'Approval: Explicit user approval' "$spec_workflow" ||
  fail 'SPEC workflow lacks explicit approval evidence'
grep -Fq 'ready or not ready' "$spec_review" ||
  fail 'SPEC review lacks ready/not-ready semantics'
if grep -Fq 'ready for planning' "$spec_review"; then
  fail 'SPEC review retained the old planning verdict'
fi
grep -Fq 'first dependency-ready unchecked task' "$implement_next" ||
  fail 'implement-next lacks dependency-ready SPEC task selection'
grep -Fq 'Approved' "$implement_next" ||
  fail 'implement-next lacks Approved SPEC status gate'
grep -Fq 'In Progress' "$implement_next" ||
  fail 'implement-next lacks In Progress SPEC status gate'
if grep -Fq 'approved PLAN' "$implement_next" ||
   grep -Fq 'first PLAN task' "$implement_next"; then
  fail 'implement-next retained a mandatory PLAN contract'
fi
grep -Fq 'approved SPEC' "$schema_design" ||
  fail 'schema-design lacks approved SPEC input'
if grep -Fq 'USER_FLOW → DB_SCHEMA → SPEC' "$schema_design" ||
   ! grep -Fq "do not require \`MASTER_PLAN.md\`" "$schema_design"; then
  fail 'schema-design retained the old document dependency chain'
fi
grep -Fq 'spec-workflow' "$technical_design" ||
  fail 'technical-design lacks SPEC workflow handoff'
if grep -Fq 'project-init` for planning' "$technical_design"; then
  fail 'technical-design still routes normal planning to project-init'
fi
for implementation_skill in "$backend" "$frontend"; do
  grep -Fqi 'approved or in-progress SPEC' "$implementation_skill" ||
    fail "implementation skill lacks SPEC status gate: $implementation_skill"
  grep -Fq 'implement-next' "$implementation_skill" ||
    fail "implementation skill lacks implement-next handoff: $implementation_skill"
  if grep -Fq 'approved PLAN' "$implementation_skill"; then
    fail "implementation skill retained a mandatory PLAN: $implementation_skill"
  fi
done
grep -Fq 'Normal work must remain SPEC/task' "$verification" ||
  fail 'completion verification is not SPEC/task-centric'
grep -Fq 'do not create a SPEC, PLAN, task list' "$project_init" ||
  fail 'project-init does not prohibit normal-work PLAN creation'
grep -Fq 'AGENTS.md' "$project_init" ||
  fail 'project-init lacks control-plane output contract'

printf 'ok: cross-skill SPEC workflow contract\n'
