---
name: OCR Engine Wrapper
description: Thin Python wrapper around Tesseract. Normalizes output, handles multi-page PDFs.
type: project
---

Wraps Tesseract OCR with a normalized Python interface. Handles multi-page PDFs by splitting pages, running OCR per page, and reassembling as structured text blocks.

**Status:** Deployed. Chosen over Google Vision API and EasyOCR in 2026-02-14 evaluation.

**Decision rationale:** Best cost/latency trade-off at current volume. Vision API rejected on cost; EasyOCR rejected on accuracy for low-res scans.

**Config:** psm mode set per doc type — see `reference_tesseract_config.md`.
