---
title: "Worklog"
weight: 1
chapter: false
pre: "<b>1.</b>"
---

This worklog is a **reconstructed ten-period execution plan** for the EduCloud
responsibilities assigned to **Nguyễn Song Minh Luân**: enrollment APIs,
learning-progress APIs, uploads to Amazon S3, API testing with Postman, and
application-log checks in Amazon CloudWatch. The periods cover the official
internship from **June 1, 2026 through August 15, 2026**; the final period is a
13-day validation and handover phase rather than a seven-day calendar week.

{{% notice warning %}}
The assignment brief establishes Luân's workstream, while the supplied Git
history does not independently identify him as an author of the cited lines.
Therefore, “present in the codebase” proves system behavior only. Before final
submission, align the dates/statuses with Luân's actual activity and attach PR,
commit, task-board, or mentor confirmation for personal attribution.
{{% /notice %}}

## Status basis

The status below is frozen on **July 30, 2026**. “Codebase target present” means
the behavior can be traced to the supplied EduCloud tree; it does not assign
authorship. Period 9 is the current plan phase, and Period 10 is future work.
Seven selected test nodes relevant to the
assigned areas passed **7/7**; the full suite passed **26/26 tests** in an
isolated environment using pinned dependencies. The manual checklist in
EduCloud/api/test-plan/test-cases.md is still marked **Not Started**, so this
worklog does not claim that the complete Postman run or a live AWS
S3/CloudWatch verification has already been finished.

| Period | Dates | Main focus | Status on Jul 30 | Main output |
| --- | --- | --- | --- | --- |
| [Week 1](week-01/) | Jun 01 - Jun 07 | Onboarding and assigned-scope analysis | Plan reconstructed | Role scope and evidence checklist |
| [Week 2](week-02/) | Jun 08 - Jun 14 | Requirements and acceptance criteria | Plan reconstructed | Positive and negative API scenarios |
| [Week 3](week-03/) | Jun 15 - Jun 21 | API, data, and test design | Plan reconstructed | Endpoint flow, data constraints, test structure |
| [Week 4](week-04/) | Jun 22 - Jun 28 | Enrollment/progress data foundation | Codebase target present; attribution pending | Enrollment and Progress models with uniqueness rules |
| [Week 5](week-05/) | Jun 29 - Jul 05 | FastAPI integration baseline | Codebase target present; attribution pending | Router registration, configuration, response conventions |
| [Week 6](week-06/) | Jul 06 - Jul 12 | Enrollment and My Courses APIs | Codebase target present; attribution pending | Enroll flow and student learning dashboard |
| [Week 7](week-07/) | Jul 13 - Jul 19 | Progress and basic upload APIs | Codebase target present; attribution pending | Complete/progress flow and validated uploads |
| [Week 8](week-08/) | Jul 20 - Jul 26 | Frontend integration and automated regression | Codebase target present; attribution pending | Service integration and test-backed hardening |
| [Week 9](week-09/) | Jul 27 - Aug 02 | Supporting extensions, CloudWatch, and verification | Current plan phase; live evidence pending | Multipart/log-viewer code reviewed; local tests passed |
| [Week 10](week-10/) | Aug 03 - Aug 15 | Full regression, live checks, and handover | Planned | Final Postman report, AWS evidence, defect retest, report package |

## Seven core assigned endpoints

- Enrollment: **POST /api/courses/{course_id}/enroll** and **GET
  /api/my-courses**.
- Progress: **POST /api/lessons/{lesson_id}/complete** and **GET
  /api/courses/{course_id}/progress**.
- Upload: **POST /api/upload/course-thumbnail**, **POST
  /api/upload/lesson-material**, and **POST /api/upload/video**.
- Verification: execute the Postman API test matrix and check application logs
  in CloudWatch
  without storing JWTs, AWS keys, or other secrets in evidence.

## Supporting codebase extensions

- `DELETE /api/lessons/{lesson_id}/complete` for undo.
- Remote/deduplicated thumbnail behavior.
- Multipart video start/part/complete/abort.
- Admin-only `GET /api/admin/cloudwatch-logs` reader.

These extensions are integration/test context unless Luân has mentor/PR evidence
that they are part of his personal implementation.

## Evidence convention

Evidence links in these pages are repository-relative paths under
**EduCloud/**. They point to local source, contracts, tests, or templates and
do not rely on another student's identity or workshop links.
