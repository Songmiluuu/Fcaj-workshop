---
title: "Week 5 - Enrollment and My Courses"
menuTitle: "Week 5"
weight: 5
pre: "<b>1.5.</b>"
---

# Week 5 - Enrollment and My Courses

**Work period:** July 13–19, 2026

## Task

Implement and validate course enrollment and My Courses behavior, including
duplicate-request handling and Student-only access.

## Enrollment flow

1. Resolve the authenticated application user.
2. Require the Student role.
3. Load the selected course and confirm that it is published.
4. Confirm that the course has a published final assessment.
5. Return the existing enrollment or create one database row.

`GET /api/my-courses` loads each enrolled course with lesson progress,
assessment availability, and certificate state needed by the learner
dashboard.

## Validation

- A valid Student can enroll and retrieve the course from My Courses.
- Repeating the request returns the existing enrollment without duplication.
- Missing authentication returns 401.
- An Instructor or Admin token returns 403.
- An unavailable course or incomplete publication state returns a domain error.

## Result

Enrollment became idempotent at service level and protected by a database
uniqueness rule. My Courses reads persisted learning state instead of trusting
client-provided values.

## Technical references

- `EduCloud/backend/app/routes/enrollment_routes.py`
- `EduCloud/backend/app/services/enrollment_service.py`
- `EduCloud/backend/app/models/enrollment.py`
- `EduCloud/frontend/src/services/enrollmentService.ts`
