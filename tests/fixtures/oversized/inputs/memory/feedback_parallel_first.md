---
name: Parallel First
description: Always attempt parallel tool calls before falling back to sequential. G notices and flags serial work.
type: feedback
---

G's standing instruction: maximize parallelism. If two tool calls are independent, fire them simultaneously. Only go sequential when step N depends on step N-1's output.
