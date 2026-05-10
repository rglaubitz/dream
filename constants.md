# Dream — Constants & Invariants

Source of truth: `docs/architecture.md`. This file is the single reference for all
cap values, filename conventions, op names, and anomaly flags used by SKILL.md,
`scripts/validate_memory.sh`, and any downstream telemetry consumers. Change a
value here and propagate it everywhere — divergence between surfaces is the most
likely silent-failure mode for this workflow.

---

## Hard Caps

These limits are enforced by the validation gate (post-Prune) and are not tunable.

| Cap                   | Value                                                 | Measured by              |
| --------------------- | ----------------------------------------------------- | ------------------------ |
| `MEMORY.md` max lines | **200** (including blank lines and section headers)   | `wc -l`                  |
| `MEMORY.md` max bytes | **25,600** (25 KB)                                    | `wc -c`                  |
| Index line max chars  | **150** per non-empty, non-header line                | character count per line |
| Entries per memory    | **1** line — no multi-line entries, no nested bullets | structural inspection    |

`cap_pressure` is signalled when any single metric is within 10 % of its ceiling
after Prune completes (i.e., lines ≥ 180, bytes ≥ 23,040, or any line ≥ 135 chars).

---

## Filename Invariants

| Invariant       | Rule                                                                                     |
| --------------- | ---------------------------------------------------------------------------------------- |
| Index filename  | Always exactly `MEMORY.md` — no alternatives, no lowercase                               |
| Topic filenames | Lowercase with underscores; one topic per file (e.g. `feedback_thinking_partner_bar.md`) |
| Demoted files   | Moved to `<memory-dir>/archived/<filename>` — same name, new directory                   |
| Archived subdir | Dream creates it with `mkdir -p` on first DEMOTE; never pre-created                      |

### Topic file frontmatter (minimum required fields)

```yaml
---
name: <human-readable title — matches the link label in the index>
description: <one-line hook ≤150 chars — this is what MEMORY.md surfaces>
type: <one of: project | reference | user | feedback>
---
```

Additional fields (e.g. `status`, `last_updated`) are allowed but these three are
mandatory. A file missing any of them fails validation check 6.

---

## Op Naming

Op names are canonical tokens. The dream summary JSON uses them as keys, and the
validator's signal-aware skip detection (check 6) reads them from the summary to
distinguish a genuine zero-op run from a missed phase. Renaming an op requires
updating SKILL.md, the summary JSON schema, and the validation gate simultaneously.

### Consolidate phase ops

| Op       | When used                                                                            |
| -------- | ------------------------------------------------------------------------------------ |
| `MERGE`  | Two topic files cover the same topic — combine, delete the redundant one             |
| `UPDATE` | Existing file is mostly correct but new signal contradicts or extends a fact         |
| `CREATE` | Signal is genuinely new and has no existing topic file                               |
| `DELETE` | Topic file is fully superseded (project archived, fact disproved, decision reversed) |
| `NOOP`   | Signal already captured accurately, or is ephemeral and should not be saved          |

### Prune & Index phase ops

| Op            | When used                                                                               |
| ------------- | --------------------------------------------------------------------------------------- |
| `TRIM`        | Index line > 150 chars — shorten; move excess detail into the topic file                |
| `REMOVE`      | Index line points to a file being deleted in Consolidate                                |
| `DEMOTE`      | Topic still relevant but rarely accessed or index line is bloated — move to `archived/` |
| `PROMOTE`     | Topic file exists and matters but is absent from or mis-ordered in the index            |
| `MERGE-LINES` | Two index lines describe the same topic (both point to files being merged)              |

---

## Anomaly Flag Taxonomy

These flags populate the `anomalies` array in the dream summary. Soft flags record
and continue (the run still commits if validation passed). Terminal flags exit
non-zero and leave changes uncommitted.

| Flag                       | Type         | Trigger                                                                        |
| -------------------------- | ------------ | ------------------------------------------------------------------------------ |
| `high_diff_volume`         | soft         | > 20 % of memory files modified in one run                                     |
| `delete_burst`             | soft         | > 10 `DELETE` ops in one run                                                   |
| `merge_burst`              | soft         | > 5 `MERGE` ops in one run                                                     |
| `cap_pressure`             | soft         | After Prune, any metric is within 10 % of its hard cap                         |
| `validation_auto_fix_used` | soft         | First validation pass failed; auto-fix made it pass                            |
| `phase_skipped_suspected`  | **terminal** | `total_ops == 0` AND `total_noops == 0` AND `input_signal` is `med` or `high`  |
| `over_cap_unresolved`      | **terminal** | MEMORY.md still over any hard cap after Prune + one auto-fix attempt           |
| `preconditions_unmet`      | **terminal** | Entry-time precondition check failed (missing session entry, memory dir, etc.) |

Terminal flags cause dream to exit non-zero. The run is not committed. The next
`/journal` surfaces the failed dream summary so the operator can review.

---

## Why Centralize

SKILL.md's in-prompt instructions, `scripts/validate_memory.sh`, and any future
telemetry consumer (dashboards, autoresearch harness) all need to agree on these
exact numbers and token names. Drift between any two surfaces produces silent
failures — a validator checking 180 lines while the skill targets 200 accepts memory
that the validator would reject, or vice versa. One file, one version, no drift.
