---
title: "Week 10 - Full regression, live checks, and handover"
menuTitle: "Week 10"
weight: 10
pre: "<b>1.10.</b>"
---

**Period:** August 3, 2026 - August 15, 2026  
**Status on July 30:** Planned future work; no completion is claimed

## Objectives

- Execute the complete API regression in Postman and record actual results.
- Verify uploads against the configured S3/CloudFront environment.
- Correlate controlled API activity with CloudWatch logs.
- Close defects, sanitize evidence, and hand over the assigned APIs and report.

## Planned schedule

| Dates | Planned activity | Expected output |
| --- | --- | --- |
| Aug 03 - Aug 04 | Complete Postman requests for My Courses, complete/uncomplete, course progress, multipart video, and Admin CloudWatch logs; add reusable authentication handling. | Importable collection with no hard-coded secret |
| Aug 05 - Aug 07 | Execute TC-001–TC-011 plus assigned negative/boundary cases against the local API. | Actual response, HTTP status, Passed/Failed result, and defect note for every row |
| Aug 08 - Aug 10 | Test thumbnail, PDF/material, direct fallback, and multipart video with the authorized Instructor/Admin account in the AWS environment. | S3 object path/URL, size/type evidence, and rejected unauthorized/invalid cases |
| Aug 11 - Aug 12 | Send controlled successful and safe error requests, then query the Admin log API and compare timestamp, route, and status with CloudWatch. | Sanitized log-group/event evidence |
| Aug 13 - Aug 14 | Fix in-scope defects, re-run failed Postman cases and the targeted pytest suite. | Zero unresolved critical defect in the assigned scope |
| Aug 15 | Finalize worklog, test report, screenshots, known limitations, and handover notes. | Submission-ready evidence package |

## Required test coverage

### Enrollment and progress

- Successful enroll, repeated enroll, role rejection, missing/unpublished course,
  and course without a published assessment.
- My Courses totals and per-course percentage.
- Complete, repeat complete, uncomplete, non-enrolled rejection, and certificate
  lock.

### Upload

- Valid image, PDF/material, and video.
- Unsupported extension, oversize file, non-owner, invalid multipart key,
  duplicate part number, upload failure/abort, and successful completion.
- Confirm the returned object belongs to the selected course prefix and is
  accessible only through the intended delivery configuration.

### CloudWatch and regression

- Admin success, non-Admin HTTP 403, monitoring disabled, invalid/missing log
  group, and recent-event ordering.
- Re-run automated tests after manual defects are corrected.

## Exit criteria

| Criterion | Required evidence |
| --- | --- |
| Every assigned endpoint exists in the Postman collection. | Exported collection with variables and scripts |
| Every planned manual case has an actual result and final status. | Completed test report; no row left Not Started |
| S3 upload works with real configured resources. | Sanitized object metadata/path and API response |
| Application activity appears in the intended CloudWatch log group. | Timestamped event with sensitive values removed |
| Targeted automated suite remains green. | Final command output |
| Evidence contains no JWT, password, AWS key, presigned query string, or private personal data. | Final evidence review |

## Existing and planned evidence paths

- Existing collection: EduCloud/api/postman/EduCloud.postman_collection.json
- Existing checklist: EduCloud/api/test-plan/test-cases.md
- Report starting point: EduCloud/api/test-plan/test-report-template.md
- AWS procedure reference: EduCloud/docs/EduCloud-Build-Deployment-Guide.md
- Planned outputs: completed test report and sanitized S3/CloudWatch screenshots
  attached to the internship report
