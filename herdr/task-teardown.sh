#!/usr/bin/env bash
# Finish a task: remove the active worktree workspace's checkout. The branch is always kept.
# Shows what would be lost first, and asks again before forcing removal of a dirty checkout.
# Usage: task-teardown.sh [workspace-id]   (defaults to the active workspace)
set -euo pipefail

ws=${1:-${HERDR_ACTIVE_WORKSPACE_ID:?no active workspace}}
cwd=$(herdr pane list --workspace "$ws" | jq -r '.result.panes[0].cwd // empty')
top=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null) || { echo "Not a git checkout: $cwd"; read -rn1; exit 1; }

# A linked worktree has its own git dir; the main checkout's git dir is the common one.
if [[ $(git -C "$top" rev-parse --absolute-git-dir) == $(git -C "$top" rev-parse --path-format=absolute --git-common-dir) ]]; then
  echo "$top is the main checkout, not a task worktree."
  read -rn1 -p 'Press a key to close.'
  exit 1
fi

branch=$(git -C "$top" branch --show-current)
echo "Workspace: $(herdr workspace get "$ws" | jq -r '.result.workspace.label')"
echo "Checkout:  $top"
echo "Branch:    ${branch:-detached} (kept)"
echo
echo "Uncommitted changes:"
git -C "$top" status --short | sed 's/^/  /' | head -20
echo "Commits not on any remote:"
git -C "$top" log --oneline HEAD --not --remotes | sed 's/^/  /' | head -20
echo "Agents (stopped with the workspace):"
herdr agent list | jq -r --arg ws "$ws" \
  '.result.agents[] | select(.pane_id | startswith($ws + ":")) | "  \(.agent_status)\t\(.name // .terminal_title_stripped)"'
echo

read -rn1 -p 'Remove this checkout? [y/N] ' answer; echo
[[ $answer == [yY] ]] || exit 0
if ! herdr worktree remove --workspace "$ws" >/dev/null; then
  read -rn1 -p 'Git refused (dirty checkout). Force removal and discard changes? [y/N] ' answer; echo
  [[ $answer == [yY] ]] || exit 0
  herdr worktree remove --workspace "$ws" --force >/dev/null
fi
