---
name: Old Auth Flow
description: OAuth2 PKCE flow replaced 2026-03-15. Client-side token store deprecated. Historical context only.
type: reference
---

The pre-March-2026 OAuth2 implementation stored tokens client-side at `~/.config/pipeline/auth.json`. This path was writable by the agent process and refreshed inline during tool calls.

**Why it was replaced (2026-03-15):**

Two failure modes that were not fixable without architectural change:

1. **Concurrent refresh race** — two worker processes simultaneously discovered an expired token, both attempted refresh, and the second refresh invalidated the token the first process just wrote. Result: one process gets 401 mid-batch-run.
2. **flock contention + corruption** — flock protected writes but not reads; a reader could snapshot a partially-written JSON file during a 2-process concurrent write scenario.

**What replaced it:** Server-side token store with a dedicated refresh daemon. Workers query the daemon; the daemon holds the lock and serializes refreshes. See `reference_oauth_token_daemon.md` (if it exists) for current architecture.

**Status:** Fully decommissioned 2026-03-15. No production code uses this path. This file is retained to explain the migration rationale.

**DEMOTE signal:** Obsolete since 2026-03-15. No new contributor has needed this in 7+ weeks. Move to `archived/` on next dream pass — the migration rationale is captured in the commit messages on the March 2026 PRs.
