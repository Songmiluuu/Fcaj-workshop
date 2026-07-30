---
title: "Technical Blog Drafts"
weight: 3
chapter: false
pre: "<b>3.</b>"
---

These three articles are submission-ready internal drafts based on Nguyễn Song
Minh Luân's assigned EduCloud scope and the implementation evidence in the local
repository.

Repository evidence confirms technical behavior, not personal authorship. Before
publication, Luân should align any first-person statements with his actual work
and mentor/PR evidence. Blog 3 intentionally discusses supporting codebase
extensions beyond the seven core assigned endpoints.

> **Publication status:** Not yet published. After each article is actually
> published through the required AWS Study Group channel, add its real public
> URL and publication date here. An internal workshop route is not proof of
> publication, and no public link should be invented.

<h2 class="blog-list-title"><a href="enrollment-idempotency/">Blog 1 — Designing Idempotent and Authorized Course Enrollment</a></h2>

How EduCloud derives the Student identity from a verified token, checks course
eligibility, returns an existing enrollment on retries, and relies on a database
unique constraint as the final integrity boundary.

**Public AWS Study Group URL:** Pending actual publication.

<h2 class="blog-list-title"><a href="progress-consistency/">Blog 2 — Keeping Lesson Progress Consistent Under Retries</a></h2>

How one user/lesson state, enrollment guards, database-derived percentages, and
certificate boundaries keep progress predictable across repeated requests.

**Public AWS Study Group URL:** Pending actual publication.

<h2 class="blog-list-title"><a href="s3-multipart-validation/">Blog 3 — Secure S3 Multipart Uploads and Deployment Validation</a></h2>

How FastAPI authorizes course-scoped uploads, the browser sends video parts
directly to private S3, and Postman, automated tests, health data, and CloudWatch
are used without overstating unexecuted test evidence.

**Public AWS Study Group URL:** Pending actual publication.
