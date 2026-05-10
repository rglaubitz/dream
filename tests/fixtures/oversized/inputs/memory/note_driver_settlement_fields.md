---
name: Driver settlement field notes
description: Core driver settlement fields with per-field extraction accuracy.
type: reference
---

Core fields for driver settlement extraction:

| Field               | Accuracy  | Notes                                             |
| ------------------- | --------- | ------------------------------------------------- |
| driver_name         | 99%       |                                                   |
| driver_id           | 97%       |                                                   |
| pay_period_start    | 97%       |                                                   |
| pay_period_end      | 97%       |                                                   |
| gross_pay           | 95%       |                                                   |
| deductions_itemized | 88%       | Varies: some carriers lump all deductions         |
| net_pay             | derivable | gross minus deductions if direct extraction fails |
| miles_driven        | 90%       |                                                   |
| loads_completed     | 93%       |                                                   |

**Deductions challenge:** itemization format varies per carrier. Some list fuel, insurance, escrow, advances separately; some report a single "Total Deductions" figure. Net pay is always derivable.
