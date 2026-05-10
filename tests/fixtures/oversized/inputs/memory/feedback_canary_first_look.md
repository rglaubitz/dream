---
name: Canary First-Look Surface
description: In LLM-tool autoresearch, only changes to the top-level --help surface move composite. Subcommands are invisible.
type: feedback
---

Only changes flowing into what the model first reads (top-level `--help`) move the autoresearch composite score. Subcommand help, doctor output, and error hints are invisible to canary capture.

**How to apply:** Focus autoresearch edits on the top-level help text and primary tool description. Don't waste iterations editing subcommand help.
