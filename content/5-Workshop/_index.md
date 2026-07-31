---
title: "Workshop"
menuTitle: "Workshop"
weight: 5
chapter: true
pre: "<b>5.</b>"
---

# EduCloud API Reliability Workshop

My assigned scope in the EduCloud team project covers:

- Student enrollment and enrolled-course dashboard APIs.
- Lesson completion and course-progress APIs.
- Authorized thumbnail, material, and video uploads.
- Postman positive/negative tests and Amazon CloudWatch log verification.

The wider EduCloud application also contains frontend, Cognito authentication,
course authoring, assessments, certificates, administration, deployment, and
database work completed within the team. Those components are referenced only
when an assigned API depends on their contract or state.

The current codebase also extends the seven core endpoints with progress undo,
thumbnail import/deduplication, multipart video controls, and an Admin log-reader.
These are documented as supporting behavior around the assigned API scope.

{{< staticimage path="images/architect.jpg" alt="Overall EduCloud AWS architecture" >}}

## Learning outcomes

After completing the workshop, a reader can:

1. explain the enrollment, progress, and upload data flows;
2. run the scoped APIs with correctly separated Student/Instructor/Admin tokens;
3. verify authorization, idempotency, file validation, and progress calculations;
4. exercise the core direct upload and supporting multipart paths safely;
5. use Postman assertions and automated tests without publishing secrets;
6. confirm which application logs are available in CloudWatch; and
7. clean up test data and incomplete S3 multipart uploads.

## Workshop map

| Part | Outcome |
|---|---|
| [5.1 Overview](5.1-overview/) | Understand team architecture and Luân's API boundary |
| [5.2 Prerequisites](5.2-prerequisites/) | Prepare local tools, test identities, and safe data |
| [5.3 Contract and data](5.3-contract-data/) | Review models, constraints, responses, and errors |
| [5.4 Enrollment APIs](5.4-enrollment/) | Enroll idempotently and load My Courses |
| [5.5 Progress APIs](5.5-progress/) | Complete/read progress and review the supporting undo path |
| [5.6 Upload APIs](5.6-upload/) | Validate core uploads and review supporting multipart video |
| [5.7 Security and reliability](5.7-security/) | Apply role, ownership, key-prefix, and retry rules |
| [5.8 Validation and evidence](5.8-validation/) | Run Postman/tests and verify CloudWatch logs |
| [5.9 Cleanup and handover](5.9-cleanup/) | Remove test resources and package evidence |

{{% notice info %}}
The AWS Console figures show configuration from the shared EduCloud team
environment. They are included at the setup steps where the same team resources
were used for integration and validation.
{{% /notice %}}
