#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
fail() { printf 'not ok: %s\n' "$1" >&2; exit 1; }
contains() {
  local file=$1 token=$2 label=$3
  rg -Fq -- "$token" "$repo_root/$file" || fail "$label: missing '$token' in $file"
}

for skill in backend-feature frontend-feature; do
  contains "skills/$skill/SKILL.md" '## Lightweight completion path' "$skill lightweight path"
  contains "skills/$skill/SKILL.md" 'Use `verification-before-completion`' "$skill lightweight verification"
done

contains skills/linkedin-workspace/references/state-rules.md 'Approval=needs_review' 'revision invalidates approval'
contains skills/linkedin-workspace/references/state-rules.md 'Publish Status=not_ready' 'revision invalidates readiness'
contains skills/linkedin-workspace/references/state-rules.md '`Source Hash`' 'revision hash field matches schema'
contains skills/linkedin-workspace/references/google-sheet-schema.md '| Source Hash |' 'schema hash field'
contains skills/linkedin-visual/SKILL.md '`Type=document`' 'visual PDF type mapping'
contains skills/linkedin-visual/SKILL.md '`Variant=linkedin-pdf`' 'visual PDF variant mapping'
contains skills/linkedin-visual/SKILL.md '`Variant=editable-source`' 'editable source variant mapping'
contains skills/spec-review/SKILL.md 'drafts from `spec-workflow`' 'SPEC review accepts workflow drafts'

printf 'ok: cross-skill contracts\n'
