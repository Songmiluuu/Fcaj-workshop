---
title: "Week 1 - Onboarding and assigned-scope analysis"
menuTitle: "Week 1"
weight: 1
pre: "<b>1.1.</b>"
---

**Period:** June 1, 2026 - June 7, 2026  
**Status on July 30:** Reconstructed plan; reporting artifacts prepared

## Objectives

- Record the official internship period and understand the expected project
  report and weekly evidence.
- Convert the assigned “Enrollment/Progress/Upload + Testing” role into
  concrete EduCloud responsibilities.
- Identify dependencies on authentication, courses, lessons, storage, and AWS
  monitoring before implementation.

## Planned activities and report artifacts

| Activity | Result |
| --- | --- |
| Review the project scope and separate assigned work from Course/Lesson and Auth responsibilities. | Five assigned areas are documented: enrollment, progress, upload, Postman verification, and CloudWatch log checks. |
| Traced the required API groups in the contract. | Produced an initial endpoint inventory and identified Student, Instructor/Admin, and Admin-only access boundaries. |
| Reviewed the standard success/error response shape and evidence expectations. | Established a checklist containing request, expected response, actual response, status, and sanitized evidence. |
| Split the internship into ten periods ending on August 15. | Created a work sequence from requirements through implementation, verification, and handover. |

## Deliverables

- A role-scope matrix tied to EduCloud endpoint families.
- A ten-period work plan covering **01/06/2026–15/08/2026**.
- An evidence rule: source paths can prove that a feature exists; manual
  Postman and live AWS results require separate execution evidence.

## Completion criteria

| Criterion | Result |
| --- | --- |
| Every assigned area maps to at least one API or test artifact. | Met |
| The ten worklog periods cover the full official internship range without a date gap. | Met |
| Evidence handling excludes passwords, JWT values, AWS keys, and private configuration. | Met as a reporting rule |

## Repository evidence

- EduCloud/api/api-contract.md
- EduCloud/api/test-plan/test-cases.md
- EduCloud/api/test-plan/test-report-template.md
- EduCloud/README.md
