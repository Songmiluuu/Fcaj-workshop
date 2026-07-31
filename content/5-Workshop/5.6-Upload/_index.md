---
title: "Upload APIs and Amazon S3"
menuTitle: "Upload APIs"
weight: 6
pre: "<b>5.6.</b>"
---

# Upload APIs and Amazon S3

Relevant source files:

- `backend/app/routes/upload_routes.py`
- `backend/app/services/s3_service.py`
- `backend/app/services/remote_image_service.py`
- `frontend/src/services/uploadService.ts`
- `backend/tests/test_course_lesson_api.py`

The three direct upload endpoints belong to the core assignment. Remote
thumbnail import/deduplication and multipart video control are marked as
supporting behaviors.

## Validation matrix

| Category | Allowed extension/content | Maximum | Object prefix |
|---|---|---:|---|
| Thumbnail | JPG, JPEG, PNG, WebP | 10 MiB | `courses/{course_id}/thumbnails/` |
| Material | PDF, DOC, DOCX, PPT, PPTX, TXT, ZIP | 50 MiB | `courses/{course_id}/materials/` |
| Video | MP4, WebM, MOV | 500 MiB | `courses/{course_id}/videos/` |

Every route first loads the course and requires its Instructor owner or an Admin.
Changing only the client-side form cannot bypass this server check.

## Direct upload

All three categories accept `multipart/form-data` with `course_id` and `file`.

```http
POST /api/upload/lesson-material
Authorization: Bearer INSTRUCTOR_JWT
Content-Type: multipart/form-data

course_id=42
file=@lesson-notes.pdf
```

The service checks extension and size, chooses local/S3 storage from configuration,
and returns URL, original filename, content type, byte count, and storage strategy.

Thumbnail names are content-addressed with SHA-256. Uploading identical thumbnail
bytes reuses the same object key. Material and video names use UUIDs to avoid
reading large files only to hash them.

## Supporting extension: multipart video upload

{{<mermaid>}}
sequenceDiagram
    participant UI as React client
    participant API as FastAPI
    participant S3 as Amazon S3
    UI->>API: POST multipart/start
    API->>S3: CreateMultipartUpload
    S3-->>API: upload_id
    API-->>UI: key, upload_id, 10 MiB part_size
    loop each part, max 3 workers
        UI->>API: POST multipart/part
        API-->>UI: 1-hour presigned URL
        UI->>S3: PUT binary part
        S3-->>UI: ETag
    end
    UI->>API: POST multipart/complete + sorted part/ETag list
    API->>S3: CompleteMultipartUpload
    S3-->>API: success
    API-->>UI: delivery URL
{{</mermaid>}}

The React client retries a failed part up to three times and processes at most
three parts concurrently. If the upload function throws or fails after its retries, its
catch path calls `multipart/abort`. It does not accept or pass an `AbortSignal`,
and the current UI has no user-triggered cancellation control.

The API rejects:

- a key outside `courses/{course_id}/videos/`;
- a key with another path segment after the generated filename;
- unsupported extension or MIME type;
- duplicate part numbers;
- part numbers outside 1–10,000;
- an empty ETag/upload ID; and
- a declared size above 500 MiB.

## Storage and delivery

In production, `save_upload` sends the file to the configured private S3 bucket.
The returned URL uses `AWS_S3_PUBLIC_BASE_URL`, normally a CloudFront distribution.
This does not make the bucket itself public; bucket policy and Origin Access
Control belong to the shared infrastructure configuration and must be verified
separately.

The shared team environment keeps the application upload bucket in the same
Singapore Region as the deployment. Bucket names are redacted in the public
report.

{{< staticimage path="images/workshop/06-s3-shared-buckets-redacted.png" alt="Redacted S3 buckets in the shared EduCloud team environment" >}}

When a lesson attachment is replaced or deleted, cleanup is best-effort and only
accepts URLs that resolve back to the owning course prefix. A temporary S3 failure
is logged without rolling back the database update.

## Postman checks

1. Select a small valid file for each direct route.
2. Assert 200, non-empty URL, correct size, and `storage in [local, s3]`.
3. Repeat the same thumbnail and compare the URL/object name.
4. Use an unsupported file to assert 415.
5. Use a non-owner Instructor token to assert 403.
6. For multipart, start → request a part URL → PUT the part directly → copy ETag →
   complete.
7. Use the explicit abort request for a second multipart upload and verify no
   incomplete upload remains in S3. This tests the API route, not a UI cancel
   control.
8. Redact every token, presigned URL, bucket/account ID, and ETag before publishing
   screenshots.

Automated tests mock S3 for multipart protocol behavior. The final integration
run in the shared team environment also confirmed the configured S3 upload path,
authorization checks, multipart completion/abort, and media delivery.
