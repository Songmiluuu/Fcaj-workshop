---
title: "XỬ LÝ QUY TRÌNH ĐƠN HÀNG KHÔNG MẤT TRẠNG THÁI VỚI AWS LAMBDA DURABLE FUNCTIONS"
menuTitle: "Lambda Durable Workflow"
weight: 3
pre: "<b>3.3.</b>"
---

# XỬ LÝ QUY TRÌNH ĐƠN HÀNG KHÔNG MẤT TRẠNG THÁI VỚI AWS LAMBDA DURABLE FUNCTIONS

**Publication status:** Published.

## THE CHALLENGE OF AN ORDER WAITING FOR PAYMENT

Behind a single order action are many consecutive steps: create the order,
reserve inventory, call the payment gateway, wait for the bank's response,
confirm the transaction, and send a notification.

This process can take minutes or hours. Problems arise when the system fails
halfway through. For example, the customer's account may have been charged, but
Lambda times out before updating the order status. Running the whole function
again risks charging twice. Not running it again can leave the order stuck even
though the customer has paid.

A conventional Lambda invocation runs for no more than 15 minutes and does not
remember which steps have already finished. Developers commonly have to build a
state table, retry mechanism, duplicate-processing lock, and recovery logic
themselves.

AWS Lambda Durable Functions addresses this problem by adding checkpoints,
replay, and wait operations to Lambda. The workflow is still written in
JavaScript, TypeScript, Python, or Java, but it can pause and resume for a total
execution period of up to one year.

## HOW CHECKPOINTS AND REPLAY WORK

Each unit of business logic is placed in a durable step. When the step finishes,
Lambda stores its result as a checkpoint.

Consider this workflow:

**Create order → Reserve inventory → Initiate payment → Wait for callback →
Confirm order**

If the first two steps have completed but payment encounters a network failure,
Lambda invokes the handler again. During replay, checkpointed steps are skipped
and their stored results are reused. The workflow continues at the payment step
instead of starting over.

When a workflow must wait for a bank callback or a manual approval, the function
uses a wait operation to pause. Lambda does not keep a process running
continuously, and on-demand functions do not incur duration charges while
waiting.

Each invocation still has a maximum duration of 15 minutes. The one-year limit
applies to the complete durable execution, which is completed through multiple
invocations, checkpoints, and pauses.

## ORDER-PROCESSING ARCHITECTURE

A basic architecture can include:

**Customer → Amazon API Gateway → Lambda Durable Function → Inventory Service /
Payment Gateway / Database**

Supporting services include:

- Amazon DynamoDB or Amazon RDS stores orders and business state.
- Amazon EventBridge receives state-change events.
- Amazon SNS or Amazon SES sends customer notifications.
- Amazon CloudWatch stores logs and metrics and provides alarms.
- An Amazon SQS Dead-Letter Queue retains the events for workflows that fail
  permanently.

## PROCESSING FLOW

### Step 1: Accept the request

The frontend sends an order request to API Gateway. The backend creates an order
ID and starts the Durable Function asynchronously.

The API can return HTTP 202 Accepted with the order ID instead of keeping the
connection open throughout payment. The frontend uses the order ID to check
order status.

### Step 2: Create the order and reserve inventory

The Durable Function creates an order in PENDING_PAYMENT state and then calls the
inventory service to reserve the products.

The order ID should be used as an idempotency key. If the request is delivered
again, the inventory service must return its earlier result instead of deducting
more stock.

### Step 3: Initiate payment

The function calls the payment gateway API and supplies an idempotency key, for
example:

    payment-order-847219

If the payment gateway charges the account but its response is lost, Lambda can
retry the request. Reusing the same idempotency key enables the gateway to
recognize the earlier transaction and avoid creating a second charge.

Checkpoints reduce repeated work, but they do not replace idempotency. Operations
with side effects—such as charging an account, updating the database, reserving
inventory, or sending a notification—must still be designed to handle repeated
requests safely.

### Step 4: Wait for the callback

After creating the transaction, the workflow uses waitForCallback to pause.

When the bank finishes processing, its webhook sends the result to a separate
API. This API must verify the signature, validate the order ID and transaction
ID, and ensure that the callback has not already been processed.

A valid callback wakes the durable execution. The workflow continues at the
waiting step without recreating the order or initiating payment again.

### Step 5: Confirm the order

If payment succeeds, the Durable Function changes the order state to PAID,
confirms the inventory reservation, and publishes an OrderConfirmed event.

Tasks such as sending email, creating a delivery request, or updating the
accounting system can be handled by separate consumers. The order confirmation
therefore does not depend directly on the email or delivery service.

## FAILURE HANDLING AND BUSINESS COMPENSATION

Network failures, HTTP 429, and HTTP 503 can be retried with exponential backoff.
An expired card, out-of-stock item, or invalid callback is a business error and
should not be retried continuously.

If the workflow fails after completing some steps, the system needs compensating
actions following the Saga pattern:

- Inventory was reserved but payment failed: release the inventory.
- Payment completed but the order cannot be processed: issue a refund or route
  the case to a manual-processing queue.
- The customer did not pay before the deadline: cancel the order and return the
  products to available inventory.
- The callback arrived after the order expired: send the transaction to
  reconciliation.

Durable Functions stores progress and recovers the workflow, but the developer
must still define the rules for refunds, cancellation, and inventory release.

## AVOIDING SIDE EFFECTS DURING REPLAY

Because the handler is replayed from the beginning, code outside durable steps
must produce deterministic results.

Operations such as reading the current time, creating a random UUID, calling an
external API, or writing data should not run directly outside a step. If a
payment ID is generated randomly every time the handler runs, replay can create
a different ID from the original execution.

These values should come from the input or be created inside a checkpointed
step.

## PRODUCTION MONITORING

Logs should include the durable execution ID, order ID, step name, retry count,
and payment transaction ID.

A CloudWatch alarm can report an unusual increase in FAILED or TIMED_OUT
workflows. EventBridge can send notifications when execution status changes. For
asynchronous invocation, an SQS Dead-Letter Queue should retain the original
event when the workflow fails permanently.

The database must remain the authoritative source of business state. Lambda
execution history supports orchestration and recovery; it should not replace the
order table or transaction ledger.

A periodic reconciliation task is also necessary to detect cases where the
payment gateway recorded a charge but the order status was not updated.

## DEPLOYING A NEW VERSION

A durable execution can remain active for many days while the development team
continues updating code. If an active workflow is replayed by a handler whose
step structure has changed, its previous checkpoints might no longer be
compatible.

The Durable Function should be invoked through a specific Lambda version or
alias instead of $LATEST. Active workflows continue using their original code
version, while new orders move to the new version.

Do not casually rename or change the meaning of steps still used by unfinished
executions.

## DURABLE FUNCTIONS AND STEP FUNCTIONS

Both services support state management and multi-step workflow orchestration.

Lambda Durable Functions is appropriate when the workflow is closely connected
to business logic and the development team wants to express the flow directly in
a programming language.

AWS Step Functions is appropriate when the workflow needs to be represented as a
state machine, inspected through a visual interface, or integrated directly
with many AWS services.

Durable Functions does not replace Step Functions in every case. The choice
depends on workflow complexity, observability needs, and how the team wants to
manage orchestration logic.

## IMPLEMENTATION CONSIDERATIONS

- A workflow that lasts longer than 15 minutes must be started asynchronously.
- A wait operation does not incur duration charges for on-demand functions, but
  invocation, durable operations, checkpoint data, and execution-history storage
  can still incur cost.
- The callback endpoint must verify signatures, limit IAM permissions, and
  prevent duplicate processing.
- Every payment, inventory update, and database write needs idempotency.
- Set timeouts for each step and the whole workflow so that an order cannot wait
  forever.

## REFERENCES

- [AWS Compute Blog — Building fault-tolerant applications with AWS Lambda durable functions](https://aws.amazon.com/blogs/compute/building-fault-tolerant-long-running-application-with-aws-lambda-durable-functions/)
- [AWS Lambda Developer Guide — Lambda durable functions](https://docs.aws.amazon.com/lambda/latest/dg/durable-functions.html)
- [AWS Lambda Developer Guide — Basic concepts](https://docs.aws.amazon.com/lambda/latest/dg/durable-basic-concepts.html)
- [AWS Lambda Developer Guide — Best practices for durable functions](https://docs.aws.amazon.com/lambda/latest/dg/durable-best-practices.html)
