# Herdr keyboard guide

Herdr runs inside Ghostty, which opens it in the first window. **Ctrl+B** is the
prefix: press it, release it, then press the action key. `Prefix, ?` lists every
active binding. This guide covers the defaults in use plus the custom bindings in
`config.toml`.

## Agents and tasks

| Task | Keys |
| --- | --- |
| Agent picker (preview, prompt, close) | Prefix, a |
| Focus agent 1–9 | Prefix, 1–9 |
| Next / previous agent | Prefix, n / p |
| Jump to the latest notification | Prefix, o |
| New task: worktree, agent, first prompt | Prefix, Alt+N |
| Finish task: remove its worktree, keep the branch | Prefix, Alt+X |

In the agent picker, Enter focuses the agent, Tab marks agents, Ctrl+R sends one
prompt to the marked agents (or the highlighted one), and Ctrl+D closes the
agent's pane. The lower half previews the highlighted agent's recent output.

The new-task prompt takes a branch name, a task title, or a PR (`#123` or its
URL). A PR opens its head branch in a worktree and has Claude run
`/local-review` on it.

## Workspaces, tabs, and panes

| Task | Keys |
| --- | --- |
| Workspace and project picker | Prefix, t (fuzzy) or Prefix, w |
| Next / previous workspace | Prefix, Shift+J / Shift+K |
| New workspace / Git worktree | Prefix, Shift+N / Shift+G |
| Find an agent or terminal | Prefix, Alt+G; / to search, Enter to jump |
| New tab | Prefix, c |
| Select tab 1–9 | Prefix, Alt+1–9 |
| Next / previous tab | Prefix, ] / [ |
| Rename / close tab | Prefix, Shift+T / Shift+X |
| Split right / down | Prefix, v / minus |
| Focus left / down / up / right | Prefix, h / j / k / l |
| Previous pane | Prefix, ; |
| Resize | Prefix, r; follow the resize-mode hints |
| Zoom / close pane | Prefix, z / x |
| Copy mode | Prefix, y |
| Detach, keep work running | Prefix, q |

## Popups

| Tool | Keys |
| --- | --- |
| lazygit | Prefix, g |
| tuicr review of the focused repo | Prefix, d |
| nvim in the focused directory | Prefix, Alt+E |
| k9s | Prefix, Alt+K |

Popups open over the layout and take all input, including Esc, until the tool
exits.

In copy mode, use h/j/k/l, v or Space to select, y or Enter to copy, and q or Esc
to leave. Mouse selection is also available. Herdr opens a naming prompt for a
new tab or workspace; press Enter to confirm.

Run `herdr` to reattach to the default persistent session, or
`herdr session attach NAME` for a named session.

Reference: [Herdr keyboard guide](https://herdr.dev/tui/docs/keyboard/).
