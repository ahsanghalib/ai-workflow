#!/usr/bin/env bash
set -euo pipefail

test_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skill_dir="$(cd "$test_dir/.." && pwd)"
spec_template="$skill_dir/../spec-workflow/references/spec-template.md"
project_spec_template="$skill_dir/templates/docs/templates/spec.md"
user_flows_template="$skill_dir/templates/docs/user-flows.md"
traceability="$skill_dir/references/traceability.md"
conditional="$skill_dir/references/conditional-documents.md"
existing_safety="$skill_dir/references/existing-repository-safety.md"
source_of_truth="$skill_dir/references/source-of-truth.md"
workflow="$skill_dir/references/workflow.md"
architecture_template="$skill_dir/templates/docs/architecture.md"
schema_context="$skill_dir/templates/docs/schema/context.md"
adr_template="$skill_dir/templates/docs/decisions/adr.md"
skill="$skill_dir/SKILL.md"

fail() {
  printf 'not ok: %s\n' "$1" >&2
  exit 1
}

[[ -f "$traceability" ]] || fail 'missing traceability reference'
[[ -f "$conditional" ]] || fail 'missing conditional-document reference'
[[ -f "$existing_safety" ]] || fail 'missing existing-repository safety reference'
[[ -f "$source_of_truth" ]] || fail 'missing source-of-truth reference'
[[ -f "$workflow" ]] || fail 'missing project-init workflow reference'
[[ -f "$spec_template" ]] || fail 'missing SPEC template'
[[ -f "$project_spec_template" ]] || fail 'missing project SPEC template'

for phrase in 'User-flow references' 'Schema references' 'Schema impact'; do
  grep -Fq "$phrase" "$traceability" ||
    fail "traceability reference omitted: $phrase"
done

for phrase in 'architecture.md' 'decisions/adr.md' 'docs/decisions/<adr>.md' \
  'user-flows.md' 'schema/context.md' 'rules/*.md'; do
  grep -Fq "$phrase" "$conditional" ||
    fail "conditional-document reference omitted: $phrase"
done

for file in \
  "$architecture_template" \
  "$user_flows_template" \
  "$skill_dir/templates/docs/schema/context.md" \
  "$adr_template" \
  "$skill_dir/templates/docs/rules/api.md" \
  "$skill_dir/templates/docs/rules/contracts.md"; do
  [[ -f "$file" ]] || fail "missing retained template: $file"
done

if ! grep -Fq 'not a prerequisite for SPEC' "$user_flows_template" ||
  ! grep -Fq 'creation or implementation' "$user_flows_template"; then
  fail 'user-flow template made shared flows a SPEC prerequisite'
fi
grep -Fqi 'feature-specific behavior belongs' "$user_flows_template" ||
  fail 'user-flow template lacks feature-SPEC ownership boundary'
if grep -Fq '## Approval Gates' "$user_flows_template"; then
  fail 'user-flow template retained a separate approval-gate section'
fi
if ! grep -Fq 'does not approve feature' "$user_flows_template" ||
  ! grep -Fq 'scope or implementation' "$user_flows_template"; then
  fail 'user-flow template lacks feature-approval boundary'
fi
grep -Fq 'README + AGENTS' "$architecture_template" ||
  fail 'architecture template lacks conditional-complexity boundary'
grep -Fq 'consequential decision' "$adr_template" ||
  fail 'ADR template lacks consequential-decision boundary'
if grep -Eq 'USER_FLOW\.md|PROJECT_ARCHITECTURE\.md' \
  "$spec_template" "$project_spec_template"; then
  fail 'SPEC template retained a global flow or architecture prerequisite'
fi

grep -Fq 'Avoid duplicate sources of truth' "$conditional" ||
  fail 'conditional-document reference lacks duplicate-source boundary'
for phrase in 'existing/reconciliation' 'source code, configuration' \
  'useful current conventions' 'do not churn files' \
  'Do not rename or delete legacy documents automatically' \
  'Never read secret values' '.env' \
  'stop requiring them' 'Do not automatically delete them' \
  'ownership by this skill system is unambiguous' \
  'migration is demonstrably safe' \
  'no useful user-authored information will be lost' \
  'Do not mutate remote' \
  'deployment, or publishing state without explicit authorization'; do
  grep -Fq "$phrase" "$existing_safety" ||
    fail "existing-repository safety omitted: $phrase"
done
for artifact in MASTER_PLAN.md DB_SCHEMA.md USER_FLOW.md \
  PROJECT_ARCHITECTURE.md docs/plans/ docs/reviews/; do
  grep -Fq "$artifact" "$existing_safety" ||
    fail "existing-repository safety omitted legacy artifact: $artifact"
done
grep -Fq 'do not duplicate tables, fields, or constraints' \
  "$architecture_template" ||
  fail 'architecture template lacks data-model duplication boundary'

grep -Fq 'Do not copy every table, column, type, constraint, or index' \
  "$schema_context" ||
  fail 'schema-context template omitted executable-schema reference boundary'
if grep -Fq 'Repeat this section for every approved entity or table' \
  "$schema_context"; then
  fail 'schema-context template still encourages full schema duplication'
fi
grep -Fq 'does not approve a feature or create a second schema' "$schema_context" ||
  fail 'schema-context template lacks second-approval boundary'
grep -Fq 'approved SPEC' "$schema_context" ||
  fail 'schema-context template lacks SPEC approval boundary'
if grep -Fq 'User reviewed the proposed schema' "$schema_context" ||
  grep -Fq '## Approval Gates' "$schema_context"; then
  fail 'schema-context template still creates a blanket schema approval gate'
fi

grep -Fq 'Persisted-data source precedence' "$source_of_truth" ||
  fail 'source-of-truth reference omitted persisted-data precedence'
grep -Fq 'executable sources as the structural source' "$source_of_truth" ||
  fail 'source-of-truth reference omitted executable-source preference'
grep -Fq 'secondary context' "$source_of_truth" ||
  fail 'source-of-truth reference omitted Markdown context boundary'
grep -Fq 'Do not silently resolve conflicts' "$source_of_truth" ||
  fail 'source-of-truth reference omitted conflict reporting rule'

grep -Fq '# Execution' "$spec_template" ||
  fail 'SPEC template omitted execution boundary'
grep -Fq 'Task rules' "$project_spec_template" ||
  fail 'project SPEC template omitted task rules'
grep -Fq 'do not need to be' "$project_spec_template" ||
  fail 'project SPEC template omitted local task identity rule'
if ! grep -Fq 'insert above' "$project_spec_template" ||
  ! grep -Fq '# Execution' "$project_spec_template"; then
  fail 'project SPEC template still forces optional contract sections'
fi
project_contract="$(awk '/^# Execution$/ { exit } { print }' "$project_spec_template")"
if grep -Eq '^## (Context / Evidence|Non-goals|Constraints|Impact|Open Questions)$' \
  <<<"$project_contract"; then
  fail 'project SPEC template forces optional contract sections'
fi
grep -Fq 'Do not create a separate planning or execution document' \
  "$project_spec_template" ||
  fail 'project SPEC template permits parallel planning artifacts'
grep -Fq 'explicit user approval' "$skill_dir/references/feature-lifecycle.md" ||
  fail 'feature lifecycle omitted explicit approval gate'
grep -Fq 'same SPEC' "$skill_dir/references/feature-lifecycle.md" ||
  fail 'feature lifecycle omitted same-SPEC execution rule'
grep -Fq 'conditional-document' "$skill" ||
  fail 'project-init omitted conditional-document routing'
for phrase in 'background jobs' 'repository-wide knowledge or routing' \
  'already represented clearly' 'smallest appropriate artifact' \
  'If no, do nothing'; do
  grep -Fq "$phrase" "$workflow" ||
    fail "reconciliation decision rule omitted: $phrase"
done
grep -Fq 'background' "$skill" ||
  fail 'project-init entrypoint omitted background-job signal'
grep -Fq 'already represented' "$skill" ||
  fail 'project-init entrypoint omitted representation check'

if rg -n -i 'plan-review|plan-consistency-review|create-plan|review-plan|define-master-plan' \
  "$skill_dir/references" "$skill_dir/templates"; then
  fail 'retained project-init resources still route the removed PLAN workflow'
fi

printf 'ok: project-init traceability and conditional-document contract\n'
