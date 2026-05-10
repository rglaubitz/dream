---
name: Schema Registry
description: Central Pydantic schema store shared across all MCPs. Read-only in production.
type: project
---

Single source of truth for shared Pydantic models. All MCPs import from here rather than defining their own duplicates.

**Status:** Stable. Read-only interface. Changes require PR + test update across all consumers.

**Location:** `src/schema-registry/`

**Consumers:** Pipelines MCP, Canary CLI, agent-vega integration layer.
