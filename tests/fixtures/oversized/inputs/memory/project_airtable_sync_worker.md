---
name: Airtable Sync Worker
description: Background worker that upserts extracted fields to Airtable. Uses custom Airtable MCP.
type: project
---

Upserts extracted document fields into Airtable tables. Uses doc-type-specific upsert keys (load_number for rate cons, invoice_number for invoices, driver_id + pay_period_start for settlements).

**Status:** Deployed. Upsert keys are stable — see note_airtable_upsert_keys.md for decision history.
