#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

project_init="$repo_root/skills/project-init/SKILL.md"
workflow="$repo_root/skills/project-init/references/workflow.md"
safety="$repo_root/skills/project-init/references/existing-repository-safety.md"
capabilities="$repo_root/skills/project-init/references/capability-matrix.md"
traceability="$repo_root/skills/project-init/references/traceability.md"
spec_workflow="$repo_root/skills/spec-workflow/SKILL.md"
lifecycle="$repo_root/skills/spec-workflow/references/lifecycle-and-approval.md"
implement_next="$repo_root/skills/implement-next/SKILL.md"
verification="$repo_root/skills/verification-before-completion/SKILL.md"
session_state="$repo_root/skills/session-state/SKILL.md"
memory="$repo_root/skills/agent-memory/SKILL.md"
code_review="$repo_root/skills/code-review/SKILL.md"
review_diff="$repo_root/skills/review-diff/SKILL.md"

fail() {
  printf 'not ok: %s\n' "$1" >&2
  exit 1
}

contains() {
  local file="$1" phrase="$2" message="$3"
  grep -Fq "$phrase" "$file" || fail "$message"
}

for file in "$project_init" "$workflow" "$safety" "$capabilities" \
  "$traceability" "$spec_workflow" "$lifecycle" "$implement_next" \
  "$verification" "$session_state" "$memory" "$code_review" \
  "$review_diff"; do
  [[ -f "$file" ]] || fail "missing safeguard contract file: $file"
done

contains "$project_init" 'run the read-only inspector' \
  'project-init lost inspection-before-write guidance'
contains "$project_init" 'Wait for approval before writing' \
  'project-init lost its approval boundary'
contains "$project_init" 'never read, copy, parse, print, or write' \
  'project-init lost secret-value protection'
contains "$project_init" 'never create commits, branches, remotes, pushes' \
  'project-init lost Git and remote mutation protection'
contains "$workflow" 'before proposing writes' \
  'workflow lost pre-write inspection'
contains "$workflow" 'separate approval' \
  'workflow lost separate approval scopes'
contains "$workflow" 'inspect the whole relevant skill graph' \
  'workflow lost relevant-skill-graph inspection'
contains "$workflow" 'current handoff contracts' \
  'workflow lost handoff-contract inspection'
contains "$workflow" 'distinguish user-authored artifacts and source of truth' \
  'workflow lost user/generated artifact distinction'
contains "$workflow" 'smallest coherent set of files' \
  'workflow lost smallest-coherent-edit boundary'
contains "$workflow" 'update tests when a contract changes' \
  'workflow lost contract-test update rule'
contains "$workflow" 'one authoritative source' \
  'workflow lost parallel-source prohibition'
contains "$workflow" 'never silently weaken an existing safety guarantee' \
  'workflow lost safety-preservation rule'
contains "$workflow" 'After each major refactor area' \
  'workflow lost focused-test checkpoint'
contains "$workflow" 'rerun stale-reference searches' \
  'workflow lost stale-reference final check'
contains "$workflow" 'accidental' \
  'workflow lost accidental-dependency final check'
contains "$workflow" 'SPEC metadata database' \
  'workflow lost SPEC metadata-database prohibition'
contains "$workflow" 'mandatory YAML/JSON registry' \
  'workflow lost mandatory-registry prohibition'
contains "$workflow" 'global' \
  'workflow lost global-index prohibition'
contains "$workflow" 'replacement master-plan file' \
  'workflow lost replacement-plan prohibition'
contains "$workflow" 'separate execution-plan file' \
  'workflow lost separate-execution-plan prohibition'
contains "$workflow" 'duplicate state' \
  'workflow lost duplicate-state prohibition'
contains "$workflow" 'GitHub or external services mandatory' \
  'workflow lost mandatory-external-service prohibition'
contains "$workflow" 'particular application tech stack' \
  'workflow lost stack-assumption prohibition'
contains "$workflow" 'frontend/backend/database/auth' \
  'workflow lost capability-assumption prohibition'
contains "$workflow" 'every possible rule file' \
  'workflow lost speculative-rules prohibition'
contains "$workflow" "nested \`AGENTS.md\`" \
  'workflow lost nested-instructions prohibition'
contains "$workflow" 'architecture document by default' \
  'workflow lost default-architecture prohibition'
contains "$workflow" 'blanket schema' \
  'workflow lost blanket-schema-approval prohibition'
contains "$workflow" 'technical-design approval' \
  'workflow lost blanket-design-approval prohibition'
contains "$workflow" 'fabricate' \
  'workflow lost fabrication prohibition'
contains "$workflow" 'delete' \
  'workflow lost useful-legacy preservation prohibition'
contains "$workflow" 'simple Markdown plus executable repository evidence' \
  'workflow lost simple-evidence preference'
contains "$workflow" 'Before creating or requiring any artifact' \
  'workflow lost artifact decision gate'
contains "$workflow" 'durable information the current project actually needs' \
  'workflow lost durable-need question'
contains "$workflow" 'no clearer existing source of truth' \
  'workflow lost clearer-source requirement'
contains "$workflow" 'do not create or require the artifact' \
  'workflow lost no-artifact outcome'
contains "$workflow" 'preserve and reference it' \
  'workflow lost existing-source preservation rule'
contains "$workflow" 'demonstrated durable need' \
  'workflow lost demonstrated-need requirement'
contains "$safety" 'Do not mutate remote' \
  'existing-repository safety lost remote-mutation protection'
contains "$safety" 'Never read secret values' \
  'existing-repository safety lost secret protection'
contains "$safety" 'not a destructive repository migration' \
  'existing-repository safety lost migration boundary'
contains "$safety" 'clearly generated obsolete artifact' \
  'existing-repository safety lost generated-artifact condition'
contains "$safety" 'ownership or safety is uncertain' \
  'existing-repository safety lost uncertain-ownership fallback'
contains "$safety" 'Do not destroy history' \
  'existing-repository safety lost history-preservation boundary'
contains "$capabilities" 'do not infer capability from a tool name' \
  'capability matrix lost capability-detection boundary'
contains "$capabilities" 'Unavailable' \
  'capability matrix lost unavailable-capability fallback'
contains "$traceability" 'source of truth' \
  'traceability lost source-of-truth guidance'
contains "$lifecycle" 'Only the user can approve' \
  'SPEC lifecycle lost user approval ownership'
contains "$lifecycle" 'is not approval' \
  'SPEC lifecycle lost approval anti-inference rule'
contains "$implement_next" 'Select exactly the first unchecked task' \
  'implement-next lost its one-task boundary'
contains "$implement_next" 'red/green/refactor' \
  'implement-next lost its TDD gate'
contains "$implement_next" 'Validation must be fresh for this task' \
  'implement-next lost fresh validation evidence'
contains "$implement_next" 'leave the selected task unchecked' \
  'implement-next lost blocker handling'
contains "$verification" 'final evidence pass' \
  'completion verification lost its final evidence gate'
contains "$verification" 'partial' \
  'completion verification lost partial-result reporting'
contains "$verification" 'untested' \
  'completion verification lost untested-path reporting'
contains "$session_state" 'SESSION_STATE.md' \
  'session-state lost continuity document guidance'
contains "$memory" 'Redact secrets' \
  'agent-memory lost secret-redaction guidance'
contains "$memory" 'one new session capsule' \
  'agent-memory lost meaningful-work capture guidance'
contains "$code_review" 'Remain read-only' \
  'code-review lost read-only boundary'
contains "$code_review" 'not user approval' \
  'code-review lost approval boundary'
contains "$review_diff" 'Do not approve, merge, commit, push, publish, deploy' \
  'review-diff lost mutation boundary'

printf 'ok: useful existing safeguards contract\n'
