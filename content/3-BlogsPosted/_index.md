---
title: "Blogs Posted"
menuTitle: "Blogs Posted"
weight: 3
chapter: false
pre: "<b>3.</b>"
---

I wrote three technical articles during the internship to explore AWS
architectures related to media processing, upload security, and durable
workflows. I kept a full report version of each article on this site.

<h2 class="blog-list-title"><a href="video-processing-s3-mediaconvert-cloudfront/">Blog 1 — Automating lecture video processing with Amazon S3, MediaConvert, and CloudFront</a></h2>

A serverless video pipeline that accepts direct uploads through presigned URLs,
transcodes source files into adaptive HLS renditions, and securely distributes
private learning content through CloudFront.

<h2 class="blog-list-title"><a href="guardduty-malware-protection-s3/">Blog 2 — Blocking malicious files before they enter the system with GuardDuty Malware Protection for S3</a></h2>

A secure upload architecture that keeps new objects untrusted until GuardDuty
Malware Protection for S3 returns a clean result, while isolating threats and
scan failures from downstream systems.

<h2 class="blog-list-title"><a href="lambda-durable-order-workflow/">Blog 3 — Processing order workflows without losing state with AWS Lambda Durable Functions</a></h2>

A fault-tolerant order workflow built around checkpoints, replay, callbacks,
idempotency, compensating actions, and production monitoring.
