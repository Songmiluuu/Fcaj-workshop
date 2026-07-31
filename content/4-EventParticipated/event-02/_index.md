---
title: "FCAJ x Agentic AI Build Week 2026 — Hackathon Awards & Project Showcase"
menuTitle: "AABW 2026"
weight: 2
pre: "<b>4.2.</b>"
---

## Event overview

On 25 July 2026, I attended the **FCAJ x Agentic AI Build Week 2026 —
Hackathon Awards & Project Showcase**. In addition to presenting their final
results, the teams explained how they selected a problem, divided
responsibilities, adjusted scope, and completed a demonstration within a
hackathon schedule. I followed the event to understand what turns an Agentic AI
idea into a product that can be demonstrated, measured, and explained.

| Field | Details |
|---|---|
| Event | FCAJ x Agentic AI Build Week 2026 — Hackathon Awards & Project Showcase |
| Date | 25 July 2026 |
| Venue | AWS Office, 26th Floor, Bitexco Tower, 02 Hai Trieu Street, Saigon Ward, Ho Chi Minh City |
| Organizers | First Cloud AI Journey (FCAJ), Amazon Web Services (AWS), and the Agentic AI Build Week community |
| Participation | Attendee |

## Projects presented

The four projects addressed different problems, yet every team had to show how
its agent used data and tools:

- **3KA — S.H.E.P.H.E.R.D** combined YOLO and ByteTrack to detect and track
  crowd movement. Amazon SageMaker supported model workloads, while Amazon
  Bedrock AgentCore and Strands Agents formed the agent layer. A React dashboard
  translated the analysis into information for congestion awareness, hazard
  detection, and response planning. A reliable visual AI system depends on its
  model, data quality, camera placement, tracking stability, latency, and
  fallback behaviour.
- **OneTeam — KFC Bot Agent** implemented conversational ordering through
  familiar channels such as Zalo and WhatsApp. Separating channel adapters from
  ordering tools and business rules made the core workflow reusable when a new
  channel was introduced. The agent must still verify the result of a tool call
  rather than treat generated text as proof that a transaction completed.
- **Plan V — Solution Architect Professional Native App** accepted
  natural-language requirements and produced an initial architecture, an
  editable draw.io diagram with official AWS icons, and a directional estimate
  for the `ap-southeast-1` Region. I particularly valued its decision to expose
  assumptions and missing requirements so a Solution Architect could challenge
  the draft rather than accept a closed answer.
- **SignalScout** approached Agentic AI as a decision-support problem. It
  collected market or organisational signals, compared scenarios, and proposed
  evidence-based actions. By placing the AI workload alongside identity,
  storage, security, audit, and monitoring layers, its architecture showed that
  an AI product still carries the same operational responsibilities as any
  other production system.

## What I learned

Comparing the four demonstrations led me to four lessons:

1. **Reducing scope is an engineering decision.** A small journey that works
   from input through planning and tool use to a verified result is more
   valuable than many disconnected features.
2. **An agent needs explicit boundaries.** Its objective, permitted data,
   permitted tools, and conditions requiring human confirmation must be
   defined. The model is only one component of the complete system.
3. **Measurement is part of the product.** Latency, cost per transaction,
   success rate, traceability, and decision quality reveal more than the number
   of AWS services in an architecture diagram.
4. **A strong demo explains its decisions.** I need to begin with the user
   problem, identify the responsibility of each component, state the current
   assumptions, and show how the system responds when a step fails.

This changed the way I assess an Agentic AI prototype. In addition to the final
answer, I need to examine the data path, tool permissions, verification
evidence, operational logs, cost, and the point at which a person takes over.

## Applying the lessons to EduCloud

These lessons apply directly to my EduCloud responsibilities: enrollment,
learning progress, file upload, and API testing. I translated them into the
following actions:

1. Complete one traceable journey from `POST /api/courses/{id}/enroll` and `GET
   /api/my-courses` through `POST /api/lessons/{id}/complete` and `GET
   /api/courses/{id}/progress`, rather than demonstrating isolated endpoints.
2. Treat the upload API as a security boundary between the application and
   Amazon S3: validate input, authorise access by course, keep objects private,
   handle interrupted multipart uploads, and keep credentials outside the
   repository.
3. Use Postman to cover both happy paths and invalid requests, then correlate the
   observed result with CloudWatch logs. Every workshop conclusion should be
   supported by a response, persisted state, or log evidence.
4. State the assumptions, data flow, responsibility boundaries, and cost of the
   services actually used when presenting the EduCloud architecture. The diagram
   should help a reviewer inspect the design rather than act only as an
   illustration.

After the event, I understood that a convincing technical demonstration depends
less on feature count than on a core workflow that is stable, explainable, and
supported by evidence. I use this principle to keep the EduCloud workshop
aligned with my assigned scope.
