---
name: Batch Scheduler
description: Cron-driven batch runner for overnight pipeline jobs. v1.1, stable.
type: project
---

Runs overnight batch jobs for the doc-processing pipeline via launchd cron. Picks up queued ingest jobs after business hours, processes them in parallel, and writes results back to the audit log.

**Status:** v1.1, stable. No open issues.

**Schedule:** 2 AM Pacific nightly.

**Config:** `~/.config/batch-scheduler/config.toml`
