---
name: prepare-pr
description: Prepare a pull request by inspecting the final diff, running relevant checks, and drafting a reviewer-ready title and description. Create or update the PR when the user requests publication.
---

# Prepare PR

Prepare the final change for a reviewer who has not seen the conversation.

- Read repository contribution instructions and any PR template. Establish the intended base branch and inspect the final diff, commit range, and local changes.
- Check that the diff matches the requested scope and contains no accidental files or unrelated user work. Do not stage, commit, or discard unrelated changes.
- Run relevant required checks. Report failures, skipped checks, and environment limits accurately; fix task-related issues when that work is authorized.
- Write a concise title and description around the final implementation. Lead with the concrete problem and resulting behavior. Include validation and material risks or rollout details when relevant. Follow the repository template.
- For draft-only requests, return the proposed title and description without publishing. When the user requests PR creation or an update, complete that action within the existing authorization; preparation alone does not authorize commits, pushes, publication, or merging.
- Use structured tool arguments or a body file to preserve multiline descriptions when publishing. Confirm the resulting PR state and URL.

Stop when the requested draft or published PR is complete. Report any blocker that prevents reaching that state, with the completed preparation and exact remaining action.
