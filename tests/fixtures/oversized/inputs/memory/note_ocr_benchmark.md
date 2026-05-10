---
name: OCR benchmark notes
description: Raw OCR engine comparison data (2026-04-03). Tesseract vs Vision API vs EasyOCR on 50-doc corpus.
type: reference
---

Benchmark comparison run 2026-04-03 on a 50-document corpus (mix of rate cons, driver settlements, invoices).

| Engine            | p50 latency | p95 latency | Cost/1000 pages | Accuracy (low-res) |
| ----------------- | ----------- | ----------- | --------------- | ------------------ |
| Tesseract         | 0.4s        | 1.1s        | $0              | 91%                |
| Google Vision API | 1.2s        | 3.8s        | $1.50           | 96%                |
| EasyOCR           | 0.9s        | 2.4s        | $0              | 84%                |

**Decision:** Tesseract selected. Best cost/latency for current volume. Vision API revisit only if accuracy on complex layouts becomes blocking at scale.

**Raw data location:** `docs/spikes/ocr-benchmark-2026-04-03/`
