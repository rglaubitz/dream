---
name: Mock at the Boundary
description: Mock external I/O only. Never mock internal business logic. Tests that mock internals test nothing.
type: feedback
---

G's direction (2026-04-14): "If you're mocking a function inside the same module you're testing, you're not writing a test — you're writing fiction."

**Why:** Mocking internal functions bypasses the actual logic under test. The test passes even if the real code is broken. Only I/O boundaries (HTTP calls, DB reads, filesystem) should be mocked.

**How to apply:** Mock at the outermost I/O boundary: `httpx.Client.get`, `sqlite3.connect`, `open`. Never mock `MyService.process_doc` when testing `MyService`. If internal mocking feels necessary, it signals the boundary isn't abstracted correctly — refactor first.
