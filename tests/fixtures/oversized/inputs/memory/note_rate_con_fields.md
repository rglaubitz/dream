---
name: Rate con field extraction notes
description: 12 core rate-con fields in priority order with per-field extraction accuracy.
type: reference
---

Core fields for rate confirmation extraction, in priority order:

1. load_number (97% accuracy)
2. shipper_name (99%)
3. consignee_name (98%)
4. pickup_date (94%)
5. delivery_date (94%)
6. origin_city_state (96%)
7. destination_city_state (96%)
8. commodity (91%)
9. weight (93%)
10. rate_per_mile (89% — hardest; formatting varies widely across carriers)
11. total_rate (92%)
12. carrier_name (95%)

**Hardest field:** rate_per_mile — carriers express it as "$/mi", "per mile", "flat", or embed it in a table. LLM second-pass required when regex fails.
