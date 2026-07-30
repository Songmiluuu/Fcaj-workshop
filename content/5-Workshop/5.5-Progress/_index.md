---
title: "Progress APIs"
menuTitle: "Progress APIs"
weight: 5
pre: "<b>5.5.</b>"
---

# Progress APIs

Implementation evidence:

- `backend/app/routes/progress_routes.py`
- `backend/app/services/progress_service.py`
- `backend/app/models/progress.py`
- `frontend/src/services/progressService.ts`
- `backend/tests/test_enrollment_progress.py`

## Core completion and supporting undo

```http
POST /api/lessons/7/complete
Authorization: Bearer STUDENT_JWT
```

```json
{
  "success": true,
  "message": "Lesson completed",
  "data": {
    "lesson_id": 7,
    "course_id": 42,
    "is_completed": true,
    "certificate_issued": false,
    "certificate_code": null
  }
}
```

The core assignment uses POST to complete a lesson. The supplied codebase adds
`DELETE` on the same path as a supporting undo extension. The service:

1. requires the `student` role;
2. resolves the lesson or returns 404;
3. verifies enrollment in the lesson's course or returns 403;
4. inserts or updates one progress row;
5. prevents undo with 409 after a certificate exists; and
6. lets the broader certificate service evaluate downstream completion.

## Read progress

```http
GET /api/courses/42/progress
Authorization: Bearer STUDENT_JWT
```

```json
{
  "success": true,
  "message": "Progress loaded",
  "data": {
    "course_id": 42,
    "completed_lessons": 1,
    "total_lessons": 2,
    "percentage": 50,
    "completed_lesson_ids": [7]
  }
}
```

The calculation is:

```text
percentage = round(completed lessons × 100 / total lessons)
```

If a course has no lessons, the implementation returns 0 rather than dividing by
zero. Completed IDs are filtered to lessons that still belong to the requested
course.

## Reliability rules

- **Server authority:** only persisted progress rows determine the result.
- **Idempotency:** completing the same lesson updates one row.
- **Isolation:** user ID always comes from the token, never the request body.
- **Referential safety:** enrollment is checked against the lesson's course.
- **Certificate guard:** an issued completion cannot later be made inconsistent.
- **Deletion safety:** the wider lesson service removes dependent progress before
  deleting a lesson.

## Acceptance tests

| Case | Setup/action | Expected |
|---|---|---|
| PRG-01 | Complete one of two lessons | 200 and progress 50% |
| PRG-02 | Complete the same lesson again | One row; stable response |
| PRG-03 | Read without enrollment | 403 |
| PRG-04 | Complete a missing lesson | 404 |
| PRG-05 (extension) | Undo before certificate | 200 and `is_completed=false` |
| PRG-06 (extension) | Undo after certificate | 409 |
| PRG-07 | Read course with zero lessons | 0/0 and 0% |
| PRG-08 | Instructor token | 403 |

The attached Postman folder covers complete, read, undo, and a non-enrollment
negative case. Automated coverage also exercises the 50% calculation and
certificate integration.
