---
name: Batch Runner
description: Overnight batch job runner. v2.1, stable, runs nightly via launchd.
type: project
---

Pulls queued docs from the ingest API after business hours and processes them in parallel. Configurable concurrency via `MAX_WORKERS` env var.

**Status:** v2.1, stable. No open issues. Superseded in scope by Batch Scheduler v2 which adds scheduling logic — but Batch Runner remains the execution engine underneath.

**Schedule:** 2 AM Pacific nightly via launchd plist `com.agentfleet.tools-manager.batch-runner`.

**Config:** `~/.config/batch-runner/config.toml`

**MERGE-LINES note:** Batch Runner and Batch Scheduler v2 are often referenced together. They are distinct components (runner = execution, scheduler = orchestration) but their index lines could reasonably be merged into one entry covering the full batch subsystem.
