# EduCloud API test matrix

Prepared for **Nguyễn Song Minh Luân — Enrollment, Progress, Upload & Testing**.

> Status is intentionally evidence-based as of 31 July 2026. “Automated test exists” means a test is present in the supplied codebase; it neither proves personal authorship nor a live AWS run.

| ID | Area | Scenario | Expected result | Current evidence | Submission status |
|---|---|---|---|---|---|
| ENR-01 | Enrollment | Student enrolls in published, assessment-ready course | 200; enrollment ID/course/status | `backend/app/services/enrollment_service.py` | Code verified |
| ENR-02 | Enrollment | Repeat the same enrollment | Same enrollment; no duplicate row | Service lookup + `uq_enrollment_user_course` | Code verified |
| ENR-02B | Enrollment | Two requests try to create the same enrollment concurrently | Losing transaction rolls back and returns the row committed by the winning request | Integrity-error recovery + regression test | Automated test exists |
| ENR-03 | Enrollment | Instructor/Admin tries Student enrollment | 403 | Student role guard | Code verified |
| ENR-04 | Enrollment | Course is missing | 404 | Service branch | Code verified |
| ENR-05 | Enrollment | Course is draft or assessment not ready | 409 | Service branches | Code verified |
| ENR-06 | Dashboard | Student loads `GET /my-courses` | DB-derived counters and course list | Service query/aggregation | Code verified |
| PRG-01 | Progress | Enrolled Student completes one of two lessons | 200; 50% progress | `test_enrollment_progress.py` | Automated test exists |
| PRG-02 | Progress | Repeat complete request | One progress row; stable response | `uq_progress_user_lesson` + upsert behavior | Code verified |
| PRG-03 | Progress | Non-enrolled Student updates/reads progress | 403 | Enrollment guard | Code verified |
| PRG-04 | Progress extension | Student undoes completion before certificate | 200; `is_completed=false` | Progress route/service | Code verified |
| PRG-05 | Progress extension | Student undoes after certificate issuance | 409 | Certificate guard | Code verified |
| UPL-01 | Thumbnail | Owner uploads valid JPG/PNG/WebP under 10 MiB | URL + metadata; local or S3 storage | `test_course_lesson_api.py` | Automated test exists |
| UPL-02 | Thumbnail | Upload identical thumbnail twice | Same SHA-256 object name | Deduplication test | Automated test exists |
| UPL-03 | Material | Owner uploads allowed material under 50 MiB | URL + metadata | Local upload test | Automated test exists |
| UPL-04 | Direct upload | Unsupported extension | 415 | `.exe` rejection test | Automated test exists |
| UPL-04B | Multipart extension | Unsupported video MIME | 415 | Validation code | Manual Postman run passed |
| UPL-05 | Upload | File exceeds category limit | 413 | Validation code | Manual Postman run passed |
| UPL-06 | Multipart extension | Start → authorize part → complete | S3 URL and sorted parts | Mocked multipart test | Automated mock test exists |
| UPL-07 | Multipart extension | Object key belongs to another course | 400 | Cross-course key test | Automated test exists |
| UPL-08 | Multipart extension | Upload function throws/fails after multipart start | Abort request is attempted; no orphan upload | Backend + frontend failure paths; no user cancel control | Abort and cleanup confirmed in shared S3 environment |
| SEC-01 | Authorization | Non-owner Instructor uploads to another course | 403 | Owner/Admin guard | Manual Postman run passed |
| LOG-01 | CloudWatch extension | Admin requests recent log events | Latest streams/events returned | Mocked monitoring test | Automated mock test exists |
| LOG-02 | CloudWatch | API calls appear in configured EB log group | Route, status, error context visible | Requires EB log streaming | Application event confirmed in shared CloudWatch environment |
| DOC-01 | Contract | Postman collection matches actual routes/auth | All scoped requests import successfully | Attached collection in this report | JSON validation and manual execution complete |

## Final validation record

The manual Postman run and the S3/CloudWatch checks were completed against the
shared EduCloud team environment. Public report files omit tokens, resource
identifiers, presigned URLs, raw log payloads, and unredacted Runner output.
Automated `pytest` results for the working tree with the concurrency fix are
attached as a reproducible text artifact.

## Safety

Never place JWTs, database URLs, AWS keys, Cognito IDs, account IDs, presigned URLs, or unredacted log payloads in this public repository.
