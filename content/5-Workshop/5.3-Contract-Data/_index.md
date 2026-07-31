---
title: "API Contract and Data Integrity"
menuTitle: "Contract & data"
weight: 3
pre: "<b>5.3.</b>"
---

# API contract and data integrity

## Seven core assigned endpoints

| Method | Path | Caller | Core success result |
|---|---|---|---|
| `POST` | `/api/courses/{course_id}/enroll` | Student | Existing or new active enrollment |
| `GET` | `/api/my-courses` | Student | DB-derived counters and enrolled courses |
| `POST` | `/api/lessons/{lesson_id}/complete` | Enrolled Student | Completion saved; optional certificate result |
| `GET` | `/api/courses/{course_id}/progress` | Enrolled Student | Completed/total/percentage/lesson IDs |
| `POST` | `/api/upload/course-thumbnail` | Owner Instructor/Admin | File metadata and URL |
| `POST` | `/api/upload/lesson-material` | Owner Instructor/Admin | File metadata and URL |
| `POST` | `/api/upload/video` | Owner Instructor/Admin | Direct-upload metadata and URL |

## Additional codebase routes

| Method | Path | Caller | Core success result |
|---|---|---|---|
| `DELETE` | `/api/lessons/{lesson_id}/complete` | Enrolled Student | Lesson marked incomplete |
| `POST` | `/api/upload/course-thumbnail/import` | Owner Instructor/Admin | Imported/deduplicated thumbnail metadata |
| `POST` | `/api/upload/video/multipart/start` | Owner Instructor/Admin | S3 key, upload ID, part size |
| `POST` | `/api/upload/video/multipart/part` | Owner Instructor/Admin | One-hour presigned part URL |
| `POST` | `/api/upload/video/multipart/complete` | Owner Instructor/Admin | Final S3/CloudFront URL |
| `POST` | `/api/upload/video/multipart/abort` | Owner Instructor/Admin | Multipart upload cancelled |
| `GET` | `/api/admin/cloudwatch-logs` | Admin | Recent configured log events |

The contract contains seven core endpoints plus a few extra routes used for
integration and testing.

## Data relationships

{{<mermaid>}}
erDiagram
    USERS ||--o{ ENROLLMENTS : enrolls
    COURSES ||--o{ ENROLLMENTS : contains
    COURSES ||--o{ LESSONS : has
    USERS ||--o{ PROGRESS : records
    COURSES ||--o{ PROGRESS : groups
    LESSONS ||--o{ PROGRESS : completes
    USERS ||--o{ CERTIFICATES : earns
    COURSES ||--o{ CERTIFICATES : awards
{{</mermaid>}}

Two database invariants protect retry behavior:

- `UNIQUE(user_id, course_id)` on `enrollments`;
- `UNIQUE(user_id, lesson_id)` on `progress`.

The services query before insert/update for friendly idempotent responses; the
constraints remain essential under concurrent requests.

## Standard response envelope

Successful routes use:

```json
{
  "success": true,
  "message": "Progress loaded",
  "data": {}
}
```

Clients must use the HTTP status and `success` value, then validate the route's
specific `data` shape. They must not infer success from a message string.

## Error contract

| Status | Meaning in this scope | Example |
|---:|---|---|
| 400 | Structurally unsafe multipart input | Key does not match `courses/{course_id}/videos/` |
| 401 | Missing/invalid bearer token | No Authorization header |
| 403 | Authenticated but not allowed | Student not enrolled; Instructor not owner |
| 404 | Resource does not exist | Course or lesson ID missing |
| 409 | Current state blocks transition | Draft course; assessment not ready; certificate prevents undo |
| 413 | File exceeds size limit | Material larger than 50 MiB |
| 415 | File type/content type unsupported | `.exe` upload |
| 422 | FastAPI request validation failed | Missing form field or invalid part number |
| 502 | AWS/storage dependency failed | S3 upload could not start/complete |

Do not expose stack traces, bucket internals, database errors, tokens, or
presigned URLs in public logs.

## State transitions

```text
published course + published assessment
                |
                v
active enrollment
                |
                v
lesson progress rows ----> all lessons complete
                                  |
                                  v
                         final assessment passed
                                  |
                                  v
                         immutable certificate
```

Progress completion alone does not automatically prove the final assessment was
passed. Certificate issuance remains a downstream integration owned by the
broader system.
