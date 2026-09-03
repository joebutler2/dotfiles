# Dotfiles — Pi Config Support Plan

Support configuring `~/.pi/agent` via the dotfiles repo, following the existing pattern from `dotfiles/claude/install.sh`.

---

## Goal

- **Install**: Run `./dotfiles/pi/install.sh` to bootstrap `~/.pi/agent/settings.json`, `.agents/skills/`, and local extensions
- **Export**: Run `./dotfiles/pi/export-settings.sh` to save current live settings + skills list into version control
- **Protect**: Never track secrets — `auth.json` is ignored

---

## Scope

| File / directory | Purpose              | Handled by?          | Safe for git? |
| ---                | ---                  | ---                  | ---           |
| `~/.pi/agent/settings.json` | Defaults (model, compaction, steering, TUI, themes) | install + export | ✅ yes |
| `~/.agents/skills/`         | Installed skills (.md + manifests)     | **already** version-controlled via git; no dotfiles action needed | ✅ yes |
| `extensions/orca-*.ts`      | Local extension configs                | install (symlink)    | ✅ yes |
| `~/.pi/agent/auth.json`     | API keys & OAuth tokens                | .gitignore in PI section only | ❌ NO - sensitive |
| `trust.json`            | Project trust decisions                  | optional export; auto-generated   | ✅ yes (low value) |

---

## Structure to create

```
dotfiles/pi/
├── PLAN.md                       ← this
├── install.sh                    ← idempotent setup script, mirrors claude/install.sh pattern
│                                     - symlinks settings.json → ~/.pi/agent/settings.json
│                                     - backs up existing (with timestamped dir)
│                                     - symlinks extensions/*.ts into ~/.pi/agent/extensions/
│                                     - skips auth.json entirely
├── export-settings.sh           ← copy live state → dotfiles repo
│                                     - exports ~/.pi/agent/settings.json
│                                     - lists installed skills (from .agents/skills and skill-lock)
│                                     - records extension files used
│                                     - prints skip warnings for auth.json, trust.json auto-regenerate
├── settings.json                ← pared-down default settings
│                                   - only shared/common defaults: model, themes, TUI mode, steering behavior, compaction
│                                   No project-specific entries (those belong in repo-level .pi/settings)
└── extensions/                  ← symlinks to ~/.pi/agent/extensions/
    ├── orca-agent-status.ts
    ├── orca-prefill.ts
    └── orca-titlebar-spinner.ts
```

---

## Gitignore additions (root of `dotfiles/`)

Add a PI section that documents what **should not** be tracked if any were accidentally added:

```gitignore
# ---------------------------------------------------------------
# Pi coding agent — do NOT track sensitive files
# auth.json contains API keys & OAuth tokens. Handle manually.
.pi/agent/auth.json
```

Note: `.pi` isn't currently a gitignored pattern in this repo, but it's a common convention. Just a reminder to add if the repo ever grows one.

---

## `settings.json` contents — pared default (to be confirmed)

Based on your current live config:

| Setting | Current value | Keep? |
| --- | --- | --- |
| `model` | `"sonnet"` | ✅ keep as global default |
| `effortLevel` | `"low"` | ✅ keep — sensible baseline |
| `modelSettings.claude-sonnet-5.effortLevel` | `"low"` | ❌ move to repo-level |
| `tui` | `"fullscreen"` | ✅ keep if you always prefer fullscreen |
| `voiceEnabled` | `false` | ✅ keep, prevents accidental voice mode onboarding prompts |
| `modelSettings.*.effortLevel: "high"` | — | ❌ don't put in defaults |
| `autoMode.environment` | — | ❌ highly project-specific; repo-level only |

The pared-down default should focus on UI/behavior, not per-model tuning or org/network context that belongs in AGENTS.md.

---

## Implementation checklist (DONE)

- [x] Create `dotfiles/pi/` directory structure
  - [x] Write `install.sh` (mimic claude/install.sh idempotent pattern)
  - [x] Write `export-settings.sh`
  - [x] Pared-down `settings.json` (only `theme` — live config no longer had
        `effortLevel`/`tui`/`voiceEnabled` by the time this was implemented;
        re-review if you want those back)
  - [x] Symlinked `extensions/*.ts` files
- [x] Add PI section to `.gitignore` mentioning auth.json
- [x] Wired `pi/install.sh` into `script/bootstrap`
