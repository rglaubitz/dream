---
name: Vision API spike notes
description: Spike evaluation notes from 2026-02-01 on Google Vision API as Tesseract replacement.
type: reference
---

Spike run 2026-02-01. Question: could Google Vision API replace Tesseract?

**Findings:**

- Free tier: 1800 req/min. Acceptable for current volume.
- Paid tier: $1.50/1000 pages → ~$180/month at current volume of 120 docs/day.
- Latency: 1.2s p50 on 1-page docs. Acceptable but not better than local Tesseract.
- Accuracy on complex layouts: better than Tesseract by ~5%. Not enough to justify cost.

**Conclusion:** Rejected. Tesseract selected in OCR Engine Wrapper decision (2026-02-14).

**Revisit trigger:** If volume grows 10x OR accuracy on complex layouts becomes blocking.

**Raw API response samples:** `docs/spikes/vision-api-2026-02/`
