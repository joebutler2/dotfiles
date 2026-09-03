#!/usr/bin/env bash
#
# pi/export-settings.sh — copy the live ~/.pi/agent state that's worth
# sharing back into this repo, so you can review the diff and commit it.
# Never touches auth.json. Safe to re-run.

set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PI_DIR="$HOME/.pi/agent"

info()  { printf '\033[1;34m[pi-export]\033[0m %s\n' "$1"; }
ok()    { printf '\033[1;32m[ok]\033[0m %s\n' "$1"; }
warn()  { printf '\033[1;33m[skip]\033[0m %s\n' "$1"; }

if [ -f "$PI_DIR/settings.json" ]; then
  cp "$PI_DIR/settings.json" "$DOTFILES_ROOT/pi/settings.json"
  ok "exported settings.json (review the diff - strip machine-specific fields like lastChangelogVersion/packages before committing)"
else
  warn "$PI_DIR/settings.json not found"
fi

if [ -d "$PI_DIR/extensions" ]; then
  mkdir -p "$DOTFILES_ROOT/pi/extensions"
  cp "$PI_DIR/extensions"/*.ts "$DOTFILES_ROOT/pi/extensions/" 2>/dev/null || true
  ok "exported extensions/*.ts"
else
  warn "$PI_DIR/extensions not found"
fi

if [ -d "$PI_DIR/skills" ] || [ -d "$HOME/.agents/skills" ]; then
  info "skills are already version-controlled via git in .agents/skills - no export needed"
fi

warn "auth.json not exported (contains secrets) - handle manually if needed"
warn "trust.json not exported (auto-regenerated, low value)"

info "done"
