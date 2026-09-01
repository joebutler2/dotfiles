# 1. Don't use pyenv for Python version management

## Status

Accepted — 2026-09-01

## Context

`toolchain.zsh` had an unconditional `eval "$(pyenv init - zsh)"` left over
from a pre-dotfiles `~/.zshrc` migration. pyenv was never actually installed
on this machine, so every new shell printed:

```
toolchain.zsh:22: command not found: pyenv
```

This prompted a review of what we actually want managing Python versions,
given the tool sprawl in the Python ecosystem (pyenv, uv, poetry, conda,
mise, ...).

- **pyenv** is a Python-only version manager. Same design as rbenv: shims on
  `PATH` plus a shell hook that must be eval'd on every shell startup. It only
  switches interpreter versions — packaging/venvs are still someone else's
  job (pip, poetry, uv, ...).
- **uv** (Astral) is a fast, single-binary tool that covers Python version
  installation, virtualenvs, and package/dependency management together, with
  no shell shims or startup hook required. Already installed on this machine
  at `/opt/homebrew/bin/uv`.
- **mise** is a polyglot version manager (Node, Ruby, Java, Python, etc.)
  already wired into `toolchain.zsh` and explicitly called out there as the
  intended long-term replacement for sdkman. It's the one place we already
  manage per-project tool versions consistently.

Installing pyenv on top of uv + mise would be a third, overlapping layer for
the same job (Python version selection), with no capability it uniquely
provides here.

## Decision

We will not install or configure pyenv. Instead:

- **Python version management** goes through **mise** (`mise use python@...`
  per project), consistent with how we already manage other language
  runtimes.
- **Package/dependency management and virtualenvs** go through **uv**
  (`uv venv`, `uv pip ...`, `uv run`, etc.).

The dead `pyenv init` block has been removed from `zsh/toolchain.zsh`.

## Consequences

- New shells no longer error on `pyenv: command not found`.
- Anyone wanting a pinned Python version per project should add it via mise
  (`mise use python@3.x`), not via a `.python-version` file tied to pyenv.
- If a strong need for pyenv-specific behavior ever comes up, revisit this
  ADR rather than silently re-adding the eval hook.
