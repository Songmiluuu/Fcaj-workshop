---
title: "Validation, Postman, and CloudWatch"
menuTitle: "Validation & evidence"
weight: 8
pre: "<b>5.8.</b>"
---

# Validation, Postman, and CloudWatch

Validation is separated into three evidence levels so a mocked AWS client is never
presented as proof of a real deployment.

## Level 1 — automated backend tests

Seven test nodes relevant to the assigned areas and supporting codebase behavior
were selected and run on **30 July 2026**:

```powershell
Set-Location EduCloud/backend
python -m pytest -p no:cacheprovider `
  tests/test_enrollment_progress.py::test_enrollment_progress_and_dashboard_use_database_rows `
  tests/test_course_lesson_api.py::test_instructor_can_upload_lesson_files `
  tests/test_course_lesson_api.py::test_upload_rejects_unsupported_file_type `
  tests/test_course_lesson_api.py::test_duplicate_thumbnail_upload_reuses_the_same_object `
  tests/test_course_lesson_api.py::test_instructor_can_complete_presigned_video_upload `
  tests/test_course_lesson_api.py::test_video_multipart_rejects_another_course_key `
  tests/test_monitoring.py::test_cloudwatch_logs_reads_tail_of_latest_active_stream
```

Result: **7 collected, 7 passed**.

{{< staticlink path="files/targeted-pytest-result.txt" text="Download the sanitized test result" download="true" >}}

Relevant coverage includes:

- enrollment/progress persistence and 50% calculation;
- concurrent enrollment conflict recovery without masking unrelated database errors;
- dashboard, assessment, and certificate integration;
- local material/video upload;
- unsupported file rejection;
- deduplicated thumbnail behavior;
- multipart part sorting and completion with a mocked S3 client;
- rejection of a multipart key from another course; and
- CloudWatch log-tail behavior with a fake monitoring client.

This proves deterministic application behavior in the test environment. It does
**not** prove real Cognito, S3, CloudFront, IAM, Elastic Beanstalk, or CloudWatch
configuration.

A first diagnostic run of the whole backend exposed dependency drift: the global
environment had bcrypt 5.0.0 while the repository pins bcrypt 4.0.1 for passlib
1.7.4 compatibility. After installing `requirements-dev.txt` into an isolated
environment, the full suite collected 28 tests and **all 28 passed**. The two new
regression tests cover the concurrent enrollment recovery path and verify that an
unrelated integrity error is still raised.

{{< staticlink path="files/full-pytest-result.txt" text="Download the sanitized full-suite result" download="true" >}}

## Level 2 — scoped Postman regression

Import the collection and fill only local variables:

- {{< staticlink path="files/EduCloud-API-Testing.postman_collection.json" text="EduCloud scoped Postman collection" download="true" >}}
- {{< staticlink path="files/api-test-matrix.md" text="API test and evidence matrix" download="true" >}}

Recommended order:

1. start FastAPI and confirm `GET /docs`;
2. set `student_token`, `instructor_token`, `admin_token`, and fixture IDs;
3. run Enrollment positive, repeat/idempotency, no-token, and wrong-role cases;
4. run complete → get progress → undo → not-enrolled negative cases;
5. run the valid direct uploads included in the collection; create and execute
   the matrix's invalid-file, oversize, and non-owner cases separately because
   they are not included in the attached collection;
6. switch to a sandbox S3 configuration and run multipart start/part/complete;
7. use the explicit abort request on a second multipart upload and verify cleanup;
   this tests the API abort route, not a user-triggered UI cancellation path;
8. call the Admin CloudWatch endpoint; and
9. export the Runner report after clearing token values.

For the requests it contains, the collection includes assertions for status,
response envelope, IDs, progress range, upload metadata, and CloudWatch success.
The final manual run also covered the separate invalid-file, oversize,
non-owner, and multipart cleanup cases in the test matrix.

## Level 3 — live AWS verification

### S3/CloudFront

Verify that:

- the returned object is under the correct course prefix;
- Block Public Access remains enabled;
- direct S3 anonymous access is denied;
- delivery through the configured CloudFront URL works;
- file content type and size match;
- multipart completion removes the in-progress upload; and
- abort/lifecycle rules prevent orphaned parts.

### CloudWatch

The code exposes `GET /api/admin/cloudwatch-logs`. Its service reads at most ten
recent streams, filters events to the previous 24 hours, and returns newest events
first. It requires:

```dotenv
AWS_MONITORING_ENABLED=true
AWS_CLOUDWATCH_LOG_GROUP=YOUR_LOG_GROUP
```

Elastic Beanstalk log streaming must also be enabled outside the application.
Generate one successful scoped request and one safe validation error, record their
timestamps, and locate the corresponding access/application log events. Then
verify that a non-Admin receives 403 from the log endpoint.

The shared-environment validation confirmed authorized S3 uploads under the
configured course prefix, multipart complete/abort behavior, expected Postman
status and authorization results, and application events in the configured
CloudWatch log group. Tokens, resource identifiers, presigned URLs, and raw log
payloads are omitted from the public report.

## Shared frontend deployment

These figures record the Amplify configuration used by the EduCloud team.

{{< staticimage path="images/workshop/08-amplify-deployed.png" alt="Shared EduCloud Amplify deployment result" >}}

{{< staticimage path="images/workshop/08b-amplify-spa-rewrite.png" alt="Shared EduCloud single-page application rewrite" >}}

## Current evidence status

| Evidence | Status on 31 July 2026 |
|---|---|
| Scoped implementation paths audited | Complete |
| Selected assigned-area/supporting test nodes | 7/7 passed |
| Full backend tests in pinned environment | 28/28 passed |
| Corrected report Postman collection | Manual positive/negative run completed |
| Static scoped OpenAPI snapshot | Created; runtime Swagger remains authoritative |
| Live S3 and CloudWatch checks | Completed in the shared team environment |
| AWS Console configuration | Shared team setup included at related steps |

{{% notice warning %}}
Never publish bearer tokens, passwords, database URLs, AWS keys, presigned URLs,
account IDs, Cognito IDs, private bucket names, or unredacted log payloads.
{{% /notice %}}
