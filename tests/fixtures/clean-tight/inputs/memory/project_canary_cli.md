---
name: Canary CLI
description: CLI wrapper for autoresearch canary capture. v0.2.1, 47 tests. Stable.
type: project
---

Thin typer CLI that wraps the canary capture step in the autoresearch loop. Snapshots tool help text and emits structured JSON for scoring.

**Status:** v0.2.1, stable. No planned changes.

**Commands:** capture, diff, score, report.

**Tests:** 47 passing.

**Why built:** Autoresearch needed a reproducible, scriptable canary surface. Raw subprocess calls were brittle.
