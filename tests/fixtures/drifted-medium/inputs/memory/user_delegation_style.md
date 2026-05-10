---
name: G Delegation Style
description: G assigns tasks by pasting raw context. Expects agents to interpret, not ask for clarification.
type: user
---

G delegates by pasting raw text, screenshots, or conversation excerpts and expecting the agent to extract the task without being prompted to clarify.

**How to apply:** When given a paste-dump, parse it for the implied task first. Execute against that interpretation. If genuinely ambiguous between two very different actions, ask once with a binary choice — never open-ended.
