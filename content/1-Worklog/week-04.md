---
title: "Week 4 - Enrollment and progress data foundation"
menuTitle: "Week 4"
weight: 4
pre: "<b>1.4.</b>"
---

**Period:** June 22, 2026 - June 28, 2026  
**Status on July 30:** Codebase target present; personal attribution requires confirmation

> **Attribution basis:** this page reconstructs intended work from the assignment
> and supplied code. The referenced source proves current behavior, not who
> authored it.

## Objectives

- Build durable persistence rules for enrollment and lesson progress.
- Protect idempotency at both service and database levels.
- Prepare existing development databases to receive the same uniqueness rules.

## Planned activities and current codebase evidence

| Activity | Verified result |
| --- | --- |
| Plan Enrollment with user_id, course_id, and status. | The current model has foreign keys to users/courses and a unique user-course constraint. |
| Plan Progress with user_id, course_id, lesson_id, and is_completed. | The current model records completion per learner and enforces one row per user-lesson pair. |
| Plan compatibility index creation for existing databases. | The current migration helper creates uq_enrollment_user_course and uq_progress_user_lesson when the tables exist. |
| Plan the compatibility check during application startup. | The current backend calls ensure_learning_unique_indexes before serving requests. |
| Review response fields required by the frontend. | Current progress output exposes course, completed count, total count, percentage, and completed lesson IDs. |

## Expected deliverables

- Enrollment and Progress SQLAlchemy models.
- Database uniqueness protection for both new and previously created
  databases.
- Base response schemas for enrollment and progress.

## Test criteria

| Criterion | Result |
| --- | --- |
| The same user cannot have two enrollment rows for one course. | Present in current model/index code |
| The same user cannot have two progress rows for one lesson. | Present in current model/index code |
| Progress retains the parent course_id for efficient course aggregation. | Present in current model |
| Startup applies compatibility indexes before API requests are handled. | Present in main.py registration |

## Repository evidence

- EduCloud/backend/app/models/enrollment.py
- EduCloud/backend/app/models/progress.py
- EduCloud/backend/app/database_migrations.py
- EduCloud/backend/app/schemas/enrollment_schema.py
- EduCloud/backend/app/schemas/progress_schema.py
- EduCloud/backend/main.py
