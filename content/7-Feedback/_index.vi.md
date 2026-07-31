---
title: "Chia sẻ và góp ý"
menuTitle: "Sharing and Feedback"
weight: 7
chapter: false
pre: "<b>7.</b>"
---

# Chia sẻ và góp ý

## Cảm nhận về chương trình

Kỳ thực tập First Cloud AI Journey tạo cơ hội để tôi kết nối kiến thức Khoa học
máy tính với một ứng dụng cloud thực tế. Trong hệ thống nhóm EduCloud, trách
nhiệm cá nhân của tôi là lát cắt API enrollment, tiến độ học và upload, kèm
regression bằng Postman và kiểm tra log CloudWatch. Ranh giới kỹ thuật rõ ràng
này giúp tôi hiểu rằng bàn giao API cần response đúng, phân quyền, toàn vẹn dữ
liệu, xử lý lỗi, contract tích hợp, test và log vận hành có thể kiểm tra.

Trải nghiệm học tập hữu ích nhất đến hiện tại là theo một luồng người học qua
nhiều lớp: enroll khóa đã publish, tải My Courses, complete bài học và tính lại
progress từ database. Việc rà soát extension undo/multipart hỗ trợ bổ sung các
vấn đề như S3 key private, thứ tự part, retry, abort và cleanup. Tôi cũng nhận ra
test tự động dùng mock có giá trị nhất khi đi kèm một lần chạy Postman manual và
kiểm tra trên tài nguyên AWS đã cấu hình. Tôi đã hoàn tất cả hai trong đợt
validation cuối.

## Mức độ hài lòng

**Mức hài lòng: 4/5 — Hài lòng.**

Tôi hài lòng vì chương trình cho phép áp dụng backend, database, testing và AWS
vào một use case thống nhất. Phần triển khai, automated test, Postman manual và
kiểm tra S3/CloudWatch trên môi trường dùng chung đã bao phủ phạm vi được giao.
Tôi chưa chọn mức tối đa vì vẫn cần cải thiện việc thu thập kết quả từ sớm và
giao tiếp thường xuyên hơn với nhóm.

## Điểm tôi cần cải thiện trong cách làm việc

- Bắt đầu ma trận Postman thủ công sớm hơn và cập nhật actual result trong cùng
  tuần triển khai, thay vì dồn toàn bộ lần chạy sang giai đoạn cuối.
- Lên lịch kiểm tra S3 và CloudWatch live đủ sớm để tách lỗi ứng dụng với lỗi IAM,
  bucket, log streaming hoặc cấu hình môi trường.
- Chia sẻ tóm tắt thay đổi interface và defect tại các mốc tích hợp nhóm, nhất là
  khi enrollment/progress phụ thuộc trạng thái course và upload phụ thuộc quyền
  sở hữu course.
- Thống nhất định dạng kết quả, quy tắc che dữ liệu và người nghiệm thu trước
  khi đóng gói báo cáo.

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
5. **Review kiểm thử và bảo mật hằng tuần.** Mentor có thể kiểm tra mẫu một kết
   quả test mỗi tuần và nhắc bảo vệ JWT, password, access key cùng query string
   của presigned URL.

## Tôi có giới thiệu chương trình cho bạn bè không?

**Có, với kỳ vọng rõ ràng.** Tôi sẽ giới thiệu chương trình cho các bạn đã có
kiến thức phát triển phần mềm cơ bản và muốn thực hành chuyển yêu cầu ứng dụng
thành phần triển khai theo định hướng AWS, kế hoạch test và báo cáo kỹ thuật. Lý
do giới thiệu là giá trị học tập khi sở hữu một phạm vi tính năng rõ và tích hợp
vào hệ thống nhóm; không phải vì toàn bộ tính năng EduCloud hoặc nghiệm thu AWS
cuối kỳ đã hoàn tất. Người tham gia cũng cần sẵn sàng tự nghiên cứu, thu thập
minh chứng cẩn thận và phối hợp qua ranh giới vai trò.

## Ưu tiên bàn giao cuối

Phần việc bàn giao còn lại là liên kết contribution đã merge, giữ Postman/OpenAPI
theo phạm vi đồng bộ với source revision đó, rà dữ liệu public đã che và cùng
nhóm đóng checklist cuối của báo cáo.
