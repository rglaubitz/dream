---
name: Mock at the Boundary
description: Mock external I/O only. Never mock internal logic. If internal mocking feels necessary, refactor the boundary.
type: feedback
---

G (2026-04-14): "If you're mocking a function inside the same module you're testing, you're writing fiction."

**How to apply:** Mock at `httpx.Client.get`, `sqlite3.connect`, `open` — never at internal business logic functions. If internal mocking feels necessary, the boundary isn't abstracted correctly; refactor first.
