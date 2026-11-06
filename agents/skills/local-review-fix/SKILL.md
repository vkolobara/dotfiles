---
name: local-review-fix
description: Apply the local draft feedback remaining in a selected tuicr review after the user has inspected and edited it. Run only when the user explicitly requests review fixes.
disable-model-invocation: true
---

# Local Review Fix

Apply the feedback the user has left in tuicr. Run only when explicitly
requested, for example `/local-review-fix` after the user finishes editing comments.
Do not start fixing while the user is still reviewing.

- Read repository instructions and inspect existing changes. Use the session
  slug from the user's request or the preceding review. Otherwise run
  `tuicr review list --repo <repo-root-or-forge-URL>` and match the repository
  and comparison. Do not choose solely by activity or timestamp. Ask when
  multiple sessions remain plausible; do not create a new review session.
- Retrieve the latest JSON with `tuicr review comments --repo <repo-root>
  --session <slug>`. Read the saved comments now, even if their original text
  appears in conversation. Only local drafts are this workflow's work list;
  published comments require an explicit request to address them.
- Treat remaining local draft issues and requested suggestions as the user's
  selected feedback, including agent-authored comments that the user kept or
  edited. Do not filter out comments by author or restore deleted findings.
  Notes and questions may need an answer; praise needs no code change. Honor
  instructions to skip or defer a comment. If the list is empty, report that
  there is no draft feedback to apply and stop.
- Track each comment by ID, current content, file, side, and line range. Check
  the session's reviewed revisions against the current checkout. Find the
  corresponding code before editing; old anchors can move after code changes.
  For PR sessions, verify the local checkout corresponds to the reviewed head
  or contains the relevant change before applying fixes. Do not switch branches
  or overwrite local work merely to make anchors match.
- Revalidate the problem in the current code and affected callers. Apply the
  smallest coherent correction for valid feedback. Explain comments that are
  already satisfied, contradicted by evidence, or blocked by ambiguity; do not
  force a change merely because a comment exists. Ask only when a missing
  decision prevents a correct fix, and continue independent fixes.
- Preserve unrelated changes. Add a regression check when it meaningfully
  protects the behavior, and run the relevant checks. Re-read comments before
  finishing; if they changed during the work, reconcile the changed feedback
  before claiming it is addressed.
- Leave comments and review marks intact as the review record. Do not delete,
  clear, rewrite, or publish them to mark progress. Do not commit or push unless
  separately requested, or automatically start another review.

Finish with a concise disposition for each comment ID: fixed, already
satisfied, answered, deferred, or blocked, with the reason where needed.
Report relevant verification and material limitations.
