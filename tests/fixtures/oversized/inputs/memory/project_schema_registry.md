---
name: Schema Registry
description: Central Pydantic schema store. All MCPs import from here. Read-only in production.
type: project
---

Single source of truth for shared Pydantic models. All MCP servers and CLIs import from here. Changes require PR + test update across all consumers.

**Status:** Stable. Read-only interface enforced via CI check.

**Location:** `src/schema-registry/`
