---
name: Classification Model
description: Fine-tuned Flash model for doc-type classification. 14 classes, 98.2% accuracy.
type: project
---

Fine-tuned Gemini Flash model for classifying incoming documents by type. Runs after OCR normalization; outputs a class label and confidence score.

**Status:** Deployed. 14 doc-type classes. 98.2% accuracy on held-out test corpus.

**Classes include:** rate-con, BOL, OTR-settlement, driver-settlement, invoice, lumper-receipt, fuel-receipt, detention-notice, POD, rate-confirmation-amendment, broker-invoice, carrier-invoice, accessorial-charge, other.

**Confidence output:** feeds directly into Confidence Scorer for band assignment.
