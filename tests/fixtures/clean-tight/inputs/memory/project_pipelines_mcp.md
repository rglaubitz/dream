---
name: Pipelines MCP
description: REST-to-MCP bridge for the doc-processing pipeline. 8 tools, 91 tests. Deployed 2026-04-10.
type: project
---

Wraps the document ingestion REST API as a local MCP server. Used by agent-vega for batch doc processing.

**Status:** Deployed 2026-04-10. Stable. No open issues.

**Tools:** ingest_document, get_status, list_jobs, cancel_job, get_result, list_schemas, validate_payload, health_check.

**Tests:** 91 passing. Coverage at 88%.

**Notes:** Tested against staging API only. Prod API key lives in 1Password under "Pipelines MCP / Prod".
