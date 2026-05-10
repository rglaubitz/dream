---
name: Grinder and Reviewer Pattern
description: Multi-file mechanical edits: dispatch grinder Sonnet for commits, reviewer Sonnet to verify. Catches misses.
type: feedback
---

For multi-file mechanical edits, dispatch two agents: a grinder that makes commits and a reviewer that verifies. Catches misses without bottlenecking on a single context window.

**How to apply:** Grinder gets the full edit list; reviewer gets the expected end state and verifies. Run in parallel where possible.
