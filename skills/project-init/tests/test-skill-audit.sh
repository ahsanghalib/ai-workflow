#!/usr/bin/env bash
set -euo pipefail

test_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$test_dir/../../.." && pwd)"

fail() {
  printf 'not ok: %s\n' "$1" >&2
  exit 1
}

required_skills=(
  project-init
  spec-review
  schema-design
  technical-design
  implement-next
  backend-feature
  frontend-feature
  session-state
  verification-before-completion
  code-review
  review-diff
  repository-research
  source-driven-development
  agent-memory
  product-discovery
  brainstorming
  webapp-testing
)

for skill in "${required_skills[@]}"; do
  [[ -f "$repo_root/skills/$skill/SKILL.md" ]] ||
    fail "missing current required skill entrypoint: $skill"
done

for retired in plan-review plan-consistency-review plan-convergence; do
  [[ ! -e "$repo_root/skills/$retired/SKILL.md" ]] ||
  fail "retired PLAN skill entrypoint was restored: $retired"
done

active_skill_entrypoints=("$repo_root"/skills/*/SKILL.md)
if rg -n -i \
  'plan-review|plan-consistency-review|plan-convergence' \
  "${active_skill_entrypoints[@]}"; then
  fail 'active skill entrypoint routes to a retired PLAN skill'
fi

active_contract_paths=(
  "${active_skill_entrypoints[@]}"
  "$repo_root"/agents/codex/*.toml
  "$repo_root"/agents/opencode/*.md
  "$repo_root/README.md"
  "$repo_root/GLOBAL_AGENTS.md"
  "$repo_root"/skills/project-init/scripts/*.sh
)
if rg -n -i \
  'ready for planning|handoff to project-init|approved PLAN|proposed PLAN|SPEC/PLAN|active SPEC/PLAN|PLAN state|plan lifecycle' \
  "${active_contract_paths[@]}"; then
  fail 'active contract retained a stale PLAN lifecycle assumption'
fi

for legacy_artifact in MASTER_PLAN.md DB_SCHEMA.md USER_FLOW.md \
  PROJECT_ARCHITECTURE.md GENERAL.md BACKEND.md FRONTEND.md DATABASE.md \
  API.md AUTH.md SECURITY.md TESTING.md CONTRACTS.md; do
  if rg -n -F "$legacy_artifact" "${active_contract_paths[@]}"; then
    fail "active contract retained a legacy artifact path: $legacy_artifact"
  fi
done

skill_paths=()
for skill in "${required_skills[@]}"; do
  skill_paths+=("$repo_root/skills/$skill/SKILL.md")
done

if rg -n -i \
  'ready for planning|handoff to project-init|one explicitly approved PLAN|PLAN state|plan lifecycle' \
  "${skill_paths[@]}"; then
  fail 'active skill retained a retired PLAN lifecycle contract'
fi

printf 'ok: current skill audit with retired PLAN routes absent\n'
