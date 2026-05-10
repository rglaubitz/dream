---
name: Eval Scoring Approach
description: Scenario success rate is the signal. Weighted score plateaus invisibly — drop it from reporting.
type: feedback
---

G's direction (2026-04-18): "The weighted score is noise. Scenario pass/fail is what tells you if the thing works. Don't show me a 0.73 composite — show me 7 of 10 scenarios passing and tell me which 3 failed."

**Why:** Early autoresearch runs on qbo-cli showed the weighted composite plateauing while scenario pass rates were still improving. The composite masked real progress. G decided to cut it.

**How to apply:** In eval reports, lead with scenario pass rate (N/M passing). Drop the weighted composite from the summary. Keep raw per-scenario scores in the appendix for debugging, but don't surface them in the executive summary.
