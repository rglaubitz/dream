---
name: Error Message Quality
description: Error messages must be actionable. "Something went wrong" is never acceptable.
type: feedback
---

G's rule (2026-04-01): "If an error message doesn't tell the user what to do next, it's not an error message — it's a shrug."

**Why:** Vague errors require a second round of investigation. Actionable errors let the caller self-serve.

**How to apply:** Every error message must include: (1) what failed, (2) why (if known), (3) what to do. Example: "Document abc123 not found in ingest queue. Verify the doc_id and retry, or check audit log for prior processing." Minimum: what + what to do.
