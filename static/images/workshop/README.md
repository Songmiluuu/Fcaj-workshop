# API workshop evidence checklist

Only add evidence captured by Nguyễn Song Minh Luân. Suggested sanitized files:

| File | Evidence |
|---|---|
| `01-postman-enrollment.png` | Enrollment success + idempotent retry |
| `02-postman-enrollment-denied.png` | No-token/wrong-role denial |
| `03-postman-progress.png` | Completion and percentage response |
| `04-postman-upload.png` | Direct upload response without token/presigned URL |
| `05-s3-course-prefix.png` | Correct object path and metadata; identifiers masked |
| `06-s3-private-access.png` | Block Public Access/private delivery evidence |
| `07-s3-multipart.png` | Completed upload and no orphaned parts |
| `08-cloudwatch-api-log.png` | Timestamped route/status/error event, redacted |
| `09-postman-runner.png` | Final Runner summary |

Never include passwords, JWTs, access keys, database URLs, presigned URLs, AWS
account IDs, Cognito identifiers, unredacted bucket names, or other participants'
personal data.
