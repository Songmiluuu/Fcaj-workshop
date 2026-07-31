---
title: "Week 1 - Requirements and scope review"
menuTitle: "Week 1"
weight: 1
pre: "<b>1.1.</b>"
---

# Week 1 - Requirements and scope review

**Work period:** June 15–21, 2026

## Task

Review FCAJ requirements, EduCloud workflows, team boundaries, and the seven
assigned endpoints.

## Work completed

- Reviewed the internship report structure and the expected technical scope.
- Traced the Student flow from enrollment to My Courses, lesson completion, and
  course progress.
- Traced the Instructor upload flow for course thumbnails, lesson materials,
  and videos.
- Identified dependencies on authentication, course publishing, lesson data,
  assessments, PostgreSQL, S3, and CloudWatch.
- Separated the seven assigned endpoints from supporting functions already used
  by the shared application.

## Result

The workstream was limited to Enrollment, Progress, Upload, API regression, and
application-log checks. Authentication, course authoring, assessments,
certificates, frontend structure, and AWS deployment remain shared integration
dependencies.

## Technical references

- `EduCloud/api/api-contract.md`
- `EduCloud/backend/app/routes/enrollment_routes.py`
- `EduCloud/backend/app/routes/progress_routes.py`
- `EduCloud/backend/app/routes/upload_routes.py`
