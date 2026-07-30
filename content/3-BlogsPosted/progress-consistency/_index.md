---
title: "Keeping Lesson Progress Consistent Under Retries"
menuTitle: "Consistent Lesson Progress"
weight: 2
pre: "<b>3.2.</b>"
---

# Keeping Lesson Progress Consistent Under Retries

> **Publication status:** Submission-ready internal draft. This page is not a
> public AWS Study Group publication. Add the real public URL and publication
> date only after the article has actually been published. **Public URL:
> pending — do not fabricate.**

Progress tracking looks like a Boolean feature: a lesson is complete or it is
not. In practice, it crosses authentication, enrollment, course structure,
dashboard aggregation, assessments, and certificate issuance. Retries and stale
frontend state can make the result inconsistent unless the backend owns the
rules.

This article describes the progress model used by EduCloud Lite and the tests
needed to show that its state remains predictable.

## 1. The progress API

The two core assigned endpoints are:

```http
POST   /api/lessons/{lesson_id}/complete
GET    /api/courses/{course_id}/progress
Authorization: Bearer <EduCloud JWT>
```

The POST endpoint sets `is_completed=true`; GET returns the authenticated
Student's progress for one course. The caller does not choose a `user_id` in the
request body. The supplied codebase additionally exposes
`DELETE /api/lessons/{lesson_id}/complete` to undo completion; this article
discusses it as a supporting extension rather than a core assigned endpoint.

Before a write, `progress_service.py` verifies:

1. the authenticated role is `student`;
2. the lesson exists; and
3. the Student has an enrollment for the lesson's course.

The read endpoint applies the same Student and enrollment boundary for the
requested course. These checks prevent an authenticated but unrelated user from
learning private progress data or modifying a lesson by guessing its ID.

## 2. One canonical state per user and lesson

The `progress` table stores `user_id`, `course_id`, `lesson_id`, and
`is_completed`. Its unique constraint on `(user_id, lesson_id)` means there can
be only one canonical state for the same learner and lesson.

The service follows an update-or-create pattern:

```python
progress = find_progress(user_id, lesson_id)
if progress is None:
    progress = Progress(
        user_id=user_id,
        course_id=lesson.course_id,
        lesson_id=lesson_id,
        is_completed=completed,
    )
else:
    progress.is_completed = completed
commit()
```

Therefore, two sequential “complete” requests do not add two completed records.
They converge on `true`. Two sequential “undo” requests converge on `false`.
As with enrollment, a database upsert or explicit unique-conflict recovery would
make the narrow concurrent insert race more graceful; the unique constraint is
still the data-integrity backstop.

## 3. Deriving a percentage instead of storing one

EduCloud does not store an independent percentage that can drift from lesson
state. `GET .../progress` first obtains the current lesson IDs for the course,
then counts completed progress rows for the authenticated user that belong to
that course and those lesson IDs.

```text
percentage = round(completed_lessons × 100 / total_lessons)
```

If the course has no lessons, the result is `0`. The response includes
`completed_lessons`, `total_lessons`, `percentage`, and
`completed_lesson_ids`, allowing the frontend to render both a progress bar and
the exact completed markers from one server snapshot.

Filtering against current lesson IDs matters. A stale progress row should not
inflate the percentage after curriculum changes. The lesson-deletion integration
also removes dependent progress rows before the lesson is deleted, providing a
second cleanup layer in the current codebase.

## 4. Lesson progress is not final completion

Completing every lesson may unlock the final assessment, but it does not by
itself prove course completion. Certificate issuance in EduCloud requires:

- at least one lesson and every current lesson marked complete;
- a published final assessment;
- a passing assessment attempt by the same Student; and
- no existing certificate for the same user/course.

When these conditions are satisfied, certificate creation is idempotent and the
enrollment status becomes `completed`. Once a certificate exists, the progress
service rejects undoing a lesson with `409`. This preserves the meaning of an
already-issued completion record.

This rule is a product decision, not a universal LMS requirement. The important
engineering point is that the API expresses it explicitly and tests the boundary
instead of leaving it to frontend behavior.

## 5. Consistency scenarios to test

| Scenario | Expected result |
| --- | --- |
| Enrolled Student completes lesson | One row with `is_completed=true`. |
| Same request repeated | Same state and row count. |
| Enrolled Student undoes lesson | Existing row becomes `false`. |
| Student is not enrolled | `403`; no progress mutation. |
| Instructor/Admin calls progress API | `403 Student access required`. |
| Lesson does not exist | `404 Lesson not found`. |
| One of two lessons completed | `completed_lessons=1`, `total_lessons=2`, `percentage=50`. |
| Old row references a removed/non-current lesson | It is not counted in current course percentage. |
| Undo after certificate issuance | `409`; certificate-backed completion remains stable. |
| Complete all lessons without passing assessment | Lesson percentage may be 100, but no new certificate is issued. |

`backend/tests/test_enrollment_progress.py` implements the two-lesson example:
after one completion it asserts 50%, one active course, and no completed course.
It later completes the second lesson, submits a passing assessment, and verifies
the certificate and completed enrollment. This protects the distinction between
lesson progress and final completion.

The manual test plan contains progress cases but currently labels them **Not
Started**. Before reporting a pass, run the Student flow with a real token in
Postman or Swagger, save the response and matching database state, and repeat
selected calls against the deployed API.

## 6. Monitoring and troubleshooting

For a failed progress request, capture the timestamp, route template, response
status, and a redacted correlation note. Useful distinctions are:

- `401`: missing or invalid token;
- `403`: wrong role or missing enrollment;
- `404`: lesson does not exist;
- `409`: trying to undo a certificate-backed completion; and
- `5xx`: unexpected application/database failure.

The EduCloud health service tracks recent successes, 4xx, 5xx, average response
time, and top routes in process memory, while the Admin CloudWatch reader fetches
recent events from active Elastic Beanstalk log streams. In-memory values reset
on restart and are not shared across instances, so durable production monitoring
should add structured CloudWatch logs, alarms, and correlation IDs. Tokens and
student data must not be copied into logs or screenshots.

## 7. Future hardening

- Replace query-then-insert with a transaction-safe PostgreSQL upsert.
- Add request correlation IDs and structured audit events containing IDs rather
  than personal data.
- Add API-level concurrent retry tests, not only sequential service tests.
- Use versioned schema migrations for progress constraints and cleanup rules.
- Define curriculum-change policy: whether adding a new lesson can reopen a
  course that already has a certificate.
- Move traffic metrics to a shared durable backend if the API scales beyond one
  process.

## Conclusion

Consistent progress comes from one server-owned state per user and lesson,
authorization tied to enrollment, percentages derived from current database
rows, and a clear boundary between lesson completion and certification. EduCloud
implements those foundations and documents the concurrency and observability
improvements still needed for production scale.

## Implementation references

- `EduCloud/backend/app/routes/progress_routes.py`
- `EduCloud/backend/app/services/progress_service.py`
- `EduCloud/backend/app/models/progress.py`
- `EduCloud/backend/app/services/certificate_service.py`
- `EduCloud/backend/app/services/enrollment_service.py`
- `EduCloud/backend/tests/test_enrollment_progress.py`

**Public AWS Study Group URL:** Pending actual publication.
