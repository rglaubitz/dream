---
name: launchd plist naming
description: Reverse-domain format required: com.agentfleet.<agent>.<job>. Wrong format causes launchd to silently skip loading.
type: reference
---

launchd plists must use reverse-domain label format. Example: `com.agentfleet.tools-manager.batch-runner`.

Wrong format (e.g., just `batch-runner`) causes launchd to silently skip loading the plist — no error, no log entry, just silence.

**Verify:** `launchctl list | grep agentfleet` after loading.
