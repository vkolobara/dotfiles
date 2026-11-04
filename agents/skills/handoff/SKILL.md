---
name: handoff
description: Prepare a concise continuation note when switching coding agents, ending a work session, or handing an unfinished task to another contributor. Capture verified state and the next concrete action.
---

# Handoff

Leave enough current evidence for another agent to continue without repeating the investigation.

- Inspect the actual repository state, branch, worktree, and relevant diff. Separate changes made for this task from pre-existing user work.
- Record the objective, accepted constraints, completed changes, and decisions whose reasons are not obvious from the code.
- Record checks actually run, their results, and checks still needed. Include the decisive error or evidence for any blocker.
- Name relevant files and symbols. Distinguish confirmed causes from hypotheses and identify external resources only when the next action needs them.
- State the next concrete action and unresolved questions. Preserve the user's authorization boundaries; a handoff does not authorize new external actions.
- Return the note in chat unless the user requests a file or the project specifies a handoff location. If persisting it, use normal prose and omit credentials, sensitive logs, and unrelated personal data.

Use a compact structure: objective; branch and worktree; completed work and decisions; verification; blockers; next action. Omit empty sections. Do not commit, publish, or contact another agent merely to produce the note.
