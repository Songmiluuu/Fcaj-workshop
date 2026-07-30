---
title: "Week 6 - Enrollment and My Courses APIs"
menuTitle: "Week 6"
weight: 6
pre: "<b>1.6.</b>"
---

**Period:** July 6, 2026 - July 12, 2026  
**Status on July 30:** Codebase target present; personal attribution requires confirmation

> **Attribution basis:** this page reconstructs intended work from the assignment
> and supplied code. The referenced source proves current behavior, not who
> authored it.

## Objectives

- Implement course enrollment for authenticated Students.
- Make repeated enrollment safe.
- Build the My Courses response from real enrollment, lesson, progress,
  assessment, and certificate rows.

## Planned implementation and current codebase behavior

| Endpoint or component | Current codebase behavior |
| --- | --- |
| **POST /api/courses/{course_id}/enroll** | Checks Student role, course existence, published status, and a published final assessment; creates the enrollment only when it does not already exist. |
| **GET /api/my-courses** | Checks Student role and returns dashboard totals plus one progress summary per enrolled course. |
| Dashboard aggregation | Counts lessons and completed progress rows, calculates a rounded percentage, reports assessment readiness/pass state, and counts certificates as completed courses. |
| Frontend client | enrollCourse sends the Student JWT; getMyCourses consumes the typed StudentDashboard response. |

## Expected deliverables

- Enrollment route and service.
- Student dashboard response containing active_courses, lessons_completed,
  completed_courses, and course summaries.
- Frontend service integration for enrollment and My Courses.
- Idempotency backed by a service lookup and the unique user-course database
  constraint.

## Verification criteria

| Scenario | Expected result | Current evidence |
| --- | --- | --- |
| Eligible Student enrolls | Enrollment is created and returned | Present in enrollment_service.py |
| Repeat enrollment | Existing row is reused | Service lookup plus unique constraint |
| Instructor/Admin calls Student endpoint | HTTP 403 | Explicit role check |
| One of two lessons is complete | My Courses reports one completed lesson and 50% | Asserted in test_enrollment_progress.py |
| Course is not published or has no published assessment | HTTP 409 | Explicit conflict checks |

The enrollment/dashboard workflow is covered by one of the **7 selected test
nodes that passed on July 30**.

## Repository evidence

- EduCloud/backend/app/routes/enrollment_routes.py
- EduCloud/backend/app/services/enrollment_service.py
- EduCloud/backend/app/models/enrollment.py
- EduCloud/backend/tests/test_enrollment_progress.py
- EduCloud/frontend/src/services/enrollmentService.ts
- EduCloud/frontend/src/pages/CourseDetailPage.tsx
- EduCloud/frontend/src/pages/MyLearningPage.tsx
