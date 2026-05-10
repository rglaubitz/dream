# Memory Index

## Projects

- [Doc Ingest Pipeline](project_doc_ingest_pipeline.md) — End-to-end doc processing: receive, OCR, extract, validate, route, archive. 12 stages, deployed 2026-04-02.
- [Batch Runner](project_batch_runner.md) — Overnight batch job runner. v2.1, stable, runs nightly via launchd.
- [Batch Scheduler v2](project_batch_scheduler_v2.md) — Successor to Batch Runner; consolidates scheduling + execution. v2.3, active.
- [Schema Registry](project_schema_registry.md) — Central Pydantic schema store. All MCPs import from here. Read-only in production.
- [Routing Rules Engine](project_routing_rules_engine.md) — YAML rule-based doc router. Classifies by type, routes to downstream handler.
- [Audit Log MCP](project_audit_log_mcp.md) — FastMCP server wrapping the SQLite audit trail. 18 read-only tools. Deployed.
- [Ingest CLI](project_ingest_cli.md) — Typer CLI for manual doc ingest during dev. v0.4.2. Not for production automation.
- [Schema Validator CLI](project_schema_validator_cli.md) — Standalone validator CLI. Runs pre-ingest against schema registry. 62 tests.
- [Classification Model](project_classification_model.md) — Fine-tuned Flash model for doc-type classification. 14 classes, 98.2% accuracy.
- [Confidence Scorer](project_confidence_scorer.md) — Post-classification scorer. Assigns confidence bands and routes low-confidence docs to review queue.
- [Review Queue MCP](project_review_queue_mcp.md) — MCP server for human review of low-confidence classifications. 9 tools, 44 tests.
- [OCR Engine Wrapper](project_ocr_engine_wrapper.md) — Thin Python wrapper around Tesseract. Normalizes output, handles multi-page PDFs.
- [Legacy OCR Spike](project_legacy_ocr_spike.md) — Spike from 2026-02-01 exploring Google Vision API as Tesseract alternative. Superseded 2026-02-14 when OCR Engine Wrapper decision locked in. Never productionized. Rate limits and per-page cost were the rejection criteria; this file documents the benchmark methodology and raw numbers for future reference if the Vision API question resurfaces. DEMOTE CANDIDATE: last referenced 2026-02-14.
- [Field Extractor](project_field_extractor.md) — Regex + LLM hybrid extractor. Pulls structured fields from normalized OCR text.
- [QBO Sync Worker](project_qbo_sync_worker.md) — Background worker that pushes extracted invoice fields to QBO. Handles OAuth token refresh.
- [Drive Archive Worker](project_drive_archive_worker.md) — Background worker that archives processed docs to Google Drive with structured naming.
- [Airtable Sync Worker](project_airtable_sync_worker.md) — Background worker that upserts extracted fields to Airtable. Uses custom Airtable MCP.
- [Canary Capture CLI](project_canary_capture_cli.md) — CLI for autoresearch canary capture. Snapshots tool help text, emits structured JSON for scoring. v0.2.1, 47 tests.
- [Autoresearch Runner](project_autoresearch_runner.md) — Orchestrates 5-layer autoresearch loop. Manages iteration budget, scoring, and SKILL.md edits.

## Reference

- [FastMCP stdio transport](reference_fastmcp_stdio.md) — All local MCPs use stdio transport. SSE only when a separate process identity is required for TCC isolation.
- [uv workspace deps](reference_uv_workspace_deps.md) — Shared deps in root pyproject.toml; per-project extras in member pyproject. Always commit uv.lock.
- [Pydantic v2 migration](reference_pydantic_v2_migration.md) — v2: @field_validator not @validator. model_rebuild() for forward refs. .dict() → .model_dump().
- [FastMCP error format](reference_fastmcp_error_format.md) — Tools return structured JSON errors with code + message. Never raise bare exceptions at MCP boundary.
- [Old Auth Flow](reference_old_auth_flow.md) — OAuth2 PKCE flow used before the 2026-03-15 server-side token store migration. Client stored tokens in ~/.config/pipeline/auth.json. Replaced due to race condition on concurrent refresh and token file corruption under flock contention. The old flow is fully decommissioned; this file is retained only to explain the migration rationale to new contributors. No production code uses this path. DEMOTE CANDIDATE: obsolete since 2026-03-15.
- [Stacked PR rebase](reference_stacked_pr_rebase.md) — Each squash-merge changes SHAs on main. Rebase next stacked branch onto origin/main after each merge, then force-push.
- [uv lock pinning](reference_uv_lock_pinning.md) — Always commit uv.lock. Regenerate with `uv lock`. Reject PRs that touch pyproject.toml without updating lock.
- [launchd plist naming](reference_launchd_plist_naming.md) — Reverse-domain format required: com.agentfleet.<agent>.<job>. Wrong format causes launchd to silently skip loading the plist.
- [SQLite WAL mode](reference_sqlite_wal_mode.md) — Enable WAL mode on all SQLite DBs used by concurrent workers. Prevents write-lock contention under parallel reads.
- [Google Drive folder structure](reference_google_drive_folder.md) — Archived docs: Drive/Pipeline/Archive/<YYYY>/<MM>/<doc-type>/<date>-<doc-id>-<doc-type>.pdf.
- [Tesseract config](reference_tesseract_config.md) — --psm 6 for rate cons and settlements. --psm 3 for driver letters and non-standard layouts. Language: eng.
- [Rate limiting pattern](reference_rate_limiting_pattern.md) — Token-bucket rate limiting for all outbound API callers. Defaults: 10 req/s QBO, 5 req/s Drive, 20 req/s Airtable.

## User

- [G Working Style](user_working_style.md) — Max parallelism, sequential phases, terse delegation, paste-as-instruction pattern.
- [G Trucking Context](user_trucking_context.md) — G runs a trucking operation. Key doc types: rate cons, BOLs, OTR settlements, driver settlements, invoices.
- [G Prioritization](user_prioritization.md) — Shipped beats perfect. G will ask for polish explicitly; don't volunteer it on first pass.

## Feedback

- [Schema First](feedback_schema_first.md) — Define Pydantic models before writing tool logic. Prevents return-type drift discovered at runtime.
- [Mock at the Boundary](feedback_mock_at_boundary.md) — Mock external I/O only. Never mock internal logic. If internal mocking feels necessary, refactor the boundary.
- [Parallel First](feedback_parallel_first.md) — Always attempt parallel tool calls before falling back to sequential. G notices and flags serial work.
- [Test Naming Convention](feedback_test_naming.md) — test*<action>*<condition>\_<expected>. Three-part names only. G rejects PRs without them.
- [Commit Message Format](feedback_commit_message.md) — Conventional commits: feat/fix/chore/docs/test. No bare "update" or "misc". G will revert.
- [Error Message Quality](feedback_error_message_quality.md) — Error messages must state what failed, why (if known), and what to do next. Never "something went wrong".
- [Verbose Logging Preference](feedback_verbose_logging.md) — G's early direction (2026-01-20): always emit verbose logs by default. Every step logged at INFO level. This preference was explicitly reversed on 2026-03-10 when G said "default to ERROR, let callers opt into verbose with --verbose." See feedback_log_level_control.md for the active rule. DEMOTE CANDIDATE: superseded, retained only for historical context.
- [Log Level Control](feedback_log_level_control.md) — Default log level is ERROR. Callers opt into verbose with --verbose. Supersedes verbose-logging-preference. Active rule.
- [NOOP Is a Valid Op](feedback_noop_is_valid.md) — Returning nothing is a decision. Log the reason explicitly. Don't apologize for not acting.
- [Phase Gate Before Implementation](feedback_phase_gate.md) — No code edits until vision/arch/tech/testing/ROADMAP/phase-tasks are filled in and signed off. Template stubs = deny.
- [Canary First-Look Surface](feedback_canary_first_look.md) — In LLM-tool autoresearch, only changes to the top-level --help surface move composite. Subcommands are invisible.
- [Reinstall Before Canary Eval](feedback_reinstall_canary.md) — Canary captures tool --help via PATH. uv-tool installs go stale after source edits. Reinstall before measuring.
- [Grinder and Reviewer Pattern](feedback_grinder_reviewer.md) — Multi-file mechanical edits: dispatch grinder Sonnet for commits, reviewer Sonnet to verify. Catches misses.
- [Fresh Eval Teams](feedback_fresh_eval_teams.md) — Multi-round evals: never include prior scores in prompts. Raw source, identical rubrics, minimum 3 rounds.
- [Identical Length Errors Signal Quota Wall](feedback_identical_length_errors.md) — N failures with identical byte-length errors = single upstream rate limit, not N independent bugs.

<!-- pad-001: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-002: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-003: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-004: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-005: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-006: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-007: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-008: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-009: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-010: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-011: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-012: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-013: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-014: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-015: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-016: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-017: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-018: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-019: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-020: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-021: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-022: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-023: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-024: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-025: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-026: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-027: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-028: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-029: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-030: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-031: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-032: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-033: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-034: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-035: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-036: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-037: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-038: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-039: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-040: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-041: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-042: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-043: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-044: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-045: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-046: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-047: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-048: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-049: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-050: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-051: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-052: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-053: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-054: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-055: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-056: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-057: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-058: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-059: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-060: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-061: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-062: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-063: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-064: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-065: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-066: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-067: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-068: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-069: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-070: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-071: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-072: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-073: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-074: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-075: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-076: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-077: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-078: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-079: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-080: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-081: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-082: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-083: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-084: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-085: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-086: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-087: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-088: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-089: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-090: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-091: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-092: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-093: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-094: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-095: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-096: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-097: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-098: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-099: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-100: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-101: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-102: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-103: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-104: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-105: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-106: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-107: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-108: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-109: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-110: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-111: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-112: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-113: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-114: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-115: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-116: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-117: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-118: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-119: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-120: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-121: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-122: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-123: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-124: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-125: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-126: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-127: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-128: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-129: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-130: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-131: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-132: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-133: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-134: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-135: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-136: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-137: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-138: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-139: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-140: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-141: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-142: growth log entry — autogenerated synthetic padding for oversized fixture -->
<!-- pad-143: growth log entry — autogenerated synthetic padding for oversized fixture -->
## Notes

<!-- The following entries were added in bulk during rapid development and have not been reviewed. -->
<!-- They are carrying index-level content that belongs in topic file bodies. -->
<!-- These are TRIM and DEMOTE candidates for the next dream pass. -->

- [OCR benchmark notes](note_ocr_benchmark.md) — Raw benchmark numbers from OCR engine comparison (2026-04-03): Tesseract vs Google Vision API vs EasyOCR on a 50-document corpus of rate cons and driver settlements. Tesseract: 0.4s p50, 1.1s p95, $0/page. Vision API: 1.2s p50, 3.8s p95, $1.50/1000 pages. EasyOCR: 0.9s p50, 2.4s p95, $0/page but 12% lower accuracy on low-resolution scans. Decision: Tesseract for cost and latency; Vision API revisit only if accuracy on complex layouts becomes blocking.
- [Vision API spike notes](note_vision_api_spike.md) — Spike evaluation notes from 2026-02-01: explored Google Vision API as potential Tesseract replacement. Rate limits on free tier (1800 req/min) are acceptable for current volume. Paid tier at $1.50/1000 pages would cost ~$180/month at current doc volume. Rejected in favor of Tesseract on cost grounds. If volume grows 10x, revisit. Raw API response samples stored in docs/spikes/vision-api-2026-02/.
- [Confidence band draft thresholds](note_confidence_draft.md) — Early draft confidence band thresholds from 2026-03-20 design session: high >0.90, med 0.65–0.90, low <0.65. These were initial guesses before calibration against the real doc corpus. Final calibrated values live in project_confidence_scorer.md — always check there first. These draft numbers are retained only to show how the thresholds evolved; do not use them operationally.
- [Rate con field extraction notes](note_rate_con_fields.md) — Field extraction notes for rate cons: shipper name, consignee name, origin city/state, destination city/state, commodity, weight, rate (per mile and total), load number, pickup date, delivery date. These are the 12 core fields in priority order. Extraction accuracy by field: shipper 99%, consignee 98%, load number 97%, dates 94%, rate-per-mile 89% (hardest — formatting varies widely across carriers).
- [Driver settlement field notes](note_driver_settlement_fields.md) — Field extraction notes for driver settlements: driver name, driver ID, pay period start/end, gross pay, deductions itemized (fuel, insurance, escrow, advances), net pay, miles driven, loads completed. Extraction accuracy: driver name 99%, pay period 97%, gross pay 95%, deductions 88% (itemization varies; some carriers lump). Net pay is always derivable from gross minus deductions if direct extraction fails.
- [Airtable upsert key strategy](note_airtable_upsert_keys.md) — Upsert key decisions for each doc type: rate cons use load_number as primary key (unique per load); invoices use invoice_number; driver settlements use (driver_id, pay_period_start) composite key. Never use auto-generated IDs as upsert keys — they don't survive record recreation. This decision was made 2026-04-15 after an incident where a table rebuild orphaned 340 records because the upsert key was Airtable's internal record ID.
- [QBO invoice attachment flow](note_qbo_invoice_attachment.md) — Invoice attachment flow to QBO: (1) create or find Invoice record by invoice_number, (2) upload PDF as attachment via qbo_attachment tool with entity_type=Invoice and entity_id from step 1, (3) confirm attachment appears in QBO UI. Step 2 requires the PDF to be base64-encoded before passing to the tool. The attachment API returns an AttachableRef that must be linked back to the invoice — this is a two-call sequence, not a single atomic operation.
- [launchd debugging tips](note_launchd_debug.md) — When a launchd job silently fails to load: (1) check plist format with `plutil -lint <plist>`, (2) check system log with `log show --predicate 'subsystem == "com.apple.launchd"' --last 1h`, (3) verify plist is owned by root if in /Library/LaunchDaemons, (4) check that the working directory exists and the executable bit is set on the script. Most silent failures are plist syntax errors or permission issues that launchd swallows without error messages.
