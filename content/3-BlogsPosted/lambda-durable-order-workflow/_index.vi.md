---
title: "XỬ LÝ QUY TRÌNH ĐƠN HÀNG KHÔNG MẤT TRẠNG THÁI VỚI AWS LAMBDA DURABLE FUNCTIONS"
menuTitle: "Lambda Durable Workflow"
weight: 3
pre: "<b>3.3.</b>"
---

# XỬ LÝ QUY TRÌNH ĐƠN HÀNG KHÔNG MẤT TRẠNG THÁI VỚI AWS LAMBDA DURABLE FUNCTIONS

## BÀI TOÁN CỦA MỘT ĐƠN HÀNG CHỜ THANH TOÁN

Phía sau thao tác đặt hàng là nhiều bước liên tiếp: tạo đơn, giữ tồn kho, gọi
cổng thanh toán, chờ ngân hàng phản hồi, xác nhận giao dịch và gửi thông báo.

Quy trình này có thể kéo dài vài phút hoặc vài giờ. Vấn đề xuất hiện khi hệ thống
gặp lỗi giữa chừng. Chẳng hạn, tiền đã được trừ nhưng Lambda bị timeout trước khi
cập nhật trạng thái đơn hàng. Nếu chạy lại toàn bộ function, hệ thống có nguy cơ
thanh toán hai lần. Nếu không chạy lại, đơn hàng có thể bị treo dù khách đã trả
tiền.

Một Lambda invocation thông thường chỉ chạy tối đa 15 phút và không tự ghi nhớ
những bước đã hoàn thành. Developer thường phải tự xây dựng bảng trạng thái, cơ
chế retry, khóa chống xử lý trùng và logic phục hồi.

AWS Lambda Durable Functions giải quyết bài toán này bằng cách bổ sung
checkpoint, replay và wait vào Lambda. Workflow vẫn được viết bằng JavaScript,
TypeScript, Python hoặc Java, nhưng có thể tạm dừng và tiếp tục trong thời gian
tối đa một năm.

## CHECKPOINT VÀ REPLAY HOẠT ĐỘNG NHƯ THẾ NÀO?

Mỗi phần nghiệp vụ được đặt trong một durable step. Khi step hoàn thành, Lambda
lưu kết quả làm checkpoint.

Giả sử workflow gồm:

**Tạo đơn hàng → Giữ tồn kho → Khởi tạo thanh toán → Chờ callback → Xác nhận đơn
hàng**

Nếu hai bước đầu đã hoàn thành nhưng bước thanh toán gặp lỗi mạng, Lambda sẽ gọi
lại handler. Trong quá trình replay, các step đã có checkpoint được bỏ qua và
kết quả cũ được sử dụng lại. Workflow tiếp tục từ bước thanh toán thay vì chạy
lại từ đầu.

Khi cần chờ callback từ ngân hàng hoặc một bước phê duyệt thủ công, function sử
dụng wait operation để tạm dừng. Lambda không giữ một process chạy liên tục và
không tính duration charge trong thời gian chờ đối với on-demand functions.

Mỗi invocation vẫn chịu giới hạn tối đa 15 phút. Thời gian một năm áp dụng cho
toàn bộ durable execution, được hoàn thành qua nhiều invocation, checkpoint và
khoảng tạm dừng.

## KIẾN TRÚC XỬ LÝ ĐƠN HÀNG

Một kiến trúc cơ bản có thể gồm:

**Khách hàng → Amazon API Gateway → Lambda Durable Function → Dịch vụ tồn kho /
Cổng thanh toán / Cơ sở dữ liệu**

Các dịch vụ hỗ trợ:

- Amazon DynamoDB hoặc Amazon RDS lưu đơn hàng và trạng thái nghiệp vụ.
- Amazon EventBridge tiếp nhận sự kiện thay đổi trạng thái.
- Amazon SNS hoặc Amazon SES gửi thông báo cho khách hàng.
- Amazon CloudWatch lưu log, metric và cảnh báo.
- Amazon SQS Dead-Letter Queue giữ lại sự kiện của những workflow thất bại vĩnh
  viễn.

## LUỒNG XỬ LÝ

### Bước 1: Tiếp nhận yêu cầu

Frontend gửi yêu cầu đặt hàng đến API Gateway. Backend tạo order ID và khởi động
Durable Function theo cơ chế bất đồng bộ.

API có thể trả về HTTP 202 Accepted cùng order ID thay vì giữ kết nối trong suốt
quá trình thanh toán. Frontend sử dụng order ID để kiểm tra trạng thái đơn.

### Bước 2: Tạo đơn và giữ tồn kho

Durable Function tạo đơn hàng với trạng thái PENDING_PAYMENT, sau đó gọi dịch vụ
tồn kho để giữ sản phẩm.

Order ID nên được sử dụng làm khóa idempotency. Nếu request bị gửi lại, dịch vụ
tồn kho phải trả về kết quả cũ thay vì tiếp tục trừ thêm số lượng.

### Bước 3: Khởi tạo thanh toán

Function gọi API của cổng thanh toán và truyền một idempotency key, ví dụ:

    payment-order-847219

Trường hợp cổng thanh toán đã trừ tiền nhưng response bị mất, Lambda có thể retry
request. Cùng một idempotency key giúp cổng thanh toán nhận ra giao dịch cũ và
tránh tạo thêm giao dịch mới.

Checkpoint giúp hạn chế xử lý lại, nhưng không thay thế idempotency. Các thao tác
có side effect như trừ tiền, cập nhật database, giữ tồn kho hoặc gửi thông báo
vẫn phải được thiết kế để xử lý an toàn khi request bị lặp.

### Bước 4: Chờ callback

Sau khi tạo giao dịch, workflow sử dụng waitForCallback để tạm dừng.

Khi ngân hàng hoàn tất xử lý, webhook gửi kết quả đến một API riêng. API này cần
xác minh chữ ký, kiểm tra order ID và transaction ID, đồng thời bảo đảm callback
chưa được xử lý trước đó.

Callback hợp lệ sẽ đánh thức durable execution. Workflow tiếp tục ngay tại bước
đang chờ mà không phải tạo lại đơn hoặc khởi tạo lại thanh toán.

### Bước 5: Xác nhận đơn hàng

Nếu thanh toán thành công, Durable Function cập nhật đơn sang trạng thái PAID,
xác nhận phần tồn kho đã giữ và phát sự kiện OrderConfirmed.

Các công việc như gửi email, tạo yêu cầu giao hàng hoặc cập nhật hệ thống kế toán
có thể được xử lý bởi những consumer riêng. Nhờ đó, quá trình xác nhận đơn không
phụ thuộc trực tiếp vào dịch vụ email hay vận chuyển.

## XỬ LÝ LỖI VÀ HOÀN TÁC NGHIỆP VỤ

Lỗi mạng, HTTP 429 hoặc HTTP 503 có thể retry với exponential backoff. Những lỗi
như thẻ hết hạn, sản phẩm hết hàng hoặc callback không hợp lệ là lỗi nghiệp vụ và
không nên retry liên tục.

Nếu workflow thất bại sau khi đã hoàn thành một số bước, hệ thống cần chạy các
hành động bù trừ theo mô hình Saga:

- Đã giữ tồn kho nhưng thanh toán thất bại: giải phóng tồn kho.
- Đã thanh toán nhưng không thể xử lý đơn: hoàn tiền hoặc chuyển sang hàng đợi
  xử lý thủ công.
- Khách không thanh toán trước thời hạn: hủy đơn và trả lại sản phẩm.
- Callback đến sau khi đơn đã hết hạn: đưa giao dịch vào quy trình đối soát.

Durable Functions chịu trách nhiệm lưu tiến trình và phục hồi workflow, nhưng
developer vẫn phải định nghĩa rõ quy tắc hoàn tiền, hủy đơn và trả lại tồn kho.

## TRÁNH SIDE EFFECT KHI REPLAY

Do handler được replay từ đầu, phần code nằm ngoài durable step phải tạo ra kết
quả ổn định.

Các thao tác như lấy thời gian hiện tại, tạo UUID ngẫu nhiên, gọi external API
hoặc ghi dữ liệu không nên đặt trực tiếp bên ngoài step. Nếu payment ID được tạo
ngẫu nhiên mỗi lần handler chạy, quá trình replay có thể sinh ra một ID khác với
lần thực thi ban đầu.

Những giá trị này nên được truyền từ input hoặc tạo bên trong một step đã được
checkpoint.

## GIÁM SÁT TRÊN PRODUCTION

Log nên có durable execution ID, order ID, tên step, số lần retry và mã giao dịch
thanh toán.

CloudWatch Alarm có thể cảnh báo khi số workflow FAILED hoặc TIMED_OUT tăng bất
thường. EventBridge hỗ trợ gửi thông báo khi trạng thái execution thay đổi. Với
invocation bất đồng bộ, nên cấu hình SQS Dead-Letter Queue để giữ lại sự kiện ban
đầu khi workflow thất bại vĩnh viễn.

Cơ sở dữ liệu vẫn phải là nơi lưu trạng thái nghiệp vụ chính thức. Execution
history của Lambda phục vụ điều phối và khôi phục, không nên thay thế bảng đơn
hàng hoặc sổ giao dịch.

Một tác vụ reconciliation chạy định kỳ cũng cần thiết để phát hiện trường hợp
cổng thanh toán đã ghi nhận tiền nhưng trạng thái đơn hàng chưa được cập nhật.

## TRIỂN KHAI PHIÊN BẢN MỚI

Durable execution có thể tồn tại nhiều ngày trong khi đội phát triển tiếp tục
cập nhật code. Nếu một workflow đang chạy bị replay bằng handler có cấu trúc step
khác, checkpoint cũ có thể không còn tương thích.

Durable Function nên được gọi thông qua Lambda version hoặc alias cụ thể thay vì
$LATEST. Workflow đang hoạt động tiếp tục sử dụng phiên bản code ban đầu, còn
đơn hàng mới được chuyển sang phiên bản mới.

Không nên tùy tiện đổi tên hoặc thay đổi ý nghĩa của những step vẫn đang được sử
dụng bởi các execution chưa hoàn thành.

## DURABLE FUNCTIONS VÀ STEP FUNCTIONS

Cả hai đều hỗ trợ quản lý trạng thái và điều phối workflow nhiều bước.

Lambda Durable Functions phù hợp khi workflow gắn chặt với business logic và đội
phát triển muốn viết luồng xử lý trực tiếp bằng ngôn ngữ lập trình.

AWS Step Functions phù hợp khi cần biểu diễn workflow bằng state machine, quan
sát luồng qua giao diện trực quan hoặc tích hợp trực tiếp với nhiều dịch vụ AWS.

Durable Functions không thay thế Step Functions trong mọi trường hợp. Lựa chọn
phụ thuộc vào độ phức tạp của quy trình, nhu cầu quan sát và cách đội phát triển
muốn quản lý orchestration logic.

## MỘT SỐ LƯU Ý

- Workflow kéo dài hơn 15 phút phải được khởi động bất đồng bộ.
- Wait operation không phát sinh duration charge đối với on-demand functions,
  nhưng vẫn có chi phí invocation, durable operation, dữ liệu checkpoint và lưu
  execution history.
- Callback endpoint phải xác minh chữ ký, giới hạn quyền IAM và chống xử lý
  trùng.
- Mọi thao tác thanh toán, cập nhật tồn kho và ghi database đều cần idempotency.
- Cần đặt timeout cho từng bước và toàn bộ workflow để đơn hàng không nằm ở
  trạng thái chờ vô thời hạn.

## TÀI LIỆU THAM KHẢO

- [AWS Compute Blog — Building fault-tolerant applications with AWS Lambda durable functions](https://aws.amazon.com/blogs/compute/building-fault-tolerant-long-running-application-with-aws-lambda-durable-functions/)
- [AWS Lambda Developer Guide — Lambda durable functions](https://docs.aws.amazon.com/lambda/latest/dg/durable-functions.html)
- [AWS Lambda Developer Guide — Basic concepts](https://docs.aws.amazon.com/lambda/latest/dg/durable-basic-concepts.html)
- [AWS Lambda Developer Guide — Best practices for durable functions](https://docs.aws.amazon.com/lambda/latest/dg/durable-best-practices.html)
