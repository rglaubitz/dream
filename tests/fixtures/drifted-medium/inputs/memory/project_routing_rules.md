---
name: Routing Rules Engine
description: Rule-based doc router: classifies by type, routes to correct downstream. Active.
type: project
---

Evaluates classified documents against a YAML rule set and routes them to the correct downstream handler (QBO ingest, Drive archive, Airtable update, or manual review queue).

**Status:** Active. Rule set at `config/routing-rules.yaml`.

**Rule types:** exact-match, regex, confidence-threshold, fallback.

**Notes:** Rule changes require a reload signal (SIGHUP) — the engine does not hot-reload. Restart required for schema changes.
