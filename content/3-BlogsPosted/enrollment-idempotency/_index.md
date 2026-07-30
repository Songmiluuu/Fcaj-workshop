---
title: "Designing Idempotent and Authorized Course Enrollment"
menuTitle: "Idempotent Course Enrollment"
weight: 1
pre: "<b>3.1.</b>"
---

# Designing Idempotent and Authorized Course Enrollment

> **Publication status:** Submission-ready internal draft. This page is not a
> public AWS Study Group publication. Add the real public URL and publication
> date only after the article has actually been published. **Public URL:
> pending — do not fabricate.**

Repeated requests are normal in web applications. A learner may double-click
“Start course,” a mobile connection may retry after a timeout, or the frontend
may resend a request because it never received the first response. If enrollment
always inserts a new row, one human action can create duplicate memberships,
incorrect dashboard counts, and ambiguous completion state.

This article explains the enrollment boundary implemented in EduCloud Lite. The
focus is not only preventing duplicates; it is deciding **who** may enroll,
**which** course is eligible, and **which layer** guarantees integrity.

## 1. The API contract

The assigned enrollment surface contains two authenticated endpoints:

```http
POST /api/courses/{course_id}/enroll
GET  /api/my-courses
Authorization: Bearer <EduCloud JWT>
```

The client does not submit a `user_id`. FastAPI obtains it from the verified
bearer token through `get_current_user`. This prevents a caller from enrolling a
different account by modifying JSON in the browser.

`POST .../enroll` applies the following rules in order:

1. the authenticated role must be `student`, otherwise return `403`;
2. the course must exist, otherwise return `404`;
3. the course must be `published`, otherwise return `409`;
4. the course must have a published final assessment, otherwise return `409`;
5. if `(user_id, course_id)` already exists, return that enrollment;
6. otherwise create one active enrollment and commit it.

These checks are visible in
`backend/app/services/enrollment_service.py`. The route in
`backend/app/routes/enrollment_routes.py` exposes only the enrollment identifier,
course identifier, and status in the success response.

## 2. Authentication is not authorization

A valid token answers “who sent this request?” It does not automatically answer
“may this user perform this operation?” EduCloud stores the current application
role in PostgreSQL and includes it in the EduCloud JWT after the Cognito identity
exchange. The service still checks `role == "student"` before reading or writing
enrollment data.

This matters because an Instructor or Admin token is valid but should not be
silently turned into a Student enrollment. Keeping the rule in the service also
protects the API when a caller bypasses the React interface.

Course state is another authorization-like business boundary. A Student cannot
join a draft or hidden course merely by guessing its numeric identifier. Requiring
a published final assessment also prevents a learner from entering a course that
cannot satisfy the platform's completion workflow.

## 3. What idempotency means here

For this operation, idempotency means that repeating the same valid enrollment
request produces the same membership state: one active Student-to-course
relationship. The implementation queries the existing row before inserting:

```python
enrollment = find_enrollment(user_id, course_id)
if enrollment is None:
    enrollment = Enrollment(user_id=user_id, course_id=course_id, status="active")
    save(enrollment)
return enrollment
```

This is application-level idempotency and handles ordinary sequential retries.
It does not, by itself, eliminate the race between two requests that both read
“no row” before either commits.

The database is therefore the final guard. The `enrollments` model defines a
unique constraint on `(user_id, course_id)`. Even under concurrency, PostgreSQL
cannot persist two memberships for the same pair.

The remaining hardening opportunity is explicit race handling: use a PostgreSQL
upsert, or catch the unique-constraint error, roll back, reload the existing row,
and return the normal success representation. The current query-before-insert
plus unique constraint protects data integrity, while that future change would
also make the concurrent response path graceful.

## 4. Building the Student dashboard from database rows

`GET /api/my-courses` is also Student-only. It joins the authenticated user's
enrollments with courses and instructors, then groups lessons and completed
progress rows by course. For each enrolled course it returns:

- enrollment status;
- completed and total lesson counts;
- rounded progress percentage;
- whether an assessment exists, has been passed, or is ready to start; and
- aggregate active-course, completed-lesson, and certificate-backed completed-
  course totals.

These values are derived from PostgreSQL instead of fixed frontend numbers. The
dashboard may also trigger idempotent certificate backfill for an older eligible
completion. Certificate issuance itself still requires all lessons and a passed
assessment; 100% lesson progress alone is not presented as a certificate.

## 5. Verification matrix

An enrollment test should prove both the success path and the boundaries:

| Scenario | Expected result |
| --- | --- |
| Student + eligible published course | One active enrollment is returned. |
| Repeat the same request | The same enrollment is returned; row count remains one. |
| Missing or invalid bearer token | Authentication failure; no row created. |
| Instructor/Admin token | `403 Student access required`. |
| Unknown course | `404 Course not found`. |
| Draft/hidden course | `409`; no row created. |
| Published course without published assessment | `409`; no row created. |
| Two concurrent requests | At most one database row; response handling recorded. |
| `GET /my-courses` as Student | Totals match enrollment, lesson, progress, assessment, and certificate rows. |

The repository's `backend/tests/test_enrollment_progress.py` exercises a real
database-backed service flow and checks dashboard values. The Postman collection
contains an enrollment request, while `api/test-plan/test-cases.md` currently
marks its manual cases as **Not Started**. A report must not convert that label to
“Passed” until the collection has actually run and its response/database evidence
has been saved.

For deployment validation, record the test timestamp and expected status code,
then inspect Elastic Beanstalk health and the relevant CloudWatch stream without
copying bearer tokens into screenshots. The current Admin traffic snapshot is
process-local and resets after restart, so it is useful for a demo but not a
replacement for durable CloudWatch history.

## 6. Practical lessons

- Derive ownership from authenticated context, not request data.
- Treat role and course publication state as backend rules.
- Make ordinary retries return the existing resource.
- Use a database unique constraint even when the service checks first.
- Test failures and side effects, not only `200 OK` responses.
- Separate lesson progress from final course/certificate completion.
- Record real Postman and CloudWatch evidence; do not infer a pass from code
  alone.

## Conclusion

Reliable enrollment is a small API with several important boundaries. EduCloud
combines verified identity, Student-only authorization, course readiness checks,
application-level idempotency, and database uniqueness. This design keeps one
membership per learner and course during normal retries, while clearly identifying
concurrent upsert handling as the next hardening step.

## Implementation references

- `EduCloud/backend/app/routes/enrollment_routes.py`
- `EduCloud/backend/app/services/enrollment_service.py`
- `EduCloud/backend/app/models/enrollment.py`
- `EduCloud/backend/tests/test_enrollment_progress.py`
- `EduCloud/api/postman/EduCloud.postman_collection.json`
- `EduCloud/api/test-plan/test-cases.md`

**Public AWS Study Group URL:** Pending actual publication.
