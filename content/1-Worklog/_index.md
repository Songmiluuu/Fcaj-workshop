---
title: "Worklog"
menuTitle: "Worklog"
weight: 1
chapter: false
pre: "<b>1.</b>"
---

# Worklog

The worklog contains ten recorded periods from **June 5 to August 14, 2026**.
The assigned scope includes seven core Enrollment, Progress, and Upload
endpoints, Postman regression, Amazon S3 verification, and CloudWatch log
checks.

| Week | Task | Work period |
|---|---|---|
| [Week 1](week-01/) | Review FCAJ requirements, EduCloud workflows, team boundaries, and the seven assigned endpoints. | 05–12 Jun |
| [Week 2](week-02/) | Define Student and Instructor/Admin authorization rules, success criteria, negative cases, and required evidence. | 15–19 Jun |
| [Week 3](week-03/) | Design API contracts, enrollment/progress data constraints, upload validation, and reusable Postman variables. | 22–26 Jun |
| [Week 4](week-04/) | Align the FastAPI integration baseline, authentication dependency, response conventions, PostgreSQL persistence, and AWS configuration. | 29 Jun–03 Jul |
| [Week 5](week-05/) | Implement and validate course enrollment and My Courses behavior, including duplicate-request handling and Student-only access. | 06–10 Jul |
| [Week 6](week-06/) | Implement and validate lesson completion, course progress, and authorized thumbnail, material, and video uploads. | 13–17 Jul |
| [Week 7](week-07/) | Integrate the APIs with shared frontend, authentication, and course components; review automated regression and prepare the scoped Postman collection. | 20–24 Jul |
| [Week 8](week-08/) | Run Postman and S3/CloudWatch checks, retest defects, complete the documentation, and hand over the report. | 27–31 Jul |
| [Week 9](week-09/) | Review EduCloud operations, security controls, AWS logging, and Well-Architected practices. | 03–07 Aug |
| [Week 10](week-10/) | Consolidate Generative AI, Agentic AI, and AWS learning; complete the final summary and development roadmap. | 10–14 Aug |

## Assigned API scope

- `POST /api/courses/{course_id}/enroll`
- `GET /api/my-courses`
- `POST /api/lessons/{lesson_id}/complete`
- `GET /api/courses/{course_id}/progress`
- `POST /api/upload/course-thumbnail`
- `POST /api/upload/lesson-material`
- `POST /api/upload/video`

Multipart video controls, progress undo, remote thumbnail handling, and the
Admin CloudWatch reader support integration and testing around the core scope.
