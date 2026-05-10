# Memory Index

## Projects

- [Pipelines MCP](project_pipelines_mcp.md) — REST-to-MCP bridge for the doc-processing pipeline. 8 tools, 91 tests. Deployed 2026-04-10.
- [Canary CLI](project_canary_cli.md) — CLI wrapper for autoresearch canary capture. v0.2.1, 47 tests. Stable.
- [Schema Registry](project_schema_registry.md) — Central Pydantic schema store shared across all MCPs. Read-only in production.

## Reference

- [FastMCP stdio transport](reference_fastmcp_stdio.md) — All local MCPs use stdio. SSE only for TCC-isolation workaround.
- [uv workspace deps](reference_uv_workspace_deps.md) — Shared deps go in root pyproject.toml; per-project extras override in member pyproject.

## User

- [G Working Style](user_working_style.md) — Max parallelism, sequential phases, terse delegation, paste-as-instruction pattern.

## Feedback

- [Schema First](feedback_schema_first.md) — Define Pydantic models before writing tool logic. Prevents return-type drift.
- [NOOP Is a Valid Op](feedback_noop_is_valid.md) — Returning nothing is a decision. Log the reason; don't apologize.
