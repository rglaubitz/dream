---
name: Test Naming Convention
description: Test names: test_<action>_<condition>_<expected>. Three-part names only.
type: feedback
---

G's direction (2026-04-03): "Three-part test names or I reject the PR. test_what_when_then."

**Why:** Test names are the first failure signal. Vague names ("test_ingest_works") require reading the body to understand what failed. Three-part names are self-documenting.

**How to apply:** `test_<action>_<condition>_<expected>`. Example: `test_validate_missing_doc_id_returns_error`. All three parts required. No exceptions for short tests.
