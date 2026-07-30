---
title: "Security and Reliability"
menuTitle: "Security & reliability"
weight: 7
pre: "<b>5.7.</b>"
---

# Security and reliability

## Authorization matrix

| Operation | Student | Course owner Instructor | Other Instructor | Admin |
|---|:---:|:---:|:---:|:---:|
| Enroll / My Courses | Allow | Deny | Deny | Deny |
| Complete/read own progress | Allow after enrollment | Deny | Deny | Deny |
| Upload to owned course | Deny | Allow | Deny | Allow |
| Read logs through supporting Admin API | Deny | Deny | Deny | Allow |

The backend derives user ID and role from the authenticated context. It never
accepts a target user ID or role from enrollment/progress request bodies.

## Defense in depth

1. **Identity:** validate the upstream Cognito token and issue/use the current
   EduCloud JWT.
2. **Application role:** require Student for learning state and Admin for monitoring.
3. **Resource ownership:** require course owner or Admin for uploads.
4. **State validation:** require published course and assessment before enrollment.
5. **Database constraints:** prevent duplicate enrollment/progress rows.
6. **Object-key boundary:** require `courses/{course_id}/videos/`.
7. **Input limits:** direct uploads validate extension and size; the supporting
   multipart flow also validates MIME, part number, key scope, and ETag.
8. **Private storage:** keep S3 Block Public Access enabled and deliver through a
   controlled CloudFront origin.
9. **Secret isolation:** store production secrets outside Git/frontend/report.
10. **Redacted logging:** record operational context without bearer tokens,
    passwords, presigned URLs, or personal data.

## Least-privilege IAM intent

The Elastic Beanstalk instance role should be limited to the selected bucket and
log group. Its exact policy depends on deployment, but the resource scope should
look like:

```text
S3 bucket: arn:aws:s3:::YOUR_BUCKET
S3 objects: arn:aws:s3:::YOUR_BUCKET/courses/*
CloudWatch Logs: the specific Elastic Beanstalk application log group
```

Multipart operations need create/upload-part/complete/abort capabilities; normal
uploads need object write, and cleanup needs object delete. CloudWatch write
permissions for the runtime and read permissions for the Admin viewer should not
be granted to browser users.

## Threat and failure review

| Risk | Control in the supplied code | Verification still required |
|---|---|---|
| Student reads/changes another user's progress | User ID from token + enrollment query | Negative Postman run |
| Instructor uploads into another course | Owner/Admin guard | Other-Instructor test |
| Path substitution deletes another object | Course-prefix check before key/delete | Cross-course test |
| Duplicate enroll/progress requests | Query/update + unique indexes | Concurrent/retry test |
| Unsupported extension or oversized direct file | Extension/size validation | `.exe` automated check; 413 manual fixture |
| Invalid multipart video MIME | Multipart MIME allowlist | Manual/Postman 415 case pending |
| Large upload loses one part | Three retries + abort path | Network-failure S3 run |
| Presigned URL leaks | One-hour TTL | Screenshot/log redaction |
| S3 becomes public | Private bucket/OAC design | Console/policy evidence |
| Application error is invisible | CloudWatch log integration | EB streaming + log event evidence |
| Test resources create cost | Budget, lifecycle, cleanup | Cost/cleanup checklist |

## Important limitation

Setting `AWS_CLOUDWATCH_LOG_GROUP` only lets the application read a configured
group. It does not by itself enable Elastic Beanstalk log streaming. Likewise,
code-level S3 checks do not prove bucket policy, CloudFront OAC, CORS, encryption,
or lifecycle rules. Those are infrastructure acceptance checks, not assumptions.
