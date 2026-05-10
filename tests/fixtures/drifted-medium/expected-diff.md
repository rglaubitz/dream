# Expected Diff — drifted-medium

## Summary

3 UPDATE ops expected — one per planted drift case. No DELETE ops. No CREATE ops. Index lines may need TRIM on the updated entries if the new hook text exceeds 150 chars.

## Expected ops

```json
{
  "consolidate": {
    "merge": 0,
    "update": 3,
    "create": 0,
    "delete": 0,
    "noop": 13
  },
  "prune": {
    "trim": 0,
    "remove": 0,
    "demote": 0,
    "promote": 0,
    "merge_lines": 0
  }
}
```

(TRIM count may be 1–2 if the rewritten index hooks for updated files exceed 150 chars. Zero is also acceptable if the skill writes short hooks.)

## UPDATE 1 — project_analyzer_pipeline.md (project-status drift)

**Trigger:** Topic file says "Phase 2 in flight." Session entry (2026-05-09) and thread (`analyzer-pipeline-phase2-closeout`) confirm Phase 2 closed and project archived 2026-05-08.

**Expected changes to file body:**

- Status line changes from "Phase 2 in flight" to "Phase 2 complete. Project archived 2026-05-08."
- Phase 2 entry in the Phases list changes from "In flight" to "Complete."
- Phase 3 note updated to "Deferred indefinitely — no timeline set."
- Notes line updated to reflect archival.

**Expected changes to MEMORY.md index line:**

- Hook updated from "...Phase 2 in flight." to reflect archived status.
- Hook must remain ≤ 150 chars.

**Must NOT fire:** DELETE. The project file remains useful as historical context and maintenance reference.

## UPDATE 2 — reference_deploy_symlink.md (reference-path drift)

**Trigger:** Topic file claims `~/tools/active → ~/projects/analyzer-pipeline` exists. Session entry (2026-05-09) explicitly states the symlink was removed 2026-05-08 during archival.

**Expected changes to file body:**

- "Current symlink" section updated to state the symlink was removed 2026-05-08.
- Convention section preserved — the pattern is still valid for future use.
- Note added: symlink is currently absent; re-create when the next project becomes active.

**Expected changes to MEMORY.md index line:**

- Hook updated from "...symlinked at ~/tools/active → ..." to reflect that no active symlink currently exists.
- Hook must remain ≤ 150 chars.

**drift_source:** session signal (session entry explicitly states removal). Optionally also observable state (ls ~/tools/active would fail).

**Must NOT fire:** DELETE. The convention itself is still valid reference material.

## UPDATE 3 — feedback_eval_scoring.md (feedback-preference reversal)

**Trigger:** Topic file says "Weighted score plateaus invisibly — drop it from reporting." Session entry (2026-05-09) contains an explicit G quote reversing this: "I want both metrics. Weighted composite first, then scenario breakdown."

**Expected changes to file body:**

- Original guidance preserved with date stamp: "G's direction (2026-04-18): [original quote] — this guidance was superseded 2026-05-09."
- New guidance added with date stamp and verbatim G quote from session entry.
- "How to apply" section rewritten: show both metrics; weighted composite first, scenario pass rate second.

**Expected changes to MEMORY.md index line:**

- Hook updated from "Scenario success rate is the signal. Weighted score plateaus invisibly — drop it." to reflect the new dual-metric rule.
- Hook must remain ≤ 150 chars.

**Must NOT fire:** DELETE. The original reasoning context (why weighted score was originally cut) is still useful historical signal.

## Harvest note

UPDATE 3's drift case is anonymized from the real tools-manager `feedback_eval_methodology.md` entry. The real entry says "MCP intuitiveness eval: include a zero-context round (no domain terms). Scenario success is the signal — weighted score plateaus invisibly." The session-entry signal reversing it is synthetic but structurally identical to the `feedback_eval_methodology.md` architecture-doc example (section "Feedback contradiction (preference reversed)").

## Validation gate

All 6 checks must pass after the 3 UPDATEs:

1. Line count: 16 lines in MEMORY.md (unchanged count; 3 index lines rewritten, not added/removed) — ≤ 200.
2. Byte count: ~800 bytes — ≤ 25 KB.
3. All index lines ≤ 150 chars (skill must write short hooks for the 3 updated lines).
4. All index lines point to real files: YES (no files deleted).
5. All topic files have valid frontmatter: YES (skill updates body, not frontmatter type/name).
6. Signal-aware check: `input_signal = med` (session entry ~60 lines, 1 thread), `total_ops = 3` → completion check passes.

## Over-triggering check

The 13 remaining topic files should all be NOOP. If dream fires UPDATE on any of the stable files (batch_scheduler, schema_validator, routing_rules, audit_log_mcp, ingest_cli, reference files, user files, other feedback files), it is a false positive.
