---
name: uv lock pinning
description: Always commit uv.lock. Unlocked installs in CI produce non-deterministic failures.
type: reference
---

`uv.lock` must be committed alongside `pyproject.toml`. CI installs from the lockfile (`uv sync --frozen`). Without it, minor version bumps in transitive deps have caused test failures that are hard to bisect.

**Rule:** if `uv.lock` is in `.gitignore`, remove it. If a PR touches `pyproject.toml` and does not update `uv.lock`, reject it.

**Regenerate:** `uv lock` (no args). Commit the result.
