---
title: "Week 9 - S3 multipart upload, CloudWatch, and verification"
menuTitle: "Week 9"
weight: 9
pre: "<b>1.9.</b>"
---

**Period:** July 27, 2026 - August 2, 2026  
**Status on July 30:** Current plan phase; codebase behavior tested, live evidence pending

> **Attribution basis:** multipart control routes and the Admin log-reader are
> supporting extensions found in the supplied codebase, not core endpoints in
> the assignment screenshot. Their source proves system behavior only; personal
> authorship requires Luân's PR/task/mentor evidence.

## Objectives

- Make large video uploads reliable with direct browser-to-S3 multipart upload.
- Expose recent CloudWatch log events to authorized Admin users.
- Re-run the targeted automated suite and identify remaining manual evidence.

## Current codebase behavior verified by July 30

### S3 upload work

- The codebase provides multipart endpoints to start an upload, authorize each part, complete
  the ordered parts, and abort an incomplete upload.
- It constrains video keys to **courses/{course_id}/videos/** and rejects a key
  belonging to another course.
- It limits video types to MP4, WebM, and QuickTime and the declared size to
  500 MiB.
- It uses 10 MiB parts and one-hour presigned URLs.
- The frontend worker flow uses at most three concurrent uploads, up to
  three attempts per part, and automatic abort after failure.
- **POST /api/upload/video** remains the backend fallback when storage mode
  is not S3.

### CloudWatch work

- The codebase includes the Admin-only **GET /api/admin/cloudwatch-logs** endpoint.
- Its service reads the newest active log streams from the configured log group, limits
  events to the last 24 hours, sorted newest first, and capped the returned
  limit at 200.
- It returns a safe status message when monitoring is disabled, the log group is
  absent, or the AWS Logs client fails.

### Automated verification

The following command was run locally on **July 30, 2026**:

python -m pytest -p no:cacheprovider <seven selected node IDs>

Result: **7 collected, 7 passed**. The exact node IDs and output are attached
in the workshop validation section.

A clean environment installed from `backend/requirements-dev.txt` was also used
for the full backend suite: **26 collected, 26 passed**. The sanitized outputs
are attached in the workshop validation section.

## Current deliverable status

| Deliverable | Status | Evidence boundary |
| --- | --- | --- |
| Backend S3 multipart flow | Present in codebase; mocked API tests pass | Does not yet prove a real bucket upload or personal authorship |
| Frontend chunk/retry/abort flow | Present in codebase; source reviewed | Browser-to-S3 run and attribution still need evidence |
| CloudWatch log reader | Present in codebase; fake-client test passes | Real log group access and attribution still need evidence |
| Report-scoped Postman collection | Created and JSON-validated | Execution evidence is still pending |
| Legacy team-repository Postman evidence | Incomplete | `test-cases.md` remains Not Started and the older collection omits assigned requests |

## Remaining work for July 31–August 2

- Import the corrected report-scoped Postman collection and set only local,
  non-committed environment variables.
- Execute local positive and negative cases, then record actual responses
  without exposing tokens.
- Prepare the live S3 and CloudWatch checklist for Period 10.
- Record defects found by manual testing and retest after correction.

## Test criteria

| Criterion | Result on Jul 30 |
| --- | --- |
| Multipart completion sorts parts by part number. | Passed automated test |
| A video key outside the selected course path is rejected with HTTP 400. | Passed automated test |
| CloudWatch reader ignores stale streams and returns newest events first. | Passed fake-client test |
| Selected enrollment/progress/upload/monitoring nodes are green. | 7/7 passed |
| Full backend suite is green with pinned dependencies. | 26/26 passed |
| Real S3 object and real CloudWatch event are captured. | Pending |
| Full Postman report contains actual results. | Pending |

## Repository evidence

- EduCloud/backend/app/routes/upload_routes.py
- EduCloud/backend/app/services/s3_service.py
- EduCloud/frontend/src/services/uploadService.ts
- EduCloud/backend/app/routes/admin_routes.py
- EduCloud/backend/app/services/monitoring_service.py
- EduCloud/backend/tests/test_course_lesson_api.py
- EduCloud/backend/tests/test_monitoring.py
- EduCloud/api/postman/EduCloud.postman_collection.json
- EduCloud/api/test-plan/test-cases.md
