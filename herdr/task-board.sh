#!/usr/bin/env bash
# Task board: every worktree of the focused repo, with its agents, reported progress, git state, and PR.
# Progress is what agents record with task-progress; a closed worktree has no open herdr workspace.
# Keys: enter focuses the worktree's workspace, opening it if closed; tab marks rows; ctrl-x removes the
# marked (or highlighted) checkouts; alt-m removes every clean, fully pushed worktree whose PR is merged
# or closed; ctrl-l refreshes. Removal goes through task-teardown.sh, which confirms first and keeps branches.
# Usage: task-board.sh [repo]
set -euo pipefail

self=$(cd "$(dirname "$0")" && pwd)/$(basename "$0")
teardown=$(dirname "$self")/task-teardown.sh

# The main checkout, even when called from inside one of its worktrees.
repo_root() { dirname "$(git -C "$1" rev-parse --path-format=absolute --git-common-dir)"; }
progress_file() { git -C "$1" rev-parse --path-format=absolute --git-path task-progress; }

# Rows: path, workspace, done flag, then the display columns.
list() {
  local repo=$1 now prs agents
  now=$(date +%s)
  # One gh call for the whole repo; the newest PR per head branch wins.
  prs=$(cd "$repo" && gh pr list --state all --limit 200 --json headRefName,number,state \
    --jq '.[] | [.headRefName, "#\(.number) \(.state | ascii_downcase)"] | @tsv' 2>/dev/null | awk -F'\t' '!seen[$1]++') || prs=
  agents=$(herdr agent list | jq -r '.result.agents[] | [.workspace_id, .agent_status, .agent] | @tsv')

  herdr worktree list --cwd "$repo" | jq -r '
    .result.worktrees[] | [.path, (.branch // "detached"), (.open_workspace_id // "-"), .is_prunable] | @tsv' |
  while IFS=$'\t' read -r path branch ws prunable; do
    if [[ $prunable == true || ! -d $path ]]; then
      printf '%s\t-\tdone\t%-30.30s %s\n' "$path" "$branch" "missing checkout (alt-m prunes it)"
      continue
    fi
    if [[ $ws == - ]]; then agent=closed
    else agent=$(awk -F'\t' -v ws="$ws" '$1 == ws { printf "%s%s %s", sep, $2, $3; sep = "," }' <<<"$agents")
         agent=${agent:-shell}; fi
    file=$(progress_file "$path")
    progress=$(cat "$file" 2>/dev/null || echo -) age=-
    if [[ -f $file ]]; then
      d=$(( now - $(stat -c %Y "$file" 2>/dev/null || stat -f %m "$file") ))
      age=$(awk -v d="$d" 'BEGIN { print d < 60 ? d "s" : d < 3600 ? int(d/60) "m" : d < 86400 ? int(d/3600) "h" : int(d/86400) "d" }')
    fi
    dirty=$(git -C "$path" status --porcelain | wc -l | tr -d ' ')
    unpushed=$(git -C "$path" rev-list --count HEAD --not --remotes)
    pr=$(awk -F'\t' -v b="$branch" '$1 == b { print $2 }' <<<"$prs")
    finished=-
    if [[ $pr == *merged || $pr == *closed ]] && (( dirty == 0 && unpushed == 0 )); then finished=done; fi
    printf '%s\t%s\t%s\t%-30.30s %-18.18s %-40.40s %-4s %-9s %s\n' "$path" "$ws" "$finished" \
      "$branch" "$agent" "$progress" "$age" "${dirty}M ${unpushed}↑" "${pr:--}"
  done
}

preview() {
  local path=$1 ws=$2 pane
  [[ -d $path ]] || { echo "$path no longer exists."; return; }
  echo "Progress: $(cat "$(progress_file "$path")" 2>/dev/null || echo 'none reported')"
  echo
  git -C "$path" -c color.status=always status --short --branch | head -15
  echo
  git -C "$path" log --color=always --oneline -8
  [[ $ws == - ]] && return
  pane=$(herdr agent list | jq -r --arg ws "$ws" '[.result.agents[] | select(.workspace_id == $ws)][0].pane_id // empty')
  [[ -n $pane ]] || return 0
  echo; echo "── agent output ──"
  herdr agent read "$pane" --lines 30
}

open() {
  local repo=$1 path=$2 ws=$3
  if [[ $ws != - ]]; then herdr workspace focus "$ws" >/dev/null
  elif [[ -d $path ]]; then herdr worktree open --cwd "$repo" --path "$path" --focus >/dev/null; fi
}

prune() {
  local repo=$1 paths
  git -C "$repo" worktree prune
  mapfile -t paths < <(list "$repo" | awk -F'\t' '$3 == "done" { print $1 }' | while read -r p; do [[ -d $p ]] && echo "$p"; done)
  if (( ${#paths[@]} == 0 )); then read -rsn1 -p 'No finished worktrees to remove. Press a key.'; return; fi
  "$teardown" "${paths[@]}" || true
}

case ${1:-} in
  list) list "$2"; exit ;;
  preview) preview "$2" "$3"; exit ;;
  prune) prune "$2"; exit ;;
  remove) shift; "$teardown" "$@" || true; exit ;;
esac

here=${1:-${HERDR_ACTIVE_PANE_CWD:-$PWD}}
if ! repo=$(repo_root "$here" 2>/dev/null); then
  echo "Not in a git repository: $here"; read -rsn1 -p 'Press a key to close.'; exit 1
fi
q=$(printf '%q' "$repo")

list "$repo" |
fzf --delimiter='\t' --with-nth=4 --no-sort --multi --ansi \
    --header="$(printf '%s · enter open · tab mark · ctrl-x remove · alt-m remove finished · ctrl-l refresh\n%-30s %-18s %-40s %-4s %-9s %s' \
      "$(basename "$repo")" BRANCH AGENT PROGRESS AGE GIT PR)" \
    --prompt='worktree> ' --with-shell='bash -c' \
    --preview="'$self' preview {1} {2}" --preview-window='down,55%,follow' \
    --bind "ctrl-l:reload('$self' list $q)" \
    --bind "ctrl-x:execute('$self' remove {+1})+deselect-all+reload('$self' list $q)" \
    --bind "alt-m:execute('$self' prune $q)+reload('$self' list $q)" |
head -n1 | { IFS=$'\t' read -r path ws _ || exit 0; open "$repo" "$path" "$ws"; }
