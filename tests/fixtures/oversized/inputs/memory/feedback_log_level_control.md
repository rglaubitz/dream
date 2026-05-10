---
name: Log Level Control
description: Default log level is ERROR. Callers opt into verbose with --verbose. Supersedes verbose-logging-preference.
type: feedback
---

G (2026-03-10): "Default to ERROR. If I need to debug, I'll pass --verbose. Don't make me wade through INFO lines to find the exception."

**Why:** Verbose-by-default produced 200MB+ log files per overnight batch run. Log rotation couldn't keep up.

**How to apply:** All CLIs and workers default to ERROR log level. Expose `--verbose` / `LOG_LEVEL` env var for opt-in. This supersedes the 2026-01-20 verbose-logging-preference.
