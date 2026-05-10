---
name: Canary Capture CLI
description: CLI for autoresearch canary capture. Snapshots tool help text, emits structured JSON for scoring. v0.2.1, 47 tests.
type: project
---

Wraps the canary capture step in the autoresearch loop. Snapshots a tool's top-level `--help` output and emits structured JSON for composite scoring.

**Status:** v0.2.1. 47 tests. Stable.

**Commands:** capture, diff, score, report.

**Critical:** Must reinstall (`uv tool install`) after source edits — PATH-based capture goes stale silently.
