---
name: FastMCP error format
description: Tools return structured JSON errors with code + message. Never raise bare exceptions at MCP boundary.
type: reference
---

All tools return errors as structured JSON. FastMCP converts unhandled exceptions to generic MCP errors that lose context.

```python
@mcp.tool()
def my_tool(doc_id: str) -> dict:
    result = fetch(doc_id)
    if result is None:
        return {"error": {"code": "NOT_FOUND", "message": f"Document {doc_id} not found"}}
    return {"data": result}
```

Never: `raise ValueError(...)` — loses structure at the MCP boundary.
