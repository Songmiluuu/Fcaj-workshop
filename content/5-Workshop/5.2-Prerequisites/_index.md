---
title: "Prerequisites and Safe Setup"
menuTitle: "Prerequisites"
weight: 2
pre: "<b>5.2.</b>"
---

# Prerequisites and safe setup

## Tools

- Python 3.11 or later.
- Git and PowerShell (or an equivalent terminal).
- Postman Desktop or CLI/Newman for collection runs.
- A local EduCloud checkout.
- A dedicated Supabase PostgreSQL project and Cognito User Pool when testing
  authentication end to end.
- An AWS sandbox account only for S3/CloudWatch integration checks.

The backend source of truth is the generated Swagger UI at
`http://127.0.0.1:8001/docs`. The scoped static OpenAPI file attached to this
report is an auditable snapshot, not a replacement for runtime documentation.

## Start the backend

From the EduCloud repository:

```powershell
Set-Location backend
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements-dev.txt
python -m uvicorn main:app --reload --port 8001
```

Create `backend/.env` from the example and use only your own values. At minimum,
the application needs its database URL and JWT/Cognito settings. S3 and monitoring
checks additionally use settings such as:

```dotenv
UPLOAD_STORAGE=s3
AWS_REGION=YOUR_REGION
AWS_S3_BUCKET_NAME=YOUR_PRIVATE_BUCKET
AWS_S3_PUBLIC_BASE_URL=https://YOUR_CLOUDFRONT_DOMAIN
AWS_MONITORING_ENABLED=true
AWS_CLOUDWATCH_LOG_GROUP=YOUR_ELASTIC_BEANSTALK_LOG_GROUP
```

Keep real values out of Git, report files, Postman examples, screenshots, and
frontend `VITE_*` variables.

## Shared AWS Console setup

The figures record AWS configuration from the shared EduCloud team environment.
Sensitive resource names and values remain hidden.

{{< staticimage path="images/workshop/03-ssm-secure-parameters.png" alt="Shared team secure parameters in AWS Systems Manager" >}}

The database URL and JWT secret are stored as `SecureString` parameters so their
values do not need to appear in source code or ordinary environment files.

{{< staticimage path="images/workshop/05-elastic-beanstalk-green.png" alt="Shared team backend environment in healthy state" >}}

The backend health screen is a quick deployment check before running the API
collection. A green environment does not replace endpoint-level tests.

## Prepare identities

| Identity | Needed for | Minimum condition |
|---|---|---|
| Student | Enrollment and progress | Valid bearer token; linked application user with role `student` |
| Instructor | Upload positive tests | Owns the selected course |
| Other Instructor | Upload negative test | Does not own the selected course |
| Admin | CloudWatch viewer | Valid bearer token with application role `admin` |

Tokens are deliberately blank in the attached Postman collection. Obtain them
through the application's real login flow, paste them only into local collection
variables, and clear them after the run.

## Prepare deterministic data

Create or select:

1. one published course owned by the Instructor;
2. a published final assessment for that course, because enrollment enforces it;
3. at least two lessons, so a single completion produces an observable percentage;
4. a second published course that the Student has not enrolled in;
5. small redacted fixture files: PNG, PDF, MP4, and one unsupported extension; and
6. no existing certificate when testing the progress undo path.

Record the IDs locally as `course_id`, `lesson_id`, and
`not_enrolled_course_id`.

## Import report artifacts

- {{< staticlink path="files/EduCloud-API-Testing.postman_collection.json" text="Download the scoped Postman collection" download="true" >}}
- {{< staticlink path="files/educloud-openapi.yaml" text="Download the scoped OpenAPI snapshot" download="true" >}}
- {{< staticlink path="files/api-test-matrix.md" text="Download the evidence-based test matrix" download="true" >}}

## Safety gate

Before any live run:

- confirm the AWS account and Region in the console header;
- set a budget alert;
- use a test bucket/prefix, not shared production objects;
- mask Authorization headers and presigned URLs in Postman output;
- configure only least-privilege IAM permissions;
- verify CloudWatch log retention; and
- agree with the team before changing or deleting shared resources.
