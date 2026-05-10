---
name: uv lock pinning
description: Always commit uv.lock. Regenerate with `uv lock`. Reject PRs that touch pyproject.toml without updating lock.
type: reference
---

`uv.lock` must be committed. CI installs via `uv sync --frozen`. Without it, minor version bumps in transitive deps have caused hard-to-bisect test failures.

Reject PRs that touch `pyproject.toml` without a corresponding `uv.lock` update.
