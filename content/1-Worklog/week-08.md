---
title: "Week 8 - Validation and handover"
menuTitle: "Week 8"
weight: 8
pre: "<b>1.8.</b>"
---

# Week 8 - Validation and handover

**Work period:** August 1–14, 2026

## Task

Run Postman and S3/CloudWatch checks, retest defects, complete the
documentation, and hand over the report.

## Validation sequence

1. Run enrollment and My Courses with valid, repeated, unauthenticated, and
   wrong-role requests.
2. Run lesson completion and progress with enrolled and non-enrolled Students.
3. Test valid and invalid thumbnail, material, and video uploads.
4. Complete and abort separate multipart uploads, then check S3 cleanup.
5. Send one successful request and one controlled validation error.
6. Match request time, route, and status with CloudWatch events.
7. Retest failed cases after each defect is corrected.

## Handover package

- Postman collection without tokens or private environment values.
- API test results with final status and defect notes.
- OpenAPI snapshot and API contract.
- Automated test outputs for the submitted source revision.
- Worklog, proposal, workshop, self-assessment, and feedback in English and
  Vietnamese.
- Known limitations, cleanup status, and operating notes.

## Completion record

- Completed the scoped positive and negative Postman cases.
- Checked direct and multipart upload behavior in the shared S3 environment,
  including complete, abort, authorization, and validation paths.
- Matched controlled API activity with application events in CloudWatch.
- Kept tokens, resource identifiers, presigned URLs, and raw log payloads out of
  the public handover files.

## Security check

Published files must not contain bearer tokens, passwords, database URLs, AWS
keys, account identifiers, private bucket names, presigned query strings, or
unredacted user data.
