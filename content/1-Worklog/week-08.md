---
title: "Week 8 - Frontend integration and automated regression"
menuTitle: "Week 8"
weight: 8
pre: "<b>1.8.</b>"
---

**Period:** July 20, 2026 - July 26, 2026  
**Status on July 30:** Codebase target present; personal attribution requires confirmation

> **Attribution basis:** integration behavior is verified in the supplied tree,
> but repository metadata does not by itself prove personal authorship.

## Objectives

- Connect the core assigned APIs to the learner and instructor interfaces.
- Verify database-backed workflows with automated regression tests.
- Audit the Postman collection before final end-to-end execution.

## Planned activities and current codebase evidence

| Activity | Verified result |
| --- | --- |
| Plan/review course enrollment at the course-detail action. | The current frontend calls enrollCourse and reports API errors to the learner. |
| Plan/review My Courses on the Student dashboard. | Current counters and per-course percentages use the typed API response. |
| Plan/review progress integration on the learning page. | The current page loads completed_lesson_ids and calls POST/DELETE when completion changes; DELETE is an extension. |
| Plan/review upload services in course authoring. | Current thumbnail and lesson assets use FormData without forcing an incorrect JSON content type. |
| Review backend regression coverage. | Current tests cover database-backed enrollment/progress, upload rejection, supporting thumbnail behavior, and authorization. |
| Audit the legacy team-repository Postman collection against the API contract. | It lacks complete My Courses, Progress, multipart-video, and CloudWatch coverage; the corrected report-scoped collection is now JSON-valid but has not been executed. |

## Expected deliverables

- Typed frontend clients for enrollment, progress, and upload responses.
- Integrated learner enrollment/progress workflow.
- Automated regression coverage for the principal data and upload rules.
- A documented Postman gap list carried into Weeks 9–10.

## Verification criteria

| Criterion | Result |
| --- | --- |
| Frontend endpoint paths match backend routes. | Met by source review |
| Progress UI derives its state from completed_lesson_ids returned by the API. | Met |
| FormData uploads allow the browser to set the multipart boundary. | Met in apiClient.ts |
| Database-backed enrollment/progress workflow passes automated regression. | Met in the July 30 targeted run |
| Postman collection covers every assigned endpoint and has recorded results. | Not met; scheduled for final verification |

## Repository evidence

- EduCloud/frontend/src/services/apiClient.ts
- EduCloud/frontend/src/services/enrollmentService.ts
- EduCloud/frontend/src/services/progressService.ts
- EduCloud/frontend/src/services/uploadService.ts
- EduCloud/frontend/src/pages/LearningPage.tsx
- EduCloud/frontend/src/pages/MyLearningPage.tsx
- EduCloud/backend/tests/test_enrollment_progress.py
- EduCloud/backend/tests/test_course_lesson_api.py
- EduCloud/api/postman/EduCloud.postman_collection.json
