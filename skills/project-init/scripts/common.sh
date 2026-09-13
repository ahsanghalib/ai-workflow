#!/usr/bin/env bash

# Shared helpers for the project-init shell entrypoints.

path_has_symlink() {
  local path="$1" parent
  while [[ "$path" != "/" ]]; do
    if [[ -L "$path" ]]; then
      return 0
    fi
    parent="$(dirname "$path")"
    [[ "$parent" == "$path" ]] && break
    path="$parent"
  done
  return 1
}

escape_output() {
  local value="$1"
  value="${value//\\/\\\\}"
  value="${value//$'\n'/\\n}"
  value="${value//$'\r'/\\r}"
  value="${value//$'\t'/\\t}"
  printf '%s' "$value"
}
