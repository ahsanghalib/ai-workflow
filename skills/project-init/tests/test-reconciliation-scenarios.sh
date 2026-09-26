#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
initializer="$script_dir/scripts/init-project.sh"
temp_root="$(mktemp -d)"
trap 'rm -rf "$temp_root"' EXIT

fail() {
  printf 'not ok: %s\n' "$1" >&2
  exit 1
}

backend="$temp_root/backend-only"
mkdir -p "$backend/src/server"
printf '{"name":"backend-only"}\n' > "$backend/package.json"
printf 'export {}\n' > "$backend/src/server/main.ts"
bash "$initializer" "$backend" >/dev/null
[[ ! -e "$backend/docs/rules/frontend.md" ]] ||
  fail 'created frontend rules for backend-only project'
for forbidden in USER_FLOW.md docs/USER_FLOW.md docs/user-flows.md; do
  [[ ! -e "$backend/$forbidden" ]] ||
    fail "created shared flow documentation for backend-only project: $forbidden"
done
[[ -f "$backend/AGENTS.md" ]] || fail 'did not add missing project controls'
grep -Fxq '{"name":"backend-only"}' "$backend/package.json" ||
  fail 'rewrote backend project configuration'

frontend="$temp_root/frontend-added"
mkdir -p "$frontend/apps/web/src"
printf 'web source\n' > "$frontend/apps/web/src/main.tsx"
mkdir -p "$frontend/docs/rules"
printf 'user-owned frontend rules\n' > "$frontend/docs/rules/frontend.md"
bash "$initializer" "$frontend" >/dev/null
[[ -e "$frontend/docs/rules/frontend.md" ]] ||
  fail 'removed an existing frontend rule'
[[ ! -e "$frontend/docs/user-flows.md" ]] ||
  fail 'created shared flow documentation from a frontend signal alone'
grep -Fxq 'user-owned frontend rules' "$frontend/docs/rules/frontend.md" ||
  fail 'rewrote an existing justified frontend rule'

persistence="$temp_root/persistence-added"
mkdir -p "$persistence/migrations" "$persistence/docs/rules" \
  "$persistence/docs/schema"
printf 'migration source\n' > "$persistence/migrations/001-init.sql"
printf 'user-owned database rules\n' > "$persistence/docs/rules/database.md"
printf 'user-owned schema context\n' > "$persistence/docs/schema/context.md"
bash "$initializer" "$persistence" >/dev/null
for forbidden in DB_SCHEMA.md docs/DB_SCHEMA.md; do
  [[ ! -e "$persistence/$forbidden" ]] || fail "created schema artifact: $forbidden"
done
grep -Fxq 'user-owned database rules' "$persistence/docs/rules/database.md" ||
  fail 'rewrote an existing justified database rule'
grep -Fxq 'user-owned schema context' "$persistence/docs/schema/context.md" ||
  fail 'rewrote an existing justified schema document'

monorepo="$temp_root/monorepo"
mkdir -p "$monorepo/apps/api" "$monorepo/apps/web"
printf 'api\n' > "$monorepo/apps/api/README.md"
printf 'web\n' > "$monorepo/apps/web/README.md"
printf '# root routing\n- apps/api owns the API\n- apps/web owns the UI\n' > \
  "$monorepo/AGENTS.md"
bash "$initializer" "$monorepo" >/dev/null
[[ ! -e "$monorepo/apps/api/AGENTS.md" ]] ||
  fail 'created nested API instructions without subtree need'
[[ ! -e "$monorepo/apps/web/AGENTS.md" ]] ||
  fail 'created nested web instructions without subtree need'
grep -Fxq -- '- apps/api owns the API' "$monorepo/AGENTS.md" ||
  fail 'rewrote existing root monorepo routing'
grep -Fxq -- '- apps/web owns the UI' "$monorepo/AGENTS.md" ||
  fail 'lost existing root monorepo routing'

signals="$temp_root/capability-signals"
mkdir -p "$signals/src/api" "$signals/src/auth" "$signals/deployment" \
  "$signals/workers" "$signals/packages/shared" "$signals/ai"
printf 'api signal\n' > "$signals/src/api/main.ts"
printf 'auth signal\n' > "$signals/src/auth/main.ts"
printf 'deployment signal\n' > "$signals/deployment/README.md"
printf 'worker signal\n' > "$signals/workers/README.md"
printf 'shared package signal\n' > "$signals/packages/shared/README.md"
printf 'ai signal\n' > "$signals/ai/README.md"
bash "$initializer" "$signals" >/dev/null
for forbidden in README.md docs/architecture.md docs/decisions \
  docs/user-flows.md docs/schema docs/rules; do
  [[ ! -e "$signals/$forbidden" ]] ||
    fail "created premature project document from capability signals: $forbidden"
done

existing_controls="$temp_root/existing-controls"
mkdir -p "$existing_controls"
printf '# user instructions\n' > "$existing_controls/AGENTS.md"
printf '# user state\n' > "$existing_controls/SESSION_STATE.md"
printf 'keep me\n' > "$existing_controls/README.md"
bash "$initializer" "$existing_controls" >/dev/null
grep -Fxq '# user instructions' "$existing_controls/AGENTS.md" ||
  fail 'rewrote user-owned AGENTS.md'
grep -Fxq '# user state' "$existing_controls/SESSION_STATE.md" ||
  fail 'rewrote user-owned SESSION_STATE.md'
grep -Fxq 'keep me' "$existing_controls/README.md" ||
  fail 'rewrote user-owned README.md'
printf 'ok: project-init progressive reconciliation scenarios\n'
