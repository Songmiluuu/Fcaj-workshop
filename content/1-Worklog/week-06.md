---
title: "Week 6 - Progress and uploads"
menuTitle: "Week 6"
weight: 6
pre: "<b>1.6.</b>"
---

# Week 6 - Progress and uploads

**Work period:** July 13–17, 2026

## Task

Implement and validate lesson completion, course progress, and authorized
thumbnail, material, and video uploads.

## Progress

- `POST /api/lessons/{lesson_id}/complete` records one completion for the
  authenticated Student.
- `GET /api/courses/{course_id}/progress` calculates the percentage from
  completed lessons and the course lesson count.
- Repeated completion remains safe because the user-lesson pair is unique.
- Requests for a course without enrollment are rejected.

## Upload

| Category | Accepted files | Limit |
|---|---|---:|
| Thumbnail | JPG, JPEG, PNG, WebP | 10 MiB |
| Material | PDF, DOC, DOCX, PPT, PPTX, TXT, ZIP | 50 MiB |
| Video | MP4, WebM, MOV | 500 MiB |

Each upload verifies the course owner or Admin role before reading the file.
Object keys stay under `courses/{course_id}/` so storage and cleanup remain
course-scoped.

## Result

Progress data is derived on the server and protected against duplicate rows.
Upload routes enforce role, ownership, file type, size, and object-prefix rules
before local or S3 storage is selected.

## Technical references

- `EduCloud/backend/app/routes/progress_routes.py`
- `EduCloud/backend/app/services/progress_service.py`
- `EduCloud/backend/app/routes/upload_routes.py`
- `EduCloud/backend/app/services/s3_service.py`
