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
session_state="$repo_root/skills/session-state/SKILL.md"
code_review="$repo_root/skills/code-review/SKILL.md"
review_diff="$repo_root/skills/review-diff/SKILL.md"
repository_research="$repo_root/skills/repository-research/SKILL.md"
readme="$repo_root/README.md"

for file in "$spec_workflow" "$spec_review" "$implement_next" "$schema_design" \
  "$technical_design" "$backend" "$frontend" "$verification" "$project_init" \
  "$session_state" "$code_review" "$review_diff" "$repository_research"; do
  [[ -f "$file" ]] || fail "missing cross-skill contract file: $file"
done
[[ -f "$readme" ]] || fail 'missing repository architecture documentation'

normal_contract_paths=(
  "$repo_root"/skills/*/SKILL.md
  "$repo_root"/skills/project-init/references/*.md
  "$repo_root"/skills/spec-workflow/references/*.md
  "$repo_root"/agents/codex/*.toml
  "$repo_root"/agents/opencode/*.md
  "$repo_root/README.md"
  "$repo_root/GLOBAL_AGENTS.md"
)
for forbidden_route in \
  'SPEC → PLAN → implementation' \
  'project-init → USER_FLOW → DB_SCHEMA → SPEC' \
  'project-init → MASTER_PLAN'; do
  if rg -n -F "$forbidden_route" "${normal_contract_paths[@]}"; then
    fail "normal contract path still enforces retired route: $forbidden_route"
  fi
done

for documentation_contract in \
  'Repository-control bootstrap and reconciliation' \
  'One substantive unit-of-work lifecycle' \
  'Behavioral contract plus mutable execution record' \
  'Contract-quality review and readiness, not approval' \
  'Conditional implementation architecture design' \
  'Conditional non-trivial persistence design' \
  'One bounded task from an approved or in-progress SPEC' \
  'Optional tracking item' \
  'Optional dashboard' \
  'Final completion gate'; do
  grep -Fq "$documentation_contract" "$readme" ||
    fail "README lost workflow ownership contract: $documentation_contract"
done
grep -Fq 'The normal workflow is routed by need' "$readme" ||
  fail 'README implies every skill must run for every change'
if grep -Fq '#### Project control and planning' "$readme"; then
  fail 'README retained stale project-control planning heading'
fi
for placement_contract in \
  'Temporary current work state' \
  'Feature behavior, requirements, and acceptance' \
  'Feature-specific technical or data design' \
  'Feature tasks, validation, and implementation notes' \
  'Cross-feature engineering convention' \
  'Cross-feature architecture' \
  'Agent/runtime memory' \
  'Structural truth' \
  'Do not duplicate the same fact'; do
  grep -Fq "$placement_contract" "$readme" ||
    fail "README lost knowledge-placement contract: $placement_contract"
done

grep -Fq 'Do not create a separate planning document' "$spec_workflow" ||
  fail 'SPEC workflow still permits a separate planning document'
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
if grep -Fq 'PLAN' "$implement_next"; then
  fail 'implement-next retained planning terminology'
fi
grep -Fq 'approved SPEC' "$schema_design" ||
  fail 'schema-design lacks approved SPEC input'
if grep -Eq 'MASTER_PLAN|DB_SCHEMA|USER_FLOW|PROJECT_ARCHITECTURE|PLAN' "$schema_design"; then
  fail 'schema-design retained obsolete document terminology'
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
  grep -Fq '# Execution' "$implementation_skill" ||
    fail "implementation skill lacks SPEC execution evidence boundary: $implementation_skill"
  grep -Fq 'TDD evidence' "$implementation_skill" ||
    fail "implementation skill lacks TDD evidence handoff: $implementation_skill"
  grep -Fq 'task completion' "$implementation_skill" ||
    fail "implementation skill lacks task-completion ownership boundary: $implementation_skill"
  grep -Fq 'task-specific tests/checks' "$implementation_skill" ||
    fail "implementation skill lacks task-specific validation ownership: $implementation_skill"
  grep -Fq 'legacy rule locations' "$implementation_skill" ||
    fail "implementation skill lacks legacy-rule preservation boundary: $implementation_skill"
  grep -Fq 'After all SPEC tasks are' "$implementation_skill" ||
    fail "implementation skill lacks SPEC-level review ordering: $implementation_skill"
  if grep -Fq 'PLAN' "$implementation_skill"; then
    fail "implementation skill retained planning terminology: $implementation_skill"
  fi
done
grep -Fq 'Do not route the SPEC to implementation review' "$implement_next" ||
  fail 'implement-next does not defer SPEC-level review from one-task handoff'
grep -Fq 'Normal work remains' "$verification" ||
  fail 'completion verification is not SPEC/task-centric'
grep -Fq 'Do not create a SPEC, task list' "$project_init" ||
  fail 'project-init does not prohibit work-contract creation'
grep -Fq 'AGENTS.md' "$project_init" ||
  fail 'project-init lacks control-plane output contract'
grep -Fq 'active SPEC/task' "$session_state" ||
  fail 'session-state lacks SPEC/task continuity contract'
if grep -Fq 'PLAN' "$session_state"; then
  fail 'session-state retained PLAN state terminology'
fi
grep -Fq 'exact SPEC path or identifier' "$code_review" ||
  fail 'code-review lacks exact SPEC/task scope contract'
grep -Fq 'Remain read-only' "$code_review" ||
  fail 'code-review lost read-only boundary'
grep -Fq 'not require a SPEC' "$review_diff" ||
  fail 'review-diff lost minimal diff-only boundary'
grep -Fq 'spec-workflow' "$repository_research" ||
  fail 'repository-research lacks SPEC workflow handoff'
grep -Fq 'Do not create tickets' "$repository_research" ||
  fail 'repository-research lacks bounded-output boundary'

printf 'ok: cross-skill SPEC workflow contract\n'
