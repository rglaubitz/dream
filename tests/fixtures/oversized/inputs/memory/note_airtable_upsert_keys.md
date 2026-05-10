---
name: Airtable upsert key strategy
description: Upsert keys per doc type. Never use Airtable internal IDs — they don't survive record recreation.
type: reference
---

Upsert key decisions by doc type (decided 2026-04-15 after incident where a table rebuild orphaned 340 records):

| Doc type          | Upsert key                    | Notes           |
| ----------------- | ----------------------------- | --------------- |
| Rate con          | load_number                   | Unique per load |
| Invoice           | invoice_number                |                 |
| Driver settlement | (driver_id, pay_period_start) | Composite key   |
| OTR settlement    | (driver_id, settlement_date)  |                 |

**Rule:** Never use Airtable's auto-generated record ID as an upsert key. Record IDs don't survive table rebuilds or record recreation. Business keys only.

**Incident:** 2026-04-15 — table rebuild orphaned 340 records because upsert key was Airtable's internal record ID. Triggered this decision.
