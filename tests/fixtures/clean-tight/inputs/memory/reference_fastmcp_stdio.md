---
name: FastMCP stdio transport
description: All local MCPs use stdio. SSE only for TCC-isolation workaround.
type: reference
---

All MCP servers in this project use stdio transport. SSE is only used when the server needs its own TCC permission grant (i.e., a separate process identity is required to get Calendar or Reminders access without inheriting from the host).

**Pattern:**

```python
mcp = FastMCP("server-name")
# stdio is the default transport; no explicit config needed
mcp.run()
```

**When to use SSE:** Only for Apple Calendar / Reminders servers that must run as standalone daemons to hold their own TCC grants.
