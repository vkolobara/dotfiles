# Development setup with mise

Fish, Ghostty, Herdr, and Neovim configuration for Arch Linux and Apple Silicon macOS.
Mise manages global Go, Python, and Node defaults, shared editor tools, AI CLIs,
and native development packages. Other language toolchains and project-specific CLIs belong
in each repository's mise configuration.

## Preview and install

Install mise using the [official installer](https://mise.jdx.dev/installing-mise.html),
then run these commands from this checkout:

```sh
mise trust
mise run                         # Preview setup
mise run default --apply         # Install tools and deploy configuration
mise run default --brew          # Preview Homebrew packages on Arch
mise run default --brew --apply  # Apply Homebrew packages on Arch
```

Arch uses pacman by default. macOS uses mise's native Homebrew package providers;
Homebrew itself is optional. The `--brew` option selects Homebrew CLI packages on
Arch while retaining its native Ghostty package. Intel Macs are not supported.
macOS needs Xcode command-line tools for compilation.

Mise stops on conflicting configuration files. Move those files aside before
applying. Keep this checkout because deployed symlinks point to it. Setup sets Fish
as the login shell, which can prompt for your password. Log out and back in after
the first installation. Existing nvm or asdf shell initialization must be disabled
separately if it overrides mise.

## Configuration

| File | Responsibility |
| --- | --- |
| `mise.toml` | Shared dotfiles, Linux-only Niri link, setup and check tasks |
| `mise.arch.toml` | Native Arch desktop applications and desktop helpers |
| `mise.macos.toml` | macOS desktop applications |
| `mise.pacman.toml` | Native Arch development packages |
| `mise.homebrew.toml` | Native Homebrew CLI packages and Fish login shell |
| `mise/global.toml` | Runtimes, editor tools, Codex, Claude Code, and Cursor CLI |
| `shell/config.fish` | Shell activation, command paths, history, and navigation |
| `git/config` | Shared Git pager settings; identity stays in `~/.gitconfig` |
| `lazygit/config.yml`, `atuin/config.toml` | Git diff display and history preferences |
| `codex/`, `claude/`, `cursor/` | Selected AI preferences merged into local configuration |
| `agents/AGENTS.md` | One shared source of personal agent instructions |
| `agents/cursor-context.py`, `cursor/hooks.json` | Load shared instructions into local Cursor sessions |
| `ghostty/config.ghostty` | Terminal font and theme; opens Herdr in the first window |
| `systemd/ghostty/override.conf` | Arch: lets the Ghostty user service start reliably for Niri's terminal key |
| `herdr/` | Agent workspace config, pickers, task scripts, and the PR status plugin ([keys](herdr/KEYBOARD.md)) |

Fish, Neovim, Ghostty, Herdr, and the global mise configuration are linked on both
platforms. Niri is linked only on Linux, using an explicit OS selector. Niri and
DMS must already be installed; this setup does not install or start desktop
services. Monitor layout and other DMS-generated settings remain machine-specific
files in the Niri configuration. Arch setup installs `wl-clipboard` for Neovim;
fonts are installed and configured by Arch setup.

### Fonts on Arch

Programming uses SauceCodePro Nerd Font Mono, including in Ghostty and the
desktop monospace setting. Terminal Neovim inherits Ghostty's font. Desktop text
uses Adwaita Sans, documents use Noto Sans, and the generic serif family uses
Noto Serif. Fontconfig adds Nerd Font symbols, Noto language coverage (including
CJK), and color emoji as fallbacks. Applications and websites that select their
own fonts may override these defaults.

Arch setup installs the font packages and applies these settings. To reapply
only font settings after installing the declared packages:

```sh
mise -E arch run fonts
```

The font task merges GTK and Qt font settings, preserving other settings and
backing up changed files under `~/.local/state/dotfiles/backups/fonts-*`.
DMS font keys are merged through mise; its other settings stay local. Restart
open applications after applying. Qt font settings apply to applications using
qt5ct/qt6ct; other applications can use Fontconfig or desktop portal settings.
macOS font installation and desktop defaults are not managed here.

Verify the desktop settings merge with `python3 -m unittest discover -s fonts`.

Rofi, SwayNC, Newsboat, tmux, and Bash/Zsh configuration are no longer maintained
here. Removing declarations does not uninstall existing applications or tools.
Historical package snapshots in `docs/inventory/` are reference material only.

## Theme

Kanagawa Wave is used across terminal apps and the Linux desktop. DMS provides
Wave for dark mode and Lotus for light mode, and generates GTK, Qt/KDE, and Niri
colors. Neovim, Ghostty, and Herdr use native Kanagawa themes.

After installing packages, run `mise run theme` to deploy and refresh the theme.
DMS must already be running on Linux. Restart applications that cache colors;
a new login applies the Qt session environment everywhere. See
[theme sources and deployment notes](themes/README.md) for coverage and rollback.

## Desktop applications

Both platforms install Firefox, Bitwarden, and mpv through native package
providers. Arch uses pacman for desktop applications even with `--brew`;
macOS uses Homebrew casks for Firefox and Bitwarden and a formula for mpv.
Arch also installs Dolphin, xdg-utils, pavucontrol, playerctl, brightnessctl,
grim, and slurp for file management, desktop integration, audio and media
controls, brightness controls, and screenshots. Browser profiles,
password vaults, and application sign-ins remain local.

## Developer utilities and AI CLIs

Native packages provide GitHub CLI (`gh`), Lazygit, Delta, btop, just, bat, and
Mike Farah's yq. Arch calls the latter package `go-yq`; Homebrew calls it `yq`.
Git and Lazygit use Delta for diffs. Fish sets `EDITOR` and `VISUAL` to `nvim`,
and keeps legacy standalone Atuin behind package-manager binaries on PATH.

Mise installs `codex`, `claude-code` (the `claude` command), and `cursor-agent`.
The `agent` launcher also runs mise's Cursor CLI. Cursor desktop is a separate,
optional installation. Sign in interactively when setting up a new machine.

AI preferences use mise's partial-file merges. Model and interface preferences
are defaults applied only when missing, so choices made in the applications
survive setup. Plugin state, project trust, permissions, credentials, and caches
stay local. Claude's background updater is disabled; Fish's `cursor-agent`
function and the `agent` launcher pass `--disable-auto-update` so mise owns CLI
updates. Outside Fish, pass that flag when invoking `cursor-agent` directly.

Edit `agents/AGENTS.md` to change personal instructions for all three local
agents. Mise links that same source to `~/.codex/AGENTS.md`,
`~/.claude/CLAUDE.md`, and `~/.config/agents/AGENTS.md`. Cursor's user-level
`sessionStart` hook reads the latter and returns it as `additional_context`.
It uses Python already supplied by the setup. Repository instructions still
hold project-specific rules; personal instructions are not copied into each
repository. Local instructions and hooks do not travel to remote cloud agents.

The shared file contains the always-active communication and coding defaults.
There is no startup skill to load. Task-specific workflows remain skills and
load only when relevant. Caveman, Karpathy, and Ponytail are not startup
dependencies; their installed packages remain available when requested.

Shared skills live in `agents/skills/`. Mise links individual skill directories
into `~/.agents/skills/` for Codex and Cursor and `~/.claude/skills/` for Claude
Code, preserving other installed skills. If a client's catalog does not list a
skill, check that its symlink resolves to a directory containing `SKILL.md`.
Restart agent sessions after deployment to refresh discovery and startup
instructions.

Keep each skill portable: use standard `name` and `description` frontmatter,
plain Markdown, and relative paths to supporting files. Explicit-only skills
also use `disable-model-invocation: true` for Claude Code and Cursor, and
`policy.allow_implicit_invocation: false` in `agents/openai.yaml` for Codex.
Keep models, permissions, MCP servers, and interface settings in each client's native
configuration. Link individual skill directories rather than replacing an
entire client skills directory, so other installed skills remain intact.
Cursor also scans Claude skill locations; verify that shared skills do not
appear twice after a client update before adding more discovery paths.

To add a shared skill, create `agents/skills/<name>/SKILL.md` and add individual
symlink entries under `[dotfiles]` in `mise.toml` for `~/.agents/skills/<name>`
and `~/.claude/skills/<name>`. Both links should target the same source directory.

The remaining skills load only when relevant:

| Skill | Purpose |
| --- | --- |
| `investigate` | Reproduce unexpected behavior and establish its cause before fixing it |
| `local-review` | On request, review changes and write local draft findings in tuicr |
| `local-review-fix` | On request, apply the feedback left in tuicr after user review |
| `simplify-change` | Simplify selected code while preserving behavior |
| `prepare-pr` | Verify the final change and prepare a PR draft or requested publication |
| `handoff` | Capture current state, evidence, and the next action for another agent |
| `herdr` | Control Herdr when explicitly requested from a Herdr-managed pane |

The review workflow uses tuicr, installed through mise. Invoke
`/local-review current branch against master`, `/local-review uncommitted changes`, or
`/local-review PR <URL>` (use `$local-review` in Codex). The agent reviews the specified
comparison and records findings as local draft comments in a matching tuicr
session. Open the reported tuicr command, edit or delete comments, then invoke
`/local-review-fix` (`$local-review-fix` in Codex) to apply the remaining feedback. Neither
skill runs automatically or publishes comments to the forge. Review fixes
leave the comments in place and report what was addressed.

These skills replace `review` and `review-fix` (previously `review-change`). When migrating an existing installation,
remove the old `review`, `review-fix`, and `review-change` symlinks under
`~/.agents/skills` and `~/.claude/skills` if they point into this checkout, then
deploy the new links and restart agent sessions.

Update Codex and Claude through mise:

```sh
mise upgrade --global codex claude-code
```

Cursor is pinned to the previously installed `2026.09.18-9a7762b` release because
the newest release was inside mise's 24-hour release delay during migration.
Update its version in `mise/global.toml` deliberately rather than bypassing the
release delay. Existing standalone launchers and config copies from this
machine's migration are backed up under `~/.local/state/dotfiles/backups/`.

## Repository tools and Neovim

Global runtimes work outside this checkout. A repository's `mise.toml` can override
their versions and declare other runtimes, language servers, formatters, and CLIs:

```sh
mise use <tool>@<version>  # Run inside the repository that needs the tool
```

Kubernetes tools kubectl, k9s, Helm, and kubeseal are declared in
`mise/global.toml` and available in every directory. Setup installs these tools
automatically; Fish activation and mise shims make their commands available
without `mise exec` or separate `mise use` commands. Add other globally available
tools to the same file. Repository configurations can override their versions.
Keep system Python and other native runtimes required by OS packages; review
package dependencies before uninstalling native copies.

Neovim uses `vim.pack` for plugins and Mason for language server installation.
Use `:Mason` or `:LspInstall` to install servers inside Neovim. Mason-installed
servers are automatically enabled, and the configured server list also supports
externally installed servers. Servers attach when a matching file and project
root are found. Mason's executables take precedence inside Neovim; mise shims
remain available for external tools, including global gopls and Ruff. Start
Neovim from the project's activated shell so its runtimes are available.

Treesitter parsers update when its plugin updates, rather than on every editor
launch. On a new machine, install the parsers you need with `:TSInstall <language>`.
Parser compilation needs a C compiler and the Treesitter CLI.

Podman is a native package, installed through pacman on Arch or Homebrew when
selected. On Arch, the command is `/usr/bin/podman`. Initialize and start its VM
separately on macOS:

```sh
podman machine init
podman machine start
```

Setup does not start containers, create VMs, or change Kubernetes contexts.

## Verification

```sh
mise run test                    # Validate tasks and theme deployment
mise run check                   # Check the default platform/provider
mise run check --brew            # Check the Homebrew selection on Arch
mise -E arch,pacman tasks validate
mise -E arch,homebrew tasks validate
mise -E macos,homebrew tasks validate
```

After installation, open a new Fish shell and check command selection:

```fish
mise ls
mise which go
mise which python
mise which node
type -a go python node gopls ruff codex claude cursor-agent agent
command -s atuin podman
printf 'EDITOR=%s VISUAL=%s\n' "$EDITOR" "$VISUAL"
```

Verify language server attachment and formatting in Neovim, then run `podman info`
when ready to use containers. Preview and temporary-home dotfile checks do not
prove package installation on macOS; test installation on the target machine.
