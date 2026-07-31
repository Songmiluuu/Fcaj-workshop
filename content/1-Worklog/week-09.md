---
title: "Week 9 - Operations and security review"
menuTitle: "Week 9"
weight: 9
pre: "<b>1.9.</b>"
---

# Week 9 - Operations and security review

**Work period:** August 3–7, 2026

## Task

Review the operational and security concerns around the EduCloud deployment,
including access control, logging, storage protection, and AWS
Well-Architected practices.

## Work completed

- Rechecked backend role guards for Student, Instructor, and Admin operations.
- Reviewed the S3 private-access model, course object prefixes, upload limits,
  and the handling of incomplete multipart uploads.
- Compared application events with the CloudWatch logging flow and confirmed
  that public evidence must exclude tokens, account identifiers, presigned
  URLs, and raw private log payloads.
- Reviewed reliability, security, operational excellence, performance, and
  cost controls relevant to the current demonstration environment.

## Deliverable

A security and operations checklist covering authorization, protected storage,
log handling, deployment health, and cleanup responsibilities.

