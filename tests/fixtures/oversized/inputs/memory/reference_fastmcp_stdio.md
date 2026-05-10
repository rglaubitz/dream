---
name: FastMCP stdio transport
description: All local MCPs use stdio transport. SSE only when a separate process identity is required for TCC isolation.
type: reference
---

All MCP servers use stdio transport (the FastMCP default). SSE transport is only used when a server needs its own TCC permission grant — i.e., it must run as a standalone daemon with a separate process identity (e.g., Apple Calendar MCP).

```python
mcp = FastMCP("server-name")
mcp.run()  # stdio by default
```
