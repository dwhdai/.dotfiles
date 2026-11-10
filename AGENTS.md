# AGENTS.md

Personal dotfiles for macOS, managed with GNU Stow. The repo lives at `~/.dotfiles`, so Stow's default target is `$HOME`.

## Making config changes

All config changes must be made in this repo, then deployed to the system-wide location with GNU Stow. Never edit the deployed copy under `$HOME` (for example `~/.config/nvim/init.lua` or `~/.zshrc`) directly, even when it is a symlink back into this repo.

1. Edit or add the file inside its package, e.g. `nvim/.config/nvim/init.lua`.
2. From the repo root, preview the result: `stow -n -v <package>`.
3. Deploy it: `stow -R <package>`.

Edits to files that are already symlinked take effect immediately. Restowing is still required when a file is added, moved, or removed, and for a package that has not been stowed yet.

## Package layout

Each top-level directory is a Stow package that mirrors `$HOME`, so `<package>/.config/foo/bar` is linked to `~/.config/foo/bar`.

Packages: `aerospace`, `borders`, `claude`, `codex`, `ghostty`, `harlequin`, `herdr`, `herdr-app`, `nvim`, `tmux`, `wezterm`, `zsh`.

These are not Stow packages, so do not stow them:

- `scripts/`: on `PATH` directly. New scripts need `chmod +x`.
- `Brewfile`: install with `brew bundle`.
- `.claude/`: Claude Code settings for working in this repo only. System-wide Claude Code config belongs in the `claude` package.

## Stow conflicts

Every package is stowed, so `stow -n -v <package>` should report nothing to do unless files were added, moved, or removed.

If Stow reports a conflict, a real file exists at the target, usually because an app replaced its symlink. Stop and compare it with the repo version, because the file in `$HOME` may hold settings that are missing here. Move anything worth keeping into the repo, and only then replace the file with a symlink.

Do not run `stow --adopt` without reviewing the result, since it overwrites the repo's file with the one from `$HOME`.

## Repo rules

- This repo is public. Never commit secrets, tokens, or internal infrastructure identifiers. Read secrets at runtime instead, e.g. from the macOS keychain.
- Machine-local shell exports go in `~/.zshrc.local`, which `.zshrc` sources and which stays out of the repo.
- Apps write through symlinks, so settings changed in an app show up here as uncommitted diffs. Review them before committing, and keep app-generated state out of tracked files.
- If you notice anything in the repo that breaks these rules, such as a committed identifier or a gitignored file that should be tracked, tell the user, even when it is outside the current task.
- `herdr` and `herdr-app` directories contain runtime state. `.gitignore` tracks only the hand-edited files, so check it when adding new ones.
