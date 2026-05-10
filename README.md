# dream

A locally-owned `/dream` skill for Claude Code that performs **memory consolidation** — the periodic batch pass that turns a drifted, duplicated, date-rotted `~/.claude/projects/<project>/memory/` directory back into a clean, deduplicated, indexed memory store.

Modeled on the workflow Anthropic codified in their (gated) **Dreams** managed-agent feature and their internal **AutoDream** subsystem (exposed in the Claude Code v2.1.88 npm leak). The pattern — Orient → Gather → Consolidate → Prune & Index — is reverse-engineered from the leaked reference architecture; the prompt itself is rewritten in our own wording.

## Why this exists

Every Claude Code agent already has an inline auto-memory system that captures one fact at a time. What's missing is the periodic pass that:

- **Merges duplicates** — two topic files about the same subject → one improved file.
- **Updates drift** — entries whose backing state has changed since they were written.
- **Converts relative dates** — "yesterday" → an absolute date.
- **Prunes the index** — keep `MEMORY.md` ≤200 lines / ≤25KB / ≤150 chars per line.
- **Surfaces patterns** — what repeats across the last N sessions?

`/dream` is that pass. It runs on Sonnet, autonomously, in a read-only Bash sandbox scoped to the memory directory. Changes apply without an approval gate — git tracks the diff for review.

## Status

Phase 0 closed 2026-05-10. Phase 1 (the SKILL.md + supporting bundle + Layer-1/Layer-2 verification) in progress.

Source of truth lives here. Deployment is by `rsync` to `~/.claude/skills/dream/` (mirror of the journals v2 deployment pattern).

## Layout (target)

```
dream/
├── SKILL.md                       — the 4-phase consolidation prompt (the engine)
├── constants.md                   — caps + invariants (200 lines / 25KB / 150 chars)
├── scripts/
│   ├── dream                      — Phase 2: ~30-line bash wrapper (flock + launch CLI dispatch)
│   └── validate_memory.sh         — 6-check post-Prune validation gate
├── references/
│   ├── op-rubric.md               — 5 Consolidate ops + 5 Prune ops with decision trees
│   ├── drift-examples.md          — UPDATE/DELETE walkthroughs
│   └── journal-contract.md        — input precondition spec
├── examples/
│   └── run-summary.json           — sample stdout summary
├── evals/
│   └── evals.json                 — skill-creator eval set (3 fixtures)
└── tests/
    ├── fixtures/                  — clean-tight, drifted-medium, oversized
    └── test_dream.sh              — Layer-1 binary verification runner
```

## References

- **Plan + design**: `tools-manager/workspace/projects/active/dream/` (vision.md, ROADMAP.md, docs/architecture.md, tests/eval-strategy.md)
- **AutoDream leak research**: `docs/research/autodream-leak.md` in the project workspace
- **Sibling project**: [Journals](https://github.com/rglaubitz/journals) — captures the raw stream that `/dream` consolidates from
- **Workflow engine**: Anthropic's `skill-creator` skill (eval orchestration)

## License

Private. Prompt body is original work; the workflow shape is reverse-engineered from publicly leaked source via three independent GitHub mirrors.
