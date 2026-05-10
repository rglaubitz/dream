---
name: Parallel First
description: Always attempt parallel tool calls before falling back to sequential.
type: feedback
---

G's standing instruction: maximize parallelism. If two tool calls are independent, fire them simultaneously. Never serialize when parallel is possible.

**Why:** Sequential tool calls in a session that could be parallel double or triple wall-clock time. G notices and flags it.

**How to apply:** Before any multi-step tool use, ask: are any of these independent? If yes, batch them in the same message. Only go sequential when step N depends on step N-1's output.
