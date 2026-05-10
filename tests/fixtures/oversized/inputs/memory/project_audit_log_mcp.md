---
name: Audit Log MCP
description: FastMCP server wrapping the SQLite audit trail. 18 read-only tools. Deployed.
type: project
---

Exposes the pipeline's SQLite audit log as a read-only MCP server. Used by agents that need to inspect pipeline history without direct DB access.

**Status:** Deployed. 18 tools. No open issues.

**Transport:** stdio (local only).

**Key tools:** get_run, list_runs, get_errors, search_by_doc_id, get_stats.
