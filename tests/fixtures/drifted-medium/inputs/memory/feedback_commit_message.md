---
name: Commit Message Format
description: Use conventional commits. feat/fix/chore/docs/test. No bare "update" or "misc" commits.
type: feedback
---

G's rule (2026-03-28): "Conventional commits only. If I see 'misc fixes' I'm reverting the PR."

**Why:** Changelog generation and git log readability depend on consistent prefixes. Bare "update" commits make bisect impossible.

**How to apply:** Every commit: `<type>(<scope>): <imperative description>`. Types: feat, fix, chore, docs, test, refactor. Scope = affected component. Description in imperative mood ("add", not "added").
