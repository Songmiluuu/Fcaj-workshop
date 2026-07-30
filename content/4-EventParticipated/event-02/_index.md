---
title: "FCAJ x Agentic AI Build Week 2026 — Hackathon Awards & Project Showcase"
menuTitle: "AABW 2026"
weight: 2
pre: "<b>4.2.</b>"
---

## Event overview

On 25 July 2026, I attended the **FCAJ x Agentic AI Build Week 2026 — Hackathon Awards & Project Showcase**. The program presented practical Agentic AI projects and the engineering journeys behind them, including how teams narrowed their scope, made architecture decisions, responded to unsuccessful attempts, and prepared working demonstrations under time constraints.

| Field | Details |
|---|---|
| Event | FCAJ x Agentic AI Build Week 2026 — Hackathon Awards & Project Showcase |
| Date | 25 July 2026 |
| Venue | AWS Office, 26th Floor, Bitexco Tower, 02 Hai Trieu Street, Saigon Ward, Ho Chi Minh City |
| Organizers | First Cloud AI Journey (FCAJ), Amazon Web Services (AWS), and the Agentic AI Build Week community |
| Participation | Attendee |

## Projects presented

The showcase brought together four projects that applied Agentic AI to very different problems:

- **3KA — S.H.E.P.H.E.R.D** used YOLO and ByteTrack for crowd detection and tracking, with Amazon SageMaker, Amazon Bedrock AgentCore, Strands Agents, and a React operations dashboard. The project showed how visual data could support congestion assessment, hazard detection, and response decisions.
- **OneTeam — KFC Bot Agent** demonstrated a conversational ordering agent for channels such as Zalo and WhatsApp. Its separation of channel adapters, reusable tools, and business logic made the system easier to extend without redesigning the complete ordering flow.
- **Plan V — Solution Architect Professional Native App** converted natural-language requirements into an initial cloud architecture, an editable draw.io diagram using official AWS icons, and a directional cost estimate for the `ap-southeast-1` Region. It also surfaced assumptions and missing information for human review.
- **SignalScout** presented an evidence-oriented decision-support platform for detecting market and organizational signals, comparing scenarios, and recommending strategic actions. Its architecture demonstrated how AI workloads could be combined with identity, storage, security, audit, and observability services on AWS.

## What I learned

The main lesson I took from the event is that an AI agent is not simply a model producing an answer. A dependable solution also needs a clear objective, controlled tools, a verification step, observable behavior, and a person who remains accountable for important decisions.

I also learned to judge a prototype by the completeness of its core journey rather than by the number of features or cloud services included. A focused scenario that works from input to verified output is more convincing than an ambitious design with unfinished critical paths. Architecture, security, latency, operating cost, monitoring, and failure handling therefore need to be considered while the product is being designed, not only after the demonstration is complete.

## Applying the lessons to EduCloud

These lessons are directly relevant to my assigned EduCloud scope: enrollment, learning progress, file upload, and API testing. I use the following three criteria to guide the work:

1. Demonstrate one traceable learning journey through `POST /api/courses/{id}/enroll`, `GET /api/my-courses`, `POST /api/lessons/{id}/complete`, and `GET /api/courses/{id}/progress`.
2. Treat the upload APIs as a boundary between the application and Amazon S3, with input validation, private storage, clear error handling, and credentials kept outside the repository.
3. Cover both successful and invalid requests in Postman, then correlate the observed API behavior with CloudWatch logs instead of evaluating each component in isolation.

After attending the showcase, I understood more clearly that a strong technical demonstration is built around explainable decisions and a stable end-to-end flow. This perspective helps me keep the EduCloud workshop focused on what I am responsible for and present the purpose of each API, test, and AWS service more clearly.
