---
name: dream
description: >
  Memory consolidation skill — runs a structured 4-phase pass over an agent's
  memory directory and journal artifacts, merging duplicates, pruning stale
  facts, converting relative dates to absolute, and rebuilding the MEMORY.md
  index under its hard caps. Use this skill whenever the user runs /dream, OR
  when /journal completes and chains into /dream, OR when MEMORY.md is
  approaching or over its 200-line / 25KB caps, OR when the user says memory
  feels stale, cluttered, or duplicated. Also trigger when the user says
  "consolidate memory", "prune memory", "compact MEMORY.md", "run a memory
  pass", or any end-of-session memory housekeeping phrasing. Do not wait for
  an explicit /dream invocation — if /journal just finished, invoke this
  automatically as its final step.
allowed-tools:
  - Read # precondition check + consolidate reads + validation
  - Glob # enumerate memory files + find journal artifacts
  - Grep # drift detection, date-rot scans, transcript grep for read/route counts
  - Edit # consolidate UPDATE/MERGE ops (memory dir only)
  - Write # consolidate CREATE op (memory dir only)
  - Bash # approved subcommands only (see Sandbox section below)
# Bash sandbox — permitted subcommands:
#   ls, cat, wc, mkdir -p (memory dir only), mv (within memory dir only),
#   rm (memory dir only), flock
# Explicitly forbidden: WebFetch, WebSearch, Task, Agent, any MCP tool.
# The prompt below enforces this. Writes must stay inside the memory dir.
---

## Purpose

Memory accumulates faster than it gets curated. Auto-memory writes one fact at
a time, inline, with no view of the whole. `/dream` is the periodic batch pass
that looks at the full memory directory alongside recent journal artifacts and
asks: is this still true? do these belong together? is this line over the cap?

Run it at the tail of every substantive session. The journals kit chains into it
automatically; you can also invoke it manually when memory feels messy.

This skill produces no new knowledge. It reorganizes and validates what already
exists, so the index stays trustworthy and within its size budget.

---

## Step 0 — Preconditions

Dream is gated on `/journal` having run. Check all four inputs exist before
doing any work. This eliminates cold-start and missing-artifact edge cases at
the threshold.

**Required inputs:**

| Artifact      | Path                                                                  | Required content                           |
| ------------- | --------------------------------------------------------------------- | ------------------------------------------ |
| Session entry | `journals/sessions/<date>-session-N.md`                               | Frontmatter + `## Threads touched` section |
| Open threads  | `journals/threads/<thread-id>.md` for each ID listed in session entry | `status: open` in frontmatter              |
| Daily-note    | `journals/daily-notes/<date>.md`                                      | Any non-empty body                         |
| Memory dir    | `~/.claude/projects/<encoded-cwd>/memory/`                            | Exists; contains `MEMORY.md`               |

**How to check:** use `ls` on the memory dir and `cat` on each artifact path.
If the memory dir is absent, set `cold_start: true`. For any missing artifact,
set `preconditions: {all_met: false, missing: [...artifact names...]}`.

**If any precondition is unmet:** output the summary JSON with `preconditions_unmet`
flag, exit 0, do nothing else. Repeated failures here usually mean `/journal`'s
schema drifted — note it in the summary so the operator can investigate.

**If all preconditions are met:** compute `input_signal` (low / med / high):

| Level  | Triggers                                                                            |
| ------ | ----------------------------------------------------------------------------------- |
| `low`  | Session entry < 30 lines AND 0 open threads AND no contradiction language           |
| `med`  | Session entry 30-150 lines OR 1-2 threads OR some new facts                         |
| `high` | Session entry > 150 lines OR ≥3 threads OR explicit decision/contradiction language |

Also grep `~/.claude/projects/<encoded-cwd>/*.jsonl` for `tool_use` events with
`name: "Read"` on each memory file path to compute `read_count`. Count assistant
text mentions of the file's basename (minus Read events) for `route_count`. In
v1 these are visibility-only signals — they appear in the summary but do not
drive automated decisions. If transcripts are unparseable, set
`access_signal_unavailable` in anomalies and continue.

---

## Phase 1 — Consolidate

For each piece of signal in the journal artifacts, decide one operation against
the existing memory directory. Read the memory dir with `ls` first to get the
full file list; then read `MEMORY.md` to understand the index shape; then work
through the session entry, open threads, and daily-note.

### The five ops

**MERGE** — two existing topic files overlap substantially on the same topic.
Combine into the better-named file. Delete the redundant one. Collapse both
index lines into one. Use MERGE when the overlap is real content, not just
subject area.

**UPDATE** — an existing file is mostly right, but new signal contradicts a
fact, adds nuance, or fills a gap. Edit in place. Rewrite only the contradicted
lines. Update the index hook in MEMORY.md if the one-line description changed.
This is the default consolidation op — prefer it over DELETE.

**CREATE** — signal is genuinely new and doesn't fit any existing file. Write
a new topic file using the calling agent's declared auto-memory schema (check
its system prompt or CLAUDE.md for the schema). Add an index line in the right
section of MEMORY.md (matching the file's `type:` frontmatter).

**DELETE** — a topic file is fully superseded: the project was archived, the
fact was disproved, the decision was reversed. `rm` the file. Remove its index
line. Only use DELETE when supersession is total; partial staleness should be
UPDATE.

**NOOP** — signal is already captured accurately, or is ephemeral and shouldn't
be saved. Do nothing; note in the summary why. NOOP is not a fallback — it's an
intentional decision.

### Drift detection (when to trigger UPDATE or DELETE)

Staleness isn't always obvious. Check these patterns:

- **Path or state drift:** memory says "X exists at path Y" — verify with `ls`.
  If the path is gone, UPDATE or DELETE.
- **Decision reversal:** memory says "decision is A" — session entry shows B.
  UPDATE.
- **Status drift:** memory says "active" or "in progress" — project moved to
  archive or shipped. UPDATE the status line.
- **Date rot:** memory contains "yesterday", "last week", "next sprint" — convert
  to absolute dates anchored on the session entry's written-at timestamp.

Date conversion is non-negotiable. Relative dates that survive consolidation
will rot silently and become unusable.

| Memory text              | After conversion                               |
| ------------------------ | ---------------------------------------------- |
| "yesterday we shipped X" | "2026-05-09 we shipped X"                      |
| "last week's incident"   | "the 2026-04-28 to 2026-05-04 week's incident" |
| "currently testing"      | "as of 2026-05-09, testing"                    |

### The verification rule — before DELETE or rewrite, prove staleness

Don't delete or rewrite a fact because it sounds old. Verify in two steps:

1. Does newer signal in the session or threads contradict the memory?
2. Is that contradiction grounded in observed state (file paths, commit SHAs,
   explicit status updates) or just opinion drift?

Act only when both are true. When in doubt, NOOP and let the next dream catch
it once the signal is stronger. Over-deletion is harder to undo than leaving a
stale fact for one more session.

### Worked examples

**Project status drift (UPDATE):**

```
BEFORE: "rglaubitz/video-analyzer 1.2.0. Phase 2 in flight."
SIGNAL: session entry 2026-05-08 — "Both phases closed, project archived."
CHECK 1: contradiction? YES — "in flight" vs "archived"
CHECK 2: grounded? YES — session cites GH archive action and git tag
OP: UPDATE description and body to reflect archived status.
    Check sibling file for cross-drift; if yes, MERGE.
```

**Reference path drift (UPDATE):**

```
BEFORE: "Canonical source at ~/workspace-protocol/. Tools-manager symlinks to it."
VERIFY: ls ~/workspace-protocol → exists ✓
        ls tools-manager/.claude/rules → symlink absent, content present
CHECK 1: contradiction? PARTIAL — symlink claim no longer accurate
CHECK 2: grounded? YES — direct ls observation, path-claim is falsifiable
OP: UPDATE the symlink claim; keep the canonical-source claim.
    Flag drift_source: observed in op record.
```

**Schema fix during UPDATE:**
When a file has missing frontmatter or a feedback entry missing `**Why:**` /
`**How to apply:**`, fix it as part of the UPDATE if the fix is small. For
large schema rewrites, complete what you can and flag the rest in the summary
for human review rather than leaving half-rewritten files.

---

## Phase 2 — Prune & Index

MEMORY.md is an index, not a dump. Every line is a pointer to a topic file with
a one-line hook. Prune is specifically about that index — keeping it tight and
within hard caps.

Hard caps (invariants, not targets):

- **≤200 total lines** in MEMORY.md (headers + blank lines count)
- **≤25KB** total file size
- **≤150 chars** per index line
- **One line per memory** — no multi-line entries, no nested bullets

### The five prune ops

**TRIM** — an index line exceeds 150 chars because it carries prose that belongs
in the topic file. Shorten the line. Move the detail into the file body. The
index hook should be one punchy sentence.

**REMOVE** — an index line points to a topic file that Consolidate just deleted.
Drop the line.

**DEMOTE** — a topic file is still relevant but its index line is bloated, OR
the file is rarely accessed and not currently load-bearing. Move the file to
`<memory-dir>/archived/<filename>` (create the subdirectory with `mkdir -p` on
first use). Remove the index line. The file remains greppable but doesn't pay
the daily index cost.

**PROMOTE** — a topic file exists and matters but isn't in the index, or is
buried below a section it should sit above. Add or reposition the index line.
New entries go in the section matching the file's `type:` frontmatter.

**MERGE-LINES** — two index lines describe the same topic (both point to files
that Consolidate just merged into one). Collapse to a single line with a hook
that captures both facts.

### When the index is still over cap after Prune

Do not force-demote algorithmically. Automated last-resort demotion based on
heuristics is too brittle — the signals that define "rarely accessed" drift
themselves. Instead:

- Let the validation gate catch it with `over_cap_unresolved`
- Exit non-zero; leave changes uncommitted
- In the summary, list the top-5 longest lines and top-5 oldest files (by
  frontmatter date if present) as human-review candidates — not auto-action
- The next `/journal` will surface the failed dream summary so the operator can
  manually decide what to demote

### Section organization

MEMORY.md uses these section headers. Preserve this structure; empty sections
are removed:

```markdown
# Memory Index

## Projects

- [Title](file.md) — hook

## Reference

- [Title](file.md) — hook

## User

- [Title](file.md) — hook

## Feedback

- [Title](file.md) — hook
```

---

## Validation Gate

Run this after Prune, before committing. Six checks; one auto-fix retry allowed.

| #   | Check                   | Command                   | Fail condition                                                                                    |
| --- | ----------------------- | ------------------------- | ------------------------------------------------------------------------------------------------- |
| 1   | Line count              | `wc -l MEMORY.md`         | > 200                                                                                             |
| 2   | Byte size               | `wc -c MEMORY.md`         | > 25600                                                                                           |
| 3   | Line length             | `awk` over MEMORY.md      | any non-empty non-header line > 150 chars                                                         |
| 4   | Index integrity         | Read each linked file     | any index line points to a missing file                                                           |
| 5   | Frontmatter validity    | Check each topic file     | missing or malformed frontmatter                                                                  |
| 6   | Signal-aware completion | Count total ops and noops | `total_ops == 0 AND total_noops == 0 AND input_signal in {med, high}` → `phase_skipped_suspected` |

Check 6 exists because a dream that touched nothing with medium or high input
signal almost certainly skipped a phase rather than legitimately finding nothing
to do. A `low` signal dream with all NOOPs is healthy.

**If any check fails:** attempt one auto-fix pass (TRIM the longest lines for
check 3, re-run REMOVE for check 4, add missing frontmatter stubs for check 5).
If that also fails, exit non-zero with which checks failed; leave changes
uncommitted so the operator can inspect the diff.

**If auto-fix succeeds:** record `validation_auto_fix_used` in anomalies.
The run still commits.

---

## Anomaly Flags

These are soft signals — record them in the summary, but never abort or refuse
to commit because of them. They exist to give the operator visibility into
dreams that might be worth reviewing.

| Flag                        | Trigger                                           |
| --------------------------- | ------------------------------------------------- |
| `high_diff_volume`          | > 20% of memory files modified in one run         |
| `delete_burst`              | > 10 DELETE ops                                   |
| `merge_burst`               | > 5 MERGE ops                                     |
| `cap_pressure`              | After Prune, MEMORY.md within 10% of any hard cap |
| `validation_auto_fix_used`  | Validation required an auto-fix pass              |
| `access_signal_unavailable` | Transcript grep failed; read/route counts unknown |

All set flags appear in the `anomalies` array of the summary JSON.

---

## Summary JSON

Output this as the final stdout before exit. The launch CLI transcript captures
it; it's greppable for later analysis.

```json
{
  "preconditions": {
    "all_met": true,
    "missing": [],
    "cold_start": false
  },
  "input_signal": "med",
  "phase_completion": {
    "consolidate": true,
    "prune": true,
    "validate": true
  },
  "ops": {
    "consolidate": {
      "merge": 2,
      "update": 5,
      "create": 1,
      "delete": 4,
      "noop": 3
    },
    "prune": {
      "trim": 6,
      "remove": 4,
      "demote": 0,
      "promote": 1,
      "merge_lines": 2
    }
  },
  "diff": {
    "files_changed": 12,
    "files_changed_pct": 14.3,
    "lines_added": 87,
    "lines_deleted": 134
  },
  "memory_files_before": 84,
  "memory_files_after": 81,
  "memory_md_lines_before": 215,
  "memory_md_lines_after": 198,
  "memory_md_bytes_before": 28100,
  "memory_md_bytes_after": 24300,
  "thresholds_hit_pre": ["over_line_cap", "over_byte_cap"],
  "thresholds_clear_post": [
    "under_line_cap",
    "under_byte_cap",
    "all_index_lines_under_150_chars"
  ],
  "validation": {
    "checks_passed": 6,
    "checks_failed": 0,
    "auto_fix_attempts": 0
  },
  "anomalies": [],
  "session_entry": "journals/sessions/2026-05-09-session-1.md",
  "telemetry_pointer": null
}
```

Set `telemetry_pointer` to the launch CLI run-id path
(`~/.claude/dispatch/runs/<run-id>/`) in dispatched mode. Set null in inline
mode (the session transcript is the record).

For `preconditions_unmet` runs, emit only the preconditions block and the
anomalies array; omit ops/diff/validation.

---

## Bundled References

Load these on demand — don't preload all of them at the start of every run.

| File                             | When to load                                                   |
| -------------------------------- | -------------------------------------------------------------- |
| `references/op-rubric.md`        | When unsure whether a piece of signal warrants MERGE vs UPDATE |
| `references/drift-examples.md`   | When a drift case doesn't match the worked examples above      |
| `references/journal-contract.md` | When the session entry or thread format looks unexpected       |
| `examples/run-summary.json`      | When constructing the summary JSON and unsure about a field    |
| `constants.md`                   | When cap values need verifying (200 lines / 25KB / 150 chars)  |
