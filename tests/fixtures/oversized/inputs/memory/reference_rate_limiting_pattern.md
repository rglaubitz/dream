---
name: Rate limiting pattern
description: Token-bucket rate limiting for all outbound API callers. Defaults: 10/s QBO, 5/s Drive, 20/s Airtable.
type: reference
---

All outbound API callers use a token-bucket implementation with configurable rate. Defaults:

- QBO: 10 req/s
- Google Drive: 5 req/s
- Airtable: 20 req/s

Configured via `~/.config/pipeline/rate-limits.toml`. Override per-worker via env vars: `QBO_RATE_LIMIT`, `DRIVE_RATE_LIMIT`, `AIRTABLE_RATE_LIMIT`.
