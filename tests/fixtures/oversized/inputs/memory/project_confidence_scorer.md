---
name: Confidence Scorer
description: Post-classification scorer. Assigns confidence bands and routes low-confidence docs to review queue.
type: project
---

Takes classification model output (class + raw confidence score) and maps it to a confidence band.

**Status:** Deployed. Calibrated against 200-doc labeled corpus.

**Band thresholds (final calibrated values):** high >0.88, med 0.62–0.88, low <0.62.

**Routing:** high and med → automated downstream processing. low → Review Queue MCP for human triage.
