# Expected Diff — clean-tight

## Summary

No file modifications expected. This is a negative-control fixture.

## Expected op counts

```json
{
  "consolidate": {
    "merge": 0,
    "update": 0,
    "create": 0,
    "delete": 0,
    "noop": 2
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

## NOOP rationale (expected in dream summary)

1. **NOOP on `project_pipelines_mcp.md`** — Session entry mentions test count changed from 91 to 92, but session notes this is minor and deferred to "next substantive session." The signal is acknowledged; the session entry itself says not to update yet. Dream should NOOP and note the deferred flag.

2. **NOOP on `canary-cli-v0.3-upgrade` thread** — Thread is stale/parked with no new decisions. Nothing to consolidate.

## Validation gate

All 6 checks pass on first attempt:

1. `wc -l MEMORY.md` → 15 lines (well under 200)
2. `wc -c MEMORY.md` → ~600 bytes (well under 25 KB)
3. Every index line ≤ 150 chars: YES
4. Every index line points to a real file: YES
5. Every topic file has valid frontmatter: YES
6. Signal-aware check: `input_signal = low` AND `total_ops == 0` → healthy NOOP, no `phase_skipped_suspected` failure

## Test assertion

If any non-NOOP consolidate op or any prune op fires against this fixture, it is a **false positive**. The fixture contains no drift, no stale paths, no bloated index lines, no over-cap content. Any modification to the memory directory constitutes a test failure.

## Memory state after dream

Identical to memory state before dream. Git diff should be empty (or contain only a dream pointer file in `~/.claude/dream/runs/`).
