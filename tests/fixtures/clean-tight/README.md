# Fixture: clean-tight

**What this exercises:** Negative control — nothing should change. Catches over-eager consolidation or spurious Prune ops. Memory is well under all hard caps, all frontmatter is valid, and the journal artifacts contain only low-signal routine content that duplicates what's already in memory.

**Planted cases:**

- No drift cases. Every topic file accurately reflects the current state of the synthetic project.
- Session entry is < 30 lines and references no new facts — qualifies as `input_signal: low`.
- Open thread is stale and non-actionable (no decisions, no reversals, no contradictions).
- Daily note is routine with no status changes mentioned.

**Expected behavior:**

- `input_signal: low`
- Consolidate phase: zero UPDATE, zero MERGE, zero CREATE, zero DELETE ops. Possibly 1–2 NOOP entries noted in summary (confirming the skill read the journals and chose correctly).
- Prune phase: zero TRIM, zero DEMOTE, zero REMOVE. All index lines are under 150 chars. MEMORY.md is well under 200 lines and 25 KB.
- Validation gate: all 6 checks pass on the first attempt, no auto-fix needed.

**Reviewer check:** if any non-NOOP op fires against this fixture, it indicates a false positive in drift detection or an overly aggressive Prune heuristic. The fixture is designed so that every op requires no evidence to skip.
