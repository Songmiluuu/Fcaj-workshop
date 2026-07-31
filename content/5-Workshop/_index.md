---
title: "Workshop"
menuTitle: "Workshop"
weight: 5
chapter: true
pre: "<b>5.</b>"
---

# EduCloud API Reliability Workshop

This workshop is the practical checklist I used for my EduCloud API work:

- Student enrollment and enrolled-course dashboard APIs.
- Lesson completion and course-progress APIs.
- Authorized thumbnail, material, and video uploads.
- Postman positive/negative tests and Amazon CloudWatch log verification.

The wider EduCloud application also has frontend, Cognito, course authoring,
assessments, certificates, administration, deployment, and database work from the
team. I mention those parts only where they affect the API checks below.

The current codebase also has progress undo, thumbnail import/deduplication,
multipart video controls, and an Admin log reader. I include them where they help
explain testing or handover.

{{< staticimage path="images/architect.jpg" alt="Overall EduCloud AWS architecture" >}}

## Learning outcomes

After completing the workshop, a reader can:

1. explain the enrollment, progress, and upload data flows;
2. run the API requests with correctly separated Student/Instructor/Admin tokens;
3. verify authorization, idempotency, file validation, and progress calculations;
4. exercise the core direct upload and supporting multipart paths safely;
5. use Postman assertions and automated tests without publishing secrets;
6. confirm which application logs are available in CloudWatch; and
7. clean up test data and incomplete S3 multipart uploads.

## Workshop map

| Part | Outcome |
|---|---|
| [5.1 Overview](5.1-overview/) | Understand the team architecture and API boundary |
| [5.2 Prerequisites](5.2-prerequisites/) | Prepare local tools, test identities, and safe data |
| [5.3 Contract and data](5.3-contract-data/) | Review models, constraints, responses, and errors |
| [5.4 Enrollment APIs](5.4-enrollment/) | Enroll idempotently and load My Courses |
| [5.5 Progress APIs](5.5-progress/) | Complete/read progress and review the supporting undo path |
| [5.6 Upload APIs](5.6-upload/) | Validate core uploads and review supporting multipart video |
| [5.7 Security and reliability](5.7-security/) | Apply role, ownership, key-prefix, and retry rules |
| [5.8 Validation](5.8-validation/) | Run Postman/tests and verify CloudWatch logs |
| [5.9 Cleanup and handover](5.9-cleanup/) | Remove test resources and prepare handover |

The AWS Console figures show configuration from the shared EduCloud team
environment. They are included at the setup steps where the same team resources
were used for integration and validation.
