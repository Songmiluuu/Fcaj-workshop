---
title: "Sharing and feedback"
weight: 7
chapter: false
pre: "<b>7.</b>"
---

# Sharing and feedback

> **Interim reflection as of July 30, 2026.** The internship ends on August 15,
> 2026. These comments describe my experience so far and may be updated after
> the final Postman and live-AWS validation.

> **Evidence note:** this is a draft first-person reflection based on the
> assignment brief and supplied codebase. Before submission, I must align it
> with my actual experience and support implementation claims with PR/task or
> mentor evidence.

## My experience with the program

The First Cloud AI Journey internship has given me a practical way to connect
Computer Science knowledge with a cloud application. In the team EduCloud
system, my individual responsibility is the enrollment, learning-progress, and
upload API slice, plus Postman regression and CloudWatch log verification. This
clear technical boundary helped me understand that delivering an API involves
more than a successful response: it also requires authorization, data
integrity, failure handling, integration contracts, tests, operational logs,
and evidence that another person can review.

The most useful learning experience so far has been following one learner flow
across layers: enroll in a published course, retrieve My Courses, complete a
lesson, and recalculate database-derived progress. Reviewing the supporting
undo and multipart extensions added further concerns—private S3 keys, part
ordering, retry, abort, and cleanup. I also learned that a mock-backed
automated pass is valuable but is not a substitute for a recorded Postman run
or validation against the configured AWS resources.

## Satisfaction level

**Interim satisfaction: 4/5 — Satisfied.**

I am satisfied because the program allows me to apply backend, database,
testing, and AWS concepts to one coherent use case, and the repository already
contains reviewable implementation and automated test evidence relevant to my
assigned workstream. That evidence proves code behavior but not personal
authorship. I am not selecting the maximum score yet because access readiness,
end-to-end integration, and final evidence collection still determine how
smoothly the last phase can be completed.

## What I would improve in my own work

- Start the manual Postman matrix earlier and update actual results in the same
  week as implementation, rather than carrying the full execution to the final
  phase.
- Schedule live S3 and CloudWatch checks early enough to separate application
  defects from IAM, bucket, log-streaming, or environment configuration issues.
- Share short interface-change and defect summaries at team integration points,
  especially when enrollment/progress depends on course state and upload depends
  on course ownership.
- Define the final evidence filename, redaction rule, and acceptance owner before
  taking screenshots.

## Suggested improvements for the program

1. **Provide a role-based acceptance checklist at project kickoff.** Each role
   should know its required endpoints, positive/negative cases, AWS evidence,
   and handover artifact from the first week.
2. **Prepare shared-environment access earlier.** A short readiness check for
   test accounts, IAM permissions, S3 prefixes, CloudWatch log groups, and
   non-production data would reduce late configuration blockers.
3. **Use a common Postman environment and report format.** A secret-free example
   with reusable variables, assertions, Runner export, and defect links would
   make results easier to compare and review.
4. **Add scheduled integration checkpoints.** Brief checkpoints between API
   owners, frontend owners, and AWS/deployment owners would expose contract and
   authorization mismatches before final regression.
5. **Review evidence and security weekly.** Mentors could sample one screenshot
   or test result each week and remind interns to redact JWTs, passwords, access
   keys, and presigned URL query strings.

## Would I recommend the program?

**Yes, with clear expectations.** I would recommend it to friends who have
basic software-development knowledge and want practice turning an application
requirement into an AWS-oriented implementation, test plan, and technical
report. My recommendation is based on the learning value of owning a bounded
feature and integrating it with a team system—not on a claim that every
EduCloud feature or the final AWS acceptance is already complete. Participants
should also be prepared for self-directed research, careful evidence collection,
and coordination across role boundaries.

## Expectations for the remaining period

Before August 15, my priorities are to execute and export the corrected Postman
collection, record every actual test result, validate the upload paths on the real
S3 configuration, correlate controlled requests with CloudWatch events, retest
defects, obtain contribution confirmation, and hand over sanitized evidence. I will update this feedback if the
final results materially change the assessment above.
