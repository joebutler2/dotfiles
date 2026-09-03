#!/usr/bin/env bash
#
# pi/install.sh — bootstrap ~/.pi/agent with this repo's shared settings and
# extensions, without touching auth.json or other machine-local state.
# Idempotent — safe to re-run.

set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PI_DIR="$HOME/.pi/agent"
SETTINGS_SRC="$DOTFILES_ROOT/pi/settings.json"
SETTINGS_DST="$PI_DIR/settings.json"
EXT_SRC="$DOTFILES_ROOT/pi/extensions"
EXT_DST="$PI_DIR/extensions"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d%H%M%S)"

info()  { printf '\033[1;34m[pi-install]\033[0m %s\n' "$1"; }
ok()    { printf '\033[1;32m[ok]\033[0m %s\n' "$1"; }
warn()  { printf '\033[1;33m[skip]\033[0m %s\n' "$1"; }

mkdir -p "$PI_DIR" "$EXT_DST"

link_file() {
  local src="$1" dst="$2"

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    warn "$dst already linked"
    return
  fi

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mkdir -p "$BACKUP_DIR"
    mv "$dst" "$BACKUP_DIR/"
    info "backed up existing $dst -> $BACKUP_DIR/"
  fi

  ln -s "$src" "$dst"
  ok "linked $dst -> $src"
}

link_file "$SETTINGS_SRC" "$SETTINGS_DST"

for ext in "$EXT_SRC"/*.ts; do
  [ -e "$ext" ] || continue
  link_file "$ext" "$EXT_DST/$(basename "$ext")"
done

# auth.json holds API keys & OAuth tokens - never touched by this script.
warn "skipped auth.json (handle secrets manually)"

info "done"
