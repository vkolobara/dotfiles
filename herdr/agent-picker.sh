#!/usr/bin/env bash
# Fuzzy agent picker for herdr: sorted by status (needs-attention first), then most recent activity.
# Herdr exposes no timestamps, so "last update" is the mtime of the agent's Claude session log.
# shortcut: non-Claude agents have no session log and show "-"; add their log paths if you use other agents.
# The preview shows the highlighted agent's recent output.
# Keys: enter focuses the agent; tab marks agents; ctrl-r sends one prompt to the marked agents
# (or the highlighted one); ctrl-d closes the pane (kills the agent). Both refresh the list.
set -euo pipefail

list() {
  local now; now=$(date +%s)
  herdr agent list | jq -r '
    {blocked:0, waiting:1, done:2, working:3, idle:4} as $rank
    | .result.agents[]
    | [($rank[.agent_status] // 5), .pane_id, .agent_status,
       (.name // .terminal_title_stripped), (.cwd | split("/") | last),
       (.agent_session.value // "")]
    | @tsv' |
  while IFS=$'\t' read -r rank pane status name repo session; do
    mtime=0
    if [[ -n $session ]]; then
      for f in ~/.claude/projects/*/"$session".jsonl; do
        # GNU stat first; BSD stat (macOS) rejects -c and falls back to -f.
        [[ -e $f ]] && mtime=$(stat -c %Y "$f" 2>/dev/null || stat -f %m "$f")
      done
    fi
    printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$rank" "$mtime" "$pane" "$status" "$name" "$repo"
  done |
  sort -t$'\t' -k1,1n -k2,2nr |
  awk -F'\t' -v now="$now" '{
    if ($2 == 0) age = "-"
    else { d = now - $2
      age = d < 60 ? d "s" : d < 3600 ? int(d/60) "m" : d < 86400 ? int(d/3600) "h" : int(d/86400) "d" }
    printf "%s\t%-9s %-6s %-48.48s %s\n", $3, $4, age, $5, $6
  }'
}

# reply PANE...: read one line from the terminal and submit it to each agent.
# Herdr refuses to type into an agent that is waiting on a question; those are reported, not retried.
reply() {
  local text failed=()
  read -rep "prompt for $# agent(s)> " text
  [[ -n $text ]] || return 0
  for pane; do herdr agent prompt "$pane" "$text" >/dev/null 2>&1 || failed+=("$pane"); done
  if (( ${#failed[@]} )); then
    echo "Not sent to ${failed[*]}: blocked or gone; press enter on it in the picker to answer it there."
    read -rsn1 -p 'Press a key.' || true
  fi
}

if [[ ${1:-} == list ]]; then list; exit; fi
if [[ ${1:-} == reply ]]; then shift; reply "$@"; exit; fi

self=$(cd "$(dirname "$0")" && pwd)/$(basename "$0")
list |
fzf --delimiter='\t' --with-nth=2 --no-sort --multi \
    --header="$(printf 'enter focus · tab mark · ctrl-r prompt · ctrl-d close\n%-9s %-6s %-48s %s' STATUS AGE AGENT REPO)" \
    --prompt='agent> ' --with-shell='bash -c' \
    --preview='herdr agent read {1} --lines 60' --preview-window='down,55%,follow' \
    --bind "ctrl-r:execute('$self' reply {+1})+deselect-all+reload('$self' list)" \
    --bind "ctrl-d:execute-silent(herdr pane close \$(echo {1}))+reload('$self' list)" |
head -n1 | cut -f1 | xargs -r herdr agent focus
