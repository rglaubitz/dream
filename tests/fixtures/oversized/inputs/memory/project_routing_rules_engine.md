---
name: Routing Rules Engine
description: YAML rule-based doc router. Classifies by type, routes to downstream handler.
type: project
---

Evaluates classified documents against a YAML rule set and routes them to the correct downstream handler.

**Status:** Active. Rule set at `config/routing-rules.yaml`.

**Downstream handlers:** QBO ingest, Drive archive, Airtable update, manual review queue.

**Rule reload:** SIGHUP required. No hot-reload. Schema changes require restart.
