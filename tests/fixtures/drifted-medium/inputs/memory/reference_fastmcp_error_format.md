---
name: FastMCP error format
description: Tool errors must return structured JSON with code + message. Never raise bare exceptions.
type: reference
---

All tools must return errors as structured JSON, not raise Python exceptions. FastMCP converts unhandled exceptions to generic MCP errors that lose context.

**Pattern:**

```python
@mcp.tool()
def my_tool(doc_id: str) -> dict:
    result = fetch(doc_id)
    if result is None:
        return {"error": {"code": "NOT_FOUND", "message": f"Document {doc_id} not found"}}
    return {"data": result}
```

**Never do:**

```python
raise ValueError(f"Document {doc_id} not found")  # loses structure at MCP boundary
```
