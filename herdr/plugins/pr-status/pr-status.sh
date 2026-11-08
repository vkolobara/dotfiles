#!/usr/bin/env bash
# Report each workspace's GitHub PR as the $pr and $ci Space tokens in the herdr sidebar.
# Runs at most once per THROTTLE seconds; tokens expire after TTL so they vanish if this stops running.
# Pass --force to skip the throttle.
set -euo pipefail

THROTTLE=60
TTL_MS=$((30 * 60 * 1000))
herdr=${HERDR_BIN_PATH:-herdr}
state=${HERDR_PLUGIN_STATE_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/herdr-pr-status}
mkdir -p "$state"

# mkdir is atomic on Linux and macOS, unlike flock, which macOS lacks.
lock=$state/lock
if ! mkdir "$lock" 2>/dev/null; then
  # A crashed run can leave the lock behind; treat one older than five minutes as stale.
  [[ -n $(find "$lock" -maxdepth 0 -mmin +5 2>/dev/null) ]] || exit 0
  rmdir "$lock" && mkdir "$lock" || exit 0
fi
trap 'rmdir "$lock"' EXIT

stamp=$state/last-run
now=$(date +%s)
if [[ ${1:-} != --force && -f $stamp ]] && (( now - $(<"$stamp") < THROTTLE )); then exit 0; fi
echo "$now" >"$stamp"

report() { "$herdr" workspace report-metadata "$1" --source pr-status --ttl-ms "$TTL_MS" "${@:2}" >/dev/null; }

for ws in $("$herdr" workspace list | jq -r '.result.workspaces[].workspace_id'); do
  cwd=$("$herdr" pane list --workspace "$ws" | jq -r '.result.panes[0].cwd // empty')
  # gh resolves the PR from the checkout's current branch; no repo, remote, or PR clears the tokens.
  if [[ -z $cwd ]] || ! pr=$(cd "$cwd" && gh pr view --json number,state,isDraft,reviewDecision,statusCheckRollup 2>/dev/null); then
    report "$ws" --clear-token pr --clear-token ci || true
    continue
  fi
  # The sidebar rules in config.toml match these exact values to pick colors.
  label=$(jq -r '
    "#\(.number) " + (
      if .state == "MERGED" then "merged"
      elif .state == "CLOSED" then "closed"
      elif .isDraft then "draft"
      elif .reviewDecision == "APPROVED" then "approved"
      elif .reviewDecision == "CHANGES_REQUESTED" then "changes"
      else "open" end)' <<<"$pr")
  # Check runs report conclusion/status; legacy commit statuses report state.
  ci=$(jq -r '
    [.statusCheckRollup[] | (.conclusion // .state // "") | ascii_upcase] as $c
    | if .state != "OPEN" or ($c | length) == 0 then ""
      elif any($c[]; . == "FAILURE" or . == "ERROR" or . == "CANCELLED" or . == "TIMED_OUT" or . == "ACTION_REQUIRED") then "✗ ci"
      elif any($c[]; . == "" or . == "PENDING" or . == "EXPECTED") then "● ci"
      else "✓ ci" end' <<<"$pr")
  if [[ -n $ci ]]; then
    report "$ws" --token "pr=$label" --token "ci=$ci" || true
  else
    report "$ws" --token "pr=$label" --clear-token ci || true
  fi
done
