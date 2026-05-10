---
name: Autoresearch Runner
description: Orchestrates 5-layer autoresearch loop. Manages iteration budget, scoring, and SKILL.md edits.
type: project
---

Drives the autoresearch improvement loop: canary capture → score → identify worst scenario → generate SKILL.md edit → redeploy → re-score → keep or revert.

**Status:** Active. Used across qbo-cli, video-analyzer, and dream autoresearch runs.

**Budget:** 5–8 iterations typical, hard cap 12.

**Key rule:** Reinstall canary tool before each measurement. See `feedback_reinstall_canary.md`.
