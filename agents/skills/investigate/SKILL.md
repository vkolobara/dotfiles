---
name: investigate
description: Investigate a bug, failing check, or unexpected behavior by reproducing it and tracing its cause before editing. Use for diagnosis or as the first part of a requested fix.
---

# Investigate

Establish the cause with evidence before choosing a fix.

- Identify expected and observed behavior, the failing input, and the relevant environment. Read project instructions and inspect existing changes before reproducing the failure.
- Use the smallest safe reproduction or focused failing check. If reproduction is unavailable, state the limitation and distinguish observations from hypotheses.
- Trace the failing path, responsible function, and relevant callers. Check nearby working behavior to identify what differs.
- Test the leading hypothesis with a focused observation or experiment. Change one relevant factor at a time; avoid speculative edits and unrelated exploration.
- For a diagnosis request, report the cause, evidence, affected scope, and proposed correction without editing product code.
- For a requested fix, continue with the smallest correction at the responsible layer. Add a useful regression check when practical and run relevant verification.

Finish when the cause is supported and the requested diagnosis or fix is complete. If blocked, report the decisive missing evidence and the next experiment; do not present a guess as a confirmed cause.
