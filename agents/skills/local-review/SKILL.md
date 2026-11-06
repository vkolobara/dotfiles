---
name: local-review
description: Review requested local changes, a branch, a commit range, or a PR and write findings as local draft comments in tuicr. Run only when the user explicitly requests a review.
disable-model-invocation: true
---

# Local Review

Review the requested changes and leave findings in tuicr for the user to inspect,
edit, or delete. Do not change source code or start fixing findings. Run only
when explicitly requested; finishing an implementation does not trigger review.

## Select the comparison and session

- Read repository instructions and establish the requested scope. For example,
  `/local-review current branch against master` means changes since the merge base
  with `master`, excluding uncommitted work unless requested. Resolve the merge
  base and HEAD to commit IDs; inspect that exact diff and launch
  `tuicr --no-update-check -r <merge-base>..<head>`. Honor explicit endpoint
  comparisons or commit ranges instead of substituting merge-base semantics.
- For local changes, use `tuicr --no-update-check -w`; account for staged,
  unstaged, and relevant untracked files. For a PR, use
  `tuicr --no-update-check pr <number|owner/repo#N|URL>` and inspect the PR's
  actual base, head, and full diff, including changes previously reviewed.
  Verify the selected commits if tuicr offers a commit selector. Do not change
  the user's checkout just to review a PR.
- Check the installed `tuicr --help` and relevant `tuicr review` help if needed.
  List sessions with `tuicr review list --repo <repo-root-or-forge-URL>`.
  Reuse a session only when its checkout, comparison, and selected files match.
  An active session or recent timestamp alone does not establish a match.
  In a Git session slug, `commits/<first>..<last>` names the first and last
  included commits, not the original exclusive base passed to `-r`.
- If needed, open the scoped TUI in an available user-visible terminal using
  authorized terminal tools. Otherwise initialize it in a tool-provided PTY,
  keep it running while adding comments, and give the user the same launch
  command afterward. If neither is available, provide the exact command and
  wait for the user to start it. The review CLI cannot create sessions.
- Capture the `tuicr-session:` slug or obtain it from `review list`. Use that
  exact slug for every comment command. Empty, unmarked sessions disappear on
  TUI exit, so do not close a newly created session before writing findings.
  Read existing comments before adding any; preserve user edits and avoid
  duplicating findings. Ask only if the requested target remains ambiguous.

## Review and comment

- Read changed code and affected callers, contracts, and checks. Validate
  suspected defects with a concrete input, execution path, or focused check.
  Prioritize correctness, data integrity, security, compatibility, and meaningful
  missing coverage. Skip style preferences and speculative risks.
- Match annotations to the exact diff shown in tuicr, not a newer checkout.
  Use repository-relative paths and the correct old or new line numbers.
  Prefer a short visible line range; use a file comment when there is no
  suitable visible line. A successful add does not prove an off-diff line will
  render in the TUI.
- Add each confirmed finding using `tuicr review add --repo <repo-root>
  --session <slug> --username <agent-name> --type issue --target-file <path>
  --line <line> --side <old|new> <comment>`. Use a truthful agent name such as
  `Codex` or `Claude`. Omit `--line` and `--side` for file comments.
- Include severity, triggering condition, consequence, and evidence in each
  comment. Pass comment text as a safely quoted argument or a JSON object via
  `--input @<payload-file>`; never interpolate it as shell code.
- Read back with `tuicr review comments --repo <repo-root> --session <slug>`.
  Verify the returned IDs, author, content, and anchors against the diff. Do not
  clear existing comments or submit, publish, or export a review to the forge.
  Exit a TUI created solely in a tool-provided PTY with `:q` after verification;
  leave user-visible sessions open for the user.

Stop after recording findings. Report the session slug, comparison, finding
count, checks and material gaps, and exact command to open the same review.
If there are no findings, say so without inventing comments. The user edits or
deletes comments in tuicr, then explicitly invokes `/local-review-fix` when ready.
