---
name: Batch Scheduler v2
description: Successor to Batch Runner; consolidates scheduling + execution. v2.3, active.
type: project
---

Unified batch system that wraps Batch Runner with scheduling logic. Handles job queuing, retry on failure, per-doc-type priority lanes, and alerting on batch failure.

**Status:** v2.3, active. Batch Runner still runs underneath; Batch Scheduler v2 is the orchestration layer above it.

**Relationship to Batch Runner:** Batch Scheduler v2 calls Batch Runner's execution logic. They share the same launchd cron trigger. For most purposes, refer to Batch Scheduler v2 — it owns the full batch lifecycle.

**MERGE-LINES note:** These two index entries are often referenced together and describe the same subsystem from different angles (execution vs. orchestration). Prune phase may merge the index lines.
