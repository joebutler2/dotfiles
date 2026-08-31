#!/usr/bin/env bash
# SessionStart hook: warns if the current repo is behind/ahead of its upstream.
# Safe no-op outside a git repo or without a configured upstream.

set -uo pipefail

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

git fetch --quiet origin >/dev/null 2>&1 || exit 0

upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null) || exit 0

behind=$(git rev-list --count 'HEAD..@{u}' 2>/dev/null || echo 0)
ahead=$(git rev-list --count '@{u}..HEAD' 2>/dev/null || echo 0)

if [ "$behind" -gt 0 ]; then
  echo "⚠️  Local branch is $behind commit(s) behind $upstream — run 'git pull' before starting work."
fi
if [ "$ahead" -gt 0 ]; then
  echo "ℹ️  Local branch is $ahead commit(s) ahead of $upstream (unpushed work)."
fi

exit 0
