#!/usr/bin/env bash
#
# claude/install.sh — link this repo's Claude Code hooks into ~/.claude and
# register the SessionStart upstream-check hook in ~/.claude/settings.json,
# without touching any other hooks already configured there (e.g. Orca).
# Idempotent — safe to re-run.

set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"
HOOKS_SRC="$DOTFILES_ROOT/claude/hooks"
HOOKS_DST="$CLAUDE_DIR/hooks"
SETTINGS="$CLAUDE_DIR/settings.json"
FRAGMENT="$DOTFILES_ROOT/claude/session-start-fragment.json"

info()  { printf '\033[1;34m[claude-hooks]\033[0m %s\n' "$1"; }
ok()    { printf '\033[1;32m[ok]\033[0m %s\n' "$1"; }
warn()  { printf '\033[1;33m[skip]\033[0m %s\n' "$1"; }

mkdir -p "$CLAUDE_DIR"
chmod +x "$HOOKS_SRC"/*.sh

if [ -L "$HOOKS_DST" ] && [ "$(readlink "$HOOKS_DST")" = "$HOOKS_SRC" ]; then
  warn "$HOOKS_DST already linked"
elif [ -e "$HOOKS_DST" ]; then
  # Directory already exists (not our symlink) — merge scripts in rather than clobber it.
  cp -n "$HOOKS_SRC"/*.sh "$HOOKS_DST"/
  ok "copied hook scripts into existing $HOOKS_DST"
else
  ln -s "$HOOKS_SRC" "$HOOKS_DST"
  ok "linked $HOOKS_DST -> $HOOKS_SRC"
fi

if ! command -v jq >/dev/null 2>&1; then
  warn "jq not found — install it (brew install jq) then re-run this script to register the hook in $SETTINGS"
  exit 0
fi

[ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"

if jq -e '[.hooks.SessionStart[]?.hooks[]?.command // empty] | any(test("check-upstream\\.sh"))' "$SETTINGS" >/dev/null 2>&1; then
  warn "check-upstream hook already registered in $SETTINGS"
else
  tmp=$(mktemp)
  jq --slurpfile frag "$FRAGMENT" '.hooks.SessionStart = ((.hooks.SessionStart // []) + $frag)' \
    "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"
  ok "registered check-upstream SessionStart hook in $SETTINGS"
fi
