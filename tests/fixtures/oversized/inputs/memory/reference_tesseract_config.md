---
name: Tesseract config
description: --psm 6 for rate cons and settlements. --psm 3 for driver letters and non-standard layouts.
type: reference
---

Page segmentation mode by doc type:

- `--psm 6` (uniform text block): rate cons, OTR settlements, driver settlements, invoices — structured single-column layouts
- `--psm 3` (fully automatic): driver letters, accessorial notices, non-standard carrier docs

Language: always `eng`. DPI: normalize to 300 DPI before OCR for scanned docs.
