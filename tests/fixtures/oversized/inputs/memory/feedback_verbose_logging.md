---
name: Verbose Logging Preference
description: SUPERSEDED. G's 2026-01-20 direction to log verbosely was reversed 2026-03-10. See feedback_log_level_control.md.
type: feedback
---

G's original direction (2026-01-20): "Log everything. Every step. I want to be able to reconstruct exactly what happened from the log file alone."

**Why this was the rule:** Early pipeline runs were opaque — when something failed, there was no way to tell which stage broke without re-running with added print statements. Verbose logging fixed this.

**Why it was reversed (2026-03-10):** Verbose-by-default produced 200MB+ log files per overnight batch run. Log rotation wasn't keeping up. G reviewed a log file and said: "This is too much noise. Default to ERROR. If I need to debug, I'll pass --verbose. Don't make me wade through INFO lines to find the exception."

**Superseded by:** `feedback_log_level_control.md` — the active rule. Default ERROR; caller opts into verbose.

**How to apply (historical):** Do not apply. This file documents a preference that no longer holds. If you are implementing a new logging layer, follow `feedback_log_level_control.md`.

**DEMOTE signal:** This entry exists only to record why the reversal happened. The active rule is in a separate file. This body is 45+ lines and pays index cost for context that's rarely needed. DEMOTE CANDIDATE.
