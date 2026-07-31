---
title: "Week 2 - Authorization and acceptance criteria"
menuTitle: "Week 2"
weight: 2
pre: "<b>1.2.</b>"
---

# Week 2 - Authorization and acceptance criteria

**Work period:** June 22–28, 2026

## Task

Define Student and Instructor/Admin authorization rules, success criteria,
negative cases, and required evidence.

## Authorization rules

| Operation | Allowed role | Main condition |
|---|---|---|
| Enroll and load My Courses | Student | Authenticated application user |
| Complete a lesson and read progress | Student | Enrolled in the selected course |
| Upload course media | Course owner Instructor or Admin | Selected course exists |
| Read application logs | Admin | Monitoring is enabled and the log group is configured |

## Acceptance cases

- Enrollment succeeds only for a published course with a published final
  assessment.
- Repeating enrollment does not create a second database row.
- Progress is calculated from persisted lesson-completion records.
- Upload rejects unsupported extensions, oversized files, and non-owner access.
- CloudWatch access returns a controlled error when monitoring is disabled or
  misconfigured.

## Result

Success, authorization, validation, and failure cases were mapped before API
implementation. Test records use HTTP status, response body, database state,
object metadata, and log timestamp where relevant.

## Technical references

- `EduCloud/backend/app/dependencies.py`
- `EduCloud/backend/app/services/enrollment_service.py`
- `EduCloud/backend/app/services/progress_service.py`
- `EduCloud/backend/app/services/s3_service.py`
