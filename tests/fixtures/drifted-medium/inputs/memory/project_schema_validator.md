---
name: Schema Validator
description: Standalone Pydantic validator CLI used pre-ingest. 62 tests, deployed.
type: project
---

CLI tool that validates incoming document payloads against the schema registry before they enter the ingest queue. Rejects malformed payloads with structured error output.

**Status:** Deployed. 62 tests passing. No open issues.

**Commands:** validate, explain, list-schemas.

**Integration:** Called by the ingest CLI before queuing. Also callable standalone for debugging.
