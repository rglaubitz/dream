---
name: Drive Archive Worker
description: Background worker that archives processed docs to Google Drive with structured naming.
type: project
---

Archives processed PDFs to Google Drive following the folder structure in `reference_google_drive_folder.md`.

**Status:** Deployed. Processes all doc types post-routing.

**Naming:** `<date>-<doc-id>-<doc-type>.pdf` under `Drive/Pipeline/Archive/<YYYY>/<MM>/<doc-type>/`.
