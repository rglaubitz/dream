---
name: Audit Log MCP
description: MCP server exposing structured audit trail for all pipeline ops. 18 tools.
type: project
---

FastMCP server that wraps the pipeline's SQLite audit log. Exposes read-only query tools for agents that need to inspect pipeline history.

**Status:** Deployed. 18 tools. 0 open issues.

**Tools include:** get_run, list_runs, get_errors, search_by_doc_id, get_stats.

**Transport:** stdio (local only). No external access.
