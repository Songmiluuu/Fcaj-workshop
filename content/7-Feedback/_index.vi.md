---
title: "Chia sẻ và góp ý"
weight: 7
chapter: false
pre: "<b>7.</b>"
---

# Chia sẻ và góp ý

> **Cảm nhận tạm thời tại ngày 30/07/2026.** Kỳ thực tập kết thúc vào
> 15/08/2026. Nội dung này phản ánh trải nghiệm đến thời điểm hiện tại và có thể
> được cập nhật sau khi hoàn tất Postman cùng xác minh AWS live.

> **Lưu ý minh chứng:** đây là bản nháp cảm nhận ngôi thứ nhất dựa trên ảnh phân
> công và codebase được cung cấp. Trước khi nộp, tôi phải chỉnh theo trải nghiệm
> thật và chứng minh phần triển khai bằng PR/task hoặc xác nhận mentor.

## Cảm nhận về chương trình

Kỳ thực tập First Cloud AI Journey tạo cơ hội để tôi kết nối kiến thức Khoa học
máy tính với một ứng dụng cloud thực tế. Trong hệ thống nhóm EduCloud, trách
nhiệm cá nhân của tôi là lát cắt API enrollment, tiến độ học và upload, kèm
regression bằng Postman và kiểm tra log CloudWatch. Ranh giới kỹ thuật rõ ràng
này giúp tôi hiểu rằng bàn giao API không chỉ là nhận response thành công mà còn
gồm phân quyền, toàn vẹn dữ liệu, xử lý lỗi, contract tích hợp, test, log vận
hành và minh chứng để người khác kiểm tra.

Trải nghiệm học tập hữu ích nhất đến hiện tại là theo một luồng người học qua
nhiều lớp: enroll khóa đã publish, tải My Courses, complete bài học và tính lại
progress từ database. Việc rà soát extension undo/multipart hỗ trợ bổ sung các
vấn đề như S3 key private, thứ tự part, retry, abort và cleanup. Tôi cũng nhận ra
test tự động dùng mock là minh chứng có giá trị nhưng
không thay thế cho một lần chạy Postman có ghi kết quả hoặc xác minh trên tài
nguyên AWS đã cấu hình.

## Mức độ hài lòng

**Mức hài lòng tạm thời: 4/5 — Hài lòng.**

Tôi hài lòng vì chương trình cho phép áp dụng backend, database, testing và AWS
vào một use case thống nhất; repository đã có phần triển khai và test tự động có
thể đối chiếu với hướng được giao. Minh chứng này xác nhận hành vi code, không tự
xác nhận tác giả cá nhân. Tôi chưa chọn mức tối đa vì khả năng sẵn
sàng của môi trường, tích hợp end-to-end và việc thu thập đủ minh chứng cuối kỳ
vẫn quyết định mức độ trọn vẹn của giai đoạn còn lại.

## Điểm tôi cần cải thiện trong cách làm việc

- Bắt đầu ma trận Postman thủ công sớm hơn và cập nhật actual result trong cùng
  tuần triển khai, thay vì dồn toàn bộ lần chạy sang giai đoạn cuối.
- Lên lịch kiểm tra S3 và CloudWatch live đủ sớm để tách lỗi ứng dụng với lỗi IAM,
  bucket, log streaming hoặc cấu hình môi trường.
- Chia sẻ tóm tắt thay đổi interface và defect tại các mốc tích hợp nhóm, nhất là
  khi enrollment/progress phụ thuộc trạng thái course và upload phụ thuộc quyền
  sở hữu course.
- Thống nhất tên file minh chứng, quy tắc che dữ liệu và người nghiệm thu trước
  khi chụp screenshot.

## Đề xuất cải thiện chương trình

1. **Cung cấp checklist nghiệm thu theo vai trò ngay khi khởi động project.** Mỗi
   vai trò nên biết từ tuần đầu các endpoint, case tích cực/tiêu cực, minh chứng
   AWS và sản phẩm bàn giao bắt buộc.
2. **Chuẩn bị quyền truy cập môi trường dùng chung sớm hơn.** Một bước kiểm tra
   nhanh tài khoản test, IAM permission, S3 prefix, CloudWatch log group và dữ
   liệu phi production sẽ giảm blocker cấu hình ở cuối kỳ.
3. **Dùng chung mẫu Postman environment và test report.** Ví dụ không chứa
   secret, có biến tái sử dụng, assertion, Runner export và liên kết defect sẽ
   giúp kết quả dễ so sánh và review.
4. **Bổ sung các mốc kiểm tra tích hợp cố định.** Buổi kiểm tra ngắn giữa người
   phụ trách API, frontend và AWS/deployment sẽ phát hiện sớm sai khác contract
   hoặc phân quyền trước regression cuối.
5. **Review minh chứng và bảo mật hằng tuần.** Mentor có thể kiểm tra mẫu một
   screenshot hoặc kết quả test mỗi tuần và nhắc che JWT, password, access key
   cùng query string của presigned URL.

## Tôi có giới thiệu chương trình cho bạn bè không?

**Có, với kỳ vọng rõ ràng.** Tôi sẽ giới thiệu chương trình cho các bạn đã có
kiến thức phát triển phần mềm cơ bản và muốn thực hành chuyển yêu cầu ứng dụng
thành phần triển khai theo định hướng AWS, kế hoạch test và báo cáo kỹ thuật. Lý
do giới thiệu là giá trị học tập khi sở hữu một phạm vi tính năng rõ và tích hợp
vào hệ thống nhóm; không phải vì toàn bộ tính năng EduCloud hoặc nghiệm thu AWS
cuối kỳ đã hoàn tất. Người tham gia cũng cần sẵn sàng tự nghiên cứu, thu thập
minh chứng cẩn thận và phối hợp qua ranh giới vai trò.

## Kỳ vọng cho thời gian còn lại

Trước 15/08, ưu tiên của tôi là chạy và export Postman collection đã sửa cho báo
cáo, ghi actual result cho mọi case, xác minh luồng upload trên cấu hình S3
thật, đối chiếu request có kiểm soát với event CloudWatch, retest defect, xin
xác nhận đóng góp và bàn
giao minh chứng đã che dữ liệu nhạy cảm. Tôi sẽ cập nhật phần góp ý nếu kết quả
cuối kỳ làm thay đổi đáng kể đánh giá trên.
