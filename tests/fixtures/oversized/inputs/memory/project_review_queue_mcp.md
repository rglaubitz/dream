---
name: Review Queue MCP
description: MCP server for human review of low-confidence classifications. 9 tools, 44 tests.
type: project
---

Exposes the human review queue as an MCP server. Agents route low-confidence docs here; a human reviewer resolves them via the review UI.

**Status:** Deployed. 9 tools. 44 tests.

**Key tools:** enqueue, dequeue, resolve, reject, list_pending, get_stats.
