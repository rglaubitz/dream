---
name: Field Extractor
description: Regex + LLM hybrid extractor. Pulls structured fields from normalized OCR text.
type: project
---

Two-pass field extraction: first pass uses regex patterns for high-confidence structured fields (load numbers, dates, dollar amounts); second pass uses Flash model for ambiguous fields.

**Status:** Deployed. Per-field accuracy: load number 97%, dates 94%, rates 89%.

**Field priority:** load_number, shipper, consignee, pickup_date, delivery_date, rate_per_mile, total_rate, weight, commodity.
