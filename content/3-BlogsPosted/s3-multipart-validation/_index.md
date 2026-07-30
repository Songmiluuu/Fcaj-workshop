---
title: "Secure S3 Multipart Uploads and Deployment Validation"
menuTitle: "S3 Multipart & Validation"
weight: 3
pre: "<b>3.3.</b>"
---

# Secure S3 Multipart Uploads and Deployment Validation

> **Publication status:** Submission-ready internal draft. This page is not a
> public AWS Study Group publication. Add the real public URL and publication
> date only after the article has actually been published. **Public URL:
> pending — do not fabricate.**

Course files are not equal workloads. A thumbnail may be a few hundred
kilobytes, a document may be tens of megabytes, and a video may be hundreds of
megabytes. Sending every video byte through a small FastAPI/Elastic Beanstalk
instance increases application bandwidth, request duration, and failure impact.

EduCloud Lite therefore supports direct-to-S3 multipart video upload while
keeping authorization and object naming in FastAPI. This article explains the
control flow, the security checks, and how to validate it with automated tests,
Postman/browser evidence, and CloudWatch without claiming unexecuted tests as
results.

## 1. Upload surface and ownership boundary

The core assigned upload routes are under `/api/upload`:

```text
POST /course-thumbnail
POST /lesson-material
POST /video
```

The supplied codebase also provides supporting extensions:

```text
POST /course-thumbnail/import
POST /video/multipart/start
POST /video/multipart/part
POST /video/multipart/complete
POST /video/multipart/abort
```

Every route loads the target course and calls the same course-owner-or-Admin
authorization rule. A valid Instructor token is not enough: an Instructor cannot
upload into another Instructor's course by changing `course_id`.

The current limits and allowlists are explicit:

| Category | Allowed extension/content | Maximum size |
| --- | --- | ---: |
| Thumbnail | `.jpg`, `.jpeg`, `.png`, `.webp` | 10 MiB |
| Lesson material | `.pdf`, `.doc`, `.docx`, `.ppt`, `.pptx`, `.txt`, `.zip` | 50 MiB |
| Video | `.mp4`, `.webm`, `.mov`; multipart MIME is MP4, WebM, or QuickTime | 500 MiB |

Unsupported extensions return `415`; oversized files return `413`. Thumbnail
names are content-addressed with SHA-256, so uploading identical bytes reuses the
same object name. Other categories use UUID names to avoid hashing large videos.

## 2. Multipart control and data flow

The production-style video flow separates the control plane from the data plane:

1. The browser calls `multipart/start` with course ID, original filename, MIME
   type, and size.
2. FastAPI authorizes course ownership, validates the video, and calls S3
   `CreateMultipartUpload`.
3. S3 returns an `upload_id`; FastAPI returns it with a key under
   `courses/{course_id}/videos/{uuid}.{extension}` and a 10 MiB part size.
4. For each part number, the browser calls `multipart/part`. FastAPI rechecks
   ownership and key scope, then creates a presigned `UploadPart` URL valid for
   one hour.
5. The browser sends the part bytes directly to S3 with `PUT` and records the
   response `ETag`.
6. The browser sends all `{part_number, etag}` pairs to `multipart/complete`.
   FastAPI rejects duplicate part numbers, sorts them, and calls S3
   `CompleteMultipartUpload`.
7. If a browser worker fails, it calls `multipart/abort`; S3 discards that
   multipart session when the abort succeeds.

The React upload service uses at most three workers, slices 10 MiB chunks, and
retries each part up to three times with short exponential waits. If the backend
is configured for local rather than S3 storage, `start` returns strategy
`backend`, and the browser falls back to the regular `/upload/video` request.

## 3. Why the key check matters

A presigned URL grants temporary permission to one S3 operation. Before creating
that URL, EduCloud validates that the object key starts with the exact course
prefix and contains one filename, not another slash:

```text
courses/{authorized_course_id}/videos/{generated_filename}
```

The same check runs for part authorization, completion, and abort. Combined with
the ownership check, this stops a user who owns Course 10 from presenting a key
under Course 11.

The target architecture requires the S3 bucket to remain private. CloudFront
Origin Access Control should be the read path, while a presigned URL provides a
temporary write path for one upload part. The configured public delivery base
should be the CloudFront domain rather than a publicly readable S3 bucket URL.

Presigned URLs must be treated as secrets during their lifetime. Do not put their
query strings in screenshots, Postman exports, application logs, or Git commits.
AWS credentials must stay on the Elastic Beanstalk instance role and must never
appear in the React bundle. The final bucket, OAC, and instance-role state still
requires redacted live-account evidence.

## 4. Browser and S3 CORS requirements

The browser must be allowed to send `PUT` requests to the S3 bucket from the
deployed frontend origin. It also needs access to the response `ETag`; otherwise
the bytes may upload successfully but the browser cannot construct the complete
request.

The bucket CORS rule should therefore be narrow: only the required frontend
origin, `PUT`, required request headers, and exposed `ETag`. A wildcard origin is
not necessary for the final deployment. S3 Block Public Access and the
CloudFront OAC bucket policy are separate from CORS and must remain enabled.

## 5. Verification strategy

### 5.1 Automated evidence already represented in the repository

`backend/tests/test_course_lesson_api.py` covers:

- local material and video upload;
- rejection of an unsupported `.exe` material;
- duplicate thumbnail bytes reusing one content-addressed file;
- multipart start, part authorization, ordered completion, and returned URL; and
- rejection of a video key that belongs to another course.

These tests mock AWS calls where appropriate. They verify application behavior,
not the live account's IAM, S3 CORS, bucket policy, or CloudFront configuration.

### 5.2 Postman and browser run

Use Postman for the API control plane and negative cases:

1. authenticate as the course owner and set redacted `base_url`, `token`, and
   `course_id` environment values;
2. upload a valid thumbnail/material and confirm the response metadata;
3. repeat with a forbidden extension, missing token, wrong role, and another
   Instructor's course;
4. call multipart `start`, then request a part URL for the returned key;
5. try a key under a different course and confirm `400 Invalid video object key`;
6. verify duplicate part numbers are rejected by `complete`;
7. remove tokens and presigned URLs before exporting evidence.

Use the real React/browser flow for end-to-end chunk transfer because it slices
the file, runs concurrent workers, reads S3 `ETag` headers, and automatically
aborts after failure. Confirm the final object exists under the expected course
prefix and is readable through the configured CloudFront path, while direct
public bucket access remains blocked.

The legacy team collection at `EduCloud/api/postman/EduCloud.postman_collection.json`
began with basic upload requests and does not prove that the multipart flow was
run. The corrected report-scoped collection is JSON-valid and matches the reviewed
routes, but it also remains unexecuted. The rows TC-010 and TC-011 in the legacy
`api/test-plan/test-cases.md` are currently **Not Started**; only an actual run
with saved output may change them to Pass or Fail.

### 5.3 CloudWatch and health validation

For each deployed test, record a UTC timestamp, route template, expected status,
and a non-sensitive test ID. Then check:

- Elastic Beanstalk environment/instance health;
- recent API 4xx/5xx and average response time in the Admin health view;
- the active CloudWatch log stream around the test timestamp;
- S3 object count/size and the expected course prefix; and
- Cost Explorer/Budgets after large transfer tests.

The Admin endpoint `GET /api/admin/cloudwatch-logs` reads the newest events from
active streams in the configured log group. Its automated test verifies selection
of the latest stream and event ordering. CloudWatch ingestion and IAM read
permission still need to be configured in the deployed account. The current
request counters are process-local, and `app/utils/logger.py` still identifies
full CloudWatch logging configuration as follow-up work; therefore the report
must not claim complete request tracing unless structured logs are actually
present.

## 6. Failure handling and remaining risks

| Failure | Current behavior | Further hardening |
| --- | --- | --- |
| Part upload transiently fails | Browser retries up to three times, then requests abort. | Persist upload session so a user can resume after reload. |
| Browser closes before abort | Multipart parts may remain in S3. | Add an S3 lifecycle rule to abort incomplete multipart uploads. |
| Wrong course key | FastAPI returns `400` before presigning/completing. | Store server-side upload ownership/session records as an additional binding. |
| Duplicate completion part | FastAPI rejects duplicate part numbers. | Verify expected contiguous part numbers and recorded session metadata. |
| Declared size differs from final object | Payload is range-validated, but completion trusts client metadata. | `HEAD` the object after completion and verify size/checksum before saving its URL. |
| Malicious allowed-format file | Extension/MIME checks are not malware inspection. | Add checksum, content inspection, quarantine, and malware scanning. |
| Presigned URL appears in logs | Temporary write capability may leak. | Redact query strings and use structured allowlisted log fields. |

## Conclusion

Secure multipart upload is more than generating a presigned URL. EduCloud keeps
course ownership, type/size checks, object-key scope, part validation, completion,
and abort control in FastAPI, while the browser transfers video bytes directly
to private S3. Automated tests cover the main application rules; Postman/browser,
S3, Elastic Beanstalk, and CloudWatch evidence are still required to prove the
deployed configuration.

## Implementation references

- `EduCloud/backend/app/routes/upload_routes.py`
- `EduCloud/backend/app/services/s3_service.py`
- `EduCloud/frontend/src/services/uploadService.ts`
- `EduCloud/backend/tests/test_course_lesson_api.py`
- `EduCloud/backend/app/services/monitoring_service.py`
- `EduCloud/backend/tests/test_monitoring.py`
- `EduCloud/api/test-plan/test-cases.md`

**Public AWS Study Group URL:** Pending actual publication.
