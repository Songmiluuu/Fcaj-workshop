---
title: "Week 7 - Progress and basic upload APIs"
menuTitle: "Week 7"
weight: 7
pre: "<b>1.7.</b>"
---

**Period:** July 13, 2026 - July 19, 2026  
**Status on July 30:** Codebase target present; personal attribution requires confirmation

> **Attribution basis:** this page reconstructs intended work from the assignment
> and supplied code. The referenced source proves current behavior, not who
> authored it. DELETE/uncomplete and thumbnail deduplication are supporting
> extensions, not part of the seven core endpoints shown in the assignment.

## Objectives

- Implement lesson complete and course-progress APIs.
- Document lesson uncomplete separately as a supporting codebase extension.
- Implement validated thumbnail, lesson-material, and direct-video uploads.
- Keep local development usable while preserving an S3 deployment path.

## Planned core implementation and current codebase behavior

### Progress APIs (core plus supporting extension)

| Endpoint | Current codebase behavior |
| --- | --- |
| **POST /api/lessons/{lesson_id}/complete** | Creates or updates the learner’s Progress row as completed and checks certificate eligibility. |
| **DELETE /api/lessons/{lesson_id}/complete** | Marks the row incomplete, except after a certificate has been issued. |
| **GET /api/courses/{course_id}/progress** | Returns completed_lessons, total_lessons, rounded percentage, and completed_lesson_ids. |

All three operations require the Student role. Complete and uncomplete check
Enrollment in the lesson's course; GET progress checks Enrollment in the
requested course.

### Basic upload APIs

| Upload | Accepted files | Limit |
| --- | --- | --- |
| Course thumbnail | .jpg, .jpeg, .png, .webp | 10 MiB |
| Lesson material | .pdf, .doc, .docx, .ppt, .pptx, .txt, .zip | 50 MiB |
| Direct lesson video | .mp4, .webm, .mov | 500 MiB |

The upload routes authorize the course owner or Admin. save_upload writes
under a course-scoped path and selects local or S3 storage through
UPLOAD_STORAGE. Thumbnail names are content-addressed so the same image can be
reused instead of generating duplicate objects.

## Expected deliverables

- Core complete/read-progress routes and service logic; optional uncomplete
  support is recorded separately as a codebase extension.
- Validated course-thumbnail, material, and direct-video upload endpoints.
- Local storage fallback with a response containing URL, filename,
  content_type, size, and storage mode.
- Initial Postman requests for enrollment and uploads.

## Verification criteria

| Scenario | Expected result | Current evidence |
| --- | --- | --- |
| Enrolled Student completes one of two lessons | completed_lessons = 1 and percentage = 50 | Automated assertion |
| Student is not enrolled | HTTP 403 | Explicit service guard |
| Completed course already has a certificate | Uncomplete returns HTTP 409 | Explicit conflict guard |
| Material uses .exe | HTTP 415 | Automated API test |
| Identical thumbnail is uploaded twice | Same URL and one stored image | Automated API test |
| Manual Postman execution | Actual response and status recorded | Not yet completed |

## Repository evidence

- EduCloud/backend/app/routes/progress_routes.py
- EduCloud/backend/app/services/progress_service.py
- EduCloud/backend/app/routes/upload_routes.py
- EduCloud/backend/app/services/s3_service.py
- EduCloud/backend/tests/test_enrollment_progress.py
- EduCloud/backend/tests/test_course_lesson_api.py
- EduCloud/api/postman/EduCloud.postman_collection.json
