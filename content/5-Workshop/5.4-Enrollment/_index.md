---
title: "Enrollment APIs"
menuTitle: "Enrollment APIs"
weight: 4
pre: "<b>5.4.</b>"
---

# Enrollment APIs

Relevant source files:

- `backend/app/routes/enrollment_routes.py`
- `backend/app/services/enrollment_service.py`
- `backend/app/models/enrollment.py`
- `backend/app/database_migrations.py`
- `frontend/src/services/enrollmentService.ts`

## Enroll in a course

```http
POST /api/courses/42/enroll
Authorization: Bearer STUDENT_JWT
```

A successful response has the common envelope:

```json
{
  "success": true,
  "message": "Course enrolled",
  "data": {
    "id": 91,
    "course_id": 42,
    "status": "active"
  }
}
```

### Server decision order

{{<mermaid>}}
flowchart TD
    A["Authenticated request"] --> B{"role == student?"}
    B -- No --> X403["403 Student access required"]
    B -- Yes --> C{"course exists?"}
    C -- No --> X404["404 Course not found"]
    C -- Yes --> D{"course published?"}
    D -- No --> X409A["409 Not open for enrollment"]
    D -- Yes --> E{"published final assessment?"}
    E -- No --> X409B["409 Assessment not ready"]
    E -- Yes --> F{"enrollment already exists?"}
    F -- Yes --> R["Return existing enrollment"]
    F -- No --> I["Insert active enrollment"]
    I --> J{"commit succeeds?"}
    J -- Yes --> R
    J -- IntegrityError --> K["Rollback and reload enrollment"]
    K --> L{"matching row found?"}
    L -- Yes --> R
    L -- No --> XDB["Re-raise database error"]
{{</mermaid>}}

This ordering avoids creating access to draft content and produces explicit domain
errors. The existing-record branch makes normal client retries idempotent. The
database unique index on user/course protects simultaneous requests. If another
request commits first, the service catches the integrity error, rolls back the
failed transaction, reloads the winning enrollment, and returns it.

## Load My Courses

```http
GET /api/my-courses
Authorization: Bearer STUDENT_JWT
```

The service joins enrollment, course, and instructor data, then derives lesson
counts, completed progress rows, assessment state, and certificate count.

```json
{
  "success": true,
  "message": "My courses loaded",
  "data": {
    "active_courses": 1,
    "lessons_completed": 1,
    "completed_courses": 0,
    "courses": [
      {
        "id": 42,
        "title": "AWS Foundations",
        "instructor": "Instructor Test",
        "status": "active",
        "completed_lessons": 1,
        "total_lessons": 2,
        "percentage": 50,
        "assessment_required": true,
        "assessment_passed": false,
        "ready_for_assessment": false
      }
    ]
  }
}
```

The client must treat these values as server-authoritative. It should not cache a
locally invented enrollment or progress percentage.

## Acceptance tests

| Case | Token/data | Expected |
|---|---|---|
| ENR-01 | Student + eligible course | 200 and active enrollment |
| ENR-02 | Repeat ENR-01 | 200 and same enrollment ID |
| ENR-03 | No token | 401 |
| ENR-04 | Instructor token | 403 |
| ENR-05 | Missing course | 404 |
| ENR-06 | Draft/hidden course | 409 |
| ENR-07 | Assessment not published | 409 |
| ENR-08 | Student calls My Courses | Counters and course array from DB |

Run the first four directly from the **1. Enrollment** Postman folder. Prepare
database fixtures for state-specific 404/409 cases rather than modifying shared
production courses.
