#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
skill_dir=$(cd -- "$script_dir/.." && pwd)
skill="$skill_dir/SKILL.md"
template="$skill_dir/references/spec-template.md"
project_template="$skill_dir/../project-init/templates/docs/templates/spec.md"
lifecycle="$skill_dir/references/lifecycle-and-approval.md"
github_tracking="$skill_dir/references/github-tracking.md"

fail() {
  printf 'fail: %s\n' "$1" >&2
  exit 1
}

[[ -f "$skill" ]] || fail 'missing SKILL.md'
[[ -f "$template" ]] || fail 'missing SPEC template'
[[ -f "$project_template" ]] || fail 'missing retained project SPEC template'
[[ -f "$lifecycle" ]] || fail 'missing lifecycle reference'
[[ -f "$github_tracking" ]] || fail 'missing GitHub tracking reference'

grep -Fq 'name: spec-workflow' "$skill" || fail 'missing portable frontmatter name'
grep -Fq 'spec-review' "$skill" || fail 'missing spec-review handoff'
grep -Fq 'implement-next' "$skill" || fail 'missing implement-next handoff'
grep -Fq 'Do not create a separate planning document' "$skill" ||
  fail 'separate planning-document prohibition missing'
if ! grep -Fq 'does not implement' "$skill" ||
  ! grep -Fq 'application code' "$skill"; then
  fail 'implementation boundary missing'
fi
grep -Fq 'same SPEC' "$skill" ||
  fail 'same-SPEC execution boundary missing'
grep -Fq 'technical-design' "$skill" ||
  fail 'technical-design handoff missing'
grep -Fq 'schema-design' "$skill" ||
  fail 'schema-design handoff missing'
grep -Fq 'dependency-ordered' "$skill" ||
  fail 'dependency-ordered task preparation missing'
grep -Fq 'exact SPEC path' "$skill" ||
  fail 'implement-next handoff scope missing'
grep -Fq 'same SPEC lifecycle' "$skill" ||
  fail 'single-SPEC lifecycle rule missing'
grep -Fq 'not ready' "$skill" ||
  fail 'not-ready review loop missing'
grep -Fq 'legacy planning' "$skill" ||
  fail 'legacy approval anti-inference rule missing'
grep -Fq 'looks good' "$skill" ||
  fail 'vague approval anti-inference rule missing'
grep -Fq 'second approval gate' "$skill" ||
  fail 'second approval prohibition missing'
grep -Fq 'approved alternate source' "$skill" ||
  fail 'alternate SPEC source handling missing'
grep -Fq 'competing' "$skill" ||
  fail 'competing SPEC-tree prohibition missing'
grep -Fq 'Approval: Explicit user approval' "$skill" || fail 'approval evidence missing'
grep -Fq 'everything above it is' "$skill" ||
  fail 'contract/execution boundary missing'
grep -Fq 'Approval applies to the behavioral contract above' "$skill" ||
  fail 'approval scope is not tied to the contract boundary'
if ! grep -Fq 'Execution' "$skill" ||
  ! grep -Fq 'details remain mutable unless' "$skill"; then
  fail 'execution mutability rule missing'
fi
grep -Fq 'Status: Draft' "$template" || fail 'template draft status missing'
grep -Fq '# Execution' "$template" || fail 'template execution boundary missing'
grep -Fq 'default skeleton contains only' "$template" ||
  fail 'template default-skeleton rule missing'
grep -Fq 'add only when applicable' "$template" ||
  fail 'template optional-section rule missing'
default_contract="$(awk '
  /^```markdown$/ { block += 1; next }
  block == 1 && /^```$/ { exit }
  block == 1 { print }
' "$template")"
if grep -Eq '^## (Context / Evidence|Non-goals|Constraints|Impact|Open Questions)$' \
  <<<"$default_contract"; then
  fail 'canonical template forces an optional contract section'
fi
project_contract="$(awk '/^# Execution$/ { exit } { print }' "$project_template")"
if grep -Eq '^## (Context / Evidence|Non-goals|Constraints|Impact|Open Questions)$' \
  <<<"$project_contract"; then
  fail 'retained project template forces an optional contract section'
fi
for optional in '## Context / Evidence' '## Non-goals' '## Constraints' \
  '## Impact' '## Open Questions'; do
  grep -Fq "$optional" "$template" ||
    fail "canonical template lost optional section example: $optional"
  grep -Fq "$optional" "$project_template" ||
    fail "project template lost optional section example: $optional"
done
for candidate in "$template" "$project_template"; do
  for required in '## Problem' '## Goal' '## Requirements' \
    '## Acceptance Criteria' '# Execution' '## Tasks'; do
    grep -Fq "$required" "$candidate" ||
      fail "template lost required section $required: $candidate"
  done
  grep -Fq 'SPEC-####/TASK-###' "$candidate" ||
    fail "template lost SPEC-local task identity guidance: $candidate"
done
if rg -n 'MASTER_PLAN\.md|PLAN\.md|SPEC/PLAN' "$template" "$project_template"; then
  fail 'SPEC template retained a PLAN artifact contract'
fi
grep -Fq 'Always include' "$skill" ||
  fail 'required contract sections are not distinguished'
grep -Fq 'only when each section' "$skill" ||
  fail 'optional contract sections are not opt-in'
grep -Fq 'before the behavioral contract is approved' "$skill" ||
  fail 'pre-approval implementation-planning boundary missing'
grep -Fq 'record behavior-preserving conclusions under' "$skill" ||
  fail 'post-approval design-recording handoff missing'
grep -Fq 'Derive small, dependency-ordered' "$skill" ||
  fail 'post-approval task derivation missing'
grep -Fq 'Only the user can approve' "$lifecycle" || fail 'user approval ownership missing'
if ! grep -Fq 'legacy' "$lifecycle" ||
  ! grep -Fq 'planning' "$lifecycle"; then
  fail 'lifecycle legacy approval anti-inference rule missing'
fi
grep -Fq 'looks' "$lifecycle" ||
  fail 'lifecycle vague approval anti-inference rule missing'
grep -Fq 'second approval gate' "$lifecycle" ||
  fail 'lifecycle second approval prohibition missing'
grep -Fq 'Status' "$lifecycle" ||
  fail 'implementation handoff gate missing'
grep -Fq 'Persistent statuses are limited' "$skill" ||
  fail 'persistent status set is not constrained'
grep -Fq 'Review readiness is not a status' "$skill" ||
  fail 'review readiness status boundary missing'
grep -Fq 'recorded blocker is resolved' "$skill" ||
  fail 'blocked-to-in-progress transition rule missing'
grep -Fq 'Do not bypass' "$skill" ||
  fail 'blocked completion bypass prohibition missing'
grep -Fq 'irreversible migration choice' "$skill" ||
  fail 'irreversible migration escalation missing'
grep -Fq 'new retention/deletion semantics' "$skill" ||
  fail 'retention escalation missing'
if ! grep -Fq 'unresolved' "$skill" ||
  ! grep -Fq 'business invariant' "$skill"; then
  fail 'business-invariant escalation missing'
fi
grep -Fq 'Retain the approval evidence' "$lifecycle" ||
  fail 'approval-evidence retention rule missing'
grep -Fq "set \`Status: Draft\`" "$lifecycle" ||
  fail 'approval invalidation status transition missing'
if ! grep -Fq 'old evidence' "$lifecycle" ||
  ! grep -Fq 'must not be' "$lifecycle" ||
  ! grep -Fq 'reused' "$lifecycle"; then
  fail 'stale approval-evidence prohibition missing'
fi
grep -Fq 'zero, one, or multiple' "$github_tracking" ||
  fail 'GitHub tracking cardinality missing'
grep -Fq 'exact repository SPEC' "$github_tracking" ||
  fail 'GitHub Issue-to-SPEC reference rule missing'
grep -Fq 'entire SPEC into every Issue' "$github_tracking" ||
  fail 'GitHub Issue duplication boundary missing'
grep -Fq 'no remote mapping is a valid outcome' "$github_tracking" ||
  fail 'GitHub one-to-one mapping prohibition missing'
grep -Fq '# Execution' "$github_tracking" ||
  fail 'GitHub tracking SPEC execution boundary missing'
grep -Fq '## Tracking' "$github_tracking" ||
  fail 'GitHub tracking subsection missing'
grep -Fq 'SPEC status' "$github_tracking" ||
  fail 'GitHub tracking status ownership boundary missing'
grep -Fq 'not invent issue numbers' "$github_tracking" ||
  fail 'GitHub anti-fabrication rule missing'
if ! grep -Fq 'fully usable' "$github_tracking" ||
  ! grep -Fq 'without GitHub' "$github_tracking"; then
  fail 'local GitHub-independent workflow rule missing'
fi
grep -Fq 'harness-agnostic' "$github_tracking" ||
  fail 'GitHub harness-agnostic boundary missing'
grep -Fq 'GitHub API access' "$github_tracking" ||
  fail 'GitHub API non-assumption missing'
grep -Fq 'GitHub MCP/plugin access' "$github_tracking" ||
  fail 'GitHub MCP/plugin non-assumption missing'
grep -Fq 'authenticated' "$github_tracking" ||
  fail 'GitHub authentication non-assumption missing'
if ! grep -Fq 'permission to' "$github_tracking" ||
  ! grep -Fq 'create Issues' "$github_tracking" ||
  ! grep -Fq 'Projects' "$github_tracking"; then
  fail 'GitHub create-permission non-assumption missing'
fi
grep -Fq 'permission to mutate remote state' "$github_tracking" ||
  fail 'GitHub remote-permission non-assumption missing'
grep -Fq 'GitHub is an optional tracking layer' "$github_tracking" ||
  fail 'GitHub optionality is not explicit'
grep -Fq 'never the requirements source of truth' "$github_tracking" ||
  fail 'GitHub requirements-source boundary is missing'
grep -Fq 'does not own requirements' "$github_tracking" ||
  fail 'GitHub Project requirements ownership boundary is missing'
grep -Fq 'verified capability' "$github_tracking" ||
  fail 'GitHub verified-capability mutation gate is missing'
grep -Fq 'verified user authorization' "$github_tracking" ||
  fail 'GitHub verified-authorization mutation gate is missing'
grep -Fq 'live credentials' "$github_tracking" ||
  fail 'GitHub live-credential independence is missing'
if ! grep -Fq 'project IDs' "$github_tracking" ||
  ! grep -Fq 'PR IDs' "$github_tracking" ||
  ! grep -Fq 'remote status' "$github_tracking"; then
  fail 'GitHub Project/PR/status anti-fabrication rule is incomplete'
fi
grep -Fq 'explicitly approved' "$github_tracking" ||
  fail 'GitHub mutation approval rule missing'
grep -Fq 'fake tool contracts' "$github_tracking" ||
  fail 'GitHub fake-tool-contract prohibition missing'
if ! grep -Fq 'Do not create or' "$github_tracking" ||
  ! grep -Fq 'require one during' "$github_tracking" ||
  ! grep -Fq 'project-init' "$github_tracking"; then
  fail 'GitHub Project project-init boundary missing'
fi
grep -Fq 'authorized workflow explicitly chooses it' "$github_tracking" ||
  fail 'GitHub Project authorization trigger missing'
if ! grep -Fq 'Type' "$github_tracking" ||
  ! grep -Fq 'Priority' "$github_tracking" ||
  ! grep -Fq 'SPEC' "$github_tracking" ||
  ! grep -Fq 'Area' "$github_tracking"; then
  fail 'GitHub Project optional fields missing'
fi

for test_root in "$skill_dir/tests" "$skill_dir/../project-init/tests"; do
  if rg -n --glob '!test-contract.sh' \
    -e 'GITHUB_TOKEN|gh (issue|project|pr)|curl .*github|git (push|fetch|pull)|git remote (add|set-url)' \
    "$test_root"; then
    fail 'core contract tests contain live GitHub or remote-mutation commands'
  fi
done

printf 'ok: spec-workflow contract\n'
