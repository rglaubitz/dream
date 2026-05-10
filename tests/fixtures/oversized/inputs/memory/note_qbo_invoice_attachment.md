---
name: QBO invoice attachment flow
description: Two-call sequence to attach a PDF to a QBO Invoice entity. base64 encode required.
type: reference
---

Attaching a processed invoice PDF to a QBO Invoice record is a two-call sequence:

1. Create or find the Invoice record by invoice_number → get entity_id
2. Upload PDF as attachment via `qbo_attachment` tool: `entity_type=Invoice`, `entity_id=<from step 1>`, `content=<base64-encoded PDF>`

The attachment API returns an `AttachableRef` that is automatically linked to the invoice. It is NOT a single atomic operation — both calls must succeed.

**base64 encoding:** required before passing PDF bytes to the tool. Use `base64.b64encode(pdf_bytes).decode()`.

**Failure mode:** if step 1 succeeds but step 2 fails, the invoice exists in QBO without the attachment. Retry step 2 only — do not recreate the invoice.
