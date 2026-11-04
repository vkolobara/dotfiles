# Kanagawa

Kanagawa Wave is the default dark palette. DMS also provides Kanagawa Lotus
for light mode; terminal applications deliberately stay on Wave.

## Sources

- `kanagawa.tmTheme`, Fish settings, and the WezTerm palette come from
  [rebelot/kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim), MIT licensed.
  The WezTerm palette was converted from Lua to TOML. Its cursor setting stays
  in `wezterm.lua`. See `LICENSE.kanagawa`.
- `dms/themes/kanagawa.json` adapts the `kanagawaWl` 1.0.0 theme by wirus from
  [the DMS registry](https://github.com/AvengeMedia/dms-plugin-registry/tree/master/themes/kanagawa-wl).
  Its dark palette uses cream text, Oni Violet (`#957fb8`) highlights, and
  subtly purple containers (`#2b2738` for the DMS bar). Terminal palettes retain
  the original Wave colors.
- `k9s/skins/kanagawa.yaml` comes from
  [derailed/k9s](https://github.com/derailed/k9s/blob/master/skins/kanagawa.yaml),
  Apache-2.0 licensed. See `k9s/LICENSE`.
- Atuin, Lazygit, btop, fzf, Delta, and Claude use mappings of Kanagawa's palette.
  Herdr uses its built-in Kanagawa theme.

## Deployment

Run `mise run theme` to deploy the dotfiles, apply the remaining theme keys,
rebuild bat/Delta's syntax cache, and select DMS dark mode on Linux. DMS must
already be running for the last step. On Linux this loads `mise.arch.toml`;
macOS loads `mise.macos.toml` and skips desktop configuration.

`apply.py` preserves other settings and comments in bat, btop, Qt, KDE, and GTK
configuration. It supports `--dry-run`, respects `XDG_CONFIG_HOME`, and backs up
changed existing files under `$XDG_STATE_HOME/dotfiles/backups/kanagawa-*`
(default `~/.local/state/dotfiles/backups/`). Mise manages the JSON/TOML/YAML
merges separately. Re-running the deployment leaves matching settings alone.

DMS owns generated GTK, Qt/KDE, and Niri colors. Its Neovim and WezTerm templates
are disabled so native Kanagawa themes remain authoritative. The unused Hyprland
template is disabled for this Niri desktop; stale Hyprland config links must not
block theme generation. On Arch, install
`adw-gtk-theme` and `qt6ct` through the normal setup before refreshing DMS colors:

```sh
sudo pacman -S --needed adw-gtk-theme qt6ct
mise run theme
```

Run `mise run test` for deployment regression tests and task validation.

New Qt applications launched by Niri use qt6ct; log out and back in to propagate
`environment.d` to the rest of the session. Restart GTK/Qt applications that
retain old colors. Open a new Fish shell for shell colors; restart Neovim and
AI CLIs for their selected themes. In a Herdr pane, run
`herdr server reload-config` to refresh its UI.

Claude uses a custom Kanagawa theme with the ANSI dark preset as its base.
Cursor CLI detects the host terminal's dark background; its documented settings
do not offer a custom Kanagawa palette.

To restore a previous theme, change the tracked selectors and redeploy. Restore
individual INI/CSS files from the timestamped backup if needed. Existing Moonfly
and other WezTerm palette files remain available.
