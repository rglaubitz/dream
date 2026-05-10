# Op Rubric

When SKILL.md instructs an op, consult this rubric to decide whether it actually
fires. The rubric is the tiebreaker between SKILL.md's general guidance and a
particular memory file's specifics. If the rubric and SKILL.md seem to disagree,
the rubric wins — it was written with edge cases in mind.

---

## Consolidate Phase Ops

### MERGE

**What it is:** Combine two existing topic files that overlap substantially on the
same topic into one file. Delete the redundant file. Collapse both index lines to one.

**Fire when:**

- Two files share a core fact (same project, same decision, same pattern)
- At least 30% of one file's body would be redundant if both were read together
- The overlap is real content, not just shared subject area ("Front MCP" ≠ "Front CLI"
  even though both touch Front)

**Don't fire when:**

- Two files cover related but distinct concerns (e.g., a project file and its
  validation feedback file — different audiences, different durability)
- Merging would produce a file that violates the ≤150-char index constraint because
  the combined hook becomes unwieldy — instead UPDATE and keep both

**Examples:**

```
project_mcp_combo_in_workspace.md  → "MCB merged into tools-manager 2026-04-01."
project_tools_manager_src.md       → "src/ is universal tool home. Per 2026-04-01 reorg, MCB lives at root."

Both files are about the 2026-04-01 reorg. Core facts overlap.
→ MERGE into project_tools_manager_src.md (clearer name). DELETE project_mcp_combo_in_workspace.md.
  New index line: "src/ is universal tool home (19 dirs). MCB merged at root 2026-04-01."
```

---

### UPDATE

**What it is:** Existing file is mostly right but new signal contradicts one or more
facts, adds nuance, or fills a gap. Edit in place. Rewrite only the contradicted lines.
Update the MEMORY.md index hook if the one-line description changed.

**Fire when:**

- New signal (session entry, thread, or observed state) contradicts a specific claim
  in the file — AND the verification rule (below) confirms the contradiction
- A date in the file is relative ("last week", "recently") — convert to absolute
  regardless of other signal
- The file is correct but missing a `**Why:**` or `**How to apply:**` section
  required by the calling agent's schema — fix it inline

**Don't fire when:**

- Signal is opinion drift without a grounded observation (someone feels the decision
  changed, but no new fact supports it) — NOOP instead
- The contradiction is partial and the correct resolution is unclear — NOOP; note
  in summary for human review

**Examples:**

```
BEFORE: "rglaubitz/video-analyzer 1.2.0. Phase 2 in flight."
SIGNAL: session entry 2026-05-08 — "Both phases closed, project archived."
→ UPDATE: rewrite status line and any in-flight references. Keep historical context.
```

```
BEFORE: "currently testing the retry path"
SIGNAL: no explicit contradiction, but date is relative
→ UPDATE: convert to "as of 2026-05-08, testing the retry path"
```

---

### CREATE

**What it is:** Signal is genuinely new and doesn't fit any existing file. Write a
new topic file using the calling agent's declared auto-memory schema. Add an index
line in the right MEMORY.md section (matching the file's `type:` frontmatter).

**Fire when:**

- The session entry or thread introduces a decision, preference, project, or reference
  that has no existing topic file
- You've searched the memory dir (ls + grep on filename patterns) and confirmed no
  file covers this topic

**Don't fire when:**

- An existing file covers the same topic but needs updating — that's UPDATE, not CREATE
- Signal is ephemeral (session-specific noise, a one-time workaround, a question that
  got answered in passing) — NOOP

**Examples:**

```
Session entry introduces: "G's working hours: 9 AM–10 PM Pacific. Default calendar: Work."
No existing user_working_hours.md or similar file found.
→ CREATE user_working_style.md with type: user. Add index line in ## User section.
```

---

### DELETE

**What it is:** A topic file is fully superseded — the project was archived, the fact
was disproved, the decision reversed in full. `rm` the file. Remove its index line.

**Fire when:**

- Supersession is total: nothing in the file remains true or useful
- A project file for a project that was deleted (not archived — archived projects
  remain historically useful)
- A reference file pointing to a tool, path, or service that no longer exists and
  whose pattern has no future applicability

**Don't fire when:**

- Partial staleness — UPDATE instead
- A project shipped or closed — UPDATE the status; the file is historical context
- Any doubt about whether supersession is complete — NOOP; let the next dream
  catch it once signal is stronger

**Examples:**

```
BEFORE: feedback_help_tools_trap.md — "Agents call help tools reflexively. Remove from registries."
SIGNAL: session entry — "help tools fully removed from all registries 2026-04-15. Rule is now enforced by default config."
CHECK 1: contradiction? YES — the rule has been operationalized, the file's guidance is now baked into config
CHECK 2: grounded? PARTIAL — "enforced by config" is asserted but not observed
→ NOOP — assert + cite is not strong enough. Leave for next dream with stronger evidence.
```

---

### NOOP

**What it is:** Signal is already accurately captured in memory, or is ephemeral and
shouldn't be saved. Do nothing. Note in the summary why.

**Fire when:**

- The topic file's content matches the signal (including any dates being absolute)
- Signal is session-specific noise (a transient workaround, a debug command run once,
  a typo fix) with no durable lesson

**Don't fire when:** — NOOP is not a fallback for indecision. If you're unsure
whether to UPDATE or DELETE, the answer is UPDATE or NOOP, not NOOP by default.
Pick NOOP only when you can state why the signal doesn't require a write.

---

### Verification Rule — Before DELETE or Any Destructive Rewrite

Before executing DELETE or rewriting a fact you believe is wrong, prove staleness
in two steps:

1. **Does newer signal contradict the memory?** Check the session entry, open
   threads, and daily-note for an explicit contradiction — not just absence of
   confirmation.

2. **Is that contradiction grounded in observed state?** Grounded means: a file
   path verified with `ls`, a commit SHA mentioned in the session, an explicit
   status update in a thread, a verbatim G quote. Opinion drift ("I think that
   changed") is not grounded.

Act only when both are true. When in doubt, NOOP — over-deletion is harder to undo
than a stale fact surviving one more session.

---

## Prune & Index Phase Ops

### TRIM

**What it is:** Shorten an index line that exceeds the 150-char cap (see
`constants.md` for the exact value). Move any excess prose into the topic file's
body — don't delete it.

**Fire when:**

- `wc -m` on the index line returns > 150 (including the leading `- [Title](file.md) — ` markup)
- A freshly-written index hook from Consolidate came out verbose

**Don't fire when:**

- The line is ≤ 150 chars — leave it alone even if it feels long

**Example:**

```
BEFORE (280 chars): "- [Thinking Partner Bar](feedback_thinking_partner_bar.md) — G said
  'you're typing when you should be deciding' on 2026-04-09 after three delegated Write
  tasks. Orchestrators do judgment, not typing."
→ TRIM to: "- [Thinking Partner Bar](feedback_thinking_partner_bar.md) — G wants
  orchestrators doing judgment, not grunts typing files. Route before typing."  (121 chars)
  Move the full quote + date context into the topic file body.
```

---

### REMOVE

**What it is:** Drop an index line that points to a topic file deleted in the
Consolidate phase.

**Fire when:**

- Consolidate just executed a DELETE on the file this line points to
- Consolidate executed a MERGE that consumed the redundant file — remove the
  redundant file's index line (the surviving file's line is kept or MERGE-LINESd)

**Don't fire when:**

- The file still exists — even if stale, DEMOTE or let human review it

**Example:**

```
Consolidate deleted project_mcp_combo_in_workspace.md.
→ REMOVE its index line. (The surviving project_tools_manager_src.md line stays.)
```

---

### DEMOTE

**What it is:** Move a topic file to `<memory-dir>/archived/<filename>` (same
filename, new directory). Remove its index line. The file remains greppable but
no longer pays the daily index cost.

Target dir is always `<memory-dir>/archived/` — create it with `mkdir -p` on first
use. Never pre-create. See `constants.md` for the filename invariant.

**Fire when:**

- The topic file is still valid but its index line is bloated AND the content
  resists concise trimming (historical narrative that doesn't compress)
- The file covers a completed, closed project with no ongoing maintenance relevance
  (shipped, archived, superseded by a newer project file)
- Human reviewer explicitly requested demotion

**Don't fire when:**

- The topic file is load-bearing for current work — even if rarely accessed, keep
  it indexed if pulling it wrong would have cost
- You're tempted to DEMOTE algorithmically to get under cap — see SKILL.md's
  "over_cap_unresolved" path instead; forced demotion is too brittle

**Example:**

```
project_autoresearch.md describes a framework that was archived 2026-04-28.
Session entry confirms no future work planned. Body is 30 lines of historical context.
→ DEMOTE: mv to archived/project_autoresearch.md. Remove index line.
```

---

### PROMOTE

**What it is:** Add or reposition an index line for a topic file that exists in
the memory dir but is absent from (or misplaced in) the MEMORY.md index.

**Fire when:**

- A topic file is present in the memory dir but has no index line
- An index line sits in the wrong section (e.g., a `type: reference` file listed
  under `## Feedback`)

**Don't fire when:**

- The file is in `archived/` — demoted files intentionally have no index line

**Example:**

```
reference_fastmcp_client_transport.md exists in memory dir.
No matching line found under ## Reference in MEMORY.md.
→ PROMOTE: add "- [FastMCP Client Transport](reference_fastmcp_client_transport.md)
  — Pass StdioTransport instance, NOT a transport dict." under ## Reference.
```

---

### MERGE-LINES

**What it is:** Collapse two index lines into one when Consolidate merged their
corresponding topic files.

**Fire when:**

- Consolidate just executed a MERGE that combined two topic files into one
- The surviving file needs a single index hook that captures both files' key facts

**Don't fire when:**

- The two files were not merged — even if their hooks are similar, keep both lines
  if both files still exist

**Example:**

```
Consolidate merged project_mcp_combo_in_workspace.md INTO project_tools_manager_src.md.
Old lines:
  "- [MCP Combo merged](project_mcp_combo_in_workspace.md) — MCB merged at root 2026-04-01."
  "- [src/ tool home](project_tools_manager_src.md) — 19 dirs in src/. MCB at root."
→ MERGE-LINES to one:
  "- [src/ tool home](project_tools_manager_src.md) — Universal tool home (19 dirs). MCB merged at root 2026-04-01."
```

---

## Cross-references

Used by the Consolidate and Prune & Index phases of SKILL.md.
Cap values (200 lines, 25KB, 150 chars) are defined in `constants.md` — do not
hard-code them here; always cite `constants.md` as the source of truth.
See `references/drift-examples.md` for worked UPDATE walkthroughs.
