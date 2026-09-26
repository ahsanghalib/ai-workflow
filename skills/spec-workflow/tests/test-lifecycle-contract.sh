#!/usr/bin/env bash
set -euo pipefail

skill_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
template="$skill_dir/references/spec-template.md"
lifecycle="$skill_dir/references/lifecycle-and-approval.md"
spec_review="$skill_dir/../spec-review/SKILL.md"
implement_next="$skill_dir/../implement-next/SKILL.md"
temp_root="$(mktemp -d)"
trap 'rm -rf "$temp_root"' EXIT

fail() {
  printf 'not ok: %s\n' "$1" >&2
  exit 1
}

write_spec() {
  local path="$1" status="$2" approval="$3" tasks="$4"
  {
    printf '# SPEC-0001 — Fixture\n\n'
    printf 'Status: %s\n' "$status"
    if [[ "$approval" == true ]]; then
      printf 'Approval: Explicit user approval — 2026-09-26\n'
    fi
    printf '\n## Problem\n\nA fixture contract.\n\n'
    printf '## Acceptance Criteria\n\n- [ ] Observable result.\n\n'
    printf '# Execution\n\n## Tasks\n\n'
    if [[ "$tasks" == true ]]; then
      printf -- '- [ ] TASK-001 — Execute the fixture task.\n'
    fi
  } > "$path"
}

status_of() {
  awk -F': ' '/^Status:/ { print $2; exit }' "$1"
}

approval_is_valid() {
  grep -Eq '^Approval: Explicit user approval — [0-9]{4}-[0-9]{2}-[0-9]{2}$' "$1"
}

execution_allowed() {
  local path="$1" status
  status="$(status_of "$path")"
  case "$status" in
    Approved|"In Progress")
      approval_is_valid "$path" || return 1
      grep -Fq '# Execution' "$path" || return 1
      grep -Eq '^- \[ \] TASK-[0-9]{3} — ' "$path" || return 1
      ;;
    *)
      return 1
      ;;
  esac
}

for status in Draft Blocked Completed Cancelled; do
  fixture="$temp_root/${status}.md"
  write_spec "$fixture" "$status" true true
  if execution_allowed "$fixture"; then
    fail "$status fixture incorrectly passed implement-next execution gate"
  fi
done

for status in Approved 'In Progress'; do
  fixture="$temp_root/${status// /-}.md"
  write_spec "$fixture" "$status" true true
  execution_allowed "$fixture" ||
    fail "$status fixture failed implement-next execution gate"
done

missing_approval="$temp_root/missing-approval.md"
write_spec "$missing_approval" Approved false true
if execution_allowed "$missing_approval"; then
  fail 'Approved fixture without approval evidence passed execution gate'
fi

malformed_approval="$temp_root/malformed-approval.md"
write_spec "$malformed_approval" Approved true true
sed -i 's/^Approval:.*/Approval: Explicit user approval — /' "$malformed_approval"
if execution_allowed "$malformed_approval"; then
  fail 'Approved fixture with an undated approval passed execution gate'
fi

missing_tasks="$temp_root/missing-tasks.md"
write_spec "$missing_tasks" Approved true false
if execution_allowed "$missing_tasks"; then
  fail 'Approved fixture without an existing task passed execution gate'
fi

changed_contract="$temp_root/changed-contract.md"
write_spec "$changed_contract" Draft false true
printf '\nChanged contract requires fresh review.\n' >> "$changed_contract"
if execution_allowed "$changed_contract"; then
  fail 'contract-changed Draft fixture passed execution gate'
fi
if grep -Eq '^Approval:' "$changed_contract"; then
  fail 'contract-changed Draft fixture retained approval evidence'
fi

execution_only="$temp_root/execution-only.md"
write_spec "$execution_only" Approved true true
printf '\n## Execution Notes\n\nUpdated test command.\n' >> "$execution_only"
execution_allowed "$execution_only" ||
  fail 'execution-only fixture invalidated approval evidence'

grep -Fq 'Status: Draft' "$template" || fail 'template lacks Draft status'
grep -Fq '# Execution' "$template" || fail 'template lacks Execution boundary'
grep -Fq 'TASK-001' "$template" || fail 'template lacks SPEC-local task example'
grep -Fq 'default skeleton contains only' "$template" ||
  fail 'template does not keep the default SPEC small'
grep -Fq 'Optional contract sections (add only when applicable)' "$template" ||
  fail 'template does not expose opt-in contract sections'
grep -Fq 'Optional execution sections (add only when justified)' "$template" ||
  fail 'template does not expose opt-in execution sections'
grep -Fq 'clear approval evidence' "$skill_dir/SKILL.md" ||
  fail 'SPEC workflow lacks approval clearing rule'
grep -Fq 'Contract freeze' "$lifecycle" ||
  fail 'lifecycle reference lacks contract freeze rule'
grep -Fq 'Approval applies to the behavioral contract above' "$lifecycle" ||
  fail 'lifecycle reference lacks boundary-scoped approval rule'
if ! grep -Fq 'Execution' "$lifecycle" ||
  ! grep -Fq 'details remain mutable unless' "$lifecycle"; then
  fail 'lifecycle reference lacks execution mutability rule'
fi
grep -Fq 'Never manufacture' "$lifecycle" ||
  fail 'lifecycle reference lacks approval anti-fabrication rule'
grep -Fq 'requirements, acceptance criteria, scope, or non-goals' "$lifecycle" ||
  fail 'lifecycle reference does not enumerate approval-invalidating contract changes'
grep -Fq 'execution changes normally do not require reapproval' "$lifecycle" ||
  fail 'lifecycle reference does not distinguish execution-only changes'
grep -Fq 'test strategy details' "$lifecycle" ||
  fail 'lifecycle lacks mutable test-strategy details'
grep -Fq 'new product decision' "$lifecycle" ||
  fail 'lifecycle lacks execution escalation boundary'
grep -Fq 'irreversible migration choice' "$lifecycle" ||
  fail 'lifecycle lacks irreversible-migration escalation'
grep -Fq 'new retention/deletion semantics' "$lifecycle" ||
  fail 'lifecycle lacks retention escalation'
if ! grep -Fq 'unresolved' "$lifecycle" ||
  ! grep -Fq 'business invariant' "$lifecycle"; then
  fail 'lifecycle lacks business-invariant escalation'
fi
grep -Fq 'clear approval evidence and' "$skill_dir/SKILL.md" ||
  fail 'SPEC workflow lacks explicit approval invalidation behavior'
grep -Fq "return to \`Status: Draft\`" "$skill_dir/SKILL.md" ||
  fail 'SPEC workflow lacks explicit approval invalidation behavior'
grep -Fq 'Retain the approval evidence' "$lifecycle" ||
  fail 'lifecycle lacks approval-evidence retention rule'
if ! grep -Fq "\`Approved\`" "$lifecycle" ||
  ! grep -Fq 'Progress' "$lifecycle" ||
  ! grep -Fq "\`Blocked\`" "$lifecycle"; then
  fail 'lifecycle lacks all approval-bearing statuses'
fi
if ! grep -Fq 'old evidence' "$lifecycle" ||
  ! grep -Fq 'must not be' "$lifecycle" ||
  ! grep -Fq 'reused' "$lifecycle"; then
  fail 'lifecycle lacks stale-evidence prohibition'
fi
grep -Fq 'recorded blocker is resolved' "$lifecycle" ||
  fail 'lifecycle lacks blocked-to-in-progress transition'
grep -Fq 'No SPEC may transition directly' "$lifecycle" ||
  fail 'lifecycle permits blocked completion bypass'
grep -Fq 'ready' "$spec_review" ||
  fail 'spec-review lacks ready verdict contract'
grep -Fq 'not ready' "$spec_review" ||
  fail 'spec-review lacks not-ready verdict contract'
grep -Fq 'it is not approval' "$spec_review" ||
  fail 'spec-review treats ready as approval'
grep -Fq 'Do not set or change SPEC status' "$spec_review" ||
  fail 'spec-review lacks status immutability boundary'
grep -Fq 'Only the user can approve' "$lifecycle" ||
  fail 'lifecycle lacks explicit user approval ownership'
grep -Fq 'Approval: Explicit user approval — YYYY-MM-DD' "$lifecycle" ||
  fail 'lifecycle lacks approval evidence format'
grep -Fq 'not ready' "$skill_dir/SKILL.md" ||
  fail 'SPEC workflow lacks not-ready review loop'
grep -Fq 'second approval gate' "$skill_dir/SKILL.md" ||
  fail 'SPEC workflow lacks second-approval prohibition'
grep -Fq 'exact SPEC path or stable SPEC ID' "$implement_next" ||
  fail 'implement-next lacks exact SPEC identity requirement'
if ! grep -Fq 'do not create or' "$implement_next" ||
  ! grep -Fq 'redesign the task list' "$implement_next"; then
  fail 'implement-next lacks task-list ownership boundary'
fi
grep -Fq 'Do not choose a later task' "$implement_next" ||
  fail 'implement-next lacks task-selection boundary'
grep -Fq 'hand the SPEC back to' "$implement_next" ||
  fail 'implement-next lacks missing-task handoff'
grep -Fq "Task decomposition belongs to \`spec-workflow\`" "$implement_next" ||
  fail 'implement-next lacks task-decomposition ownership boundary'
grep -Fq 'first unchecked task' "$implement_next" ||
  fail 'implement-next lacks first-task selection'
grep -Fq 'Select exactly the first unchecked task' "$implement_next" ||
  fail 'implement-next lacks one-task boundary'
grep -Fq 'red/green/refactor' "$implement_next" ||
  fail 'implement-next lacks TDD gate'
grep -Fq 'Validation must be fresh for this task' "$implement_next" ||
  fail 'implement-next lacks fresh validation evidence'
grep -Fq 'Mark only the selected task complete' "$implement_next" ||
  fail 'implement-next lacks successful-task completion rule'
grep -Fq 'Stop. Do not automatically continue into the next task' "$implement_next" ||
  fail 'implement-next lacks stop-after-one-task rule'
grep -Fq 'leave the selected task unchecked' "$implement_next" ||
  fail 'implement-next lacks blocked-task rule'
grep -Fq 'SESSION_STATE.md' "$implement_next" ||
  fail 'implement-next lacks session-state handoff'
if grep -Fq 'PLAN' "$implement_next"; then
  fail 'implement-next contains planning terminology'
fi
grep -Fq 'Do not mark the SPEC' "$implement_next" ||
  fail 'implement-next lacks SPEC completion boundary'
grep -Fq 'before making the first task change' "$implement_next" ||
  fail 'implement-next does not transition Approved SPEC at task start'
if grep -Fq "If execution began from \`Approved\`, set the SPEC to \`In Progress\`" "$implement_next"; then
  fail 'implement-next still delays the Approved-to-In Progress transition'
fi

printf 'ok: SPEC lifecycle and approval contract\n'
