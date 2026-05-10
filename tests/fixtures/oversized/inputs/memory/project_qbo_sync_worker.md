---
name: QBO Sync Worker
description: Background worker that pushes extracted invoice fields to QBO. Handles OAuth token refresh.
type: project
---

Picks up processed invoice records from the pipeline and creates or updates QBO Invoice entities. Handles OAuth token refresh via the server-side token daemon.

**Status:** Deployed. Processes ~40 invoices/day.

**Auth:** Uses server-side OAuth token daemon. Does not store tokens locally.
