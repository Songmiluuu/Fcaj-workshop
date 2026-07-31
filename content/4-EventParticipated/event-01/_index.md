---
title: "FCAJ Community Day - June 2026"
menuTitle: "FCAJ Community Day"
weight: 1
pre: "<b>4.1.</b>"
---

## Event information

| Field | Details |
|---|---|
| Event | FCAJ Community Day - June 2026 |
| Date and time | 09:00–12:00, 27 June 2026 |
| Format | Hybrid event; I attended online through the YouTube livestream |
| On-site venue | Floors 26 and 36, Bitexco Financial Tower, 02 Hai Trieu Street, Ho Chi Minh City |
| My role | Online attendee |

I attended FCAJ Community Day online. The programme contained five sessions on
AI agents, cloud operations, Voice AI, enterprise productivity, and private MCP
connectivity. My notes focus on the technical lessons from the livestream.

## Programme followed

| Part | Session |
|---|---|
| Part 1 | Steve Tran, Founder of CloudThinker — cloud career development and the Deep Response Engine for AI-assisted operations |
| Part 2 | Nghi Danh Hoang Hieu, Kiet Tran, and Trung Vu — Voice Agent foundations and production challenges for Vietnamese |
| Part 3 | Bao Phan Kim and Minh Nguyen Nguyen, Cloud Engineers at Cloud Kinetics — AWS DevOps Agent and incident investigation |
| Part 4 | Truong Tran and Minh Anh Dang Cao, Noventiq — AI-Powered Productivity: Workforce Planning for Enterprise |
| Part 5 | Duc Toan Nguyen and Nghi Danh Hoang Hieu — Building a Secure Private MCP Connection with Amazon Quick |

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

I drew five main lessons from the five sessions:

1. **Observability must come before automation.** A DevOps Agent can investigate
   only when the system provides sufficient logs, metrics, traces, and deployment
   history. My EduCloud APIs therefore need structured logs containing a request
   ID, actor, course or lesson ID, status code, and elapsed time, while tokens,
   credentials, and presigned URLs must be excluded.
2. **AI supports decisions without removing human accountability.** High-impact
   actions such as deleting an object, aborting an upload, or changing
   infrastructure still require authorisation checks, guardrails, and an
   explicit approval boundary.
3. **A successful demo is not an operational service.** The Voice Agent session
   exposed issues such as latency, interruptions, regional accents, versioning,
   and human handoff. In the same way, EduCloud enrollment, progress, and upload
   flows need tests for repeated requests, timeouts, invalid files, interrupted
   connections, and cleanup after failure.
4. **Private connectivity has a trade-off.** It reduces public exposure, but VPC
   endpoints, DNS resolvers, load balancers, compute, and data transfer add cost
   and complexity. I need to justify every EduCloud component rather than add
   services simply to make the architecture look more extensive.
5. **Technical value begins with a real problem.** The CloudThinker journey
   reminded me to complete one useful end-to-end learner workflow before
   expanding the feature set. Fundamentals in APIs, security, networking, and
   testing remain necessary for evaluating AI-assisted output.

## Reflection

Attending online allowed me to follow the presentations, demonstrations, and
Q&A as one continuous programme. My clearest takeaway is that a trustworthy
cloud solution cannot be evaluated only through its happy path. For EduCloud, I
will use these lessons as a practical checklist: test both successful and failed
flows, preserve useful but non-sensitive evidence in CloudWatch, constrain S3
access, and document operating assumptions and cost alongside the API
implementation.
