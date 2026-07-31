---
title: "Cleanup and Handover"
menuTitle: "Cleanup & handover"
weight: 9
pre: "<b>5.9.</b>"
---

# Cleanup and handover

Each test run ends with a cleanup check. Never delete a shared team resource
without the owner and team confirming the exact target.

## Before cleanup

- Export the Postman Runner result with local tokens removed.
- Save redacted S3/CloudWatch screenshots.
- Record the AWS account alias, Region, resource purpose, and owner privately.
- Confirm which resources are personal sandbox resources and which belong to the
  shared EduCloud demo.
- Keep the source commit/test command associated with the evidence.

## Application data

Use application APIs or a controlled database script to remove only uniquely
named test courses/users. Check dependent enrollment, progress, assessment, and
certificate records. Do not run broad SQL deletes against shared data.

## S3 multipart and objects

1. Abort every upload deliberately left incomplete.
2. Check the bucket's **Multipart uploads** view or list uploads with AWS CLI.
3. Delete only the dedicated test prefix after validating its absolute bucket/key.
4. Confirm lifecycle rules abort stale multipart uploads.
5. Invalidate CloudFront only if the test replaced a cached shared path.

Example read-only inventory:

```powershell
aws s3api list-multipart-uploads `
  --bucket YOUR_TEST_BUCKET `
  --region YOUR_REGION
```

Do not paste the output into the public report if it contains account-specific
names or upload IDs.

## AWS resources

For a **personal sandbox deployment**, remove resources in dependency-aware order:

1. test objects and incomplete multipart uploads;
2. CloudFront distribution/OAC after it is disabled;
3. S3 bucket after it is empty;
4. Elastic Beanstalk environment/application and generated EC2 resources;
5. Amplify test application;
6. Cognito test users/client/pool;
7. Parameter Store test parameters;
8. CloudWatch alarms, dashboards, and test log groups after evidence export; and
9. budget/test IAM policies no longer needed.

For the **shared team demo**, leave resources running and hand the cleanup checklist
to the resource owner instead.

## Troubleshooting guide

| Symptom | Check |
|---|---|
| Enrollment returns 409 | Course status and published final assessment |
| Progress returns 403 | Student role, token user, and enrollment for the lesson's course |
| Upload returns 403 | Course ID and Instructor ownership |
| Upload returns 413/415 | Category size, extension, and video MIME type |
| Multipart part returns 400 | Exact `courses/{course_id}/videos/` key prefix |
| Complete fails in S3 | Uploaded part numbers/ETags, duplicate parts, IAM permission |
| Media URL returns 403 | Private bucket/OAC policy, CloudFront origin/path, object key |
| CloudWatch page is empty | Monitoring flag, exact log group, Region, EB log streaming, 24-hour window |
| Frontend result differs from Postman | Base URL, JWT, CORS, cached client state |

## Final handover package

- Hugo report source and GitHub Pages workflow.
- Bilingual ten-week worklog, proposal, workshop,
  self-evaluation, and feedback.
- Scoped Postman collection, OpenAPI snapshot, and test matrix.
- `pytest` command/result for the submitted source revision.
- Sanitized Postman/S3/CloudWatch results and relevant configuration figures.
- Three real public blog URLs and verified event evidence.
- Known limitations, owner list, cost/cleanup status, and next actions.

A handover is complete only when another reader can reproduce the API checks
without receiving a private token, password, or access key.
