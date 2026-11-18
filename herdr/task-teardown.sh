#!/usr/bin/env bash
# Finish tasks: remove worktree checkouts and close their workspaces. Branches are always kept.
# Shows what would be lost first, and asks again before forcing removal of a dirty checkout.
# Usage: task-teardown.sh [workspace-id | path]...   (defaults to the active workspace)
set -euo pipefail

pause() { [[ -t 0 ]] && read -rsn1 -p 'Press a key to close.'; echo; }

(( $# )) || set -- "${HERDR_ACTIVE_WORKSPACE_ID:?no active workspace}"

tops=() wss=()
for target; do
  if [[ -d $target ]]; then cwd=$target
  else cwd=$(herdr pane list --workspace "$target" | jq -r '.result.panes[0].cwd // empty'); fi
  top=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null) || { echo "Not a git checkout: $target"; echo; continue; }
  # A linked worktree has its own git dir; the main checkout's git dir is the common one.
  if [[ $(git -C "$top" rev-parse --absolute-git-dir) == $(git -C "$top" rev-parse --path-format=absolute --git-common-dir) ]]; then
    echo "$top is the main checkout, not a task worktree; skipped."; echo
    continue
  fi
  ws=$(herdr worktree list --cwd "$top" |
    jq -r --arg p "$top" '.result.worktrees[] | select(.path == $p) | .open_workspace_id // empty')

  echo "Checkout:  $top"
  echo "Branch:    $(git -C "$top" branch --show-current || true) (kept)"
  echo "Progress:  $(cat "$(git -C "$top" rev-parse --path-format=absolute --git-path task-progress)" 2>/dev/null || echo -)"
  echo "Uncommitted changes:"
  git -C "$top" status --short | sed 's/^/  /' | head -20
  echo "Commits not on any remote:"
  git -C "$top" log --oneline HEAD --not --remotes | sed 's/^/  /' | head -20
  if [[ -n $ws ]]; then
    echo "Agents (stopped with the workspace):"
    herdr agent list | jq -r --arg ws "$ws" \
      '.result.agents[] | select(.workspace_id == $ws) | "  \(.agent_status)\t\(.name // .terminal_title_stripped)"'
  fi
  echo
  tops+=("$top") wss+=("$ws")
done

(( ${#tops[@]} )) || { pause; exit 1; }
read -rn1 -p "Remove ${#tops[@]} checkout(s)? [y/N] " answer; echo
[[ $answer == [yY] ]] || exit 0

for i in "${!tops[@]}"; do
  top=${tops[i]} ws=${wss[i]}
  # Closed worktrees have no workspace for herdr to remove; git removes them directly.
  if [[ -n $ws ]]; then remove() { herdr worktree remove --workspace "$ws" "$@" >/dev/null; }
  else remove() { git -C "$top" worktree remove "$@" "$top"; }; fi
  remove 2>/dev/null && continue
  read -rn1 -p "Git refused $top (dirty checkout). Force removal and discard changes? [y/N] " answer; echo
  if [[ $answer == [yY] ]]; then remove --force; fi
done
