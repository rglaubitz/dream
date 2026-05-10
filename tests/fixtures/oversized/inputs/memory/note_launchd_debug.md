---
name: launchd debugging tips
description: Four-step checklist when a launchd job silently fails to load or run.
type: reference
---

When a launchd job silently fails to load or produce output:

1. **Validate plist syntax:** `plutil -lint /path/to/com.agentfleet.*.plist` — syntax errors are the most common cause of silent failures.
2. **Check system log:** `log show --predicate 'subsystem == "com.apple.launchd"' --last 1h` — launchd logs load failures here even when nothing appears in Console.
3. **Check ownership:** plists in `/Library/LaunchDaemons/` must be owned by root (`chown root:wheel <plist>`). User-owned plists in system daemons path are silently skipped.
4. **Verify executable:** the script or binary the plist points to must have the executable bit set (`chmod +x <script>`). Missing exec bit = silent no-op.

**Most common failure pattern:** plist syntax error + wrong label format (not reverse-domain). Run step 1 first — it catches ~80% of issues.
