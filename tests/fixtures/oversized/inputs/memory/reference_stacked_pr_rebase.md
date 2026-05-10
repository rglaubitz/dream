---
name: Stacked PR rebase
description: Each squash-merge changes SHAs on main. Rebase next stacked branch onto origin/main after each merge.
type: reference
---

After each squash-merge on main, the merged commit's SHA changes. The next stacked PR sees its former ancestors as duplicate commits and conflicts.

**Pattern:** `git fetch origin && git rebase origin/main && git push --force-with-lease`. Repeat for each stacked PR after the one below it merges.
