---
title: "Week 5 - FastAPI integration baseline"
menuTitle: "Week 5"
weight: 5
pre: "<b>1.5.</b>"
---

**Period:** June 29, 2026 - July 5, 2026  
**Status on July 30:** Codebase target present; personal attribution requires confirmation

> **Attribution basis:** this page reconstructs intended work from the assignment
> and supplied code. The referenced source proves current behavior, not who
> authored it.

## Objectives

- Register the core assigned API groups under one consistent **/api** prefix.
- Centralize environment settings for storage and monitoring.
- Use shared authentication and response conventions before adding business
  logic.

## Planned activities and current codebase evidence

| Activity | Verified result |
| --- | --- |
| Plan registration of core enrollment/progress/upload routers and review the supporting Admin router. | Current modules use settings.API_PREFIX, whose default is /api. |
| Plan reuse of get_current_user on protected endpoints. | Current enrollment, progress, upload, and supporting CloudWatch routes use the same dependency. |
| Plan use of the shared success-response helper. | Current successful responses contain success, message, and data. |
| Plan environment-driven storage settings. | UPLOAD_STORAGE selects local or S3; local path, bucket, Region, and public base URL are configurable. |
| Plan monitoring switches and request instrumentation. | AWS_MONITORING_ENABLED and AWS_CLOUDWATCH_LOG_GROUP are external configuration; middleware records route, status, and duration. |

## Expected deliverables

- FastAPI route integration for the assigned API groups.
- Shared authentication and success-response baseline.
- Environment configuration for local upload, S3, and CloudWatch.
- Local upload mounting only when local storage mode is active.

## Test criteria

| Criterion | Result |
| --- | --- |
| Core and supporting routers receive the same /api prefix. | Present in supplied codebase |
| Protected handlers resolve current-user context before business logic. | Met |
| Switching storage mode does not require a source-code edit. | Met |
| Secrets and environment-specific log-group names stay outside committed values. | Met in .env.example; real values must remain uncommitted |

## Repository evidence

- EduCloud/backend/main.py
- EduCloud/backend/app/config.py
- EduCloud/backend/.env.example
- EduCloud/backend/app/utils/response.py
- EduCloud/backend/app/middleware/auth_middleware.py
- EduCloud/backend/app/services/monitoring_service.py
