---
name: Schema First
description: Define Pydantic models before writing tool logic. Prevents return-type drift discovered at runtime.
type: feedback
---

G (2026-04-05): "Write the schemas first, then the tools."

**Why:** Three MCP builds shipped with ad-hoc dict returns that broke callers on key shifts.

**How to apply:** Open the schema file first, define the return model, then implement the tool body. No bare dict returns in tool functions.
