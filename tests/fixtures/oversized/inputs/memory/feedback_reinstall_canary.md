---
name: Reinstall Before Canary Eval
description: Canary captures tool --help via PATH. uv-tool installs go stale after source edits. Reinstall before measuring.
type: feedback
---

Canary capture uses the PATH-installed binary. After source edits, `uv tool install` must be re-run or the canary reads stale output.

**How to apply:** Before every autoresearch measurement: `uv tool install --reinstall <tool>` then grep for a known token to confirm the new version is live.
