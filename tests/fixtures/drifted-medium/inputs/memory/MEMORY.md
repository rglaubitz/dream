# Memory Index

## Projects

- [Analyzer Pipeline](project_analyzer_pipeline.md) — Multi-stage doc analyzer: OCR → extract → classify → route. Phase 2 in flight.
- [Batch Scheduler](project_batch_scheduler.md) — Cron-driven batch runner for overnight pipeline jobs. v1.1, stable.
- [Schema Validator](project_schema_validator.md) — Standalone Pydantic validator CLI used pre-ingest. 62 tests, deployed.
- [Routing Rules Engine](project_routing_rules.md) — Rule-based doc router: classifies by type, routes to correct downstream. Active.
- [Audit Log MCP](project_audit_log_mcp.md) — MCP server exposing structured audit trail for all pipeline ops. 18 tools.
- [Ingest CLI](project_ingest_cli.md) — CLI frontend for manual doc ingest during dev. Wraps REST API. v0.4.2.

## Reference

- [Deploy symlink convention](reference_deploy_symlink.md) — Active project symlinked at ~/tools/active → ~/projects/analyzer-pipeline for quick access.
- [FastMCP error format](reference_fastmcp_error_format.md) — Tool errors must return structured JSON with code + message. Never raise bare exceptions.
- [uv lock pinning](reference_uv_lock_pinning.md) — Always commit uv.lock. Unlocked installs in CI produce non-deterministic failures.
- [Pydantic v2 migration](reference_pydantic_v2_migration.md) — v2 validators use @field_validator not @validator. model_rebuild() needed for forward refs.

## User

- [G Delegation Style](user_delegation_style.md) — G assigns tasks by pasting raw context. Expects agents to interpret, not ask for clarification.
- [G Prioritization](user_prioritization.md) — Shipped beats perfect. G will explicitly ask for polish; don't volunteer it on first pass.

## Feedback

- [Eval Scoring Approach](feedback_eval_scoring.md) — Scenario success rate is the signal. Weighted score plateaus invisibly — drop it from reporting.
- [Test Naming Convention](feedback_test_naming.md) — Test names: test*<action>*<condition>\_<expected>. Three-part names only.
- [Commit Message Format](feedback_commit_message.md) — Use conventional commits. feat/fix/chore/docs/test. No bare "update" or "misc" commits.
- [Parallel First](feedback_parallel_first.md) — Always attempt parallel tool calls before falling back to sequential.
- [Error Message Quality](feedback_error_message_quality.md) — Error messages must be actionable. "Something went wrong" is never acceptable.
- [Mock at the Boundary](feedback_mock_at_boundary.md) — Mock external I/O only. Never mock internal business logic. Tests that mock internals test nothing.
