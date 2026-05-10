---
name: Deploy symlink convention
description: Active project symlinked at ~/tools/active → ~/projects/analyzer-pipeline for quick access.
type: reference
---

During active development, the current project is symlinked into `~/tools/active` so shell aliases like `cd active` and `code active` resolve without path changes.

**Current symlink:** `~/tools/active → ~/projects/analyzer-pipeline`

**How to create:**

```bash
ln -sfn ~/projects/analyzer-pipeline ~/tools/active
```

**How to remove when done:**

```bash
rm ~/tools/active
```

**Note:** The symlink is a dev convenience only. It is removed when the project is archived or moves to maintenance mode.
