---
name: uv workspace deps
description: Shared deps in root pyproject.toml; per-project extras in member pyproject. Always commit uv.lock.
type: reference
---

Shared dependencies (fastmcp, pydantic, httpx) belong in the root `pyproject.toml`. Per-project extras go in the member's `pyproject.toml` under `[project.optional-dependencies]`.

Always commit `uv.lock`. Unlocked CI installs produce non-deterministic failures from transitive dep version drift. Regenerate with `uv lock`.
