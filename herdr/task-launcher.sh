#!/usr/bin/env bash
# Start a new task: a git worktree next to the repo, opened as a herdr workspace, with an agent in it.
# Interactive from the popup; scriptable as: task-launcher.sh <repo> <branch|PR> [agent] [prompt].
# The worktree goes to <repo>-<branch-slug> beside the repo; an existing local branch is checked out.
# The branch may be a task title; anything git rejects as a branch name becomes its slug.
# A PR (#123, 123, or its URL) in place of the branch reviews it: the PR head is fetched into a
# local branch, and Claude runs /local-review on it.
set -euo pipefail

agents=(claude codex pi opencode)

# The main checkout, even when called from inside one of its worktrees.
repo_root() { dirname "$(git -C "$1" rev-parse --path-format=absolute --git-common-dir)"; }
is_pr() { [[ $1 =~ ^#?([0-9]+)$ || $1 =~ /pull/([0-9]+) ]]; }
# Popups close when the script exits, so wait for a key before leaving on an error.
fail() { echo "$*"; [[ -t 0 ]] && read -rsn1 -p 'Press a key to close.'; exit 1; }

if (( $# >= 2 )); then
  repo=$(repo_root "$1") branch=$2 agent=${3:-claude} prompt=${4:-}
else
  here=${HERDR_ACTIVE_PANE_CWD:-$PWD}
  # The focused repo first, then the same project search as workspace-picker.sh.
  repo=$(
    { git -C "$here" rev-parse --git-dir >/dev/null 2>&1 && repo_root "$here"
      fd -HI '^.git$' --max-depth=4 --prune --exclude .cache "$HOME/" | sed 's|/\.git/*$||'
    } | awk '!seen[$0]++' | fzf --no-sort --prompt='repo> '
  ) || exit 0
  read -rep 'branch, task title, or PR> ' branch
  [[ -n $branch ]] || exit 0
  agent=claude prompt=
  if ! is_pr "$branch"; then
    agent=$(printf '%s\n' "${agents[@]}" | fzf --no-sort --prompt='agent> ') || exit 0
    read -rep 'prompt (optional)> ' prompt
  fi
fi

name=
if is_pr "$branch"; then
  pr=${BASH_REMATCH[1]}
  info=$(cd "$repo" && gh pr view "$pr" --json headRefName,url,isCrossRepository \
    --jq '[.headRefName, .url, .isCrossRepository] | @tsv') || fail "No PR #$pr for $repo."
  IFS=$'\t' read -r head url fork <<<"$info"
  # A fork's head branch is often named like one of yours (main); give it its own pr-N branch.
  if [[ $fork == true ]]; then branch=pr-$pr; else branch=$head; fi
  # Fails rather than overwrite a local branch that is checked out or has commits the PR lacks.
  git -C "$repo" fetch --quiet origin "pull/$pr/head:$branch" ||
    fail "Could not update local branch $branch from PR #$pr; it is checked out or has diverged."
  agent=claude prompt="/local-review PR $url" name=pr-$pr
fi

slug=$(tr '[:upper:]' '[:lower:]' <<<"$branch" | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')
# A task title such as "Fix login bug" is not a valid branch name; use its slug instead.
git check-ref-format --branch "$branch" >/dev/null 2>&1 || branch=$slug
path="$(dirname "$repo")/$(basename "$repo")-$slug"
# Agent names must match [a-z][a-z0-9_-]{0,31}.
name=${name:-$(sed -E 's/^[^a-z]+//' <<<"$slug" | cut -c1-32)}
name=${name:-task}

pane=$(herdr worktree create --cwd "$repo" --branch "$branch" --path "$path" --label "$slug" --focus |
  jq -r '.result.root_pane.pane_id')
# Shells with mise activation would otherwise warn about the new checkout's untrusted config.
if [[ -e $path/mise.toml || -e $path/.mise.toml ]]; then mise trust --quiet "$path" || true; fi

if ! herdr agent start "$name" --kind "$agent" --pane "$pane" >/dev/null 2>&1; then
  # A new checkout path is untrusted, so the agent opens on its folder-trust question, which herdr
  # reports as blocked. Accept only that question; anything else is left for you in the pane.
  if herdr agent read "$name" --lines 40 | grep -qi 'trust'; then
    herdr agent send-keys "$name" enter >/dev/null
    herdr agent wait "$name" --until idle --timeout 60000 >/dev/null
  else
    fail "$agent did not become ready; check its pane. Prompt not sent: $prompt"
  fi
fi
if [[ -n $prompt ]]; then herdr agent prompt "$name" "$prompt" >/dev/null; fi
