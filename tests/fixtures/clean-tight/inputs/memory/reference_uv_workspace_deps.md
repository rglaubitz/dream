---
name: uv workspace deps
description: Shared deps go in root pyproject.toml; per-project extras override in member pyproject.
type: reference
---

In a uv workspace, shared dependencies belong in the root `pyproject.toml` under `[tool.uv.workspace]`. Each member project's `pyproject.toml` can add its own extras but should not re-declare shared deps.

**Pattern:**

```
root/pyproject.toml   ← fastmcp, pydantic, httpx
src/myserver/pyproject.toml  ← [project.optional-dependencies] extras = ["pyobjc"]
```

**Common mistake:** Duplicating fastmcp in member projects causes version conflicts when uv resolves the workspace lock.
