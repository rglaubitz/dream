# Fixture: oversized

**What this exercises:** Stress test for Prune & Index. MEMORY.md is at 220 lines (over the 200-line hard cap). Several index lines exceed 150 chars. Multiple topic files are bloated (>40 lines) and have not been touched in synthetic months. Dream must bring the index back under caps via TRIM and DEMOTE without being told which files to target.

**Planted cases:**

1. **Over-cap MEMORY.md** — 220 lines total (20 over the 200-line hard cap). Prune must reduce it to ≤ 200 lines.

2. **Overlong index lines (TRIM targets)** — 5 index lines exceed 150 chars, carrying content that belongs in topic file bodies. Dream must TRIM these to ≤ 150 chars each.

3. **DEMOTE candidates (≥ 3 files)** — Three topic files are explicitly stale/rarely-relevant:
   - `project_legacy_ocr_spike.md` — a 2026-02-01 spike that was superseded. Never referenced since.
   - `reference_old_auth_flow.md` — documents an OAuth flow replaced in 2026-03-15. No longer applicable.
   - `feedback_verbose_logging.md` — a 2026-01-20 preference that was reversed and superseded by a newer entry in the same index. Body is 45 lines.
     These should be moved to `archived/` and their index lines removed.

4. **MERGE-LINES candidate** — Two index lines (`project_batch_runner.md` and `project_batch_scheduler_v2.md`) clearly describe the same consolidated project. One should survive; the other's line removed. (The two topic files themselves are distinct enough that a full MERGE is optional — the key signal is the MERGE-LINES prune op on the index.)

5. **High-signal session entry** — mentions multiple existing topics without introducing new facts, so Consolidate ops are minimal (≤ 1 UPDATE). The bulk of the work is in Prune.

**Reviewer verification:** Count lines in `inputs/memory/MEMORY.md` — should be 220. Identify the 5 overlong index lines (>150 chars). Locate the 3 DEMOTE candidates above. Confirm `inputs/journals/sessions/2026-05-09-session-1.md` references existing topics only and contains no new decisions that would trigger Consolidate ops.
