---
name: Doc Ingest Pipeline
description: End-to-end doc processing: receive, OCR, extract, validate, route, archive. 12 stages, deployed 2026-04-02.
type: project
---

The primary document processing pipeline. Receives raw documents (PDFs, images) via the ingest API, runs them through 12 sequential stages, and routes results to downstream systems.

**Status:** Deployed 2026-04-02. Stable. Processing ~120 docs/day.

**Stages:** receive → deduplicate → OCR → normalize → extract → validate → classify → route → qbo-sync → drive-archive → airtable-sync → audit-log.

**Repo:** agent-vega/doc-ingest-pipeline
