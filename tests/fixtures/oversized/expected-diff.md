# Expected Diff — oversized

## Summary

Prune-heavy run. MEMORY.md starts at 220 lines (20 over the 200-line hard cap). Dream must bring it back under cap via TRIM, DEMOTE, and MERGE-LINES. Consolidate ops are minimal — no drift detected in the high-signal session (it explicitly flags no updates needed, only Prune work).

## Expected ops

```json
{
  "consolidate": {
    "merge": 0,
    "update": 0,
    "create": 0,
    "delete": 0,
    "noop": 3
  },
  "prune": {
    "trim": 5,
    "remove": 0,
    "demote": 3,
    "promote": 0,
    "merge_lines": 1
  }
}
```

Counts are targets. Acceptable ranges: TRIM 4–7, DEMOTE 3–4, MERGE-LINES 1.

## TRIM — 5 overlong index lines (>150 chars)

The following index lines in MEMORY.md carry body-level content and must be shortened. Each must be trimmed to ≤150 chars; the detail belongs in the topic file body, which is already there.

1. `project_legacy_ocr_spike.md` index line (298 chars) — trim to short hook, e.g. "Spike from 2026-02-01 on Google Vision API. Superseded 2026-02-14. DEMOTE candidate."
2. `reference_old_auth_flow.md` index line (381 chars) — trim to short hook, e.g. "OAuth2 PKCE flow replaced 2026-03-15. Client-side token store deprecated. Historical context only."
3. `feedback_verbose_logging.md` index line (295 chars) — trim to short hook noting supersession.
4. `reference_uv_workspace_deps.md` index line (225 chars) — trim to core fact.
5. `reference_fastmcp_error_format.md` index line (247 chars) — trim to core rule.

Additional lines may qualify depending on how the skill measures chars. Any index line over 150 chars after TRIM is a test failure.

## DEMOTE — 3 files moved to archived/

These three files are stale, superseded, or obsolete. Their index lines should be removed and the files moved to `<memory-dir>/archived/`:

1. **`project_legacy_ocr_spike.md`** — last referenced 2026-02-14, superseded by `project_ocr_engine_wrapper.md`. Session entry explicitly flags it as a DEMOTE candidate.
2. **`reference_old_auth_flow.md`** — decommissioned 2026-03-15. No production code uses this path. Session entry and thread both flag it.
3. **`feedback_verbose_logging.md`** — preference reversed 2026-03-10. Superseded by `feedback_log_level_control.md` (active rule, present in same index). Body is 45+ lines paying index cost for superseded guidance.

After DEMOTE: `archived/` subdirectory created if it didn't exist. Three files moved there. Three index lines removed.

## MERGE-LINES — batch subsystem (1 op)

`project_batch_runner.md` and `project_batch_scheduler_v2.md` describe the same subsystem from two angles (execution vs. orchestration). The thread and daily note both flag this.

**Expected result:** one index line survives covering the full batch subsystem. Suggested survivor: Batch Scheduler v2 line (it's the higher-level abstraction). The topic files themselves are NOT merged — only the index lines. Batch Runner's topic file remains accessible but not indexed.

Alternatively: one merged line like "Batch subsystem — Batch Runner (execution, v2.1) + Batch Scheduler v2 (orchestration, v2.3). Nightly launchd, stable."

## Expected final state of MEMORY.md

| Metric                              | Before                            | After    | Pass?                                                                                                                                                                                 |
| ----------------------------------- | --------------------------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Line count                          | 220                               | ≤ 200    | YES (3 DEMOTE removes 3 lines; MERGE-LINES removes 1; TRIM removes padding lines that were overlong index lines reduced to shorter forms — net reduction depends on pad line removal) |
| Byte count                          | varies                            | ≤ 25,600 | YES                                                                                                                                                                                   |
| Index lines > 150 chars             | many                              | 0        | YES                                                                                                                                                                                   |
| All index lines point to real files | NO (pad lines are not real files) | YES      | After removing pad comments                                                                                                                                                           |

**Important:** The HTML comment padding lines (`<!-- pad-NNN: ... -->`) in the pre-Prune MEMORY.md are not valid index entries and are not real file pointers. Dream's validation gate (check 4: every index line points to a real file) should detect these and remove them — either via TRIM (they're not index entries) or by recognizing the `## Archived Notes` and `## Notes` sections as non-standard and collapsing them. The expected final MEMORY.md contains only the four standard sections (Projects, Reference, User, Feedback) with valid pointer lines.

**Line count target:** after removing DEMOTE entries (3 lines), MERGE-LINES (1 line), and the padding comment block (143 lines), MEMORY.md should land at approximately 73–80 lines — well under the 200-line cap.

## Validation gate

All 6 checks must pass after Prune:

1. `wc -l MEMORY.md` → ≤ 200 lines: YES
2. `wc -c MEMORY.md` → ≤ 25,600 bytes: YES
3. All index lines ≤ 150 chars: YES (after TRIM)
4. All index lines point to real files in memory dir or `archived/`: YES (after DEMOTE moves files)
5. All topic files have valid frontmatter: YES (no topic files modified)
6. Signal-aware check: `input_signal = high` (session entry ~80 lines, 1 thread, explicit "memory index over cap" language), `total_ops = 9` (3 NOOP + 5 TRIM + 3 DEMOTE + 1 MERGE-LINES) → completion check passes

## Test failure condition

If `over_cap_unresolved` fires after this fixture, the test fails. The fixture is designed so that TRIM + DEMOTE + MERGE-LINES are sufficient to bring MEMORY.md under cap without requiring any forced algorithmic demotion.

If dream leaves MEMORY.md over 200 lines after completing Prune, it indicates either: (a) the DEMOTE op didn't fire on the three candidates, or (b) the padding comment lines were not removed. Both are test failures.
