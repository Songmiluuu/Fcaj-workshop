---
title: "Week 3 - API, data, and test design"
menuTitle: "Week 3"
weight: 3
pre: "<b>1.3.</b>"
---

**Period:** June 15, 2026 - June 21, 2026  
**Status on July 30:** Reconstructed plan; report artifacts prepared, manual cases unexecuted

## Objectives

- Define route, service, model, and response responsibilities for the assigned
  APIs.
- Design a repeatable end-to-end learner flow for later Postman testing.
- Prepare test data and variables without embedding secrets.

## Planned activities and report artifacts

| Activity | Result |
| --- | --- |
| Mapped the API flow from FastAPI route to business service and SQLAlchemy model. | Enrollment and progress logic could be implemented separately from HTTP response formatting. |
| Defined the Enrollment key as user + course and the Progress key as user + lesson. | Duplicate requests have an explicit idempotency strategy. |
| Designed the learner test sequence: authenticate → select published course → enroll → list My Courses → complete lesson → read progress. | Established ordering and prerequisite data for API verification. |
| Designed the upload test sequence for thumbnail, material, and video. | Identified required multipart fields, allowed types, size boundaries, and course-owner authorization. |
| Reviewed the Postman collection structure and test-case template. | Defined base_url, token, course_id, and lesson_id as variables; kept execution status separate from design status. |

## Deliverables

- Endpoint-to-layer map for Enrollment, Progress, Upload, and CloudWatch.
- A reusable learner-flow test sequence and upload test-data checklist.
- Test cases **TC-007 through TC-011** for enrollment, completion, progress,
  upload, and CloudWatch checking.
- Standard result fields: input, expected result, actual result, status, and
  note.

## Test criteria

| Check | Result |
| --- | --- |
| The API contract lists all core assigned endpoint groups. | Met as a report artifact |
| The test plan contains an explicit case for each assigned feature family. | Met |
| The Postman collection is valid JSON and defines reusable environment variables. | Met |
| Manual tests are marked Passed only after execution evidence exists. | Met as a process rule; all checklist rows are still Not Started |

## Repository evidence

- EduCloud/api/api-contract.md
- EduCloud/api/postman/EduCloud.postman_collection.json
- EduCloud/api/test-plan/test-cases.md
- EduCloud/api/test-plan/test-report-template.md
- EduCloud/backend/app/schemas/enrollment_schema.py
- EduCloud/backend/app/schemas/progress_schema.py
