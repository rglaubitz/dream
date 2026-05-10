---
name: Schema First
description: Define Pydantic models before writing tool logic. Prevents return-type drift.
type: feedback
---

G's explicit instruction (2026-04-05): "Write the schemas first, then the tools. Don't let me catch you hardcoding return dicts."

**Why:** Three consecutive MCP builds shipped with ad-hoc dict returns that later broke callers when keys shifted. Pydantic models catch this at write time, not at runtime.

**How to apply:** When starting a new tool, open the schema file first. Define the return model. Then implement the tool body that populates and returns it. PR review gate: no bare dict returns in tool functions.
