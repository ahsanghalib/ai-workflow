#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail() {
  printf 'not ok: %s\n' "$1" >&2
  exit 1
}

spec="$script_dir/templates/docs/templates/SPEC.md"
plan="$script_dir/templates/docs/templates/PLAN.md"
api="$script_dir/templates/docs/rules/API.md"
frontend="$script_dir/templates/docs/rules/FRONTEND.md"
contracts="$script_dir/templates/docs/rules/CONTRACTS.md"
traceability="$script_dir/references/traceability.md"
workflow="$script_dir/references/workflow.md"
acceptance="$script_dir/references/acceptance-scenarios.md"
profiles="$script_dir/references/project-profiles.md"
manifest="$script_dir/references/template-manifest.md"
validator="$script_dir/scripts/validate-foundation.sh"
feature_lifecycle="$script_dir/references/feature-lifecycle.md"
user_flow="$script_dir/templates/docs/USER_FLOW.md"
schema_prompt="$script_dir/templates/.ai/prompts/design-database-schema.md"
spec_prompt="$script_dir/templates/.ai/prompts/create-spec.md"
ci="$script_dir/../../.github/workflows/validate.yml"
common="$script_dir/scripts/common.sh"

[[ -f "$traceability" ]] || fail 'missing traceability reference'
[[ -f "$profiles" ]] || fail 'missing project profile reference'
[[ -x "$validator" ]] || fail 'missing foundation validator'
for phrase in 'web-app' 'monorepo' 'unknown/other' 'Actor or user flow' 'Persistence'; do
  grep -Fq "$phrase" "$profiles" || fail "project profile omitted: $phrase"
done
grep -Fq 'validate-foundation.sh' "$workflow" ||
  fail 'workflow omitted foundation validator routing'
for option in '--readme' '--agents' '--master-plan' '--architecture' '--user-flow' '--schema'; do
  grep -Fq -- "$option" "$workflow" || fail "workflow omitted validator option: $option"
done
grep -Fq 'inapplicable optional document' "$workflow" ||
  fail 'workflow omitted conditional optional-document handling'
grep -Fq 'project-profiles.md' "$workflow" ||
  fail 'workflow omitted project profile routing'
grep -Fq 'no-op' "$workflow" ||
  fail 'workflow omitted unchanged scaffold no-op behavior'
grep -Fq 'Base outputs when missing' "$manifest" ||
  fail 'manifest omitted base-output section'
grep -Fq 'Optional after profile review and approval' "$manifest" ||
  fail 'manifest omitted profile-selected output section'
if grep -Fq 'docs/USER_FLOW.md is required for the normal scaffold' "$workflow"; then
  fail 'workflow retained unconditional user-flow requirement'
fi
if grep -Fq 'required docs/USER_FLOW.md' "$manifest"; then
  fail 'manifest retained unconditional user-flow requirement'
fi
for phrase in 'User-flow references' 'Approved schema entities' 'Schema impact' 'schema-impact review'; do
  grep -Fqi "$phrase" "$traceability" || fail "traceability reference omitted: $phrase"
done
for file in "$spec" "$plan" "$api" "$frontend" "$contracts"; do
  grep -Fqi 'traceability' "$file" || fail "missing traceability guidance: $file"
done
for phrase in '**Status:** Proposed' '**Created:** YYYY-MM-DD' '**Updated:** YYYY-MM-DD' \
  '**Reviewed:** No | YYYY-MM-DD' '**Approval evidence:'; do
  grep -Fq "$phrase" "$spec" || fail "SPEC omitted lifecycle metadata: $phrase"
done
for phrase in 'Traceability for each task group' 'User-flow references' \
  'Approved schema entities' 'Schema impact/review' \
  'API/shared-contract references' 'Frontend surface references' \
  'Validation evidence'; do
  grep -Fq "$phrase" "$plan" || fail "PLAN omitted task-group traceability: $phrase"
done
grep -Fq 'project schema' "$workflow" ||
  fail 'workflow omitted the initial-schema path'
grep -Fq 'applicable foundational documents' "$script_dir/references/workflow.md" ||
  fail 'workflow omitted reviewed user-flow prerequisite'
grep -Fq 'Existing-layout foundation mapping' "$acceptance" ||
  fail 'acceptance scenarios omitted existing-layout validator mapping'
grep -Fq 'initial project schema' "$script_dir/references/feature-lifecycle.md" ||
  fail 'feature lifecycle omitted initial-schema exception'
grep -Fq 'initial project schema' "$script_dir/../schema-design/SKILL.md" 2>/dev/null ||
  fail 'schema-design omitted initial-schema context'
grep -Fq "Status to \`Approved\`" "$feature_lifecycle" ||
  fail 'feature lifecycle omitted explicit SPEC approval transition'
grep -Fq 'selected output' "$workflow" ||
  fail 'workflow omitted selected-output approval mode'
grep -Fq 'new-project-only' "$workflow" ||
  fail 'workflow omitted reconciliation scaffold boundary'
grep -Fq 'initial project schema' "$schema_prompt" ||
  fail 'schema prompt omitted initial-schema branch'
grep -Fq 'persistence is not approved' "$schema_prompt" ||
  fail 'schema prompt omitted no-persistence branch'
grep -Fq 'persistence is not approved' "$spec_prompt" ||
  fail 'SPEC prompt omitted no-persistence branch'
if grep -Fq -- "- Schema reference: \`docs/DB_SCHEMA.md\`" "$user_flow"; then
  fail 'user-flow template retained an unconditional schema reference'
fi
for phrase in 'next?:' 'prev?:' 'limit?:'; do
  grep -Fq "$phrase" "$contracts" ||
    fail "shared contracts omitted cursor field: $phrase"
done
grep -Fq 'next?: string' "$contracts" ||
  fail 'shared contracts omitted optional next cursor shape'
grep -Fq 'prev?: string' "$contracts" ||
  fail 'shared contracts omitted optional previous cursor shape'
if grep -Fq 'string | null' "$contracts" ||
  grep -Fq 'nextCursor' "$contracts" || grep -Fq 'hasMore' "$contracts"; then
  fail 'shared contracts retained the old cursor pagination shape'
fi
[[ -f "$common" ]] || fail 'missing shared project-init shell helper'
for phrase in 'path_has_symlink()' 'escape_output()'; do
  grep -Fq "$phrase" "$common" || fail "shared helper omitted: $phrase"
done
source_line="source \"\$script_dir/common.sh\""
for script in "$script_dir/scripts/init-project.sh" \
  "$script_dir/scripts/inspect-project.sh" \
  "$script_dir/scripts/inventory-project.sh"; do
  grep -Fq "$source_line" "$script" ||
    fail "script does not source the shared helper: $script"
  if grep -Eq '^(path_has_symlink|escape_output)\(\)' "$script"; then
    fail "script redefines a shared helper: $script"
  fi
done
grep -Fq 'test-project-init.sh' "$ci" ||
  fail 'CI omitted the project-init disposable suite'
grep -Fq 'Database Schema: add' "$script_dir/templates/README.md" ||
  fail 'template README retained a dead optional-schema link'
if grep -Fq '[Database Schema](./docs/DB_SCHEMA.md)' "$script_dir/templates/README.md"; then
  fail 'template README still links to absent optional schema'
fi
grep -Fq 'traceability.md' "$script_dir/SKILL.md" ||
  fail 'skill omitted traceability routing'
grep -Fq 'project-profiles.md' "$script_dir/SKILL.md" ||
  fail 'skill omitted project-profile routing'
grep -Fq 'validate-foundation.sh' "$script_dir/SKILL.md" ||
  fail 'skill omitted foundation validator routing'
grep -Fq 'traceability.md' "$script_dir/references/workflow.md" ||
  fail 'workflow omitted traceability routing'
grep -Fq 'Light is the default' "$script_dir/SKILL.md" ||
  fail 'skill omitted the Light default for ordinary iteration'
grep -Fq 'Strict remains the default' "$script_dir/SKILL.md" ||
  fail 'skill omitted the Strict bootstrap exception'
grep -Fq 'Ambiguity resolves to Light' "$workflow" ||
  fail 'workflow omitted lighter-mode ambiguity resolution'
grep -Fq 'already decided or still being explored' "$feature_lifecycle" ||
  fail 'feature lifecycle omitted the discovery gate'
grep -Fq 'does not create a SPEC' "$feature_lifecycle" ||
  fail 'feature lifecycle did not stop exploratory work before SPEC creation'
grep -Fq 'SPEC → spec-review → PLAN' "$workflow" ||
  fail 'workflow omitted the visible review ceremony'
grep -Fq 'Risk-based escalation' "$workflow" ||
  fail 'workflow omitted risk-based escalation'
grep -Fq 'public API/shared contract' "$workflow" ||
  fail 'workflow omitted public-contract escalation'
grep -Fq 'authentication' "$workflow" ||
  fail 'workflow omitted authentication escalation'
grep -Fq 'Approving:' "$workflow" ||
  fail 'workflow omitted high-impact approval acknowledgement'

printf 'ok: project-init traceability contract\n'
