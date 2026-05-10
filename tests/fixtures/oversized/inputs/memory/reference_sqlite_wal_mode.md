---
name: SQLite WAL mode
description: Enable WAL mode on all SQLite DBs used by concurrent workers. Prevents write-lock contention.
type: reference
---

All SQLite databases accessed by concurrent workers must use WAL (Write-Ahead Logging) mode.

```python
conn = sqlite3.connect("audit.db")
conn.execute("PRAGMA journal_mode=WAL")
```

Without WAL, concurrent reads block on writes. At pipeline volume (multiple workers), this produces cascading timeouts.
