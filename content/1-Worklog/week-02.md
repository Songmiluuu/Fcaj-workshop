---
title: "Week 2 - Requirements and acceptance criteria"
menuTitle: "Week 2"
weight: 2
pre: "<b>1.2.</b>"
---

**Period:** June 8, 2026 - June 14, 2026  
**Status on July 30:** Reconstructed plan; criteria compared with the supplied codebase

## Objectives

- Define business rules and authorization for each assigned API.
- Specify both successful and failure scenarios before implementation.
- Decide what must be verified automatically, manually in Postman, and on AWS.

## Requirements analyzed

| Area | Required behavior |
| --- | --- |
| Enrollment | Only a Student can enroll; the course must exist, be published, and have a published final assessment; a repeated request must not create a duplicate row. |
| My Courses | Return active courses, total completed lessons, completed courses, and per-course percentage from database rows. |
| Progress | Only an enrolled Student can complete a lesson or read progress; completion is idempotent by user and lesson. The certificate-based undo guard belongs to a supporting extension. |
| Upload | Only the course owner or Admin can upload; reject unsupported extensions and oversized files; support local storage for development and S3 for deployment. |
| CloudWatch | Core work correlates controlled API calls with application logs. The supporting Admin reader must reject non-Admins and handle monitoring errors without exposing credentials. |

## Acceptance matrix

| Scenario | Expected result |
| --- | --- |
| Student enrolls in an eligible course | HTTP success and one Enrollment row |
| Same Student enrolls again | Existing enrollment returned; no duplicate row |
| Non-Student enrolls | HTTP 403 |
| Course is missing, unpublished, or lacks a published assessment | HTTP 404 or 409 according to the condition |
| Enrolled Student completes one of two lessons | One completed lesson and 50% progress |
| Non-enrolled Student updates progress | HTTP 403 |
| Material has an unsupported extension | HTTP 415 |
| Upload exceeds its category limit | HTTP 413 |
| Non-Admin requests supporting CloudWatch reader | HTTP 403 |

## Deliverables

- Business-rule and authorization matrix for the core assigned endpoints.
- Positive, negative, boundary, and idempotency test criteria.
- Separation of verification levels: mocked/local automated tests, manual
  Postman execution, and live AWS S3/CloudWatch checks.

## Completion criteria

- Every mutating endpoint has an authorization rule and at least one negative
  case: **met in the design and current implementation**.
- Duplicate enrollment/progress behavior has a database-level rule: **met**.
- Runtime AWS behavior is not inferred from source code alone: **met as an
  evidence rule; live verification remains future work**.

## Repository evidence

- EduCloud/backend/app/services/enrollment_service.py
- EduCloud/backend/app/services/progress_service.py
- EduCloud/backend/app/routes/upload_routes.py
- EduCloud/backend/app/routes/admin_routes.py
- EduCloud/backend/app/models/enrollment.py
- EduCloud/backend/app/models/progress.py
