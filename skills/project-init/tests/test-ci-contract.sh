#!/usr/bin/env bash
set -euo pipefail

test_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$test_dir/../../.." && pwd)"
workflow="$repo_root/.github/workflows/validate.yml"
project_suite="$test_dir/test-project-init.sh"

fail() {
  printf 'not ok: %s\n' "$1" >&2
  exit 1
}

if [[ ! -f "$workflow" ]]; then
  printf 'ok: repository CI workflow absent; local test contracts remain valid\n'
  exit 0
fi

[[ -f "$project_suite" ]] || fail 'missing project-init aggregate test runner'

for child in \
  test-inspect-project.sh \
  test-inventory-project.sh \
  test-init-project.sh \
  test-validate-foundation.sh \
  test-acceptance-scenarios.sh \
  test-reconciliation-scenarios.sh \
  test-skill-audit.sh \
  test-safeguards-contract.sh \
  test-ci-contract.sh; do
  grep -Fq "bash \"\$test_dir/$child\"" "$project_suite" ||
    fail "aggregate project-init suite omits $child"
done

required_steps=(
  'bash validate-skills.sh'
  'bash -n script.sh bin/* skills/project-init/scripts/*.sh skills/project-init/tests/*.sh skills/spec-workflow/tests/*.sh'
  'bash skills/project-init/tests/test-project-init.sh'
  'bash skills/project-init/tests/test-traceability-contract.sh'
  'bash skills/spec-workflow/tests/test-contract.sh'
  'bash skills/spec-workflow/tests/test-cross-skill-contract.sh'
  'bash skills/spec-workflow/tests/test-lifecycle-contract.sh'
  'bash skills/spec-workflow/tests/test-design-completion-contract.sh'
)

for step in "${required_steps[@]}"; do
  count="$(grep -Fc -- "run: $step" "$workflow" || true)"
  [[ "$count" -eq 1 ]] ||
    fail "CI workflow must run exactly once: $step"
done

printf 'ok: CI workflow and aggregate test coverage contract\n'
