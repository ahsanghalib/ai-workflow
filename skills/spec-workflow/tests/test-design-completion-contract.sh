#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
schema="$repo_root/skills/schema-design/SKILL.md"
technical="$repo_root/skills/technical-design/SKILL.md"
verification="$repo_root/skills/verification-before-completion/SKILL.md"
spec_workflow="$repo_root/skills/spec-workflow/SKILL.md"
project_init="$repo_root/skills/project-init/SKILL.md"
temp_root="$(mktemp -d)"
trap 'rm -rf "$temp_root"' EXIT

fail() {
  printf 'not ok: %s\n' "$1" >&2
  exit 1
}

write_completion_fixture() {
  local path="$1" task_state="$2" verification="$3"
  {
    printf '# SPEC-0001 — Completion fixture\n\n'
    printf 'Status: In Progress\n\n'
    printf '# Execution\n\n## Tasks\n\n'
    if [[ "$task_state" == complete ]]; then
      printf -- '- [x] TASK-001 — Complete the fixture task.\n'
    else
      printf -- '- [ ] TASK-001 — Complete the fixture task.\n'
    fi
    printf '\nTask validation: passed\n'
    if [[ -n "$verification" ]]; then
      printf 'Final verification: %s\n' "$verification"
    fi
  } > "$path"
}

completion_status() {
  local path="$1" status verification
  status="$(awk -F': ' '/^Status:/ { print $2; exit }' "$path")"
  verification="$(awk -F': ' '/^Final verification:/ { print $2; exit }' "$path")"
  if [[ "$status" == 'In Progress' ]] &&
    grep -Eq '^- \[x\] TASK-[0-9]{3} — ' "$path" &&
    [[ "$verification" == verified ]]; then
    printf 'Completed\n'
  else
    printf '%s\n' "$status"
  fi
}

grep -Fq 'approved SPEC' "$schema" ||
  fail 'schema design does not require approved SPEC context'
if grep -Eq 'MASTER_PLAN.md|DB_SCHEMA.md|USER_FLOW.md|PROJECT_ARCHITECTURE.md|PLAN' "$schema"; then
  fail 'schema design retained obsolete document terminology'
fi
grep -Fq 'none is a prerequisite' "$schema" ||
  fail 'schema design lacks normal-work dependency removal'
grep -Fq 'Do not invent a second approval gate' "$schema" ||
  fail 'schema design retained blanket second approval'
if ! grep -Fq 'behavior-preserving work does not' "$schema" ||
  ! grep -Fq 'another approval ceremony' "$schema"; then
  fail 'schema design lacks behavior-preserving approval boundary'
fi
grep -Fq 'same SPEC' "$schema" ||
  fail 'schema design does not feed SPEC Execution'
grep -Fq 'Requirements drive this work' "$schema" ||
  fail 'schema design does not make requirements the driver'
grep -Fq 'non-trivial data-model decisions' "$schema" ||
  fail 'schema design lacks conditional non-triviality gate'
if ! grep -Fq 'baseline' "$schema" ||
  ! grep -Fq 'automatically during project initialization' "$schema"; then
  fail 'schema design permits automatic baseline initialization'
fi
grep -Fq '## Data Design' "$schema" ||
  fail 'schema design lacks Data Design handoff section'
grep -Fq '## When schema design is appropriate' "$schema" ||
  fail 'schema design lacks invocation guidance'
grep -Fq 'new domain entities' "$schema" ||
  fail 'schema design lacks entity trigger example'
grep -Fq 'complex migrations' "$schema" ||
  fail 'schema design lacks migration trigger example'
grep -Fq 'tenant isolation' "$schema" ||
  fail 'schema design lacks tenant trigger example'
grep -Fq 'Do not invoke heavyweight schema design' "$schema" ||
  fail 'schema design lacks small-change bypass'
grep -Fq 'no persistence impact' "$schema" ||
  fail 'schema design lacks non-persistent-work bypass'
grep -Fq 'executable schema and migration history' "$schema" ||
  fail 'schema design lacks executable-source precedence'
grep -Fq 'Those decisions require explicit user approval' "$schema" ||
  fail 'schema design lacks explicit approval for risky decisions'
grep -Fq 'a schema-design handoff is not approval' "$schema" ||
  fail 'schema design handoff can be mistaken for approval'

grep -Fq 'approved SPEC' "$technical" ||
  fail 'technical design does not require approved SPEC context'
grep -Fq 'separate delivery plan' "$technical" ||
  fail 'technical design lacks separate-plan prohibition'
grep -Fq 'second approval' "$technical" ||
  fail 'technical design lacks behavior-preserving approval rule'
if ! grep -Fq 'Ordinary behavior-preserving' "$technical" ||
  ! grep -Fq 'do not require a second user approval' "$technical"; then
  fail 'technical design does not inherit approval for ordinary design'
fi
grep -Fq 'Synthesize into SPEC Execution' "$technical" ||
  fail 'technical design does not feed SPEC Execution'
grep -Fq '# Execution' "$technical" ||
  fail 'technical design lacks same-SPEC Execution destination'
grep -Fq '## Technical Design' "$technical" ||
  fail 'technical design lacks its same-SPEC subsection'
grep -Fq 'spec-workflow' "$technical" ||
  fail 'technical design lacks SPEC workflow handoff'
grep -Fq 'Do not edit the SPEC' "$technical" ||
  fail 'technical design is not explicitly read-only'
grep -Fq 'technical-design artifact' "$technical" ||
  fail 'technical design lacks standalone-artifact prohibition'
grep -Fq 'Do not treat a design verdict as approval' "$technical" ||
  fail 'technical design verdict can be mistaken for approval'
grep -Fq 'changes the approved SPEC contract' "$technical" ||
  fail 'technical design lacks contract-change escalation'
grep -Fq 'route back through' "$technical" ||
  fail 'technical design lacks user/SPEC revision route'
if grep -Eq 'project-init|PLAN|plan creation' "$technical"; then
  fail 'technical design retained project-init or PLAN routing'
fi
grep -Fq 'durable cross-feature or project' "$technical" ||
  fail 'technical design lacks durable-knowledge promotion boundary'
for destination in 'docs/architecture.md' 'docs/rules/' 'docs/decisions/'; do
  grep -Fq "$destination" "$technical" ||
    fail "technical design lacks conditional destination: $destination"
done

completion_fixture="$temp_root/completion.md"
write_completion_fixture "$completion_fixture" complete ''
[[ "$(completion_status "$completion_fixture")" == 'In Progress' ]] ||
  fail 'completed task checkboxes or narrow task validation implied completion'

write_completion_fixture "$completion_fixture" complete verified
[[ "$(completion_status "$completion_fixture")" == Completed ]] ||
  fail 'successful final verification did not permit SPEC completion'

for verification_result in failed partial; do
  write_completion_fixture "$completion_fixture" complete "$verification_result"
  [[ "$(completion_status "$completion_fixture")" == 'In Progress' ]] ||
    fail "$verification_result final verification incorrectly permitted completion"
done

write_completion_fixture "$completion_fixture" incomplete verified
[[ "$(completion_status "$completion_fixture")" == 'In Progress' ]] ||
  fail 'final verification permitted completion with an incomplete task'

grep -Fq 'Normal work remains' "$verification" ||
  fail 'completion verification is not SPEC/task-centric'
grep -Fq 'final evidence pass' "$verification" ||
  fail 'completion verification lacks final evidence gate'
grep -Fq 'partial' "$verification" ||
  fail 'completion verification lacks partial-result reporting'
grep -Fq 'A checked task list alone' "$spec_workflow" ||
  fail 'SPEC workflow permits task checkboxes to imply completion'
grep -Fq 'final acceptance and validation evidence passes' "$spec_workflow" ||
  fail 'SPEC workflow lacks final verification requirement'
grep -Fq 'architecture documents' "$project_init" ||
  fail 'project-init architecture boundary is undocumented'

printf 'ok: design and completion contract\n'
