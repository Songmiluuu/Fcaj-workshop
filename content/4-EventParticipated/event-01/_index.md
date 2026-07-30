---
title: "FCAJ Community Day — June 2026"
menuTitle: "FCAJ Community Day"
weight: 1
pre: "<b>4.1.</b>"
---

## Event information

| Field | Details |
|---|---|
| Event | FCAJ Community Day — June 2026 |
| Date and time | 09:00–12:00, 27 June 2026 |
| Format | Hybrid event; I attended online through the YouTube livestream |
| On-site venue | Floors 26 and 36, Bitexco Financial Tower, 02 Hai Trieu Street, Ho Chi Minh City |
| My role | Online attendee |

I attended FCAJ Community Day online. The programme contained five sessions on
AI agents, cloud operations, Voice AI, enterprise productivity, and private MCP
connectivity. The notes below summarise what I learned from the livestream.

## Programme followed

| Video timestamp | Session |
|---|---|
| 00:13:06–00:43:07 | Steve Tran, Founder of CloudThinker — cloud career development and the Deep Response Engine for AI-assisted operations |
| 00:43:07–01:03:09 | Nghi Danh Hoang Hieu, Kiet Tran, and Trung Vu — Voice Agent foundations and production challenges for Vietnamese |
| 01:03:09–01:31:07 | Bao Phan Kim and Minh Nguyen Nguyen, Cloud Engineers at Cloud Kinetics — AWS DevOps Agent and incident investigation |
| 01:31:07–02:13:31 | Truong Tran and Minh Anh Dang Cao, Noventiq — AI-Powered Productivity: Workforce Planning for Enterprise |
| 02:13:31–02:30:35 | Duc Toan Nguyen and Nghi Danh Hoang Hieu — Building a Secure Private MCP Connection with Amazon Quick |

## Session summary

### AI-assisted cloud operations

Steve Tran described his path from operating infrastructure to working as a
Solution Architect and building CloudThinker. His session connected faster
AI-assisted software development with a growing need for strong production
engineers. The platform examples covered incident investigation, review of
infrastructure changes, FinOps, and security assessment. A point that stood out
to me was that AI should support an engineer's decisions in a critical system;
it should not silently take control of production.

The session also presented a practical product lesson: begin executing early,
then test the idea against a real customer problem. A technically interesting
prototype has limited value if its workflow does not match how its users
actually work.

### Voice Agent beyond a demo

The Voice Agent panel compared direct speech-to-speech processing with a
Speech-to-Text → LLM → Text-to-Speech pipeline. Because Vietnamese is a
low-resource language, the three-stage design remains a practical option for
many enterprise use cases. A live example used Amazon Bedrock AgentCore and a
knowledge base to answer product questions.

The production discussion was more valuable to me than the basic demo. A real
system must handle streaming latency, regional accents, forms of address,
interruptions, tool calls, audit history, versioning, and transfer to a human
operator when the agent cannot safely continue. These are examples of edge
cases that become visible only when a prototype is treated as an operational
service.

### DevOps Agent and observability

The AWS DevOps Agent session showed an incident workflow that gathers logs,
traces, topology, and previous operational context; forms and checks
hypotheses; identifies a likely root cause; and proposes a mitigation plan. In
the demonstration, an e-commerce application on ECS behind an Application Load
Balancer experienced abnormal traffic and increased latency. The agent helped
organise the evidence and recommend recovery steps, while the operator retained
control of execution.

The strongest prerequisite was good observability. Without adequate logs,
metrics, alarms, and deployment history, neither an engineer nor an AI agent
has enough evidence for a reliable conclusion. The speakers summarised the
tool as an amplifier of DevOps skill, not a replacement for it.

### Enterprise workflows and secure connectivity

The Amazon Quick workforce-planning session demonstrated skills for processing
CVs, comparing them with a job description, producing a structured report, and
tracking a recruitment workflow. It illustrated how an agent can reduce
repetitive work while leaving judgement and accountability with people.

The final session moved from functionality to security. It discussed connecting
Amazon Quick to an MCP server through private AWS networking instead of exposing
the server directly to the public Internet. The architecture involved private
DNS, VPC connectivity, an Application Load Balancer, TLS, authentication, and
restricted credential storage. The Q&A also made the trade-off explicit:
private connectivity can reduce exposure, but its endpoints, resolver, compute,
load balancer, and data transfer must be included in the cost estimate.

## Lessons and connection to EduCloud

1. **Start with the user workflow.** For EduCloud, enrollment, progress, lesson
   completion, and upload APIs should form a coherent learner and instructor
   journey rather than a set of isolated endpoints.
2. **Treat observability as part of the API.** My assigned APIs need enough
   structured context to correlate an HTTP request with its outcome. Useful
   fields include a request ID, actor, course or lesson ID, status code, object
   key, and elapsed time. Tokens, credentials, and presigned URLs must be
   redacted.
3. **Keep a human-controlled boundary.** Destructive or high-impact operations,
   such as deleting an object or aborting an upload, need explicit authorisation
   and predictable guardrails rather than unconditional automation.
4. **Apply least privilege to file delivery.** Course material should remain in
   a private S3 bucket. A learner should receive access only to the permitted
   course object, and any presigned URL should have a short lifetime.
5. **Test failure paths, not only successful requests.** The EduCloud test plan
   should include duplicate enrollment, unauthorised lesson completion,
   unsupported or oversized files, interrupted multipart uploads, and cleanup
   after failure.
6. **A working demo is not production readiness.** Idempotency, timeout, retry,
   audit history, and rollback or cleanup behaviour all need to be considered
   for enrollment, progress, and upload flows.
7. **Make cost an architecture input.** S3 storage and transfer, CloudWatch log
   retention, and abandoned multipart uploads need limits, monitoring, and
   lifecycle rules based on the actual workload.
8. **Use AI with strong fundamentals.** AI can accelerate coding and incident
   analysis, but evaluating its output still requires knowledge of APIs,
   security, networking, testing, and cloud operations.

## Reflection

Attending the livestream helped me understand the distance between a feature
that works in a demonstration and a cloud system that can be operated safely.
For my EduCloud scope, I will use the sessions as a checklist: verify behaviour
with tests, preserve useful but non-sensitive evidence in CloudWatch, constrain
S3 access, and document failure and cost considerations alongside the API
implementation.
