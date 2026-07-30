---
title: "Self-evaluation"
weight: 6
chapter: false
pre: "<b>6.</b>"
---

# Self-evaluation

> **Assessment date: July 30, 2026.** My internship runs from June 1 to
> August 15, 2026, so this is an interim self-evaluation rather than a claim of
> final completion.

## Scope of this assessment

**EduCloud is a team system.** It contains authentication, course and lesson
management, assessments, certificates, administration, and deployment work
owned across the team. I do not claim all of those features as my individual
contribution.

My assignment brief defines the following **core Enrollment, Progress, Upload,
and Testing API** work:

- `POST /api/courses/{course_id}/enroll` and `GET /api/my-courses`;
- `POST /api/lessons/{lesson_id}/complete` and
  `GET /api/courses/{course_id}/progress`;
- authorized thumbnail, lesson-material, and direct-video upload flows; and
- Postman API regression plus verification of application logs in Amazon
  CloudWatch.

The team codebase also includes progress undo, thumbnail import/deduplication,
multipart-video controls, and an Admin log-reader. I evaluate these as
**supporting extensions**, not original core assignments, unless mentor/PR
evidence confirms otherwise.

The repository contains routes, services, data constraints, frontend
integration, and automated tests relevant to this workstream. Seven selected test nodes
relevant to enrollment, progress, upload, and CloudWatch behavior passed
**7/7**, and the full backend suite passed **26/26 tests** in
an isolated environment using the repository's pinned dependencies. However,
the legacy repository manual test-case file still records
`Not Started`, and live Postman Runner, real Amazon S3, and real CloudWatch
evidence has not yet been captured. Those items remain part of the final phase.

{{% notice warning %}}
These ratings are a provisional self-assessment template. The supplied Git
history does not independently attribute the cited implementation to Luân, so
the final version must be supported by his PR/commit/task evidence or mentor
confirmation. Automated test results confirm current code behavior only.
{{% /notice %}}

## Required evaluation criteria

The ratings below use the three levels required by the internship report:
**Good**, **Fair**, and **Average**.

| No. | Criterion | Rating | Evidence-based comment |
| ---: | --- | :---: | --- |
| 1 | **Professional knowledge and skills** | **Fair** | The report connects the core endpoints to FastAPI routing, service separation, SQLAlchemy constraints, role/ownership checks, progress calculation, and file validation. Personal implementation and live AWS acceptance still need evidence. |
| 2 | **Ability to learn** | **Fair** | The workstream review covers direct uploads, supporting multipart behavior, and controlled S3/CloudWatch tests before live verification. Mentor or task evidence is needed to substantiate the learning timeline. |
| 3 | **Proactiveness** | **Fair** | The report turns the assigned endpoint list into data rules, positive/negative cases, a corrected Postman artifact, automated checks, and a gap list; execution and attribution remain incomplete. |
| 4 | **Discipline** | **Fair** | The current report keeps source, API contracts, worklogs, and test status aligned and does not label unexecuted checks as passed. Luân still needs to complete every manual result and organize final evidence before August 15. |
| 5 | **Communication** | **Fair** | The API contract, bilingual notes, endpoint ownership, and pending issues are documented for handover. The repository alone does not demonstrate enough regular team communication to justify a Good rating; concise progress and defect updates should be made more consistently. |
| 6 | **Teamwork** | **Fair** | The APIs in my assigned workstream integrate with authentication, course, lesson, frontend, and AWS work owned elsewhere in the team. The interfaces are documented, but the final cross-role end-to-end run and handover evidence are not complete yet. |
| 7 | **Problem solving** | **Fair** | The code and test review covers duplicate enrollment/progress, non-enrolled access, course ownership, invalid extensions, supporting multipart ordering/key checks, and safe CloudWatch errors. Personal resolution evidence is still required. |
| 8 | **Contribution to the project** | **Fair** | The intended contribution is the seven-endpoint API/testing slice. The codebase and local tests show the slice exists, but final attribution and live acceptance evidence are still pending. |

## Strengths

- The reviewed codebase derives enrollment and progress results on the server and
  protects them with authorization and database uniqueness rules rather than
  trusting client state.
- The report's test plan considers success and failure paths, including retries,
  duplicate requests, unauthorized access, invalid uploads, and abandoned
  multipart uploads.
- Confirmed code/test behavior is separated from planned or live-AWS evidence so
  the report remains auditable.

## Areas for improvement

- Execute the corrected report-scoped Postman collection for My Courses,
  progress, multipart upload, and Admin CloudWatch; then record actual status,
  response, and defect results for every case.
- Validate thumbnail, material, direct-video, and multipart-video uploads against
  the configured private S3 environment and capture sanitized evidence.
- Correlate controlled successful and failed API requests with the intended
  CloudWatch log group without exposing tokens, credentials, or presigned query
  strings.
- Make progress, interface changes, blockers, and regression results more visible
  to the team through short, regular handover updates.

## Interim overall assessment

A provisional **Fair (Khá) rating at this checkpoint** is supportable for the
documented report work. The supplied codebase contains the core implementation,
and the targeted automated regression demonstrates its authorization, data
integrity, and error handling; those facts do not yet prove Luân's authorship. A
final **Good** assessment would require attribution evidence, the remaining
Postman matrix, live S3/CloudWatch validation, defect retesting, and complete
handover evidence before the internship ends.
