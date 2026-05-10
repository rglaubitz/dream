---
name: Legacy OCR Spike
description: Spike from 2026-02-01 exploring Google Vision API as Tesseract alternative. Superseded 2026-02-14.
type: project
---

Exploration spike: could Google Vision API replace Tesseract for our OCR layer?

**Outcome:** No. Rejected 2026-02-14. OCR Engine Wrapper (Tesseract-based) was chosen instead.

**Rejection criteria:**

- Cost: ~$1.50/1000 pages paid tier → ~$180/month at current volume
- Latency: 1.2s p50 vs Tesseract 0.4s p50 — no meaningful accuracy advantage to justify the gap
- Rate limits: 1800 req/min free tier acceptable, but paid tier required for headroom

**Status:** Superseded. Never productionized. Last referenced 2026-02-14. All follow-on work in `project_ocr_engine_wrapper.md`.

**Why retained:** Documents why Vision API was rejected so future engineers don't relitigate the decision without new data.

**DEMOTE signal:** No sessions have referenced this file since 2026-02-14. Spike is complete; decision is final. Move to `archived/` on next dream pass.
