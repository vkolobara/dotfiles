# WezTerm and Herdr keyboard guide

Both use **Ctrl+B** as the prefix: press it, release it, then press the action key.
When the active local WezTerm pane runs the Herdr client, Ctrl+B goes directly to
Herdr. In other panes, it starts WezTerm's one-second prefix table. Detection runs
on each prefix press, so entering Herdr, switching panes, and detaching do not
leave a window-wide mode behind. Alt+F also passes through while Herdr is active.

**Ctrl+= / Ctrl+-** increase/decrease the WezTerm font everywhere.

| Task | Outside Herdr: WezTerm | Inside Herdr |
| --- | --- | --- |
| Workspace picker | Prefix, t | Prefix, t (fuzzy) or Prefix, w |
| Project sessionizer | Prefix, Shift+T | Prefix, t (projects follow workspaces) |
| New workspace | Prefix, i | Prefix, Shift+N |
| Next / previous workspace | Prefix, n / p | Prefix, w, then Up / Down |
| Find an agent or terminal | — | Prefix, g; / to search, Enter to jump |
| New tab | Prefix, c | Prefix, c |
| Select tab 1–9 | Prefix, 1–9 | Prefix, 1–9 |
| Tab picker / next / previous | Prefix, w | Prefix, n / p |
| Rename tab | Prefix, comma | Prefix, Shift+T |
| Close tab | Prefix, & | Prefix, Shift+X |
| Split right / down | Prefix, / / minus | Prefix, v / minus |
| Focus left / down / up / right | Prefix, h / j / k / l | Prefix, h / j / k / l |
| Resize | Prefix, Shift+H / J / K / L | Prefix, r; follow the resize-mode hints |
| Zoom pane | Alt+F | Prefix, z |
| Close pane | Prefix, x | Prefix, x |
| Copy mode | Prefix, [ | Prefix, [ |
| Detach, keep work running | — | Prefix, q |
| Active keybinding help | — | Prefix, ? |

In WezTerm copy mode, use h/j/k/l to move, v to select, y to copy, and Esc to
leave. In Herdr copy mode, use h/j/k/l, v or Space to select, y or Enter to copy,
and q or Esc to leave. Mouse selection is also available. Herdr's workspace
navigation exits with Esc. Its Go To picker groups terminals and agents by
workspace; use / to search and Enter to jump.

Herdr opens a naming prompt for a new tab or workspace; press Enter to confirm.

Detach with **Ctrl+B, q**. The previous Ctrl+Alt+Q override has been removed.
Run `herdr` to reattach to the default persistent session, or
`herdr session attach NAME` for a named session. Detaching restores WezTerm's
prefix in the outer shell. To move to an outer WezTerm pane while attached, click
that pane; Ctrl+B controls Herdr until you leave its pane or detach.

Detection uses WezTerm's local foreground process information, matching the
`herdr` executable, rather than inherited `HERDR_ENV` values in child shells.
A plain `ssh` connection hides remote processes, and WezTerm mux-domain panes may
not expose foreground information. In those cases, or if process lookup fails,
WezTerm retains its outer shortcuts; automatic remote Herdr routing is not
supported. Remote attachment has not been verified.

References: [WezTerm key tables](https://wezterm.org/config/lua/keyassignment/ActivateKeyTable.html),
[foreground process API](https://wezterm.org/config/lua/pane/get_foreground_process_info.html),
and [Herdr keyboard guide](https://herdr.dev/tui/docs/keyboard/).
