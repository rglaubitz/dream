# Drift Examples

These walkthroughs are the prompt's mental model for what an UPDATE looks like in
practice. When in doubt during Consolidate, pattern-match against these three first.
The verification rule drives all three: prove contradiction, prove it's grounded,
then act. Absence of proof → NOOP.

---

## Case 1 — Project-Status Drift

**Setup — original topic file (`project_analyzer_pipeline.md`, excerpt):**

```markdown
---
name: Analyzer Pipeline
description: Doc processing pipeline — Phase 2 in flight. Flash-first cascade, 99.5% accuracy.
type: project
---

Status: Phase 2 in flight.

Phases:

- Phase 1: Complete (2026-04-12)
- Phase 2: In flight — retry-path hardening, throughput testing
- Phase 3: Planned — multi-tenant routing

Notes: Active development. Do not demote.
```

**Contradicting signal (session entry `2026-05-09-session-1.md`, excerpt):**

```
Both phases closed 2026-05-08. Project archived under archive/doc-pipeline/.
Phase 3 has no timeline — deferred indefinitely.
```

**Decision — verification rule:**

1. Contradiction? YES — "Phase 2 in flight" vs "Phase 2 closed 2026-05-08, archived."
2. Grounded in observed state? YES — session entry cites the archive action and a
   specific date. The archive move is a concrete, reversible action (not opinion drift).

Verdict: **UPDATE**. Not DELETE — the file has historical accuracy value and may be
referenced by other agents auditing the pipeline's build history.

**After — rewritten file:**

```markdown
---
name: Analyzer Pipeline
description: Doc processing pipeline — Phase 2 complete 2026-05-08, archived. Flash-first cascade, 99.5% accuracy.
type: project
---

Status: Phase 2 complete. Project archived 2026-05-08 under archive/doc-pipeline/.

Phases:

- Phase 1: Complete (2026-04-12)
- Phase 2: Complete (2026-05-08) — retry-path hardening, throughput testing
- Phase 3: Deferred indefinitely — no timeline set.

Notes: Archived. Historical reference only.
```

**Why this matters:** Status drift is the most common consolidation failure. If
the project file survives with "in flight" status, the next dream skips it (no
contradiction), and future agents treat a closed project as active work.

---

## Case 2 — Reference-Path Drift

**Setup — original topic file (`reference_deploy_symlink.md`, excerpt):**

```markdown
---
name: Deploy Symlink Convention
description: Active project symlink at ~/tools/active → ~/projects/analyzer-pipeline. Re-create for each new active project.
type: reference
---

Convention: one symlink at ~/tools/active pointing to the current active project.
Re-create on project rotation.

Current symlink: ~/tools/active → ~/projects/analyzer-pipeline
Created: 2026-04-15

Why: Agents reference ~/tools/active in scripts without needing to know the
current project name. Decouples scripts from project-naming churn.
```

**Contradicting signal (session entry `2026-05-09-session-1.md`, excerpt):**

```
Symlink ~/tools/active removed 2026-05-08 during archival cleanup.
No active project currently. Will re-create when next project becomes active.
```

**Decision — verification rule:**

1. Contradiction? YES — file claims symlink exists; session entry says it was removed.
2. Grounded in observed state? YES — session entry cites the removal as an explicit
   action on a specific date. Observable via `ls ~/tools/active` (would return
   "No such file or directory"). Both sources agree: the symlink is gone.

Verdict: **UPDATE**. Not DELETE — the convention pattern (one active symlink, rotate
on project change) is still valid reference material for when the next project starts.

**After — rewritten file:**

```markdown
---
name: Deploy Symlink Convention
description: Active project symlink convention. Currently absent — re-create when next project becomes active.
type: reference
---

Convention: one symlink at ~/tools/active pointing to the current active project.
Re-create on project rotation.

Current symlink: REMOVED 2026-05-08 (archival cleanup of analyzer-pipeline).
No active project currently. Re-create when next project is designated active.

Why: Agents reference ~/tools/active in scripts without needing to know the
current project name. Decouples scripts from project-naming churn.
```

**Why this matters:** Path drift is silent. If this file survives unchanged, any
agent following the convention will try to use a symlink that doesn't exist, fail,
and spend time diagnosing a stale reference rather than a broken tool.

---

## Case 3 — Feedback Reversal

**Setup — original topic file (`feedback_eval_scoring.md`, excerpt):**

```markdown
---
name: Eval Scoring
description: Scenario success rate is the signal. Weighted score plateaus invisibly — drop it from reporting.
type: feedback
---

G's direction (2026-04-18): "The weighted composite is a trap — it plateaus at 0.45
and you can't tell if you're moving. Drop it. Scenario success rate is the only
number that matters."

**Why:** Weighted score gave false precision. At the time, composite had been flat
for 3 eval rounds while individual scenarios were improving — the aggregate masked
the signal.

**How to apply:** Report scenario pass rate only. Do not include weighted composite
in eval summaries.
```

**Contradicting signal (session entry `2026-05-09-session-1.md`, excerpt):**

```
G on eval reporting: "I want both metrics. Weighted composite first for trend lines,
then scenario breakdown. Don't drop either — they answer different questions."
```

**Decision — verification rule:**

1. Contradiction? YES — original guidance: drop weighted score. New signal: keep both.
2. Grounded in observed state? YES — verbatim G quote in the session entry.
   Explicit preference reversal, not vague opinion drift.

Verdict: **UPDATE**. Not DELETE — the original reasoning (why weighted score was
originally cut) is still useful historical signal. A future agent hitting a similar
plateau needs to know the original context to understand why the rule evolved.

**After — rewritten file:**

```markdown
---
name: Eval Scoring
description: Show both metrics: weighted composite first (trend), then scenario pass rate (pass/fail). Superseded 2026-05-09.
type: feedback
---

G's direction (2026-04-18): "The weighted composite is a trap — it plateaus at 0.45
and you can't tell if you're moving. Drop it. Scenario success rate is the only
number that matters."
— This guidance was superseded 2026-05-09.

G's refined direction (2026-05-09): "I want both metrics. Weighted composite first
for trend lines, then scenario breakdown. Don't drop either — they answer different
questions."

**Why:** Original cut was right for a stalled eval (3 flat rounds). Once the eval
began moving again, composite regained diagnostic value. Two metrics answer two
different questions: composite = is the tool improving over time? scenario rate =
does it pass or fail specific use cases?

**How to apply:** Always report both. Lead with weighted composite, follow with
scenario pass rate table. Do not drop either in eval summaries.
```

**Why this matters:** Feedback reversals are the hardest to catch. The original
entry is still internally consistent — it reads as true. Only the session entry
reveals the preference changed. If the UPDATE doesn't date-stamp both versions,
future-dream has no way to tell which guidance is current.

---

## Cross-references

Used by the Consolidate phase of SKILL.md (see "Worked examples" and "Drift
detection" sections).
The three cases above are structurally identical to the planted drifts in
`tests/fixtures/drifted-medium/` — see `expected-diff.md` for the exact
ops expected against those fixtures.
For op definitions, see `references/op-rubric.md`.
Cap constraints referenced in file body rewrites follow `constants.md`.
