---
title: "Overview and Architecture"
menuTitle: "Overview & architecture"
weight: 1
pre: "<b>5.1.</b>"
---

# Overview and architecture

## Responsibility boundary

| Layer | Team system | Luân's assigned work |
|---|---|---|
| Client | React/Vite pages and API client | Validate the contract consumed by Course Detail, My Learning, Learning Page, and Instructor uploads |
| Identity | Amazon Cognito and EduCloud JWT exchange | Require the current user and verify role/ownership behavior at API boundaries |
| API | FastAPI routes and services | Enrollment, progress, upload, Postman tests, and log checks |
| Data | Supabase PostgreSQL | Preserve enrollment/progress integrity and calculate DB-derived results |
| Storage | Private Amazon S3 and CloudFront | Core direct-upload validation; multipart/abort are supporting codebase extensions |
| Runtime | Elastic Beanstalk/EC2 | Generate request activity and verify streamed application logs in CloudWatch |
| Frontend hosting | AWS Amplify | Integration context only |

## Focused architecture

{{<mermaid>}}
flowchart LR
    Student["Student browser"] --> React["React client on Amplify"]
    Instructor["Instructor browser"] --> React
    React --> CDN["CloudFront /api behavior"]
    CDN --> API["FastAPI on Elastic Beanstalk"]
    API --> Auth["Cognito token verification"]
    API --> DB["Supabase PostgreSQL"]
    API --> S3["Private Amazon S3"]
    S3 --> CDN
    API --> Logs["CloudWatch Logs"]
    Admin["Admin browser"] --> API
{{</mermaid>}}

The report covers four trust transitions:

1. an untrusted browser presents a bearer token to FastAPI;
2. FastAPI maps identity and role before reading or writing PostgreSQL;
3. authorized upload requests receive a course-scoped storage operation or a
   short-lived presigned S3 URL; and
4. runtime logs are streamed by the hosting environment; the supporting codebase
   also exposes an Admin-only monitoring reader.

## Three request families

### Enrollment

`POST /api/courses/{course_id}/enroll` checks Student role, course existence,
published state, final-assessment readiness, and an existing enrollment before
inserting. The unique `(user_id, course_id)` constraint is the database backstop.

### Progress

Core `POST /api/lessons/{lesson_id}/complete` and
`GET /api/courses/{course_id}/progress` require enrollment. Percentage is
calculated from completed lesson rows rather than trusted frontend state. The
codebase's DELETE undo route is a supporting extension.

### Upload

Thumbnail, material, and video routes require course ownership or Admin. The
backend validates type and size. Production can store objects under
`courses/{course_id}/...` in S3; the current codebase also gives large video a
supporting presigned multipart flow.

## AWS services and rationale

- **Amazon S3:** durable private object storage for course assets.
- **Amazon CloudFront:** controlled media delivery and an API entry path.
- **Amazon CloudWatch:** application log retention and troubleshooting.
- **Elastic Beanstalk/EC2:** managed FastAPI runtime and log-streaming integration.
- **Amazon Cognito:** managed user identity upstream of API authorization.
- **AWS Amplify:** build/host the shared React frontend.

Supabase PostgreSQL is an external managed database in the project architecture.
It stores application state but does not replace Cognito authentication.
