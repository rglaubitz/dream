---
name: Analyzer Pipeline
description: Multi-stage doc analyzer: OCR → extract → classify → route. Phase 2 in flight.
type: project
---

Multi-stage document analysis pipeline. Receives raw docs from the ingest layer, runs OCR (Tesseract), extracts structured fields, classifies by document type, and routes to the correct downstream handler.

**Status:** Phase 2 in flight. Rate-con extraction module under active development.

**Phases:**

- Phase 1: OCR + basic extraction. Complete.
- Phase 2: Classification + routing. In flight.
- Phase 3: Confidence scoring + review queue. Planned.

**Repo:** agent-vega/analyzer-pipeline

**Notes:** Phase 2 target completion was 2026-05-07. Team Vega owns implementation.
