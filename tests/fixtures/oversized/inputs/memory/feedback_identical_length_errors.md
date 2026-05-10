---
name: Identical Length Errors Signal Quota Wall
description: N failures with identical byte-length errors = single upstream rate limit, not N independent bugs.
type: feedback
---

When N cells fail with errors of identical byte length, it's a single upstream quota or rate limit — not N independent bugs. Per-platform passes plus consolidated failures implies a load-cumulative cause.

**How to apply:** Before debugging individual failures, check if error byte lengths are identical across all failures. If so, look for a shared upstream limit first.
