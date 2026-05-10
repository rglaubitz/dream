# Journal Contract

Dream requires four artifacts on entry. If any are missing, it exits 0 with a
`preconditions_unmet` summary and does no work. This is intentional — a no-op is
always safer than writing memory from incomplete signal.

---

## Required Inputs

### 1. Memory directory

**Path:** `~/.claude/projects/<encoded-cwd>/memory/`

The encoded-cwd is the project directory path with `/` replaced by `-` and special
characters percent-encoded (matching Claude Code's internal project ID scheme).

**Required content:** Directory must exist and contain a file named exactly
`MEMORY.md` (see `constants.md` for the filename invariant — no alternatives,
no lowercase).

**Detection:**

```bash
ls ~/.claude/projects/<encoded-cwd>/memory/MEMORY.md
```

Exit 0 = present. "No such file or directory" = memory dir missing; set
`cold_start: true` in the summary.

---

### 2. Session entry

**Path:** `journals/sessions/<date>-session-N.md`

Passed via the `extra` arg when `/dream` is invoked by `/journal`. If not passed,
detect as the most-recently-modified file matching the pattern.

**Required content:** Must have YAML frontmatter and a `## Threads touched` section
listing thread IDs (zero threads is valid — the section must still be present).

**Detection:**

```bash
# If path was passed via extra arg — verify it exists:
ls journals/sessions/<passed-path>

# If not passed — find the most recent:
ls -t journals/sessions/*.md | head -1
```

---

### 3. Open threads

**Path:** `journals/threads/<thread-id>.md` for each thread ID listed in the
session entry's `## Threads touched` section.

**Required content:** Frontmatter with `status: open`. Threads with `status: closed`
are ignored (not missing — just not signal-bearing for this run).

Zero open threads is valid — dream proceeds normally and the thread-scan phase is
a no-op.

**Detection:**

```bash
# For each thread-id listed in the session entry:
ls journals/threads/<thread-id>.md
grep 'status: open' journals/threads/<thread-id>.md
```

A thread file that exists but has `status: closed` is not a precondition failure.
A thread file that is listed but does not exist is a precondition failure — note it
in `missing`.

---

### 4. Daily note

**Path:** `journals/daily-notes/<date>.md` where `<date>` is today's date in
`YYYY-MM-DD` format.

**Required content:** Any non-empty body (at least one line after the frontmatter).

An absent daily note is a precondition failure. An empty daily note (frontmatter
only, no body) is also a failure — treat as missing.

**Detection:**

```bash
# Check existence and non-empty body:
find journals/daily-notes -name "$(date +%Y-%m-%d).md" -size +0c
```

---

## Missing-Artifact Behavior

If any required artifact is absent or malformed:

1. Do **not** proceed to Consolidate or Prune.
2. Do **not** write to the memory directory.
3. Emit the summary JSON with only the preconditions block and the anomalies array:

```json
{
  "preconditions": {
    "all_met": false,
    "missing": ["session_entry", "daily_note"],
    "cold_start": false
  },
  "anomalies": ["preconditions_unmet"]
}
```

4. Exit 0. A missing artifact is not a crash — it is a known, expected state when
   `/journal` hasn't run yet or ran with `--no-dream`.

5. In stdout (before the JSON), explain which artifact is missing and why that
   prevents dream from running. One sentence per missing artifact.

`preconditions_unmet` is a terminal anomaly flag (see `constants.md`) — the run is
not committed, but exit status is 0 so upstream callers don't treat it as an error.

---

## Why This Matters

The journal contract is the seam between `/journal` and `/dream`. Dream is not
designed to self-orient from raw transcripts — it starts from already-curated
artifacts that `/journal` produces. If that contract drifts (for example, if the
journals kit starts writing session files to `journals/sessions/YYYY/` instead of
`journals/sessions/`), dream will silently no-op on every run rather than reading
the wrong path or corrupting memory with stale signal. That silent no-op is
intentional: a failed precondition check surfaces in the summary JSON and in the
next `/journal` pass, giving the operator a clear signal that the two skills have
drifted out of sync. The fix is always upstream — align the journals kit's output
paths with what dream expects here, not the reverse.

---

## Cross-references

Used by Step 0 (Preconditions) of SKILL.md.
Cap values and filename invariants referenced above are defined in `constants.md`.
See `references/op-rubric.md` for what dream does once preconditions pass.
