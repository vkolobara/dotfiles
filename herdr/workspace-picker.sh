#!/usr/bin/env bash
# Fuzzy workspace picker for herdr: open workspaces plus a project sessionizer.
# Lists open workspaces first, then git projects under $HOME that have no workspace yet.
# Enter focuses the workspace, or creates one in the project directory, named after it.
set -euo pipefail

workspaces=$(herdr workspace list | jq -r '.result.workspaces[] | [.workspace_id, .label] | @tsv')

{
  awk -F'\t' '{ printf "%s\t%s\t* %s\n", $1, $2, $2 }' <<<"$workspaces"
  # Git repositories up to four levels below $HOME.
  fd -HI '^.git$' --max-depth=4 --prune --exclude .cache "$HOME/" |
    sed 's|/\.git/*$||' |
    awk -F'\t' '
      NR == FNR { open[$2] = 1; next }
      { name = $0; sub(".*/", "", name); if (!(name in open)) printf "-\t%s\t  %s\n", $0, $0 }
    ' <(printf '%s\n' "$workspaces") -
} |
fzf --delimiter='\t' --with-nth=3 --no-sort --prompt='workspace> ' |
{
  IFS=$'\t' read -r id target _ || exit 0
  # Tab is IFS whitespace, so an empty id field would collapse; projects use "-".
  if [[ $id != - ]]; then
    herdr workspace focus "$id" >/dev/null
  else
    herdr workspace create --cwd "$target" --label "$(basename "$target")" --focus >/dev/null
  fi
}
