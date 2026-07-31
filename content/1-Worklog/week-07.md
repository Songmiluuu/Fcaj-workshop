---
title: "Week 7 - Integration and regression"
menuTitle: "Week 7"
weight: 7
pre: "<b>1.7.</b>"
---

# Week 7 - Integration and regression

**Work period:** July 20–24, 2026

## Task

Integrate the APIs with shared frontend, authentication, and course components;
review automated regression and prepare the scoped Postman collection.

## Integration work

- Connected enrollment results to the learner dashboard.
- Connected completion and progress responses to course learning state.
- Connected Instructor uploads to course ownership and media fields.
- Reused the shared login flow and role information for all assigned routes.
- Reviewed multipart video and Admin log-reader behavior as supporting
  integration paths.

## Regression

Seven selected tests covering enrollment, progress, upload validation,
multipart controls, and CloudWatch behavior passed **7/7** on July 30. The full
backend suite passed **28/28** on July 31 in an isolated environment using the
repository dependency versions, including two concurrent-enrollment regression tests.

The scoped Postman collection contains the assigned API flow, role-specific
variables, response assertions, multipart requests, and the Admin CloudWatch
request.

## Result

The assigned APIs were connected to shared application components and checked
against automated regression. The Postman collection was prepared for the
final local and AWS runs.

## Technical references

- `EduCloud/frontend/src/services/enrollmentService.ts`
- `EduCloud/frontend/src/services/progressService.ts`
- `EduCloud/frontend/src/services/uploadService.ts`
- `nopbai/static/files/EduCloud-API-Testing.postman_collection.json`
- `nopbai/static/files/targeted-pytest-result.txt`
- `nopbai/static/files/full-pytest-result.txt`
