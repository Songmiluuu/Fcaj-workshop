---
title: "Week 3 - API contract and data design"
menuTitle: "Week 3"
weight: 3
pre: "<b>1.3.</b>"
---

# Week 3 - API contract and data design

**Work period:** June 29–July 5, 2026

## Task

Design API contracts, enrollment/progress data constraints, upload validation,
and reusable Postman variables.

## API and data design

- Standardized successful responses around `success`, `message`, and `data`.
- Used authenticated user context instead of accepting a target user ID from
  request bodies.
- Required unique enrollment rows for each user-course pair.
- Required unique progress rows for each user-lesson pair.
- Defined course-scoped S3 prefixes for thumbnails, materials, and videos.
- Set extension and size rules for each upload category.

## Postman design

The collection uses environment variables for `base_url`, role tokens,
`course_id`, `lesson_id`, `upload_id`, object key, and ETag. Request scripts
store IDs only when a response succeeds, which keeps negative cases independent
from the main workflow.

## Result

The route contract, persistence rules, upload limits, and reusable test
variables were aligned before integration work began.

## Technical references

- `EduCloud/api/openapi.yaml`
- `EduCloud/backend/app/models/enrollment.py`
- `EduCloud/backend/app/models/progress.py`
- `EduCloud/api/postman/EduCloud.postman_collection.json`
