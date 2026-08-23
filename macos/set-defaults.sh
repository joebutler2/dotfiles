#!/usr/bin/env bash
# macos/set-defaults.sh — optional, run by hand (not called from bootstrap).
# A handful of low-risk `defaults write` tweaks. Extend as you find ones you want.

set -euo pipefail

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show full path in Finder title bar
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Faster key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

killall Finder >/dev/null 2>&1 || true

echo "macOS defaults applied. Some changes may require logout to take effect."
