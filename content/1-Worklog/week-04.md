---
title: "Week 4 - FastAPI and persistence baseline"
menuTitle: "Week 4"
weight: 4
pre: "<b>1.4.</b>"
---

# Week 4 - FastAPI and persistence baseline

**Work period:** June 29–July 3, 2026

## Task

Align the FastAPI integration baseline, authentication dependency, response
conventions, PostgreSQL persistence, and AWS configuration.

## Work completed

- Registered enrollment, progress, upload, and monitoring routers under the
  `/api` prefix.
- Reused the shared authentication dependency for role and identity checks.
- Kept business rules in services instead of route handlers.
- Verified that enrollment and progress use PostgreSQL-backed models.
- Centralized S3, CloudFront, and CloudWatch settings in application
  configuration.
- Kept production credentials outside source code and frontend variables.

## Result

All assigned API groups use the same authentication context, response
conventions, persistence layer, and configuration source. This baseline reduced
differences between local testing and AWS integration.

## Technical references

- `EduCloud/backend/main.py`
- `EduCloud/backend/app/config.py`
- `EduCloud/backend/app/database.py`
- `EduCloud/backend/app/utils/response.py`
