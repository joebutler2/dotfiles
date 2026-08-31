# dotfiles

Joe Butler's dotfiles. Structure and bootstrap approach borrowed from
[holman/dotfiles](https://github.com/holman/dotfiles) — topic-based directories,
a single symlink convention, and one bootstrap script. No framework, no
dependencies beyond zsh + git.

## Layout

Each tool gets its own topic directory (`git/`, `zsh/`, `vim/`, `tmux/`, ...).
Any file ending in `.symlink` gets symlinked into `$HOME` by the bootstrap
script, with the `.symlink` suffix stripped and a leading dot added. So:

```
git/gitconfig.symlink   ->  ~/.gitconfig
zsh/zshrc.symlink       ->  ~/.zshrc
vim/vimrc.symlink       ->  ~/.vimrc
tmux/tmux.conf.symlink  ->  ~/.tmux.conf
```

Everything else in a topic directory (helper scripts, `*.zsh` files sourced
by `zshrc`, etc.) is just support code for that topic and isn't symlinked
directly.

## Install

```bash
git clone git@github.com:joebutler2/dotfiles.git ~/dotfiles
cd ~/dotfiles
script/bootstrap
```

`script/bootstrap` is idempotent — safe to re-run any time after adding or
changing files. It:

1. Symlinks every `*.symlink` file into `$HOME` (backing up anything it
   would overwrite into `~/.dotfiles-backup/<timestamp>/`).
2. Offers to install a common set of CLI tools (git, zsh, vim, tmux, tree,
   node, python), picking whatever's native to the platform:
   - **macOS**: `brew bundle` against the `Brewfile`, if Homebrew is
     installed.
   - **Linux**: whichever of `apt-get` / `dnf` / `pacman` is found, installing
     from the matching `linux/packages.*` list.
   If neither applies (no Homebrew on macOS, no recognized package manager
   on Linux, or an unrecognized platform), this step is skipped with a
   warning and everything else still runs.

## Adding something new

1. Put it in the right topic directory (create a new one if the tool doesn't
   have one yet).
2. Name it `<name>.symlink` if it should land directly in `$HOME`.
3. Re-run `script/bootstrap`.

## Adding a CLI tool to install

Add the package name to `Brewfile` (macOS) and to each `linux/packages.*`
file it exists in (package names occasionally differ across apt/dnf/pacman -
e.g. `node` on Homebrew is `nodejs` on apt/dnf). Not every tool needs an
entry in all four lists.

## Why this convention

- **No dependency on a dotfiles manager** (no stow, no chezmoi, no rcm) —
  just a ~30-line shell script, so it works on a fresh machine with nothing
  but git and zsh installed.
- **Topic directories keep related config together** — everything about git
  lives in `git/`, instead of a flat pile of dotfiles at the repo root.
- **`.symlink` suffix makes the mapping to `$HOME` explicit and greppable**,
  rather than relying on a manifest file that can drift out of sync.

## Status

This repo was just scaffolded — the files under each topic are minimal
starting points, not yet a full export of Joe's actual shell/editor/git
config from his machine. Fill in `zsh/aliases.zsh`, `git/gitconfig.symlink`,
etc. with real config as it gets moved over.
