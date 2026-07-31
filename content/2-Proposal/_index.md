---
title: "Proposal"
menuTitle: "Proposal"
weight: 2
chapter: false
disableTitle: true
pre: "<b>2.</b>"
---

<h1 class="proposal-hero-title">EDUCLOUD LITE — ENROLLMENT, PROGRESS, UPLOAD APIS & TESTING</h1>

**Project Intern:** Nguyễn Song Minh Luân  
**Program:** First Cloud AI Journey — Amazon Web Services Vietnam Company Limited  
**Internship period:** June 1, 2026 – August 15, 2026

## 1. Project overview

EduCloud Lite is a free-course learning management system built with a React/Vite
frontend and a FastAPI backend. Students can browse published courses, enroll,
study protected lesson content, persist lesson progress, take a final assessment,
and receive a certificate after satisfying the completion rules. Instructors can
author courses and upload thumbnails, documents, and videos. Administrators can
review platform data and health information.

The repository implements a low-cost AWS delivery design: Amplify Hosting serves
the frontend, Amazon Cognito manages user identity, FastAPI runs in an Elastic
Beanstalk single-instance environment, a private Amazon S3 bucket stores course
assets, CloudFront delivers media and routes API traffic, and CloudWatch supports
operational inspection. Supabase PostgreSQL remains the external application
database and role authority.

The team architecture provides context for my assigned APIs. Components outside
that scope remain team-owned.

## 2. Problem statement

A static course page cannot reliably answer four important questions: who may
join a course, which lessons a student has completed, who may upload course
files, and whether the API behaved correctly after deployment. Without backend
rules, common failures include:

- duplicate enrollment or progress rows caused by retries and double-clicks;
- progress changes by a user who is not enrolled in the course;
- uploads to a course owned by another instructor;
- large videos passing through the application server and exhausting its
  bandwidth or temporary storage;
- unsupported files, cross-course S3 object keys, or abandoned multipart uploads;
- successful local tests but insufficient Postman and CloudWatch evidence in the
  deployed environment.

EduCloud therefore needs authenticated, idempotent business operations,
course-scoped file storage, repeatable tests, and observable production behavior.

## 3. Objectives and success criteria

| Objective | Measurable acceptance criterion |
| --- | --- |
| Safe enrollment | Only a Student can enroll; the course must exist, be published, and have a published final assessment. Repeating the request returns the existing enrollment, while the database enforces one row per user/course. |
| Consistent progress | Only an enrolled Student can complete a lesson and read course progress. One row is maintained per user/lesson, and the API derives completed count and percentage from database rows. |
| Controlled uploads | Only the course owner or an Admin can upload. Core direct routes validate extension and size; the supporting multipart flow also validates video MIME, course key prefix, part number, and duplicate parts. |
| Supporting large-video extension | The current codebase supports 10 MiB browser-to-S3 multipart upload with complete/abort controls. This is integration context, not one of the seven core assigned endpoints. |
| Repeatable verification | Positive and negative cases for enrollment, progress, upload, authorization, and validation are documented in Postman/test plans; automated tests remain passing. |
| Operational evidence | Deployment checks capture request outcome, error behavior, Elastic Beanstalk health, and relevant CloudWatch events without exposing tokens or secrets. |
| Cost control | The demo uses a small deployment footprint and a cleanup plan for compute, logs, objects, and incomplete multipart uploads. |

The repository already contains supporting implementation evidence in
`backend/app/services/enrollment_service.py`, `progress_service.py`,
`s3_service.py`, the corresponding route/model files, Postman/API artifacts,
and backend tests. The attached matrix separates automated results from manual
Postman and shared-environment AWS checks so each result can be reviewed in its
proper context.

## 4. Scope and responsibility boundary

### 4.1 Whole-team scope

The complete EduCloud product includes Cognito registration and sign-in, user
roles, course and lesson management, protected learning content, assessments,
certificates, reviews, instructor applications, admin functions, frontend pages,
deployment, and shared database models.

### 4.2 Nguyễn Song Minh Luân's individual scope

The assignment brief defines my **core workstream** as API Developer —
Enrollment, Progress, Upload & Testing:

- `POST /api/courses/{course_id}/enroll` and `GET /api/my-courses`;
- `POST /api/lessons/{lesson_id}/complete`;
- `GET /api/courses/{course_id}/progress`;
- `POST /api/upload/course-thumbnail`, `POST /api/upload/lesson-material`, and
  `POST /api/upload/video`;
- Student/enrollment and Instructor-or-Admin/course-ownership authorization for
  those flows;
- input validation, idempotency rules, database uniqueness, and actionable
  errors for those flows;
- Postman verification for the APIs and application-log checks in CloudWatch.

The current team codebase also contains `DELETE` progress undo, remote/deduplicated
thumbnail behavior, multipart start/part/complete/abort routes, and an Admin
CloudWatch-log endpoint. These **supporting extensions** are included in
integration tests but remain separate from the seven original core endpoints.

Other team members' authentication, course/lesson authoring, frontend, database,
and deployment work are dependencies or integration context, not personal
deliverables. I may fix integration defects at the boundary, but will record
  those separately from the core assigned features.

### 4.3 Out of scope

Paid courses, checkout, production-scale multi-region availability, automatic
server-side certificate PDFs, transcoding/DRM, malware scanning, and a complete
enterprise observability platform are outside this internship scope.

## 5. Whole-system AWS architecture

{{< staticimage path="images/architect.jpg" alt="EduCloud AWS architecture" >}}

| Layer | Component and responsibility |
| --- | --- |
| Web delivery | GitHub `main` triggers Amplify Hosting to build and serve the React/Vite single-page application over HTTPS. |
| Identity | Amazon Cognito handles registration, email verification, sign-in, and recovery. FastAPI verifies Cognito identity and issues an EduCloud JWT containing the current PostgreSQL role. |
| Entry and routing | CloudFront delivers course assets from S3 and forwards `/api/*` traffic to the Elastic Beanstalk origin. API responses must not use media-style caching. |
| API compute | FastAPI runs in a Python Elastic Beanstalk single-instance environment backed by EC2 for the low-traffic demonstration. |
| Application data | Supabase PostgreSQL, outside the AWS account boundary and connected over TLS, stores users, courses, lessons, enrollments, progress, assessments, and certificates. |
| Object storage | A private S3 bucket stores objects under `courses/{course_id}/...`. CloudFront Origin Access Control is the read path; presigned `UploadPart` URLs provide temporary write capability for videos. |
| Configuration and access | Systems Manager Parameter Store holds production secrets where configured. IAM roles grant the backend only the S3, CloudWatch, configuration, and read-only cost permissions it needs. |
| Operations | Elastic Beanstalk health, CloudWatch logs, the Admin health view, S3 usage, and Cost Explorer provide deployment evidence and troubleshooting signals. |

The core assigned API flow is: the signed-in browser sends an EduCloud bearer token
to FastAPI; FastAPI authorizes the user against PostgreSQL; enrollment/progress
updates are committed to PostgreSQL, while upload control requests create
course-scoped storage operations. As a supporting codebase extension, the browser
can send video bytes directly to S3 and return each ETag to FastAPI for ordered
multipart completion.

## 6. Security, data integrity, and privacy

- Derive `user_id` and role from the verified token; never accept a target
  student identity from the enrollment/progress request body.
- Enforce Student-only enrollment/progress and course-owner-or-Admin upload on
  the backend, not only by hiding frontend buttons.
- Keep unique constraints on `(user_id, course_id)` and `(user_id, lesson_id)`;
  handle retry and concurrency outcomes without creating duplicate rows.
- Permit enrollment only for a published course with a published assessment.
- Validate upload extensions and limits: 10 MiB thumbnails, 50 MiB materials,
  and 500 MiB videos in the current implementation. Multipart video MIME types
  are limited to MP4, WebM, and QuickTime.
- Restrict keys to `courses/{course_id}/videos/{filename}` before authorizing,
  completing, or aborting a multipart upload. Presigned URLs expire after one
  hour in the current implementation.
- Keep S3 Block Public Access enabled and use CloudFront OAC for reads. Do not
  expose AWS credentials, database URLs, JWT secrets, bearer tokens, or
  presigned query strings in the report or logs.
- Restrict CORS to the deployed frontend and expose S3 `ETag` only as needed for
  multipart completion. Use HTTPS/TLS for every external hop.
- Treat the current browser token storage and in-process rate/traffic metrics as
  prototype limitations; production hardening should use short-lived sessions,
  shared rate limiting, and structured audit logging.

## 7. Testing and monitoring plan

Testing uses three complementary levels:

1. **Automated tests:** verify database-backed enrollment/progress, 50% progress
   for one of two lessons, upload type rejection, multipart part ordering, and
   rejection of a key belonging to another course.
2. **Postman/Swagger:** run happy paths and negative cases with Student,
   Instructor, Admin, missing-token, wrong-role, unpublished-course,
   not-enrolled, invalid-file, oversize-file, and wrong-course-key inputs. Export
   a collection/environment with secrets removed and save response evidence.
3. **Deployed checks:** reproduce selected calls through the public API route,
   verify database/S3 side effects, review Elastic Beanstalk health and the most
   recent CloudWatch stream, and correlate timestamps and status codes. Never
   log full authorization headers or presigned URLs.

The Admin health implementation reports database latency/row counts, local or S3
storage information, process-local request totals, recent 4xx/5xx counts, average
response time, and top routes. These in-memory traffic values reset after a
backend restart, so CloudWatch metrics/logs are required for durable production
history. Monitoring should cover enrollment conflicts, progress authorization
failures, upload 4xx/5xx, S3 errors, latency, EC2/Elastic Beanstalk health,
storage growth, incomplete multipart uploads, and spend.

## 8. Eight-week work plan

The technical schedule covers June 15 through August 14, 2026.

| Week | Dates | Task |
| --- | --- | --- |
| 1 | Jun 15–21 | Review FCAJ requirements, EduCloud workflows, team boundaries, and the seven assigned endpoints. |
| 2 | Jun 22–28 | Define Student and Instructor/Admin authorization rules, success criteria, negative cases, and required evidence. |
| 3 | Jun 29–Jul 5 | Design API contracts, enrollment/progress data constraints, upload validation, and reusable Postman variables. |
| 4 | Jul 6–12 | Align the FastAPI integration baseline, authentication dependency, response conventions, PostgreSQL persistence, and AWS configuration. |
| 5 | Jul 13–19 | Implement and validate course enrollment and My Courses behavior, including duplicate-request handling and Student-only access. |
| 6 | Jul 20–26 | Implement and validate lesson completion, course progress, and authorized thumbnail, material, and video uploads. |
| 7 | Jul 27–31 | Integrate the APIs with shared frontend, authentication, and course components; review automated regression and prepare the scoped Postman collection. |
| 8 | Aug 1–14 | Run Postman and S3/CloudWatch checks, retest defects, complete the documentation, and hand over the report. |

## 9. Cost plan and optimization

No fixed price is presented as an actual bill. AWS prices vary by Region, usage,
and date, so this section focuses on the deployment choices that limit avoidable
cost.

| Cost driver | Planning assumption and control |
| --- | --- |
| Elastic Beanstalk/EC2 | One low-traffic single instance for the demonstration; avoid an unused load balancer or multi-instance fleet; terminate after evaluation if permitted. |
| Amplify | Small SPA with controlled build frequency; monitor build minutes, stored artifacts, and outbound transfer. |
| S3 | Store only required media; use course prefixes, remove replaced objects, and add a lifecycle rule to abort incomplete multipart uploads. |
| CloudFront | Cache versioned media, but do not cache personalized enrollment/progress API responses; monitor requests and data transfer, especially video. |
| Cognito | Demo-scale active users only; monitor usage instead of assuming a perpetual free allowance. |
| CloudWatch | Set deliberate retention and avoid verbose logs containing large payloads or presigned URLs. |
| External database | Track Supabase separately because it is not an AWS charge; retain the smallest plan that satisfies the submission. |

Budget alerts, periodic cost review, an inventory of active resources, and a
documented cleanup order are recommended controls for the shared deployment.

## 10. Risks and mitigation

| Risk | Impact | Mitigation |
| --- | --- | --- |
| Concurrent enrollment requests | Database uniqueness error or duplicate membership | Keep the unique constraint; if a competing request commits first, roll back the failed transaction, reload that enrollment, and return it. |
| Stale or incorrect progress | Wrong resume position or certificate eligibility | Filter by authenticated user and current course lessons; update one user/lesson row; test repeat complete/undo and deletion behavior. |
| Unauthorized upload | Another course's content is overwritten or exposed | Check course ownership/Admin role on every multipart step and validate the full course key prefix. |
| Incomplete multipart upload | Orphaned S3 parts and avoidable cost | Abort on client failure, add S3 lifecycle cleanup, and monitor incomplete uploads. |
| S3 CORS does not expose `ETag` | Browser cannot complete multipart upload | Allow only the deployed origin/methods/headers and expose `ETag`; verify with a real browser request. |
| Presigned URL leakage | Temporary unauthorized write access | Use short expiry, redact query strings, never store URLs in logs, and issue URLs only after authorization. |
| Process-local monitoring resets | Missing history after restart or scale-out | Use CloudWatch for durable logs/metrics and treat the Admin traffic snapshot as a demo aid. |
| Cloud cost growth | Credits are consumed after testing | Use budgets, retention/lifecycle rules, scheduled review, and a final cleanup checklist. |

## 11. Deliverables and future work

The planned personal deliverables are the seven core API routes and their
service/data rules, updated API contract/Postman artifacts, automated and manual
test evidence, CloudWatch validation notes, and the corresponding proposal,
worklog, and three published technical articles. Multipart, progress undo,
thumbnail import, and the Admin log-reader are documented as supporting
extensions around the core assigned endpoints.

After the internship, the most valuable extensions are concurrent load testing
for enrollment/progress, Alembic migrations,
resumable multipart sessions stored server-side, checksums and malware scanning,
automatic incomplete-upload lifecycle rules, structured correlation IDs,
CloudWatch alarms/dashboards, distributed rate limiting, and production-scale
load/security testing.
