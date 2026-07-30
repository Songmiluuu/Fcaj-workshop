---
title: "Workshop API"
menuTitle: "Workshop"
weight: 5
chapter: true
pre: "<b>5.</b>"
---

# Workshop độ tin cậy API EduCloud

Workshop thực hành này trình bày đúng phần việc được giao cho **Nguyễn Song Minh
Luân** trong project nhóm EduCloud:

- API ghi danh và danh sách khóa học của Student.
- API hoàn thành bài học và tính tiến độ khóa học.
- Upload thumbnail, tài liệu và video với phân quyền.
- Kiểm thử tích cực/tiêu cực bằng Postman và kiểm tra log Amazon CloudWatch.

Hệ thống EduCloud chung còn có frontend, xác thực Cognito, quản lý khóa học,
assessment, certificate, trang quản trị, deployment và database do cả nhóm phối
hợp. Các thành phần đó chỉ được nhắc như dependency hoặc ranh giới tích hợp; báo
cáo không nhận toàn bộ là đóng góp cá nhân.

Codebase được cung cấp còn mở rộng bảy endpoint cốt lõi bằng hoàn tác progress,
import/deduplicate thumbnail, điều khiển multipart video và Admin log-reader.
Workshop ghi chúng là hành vi hỗ trợ. Lịch sử Git không tự quy các phần triển khai
được dẫn cho Luân, nên quyền sở hữu cá nhân vẫn cần PR/task/xác nhận mentor.

{{< staticimage path="images/educloud-aws-architecture.png" alt="Kiến trúc AWS tổng thể của EduCloud" >}}

## Kết quả học tập

Sau workshop, người đọc có thể:

1. giải thích luồng enrollment, progress và upload;
2. gọi API với token Student/Instructor/Admin đúng vai trò;
3. kiểm tra phân quyền, idempotency, file validation và phép tính tiến độ;
4. thực hành upload trực tiếp cốt lõi và multipart hỗ trợ an toàn;
5. dùng Postman assertion và automated test mà không công khai secret;
6. xác định log ứng dụng nào có thể kiểm tra trên CloudWatch; và
7. dọn test data cùng multipart upload bị bỏ dở trên S3.

## Bản đồ workshop

| Phần | Kết quả |
|---|---|
| [5.1 Tổng quan](5.1-overview/) | Hiểu kiến trúc nhóm và ranh giới API của Luân |
| [5.2 Chuẩn bị](5.2-prerequisites/) | Chuẩn bị công cụ, test identity và dữ liệu an toàn |
| [5.3 Contract và dữ liệu](5.3-contract-data/) | Hiểu model, constraint, response và error |
| [5.4 API ghi danh](5.4-enrollment/) | Ghi danh idempotent và tải My Courses |
| [5.5 API tiến độ](5.5-progress/) | Complete/đọc progress và xem luồng undo hỗ trợ |
| [5.6 API upload](5.6-upload/) | Kiểm tra upload cốt lõi và multipart video hỗ trợ |
| [5.7 Bảo mật và độ tin cậy](5.7-security/) | Kiểm tra role, ownership, key prefix và retry |
| [5.8 Kiểm thử và minh chứng](5.8-validation/) | Chạy Postman/test và kiểm tra CloudWatch |
| [5.9 Cleanup và bàn giao](5.9-cleanup/) | Dọn tài nguyên test và đóng gói minh chứng |

{{% notice info %}}
Codebase được cung cấp có các luồng trên. Screenshot Postman Runner, S3 thật và
CloudWatch vẫn là minh chứng nghiệm thu cần chụp bằng tài khoản của Luân trước khi
nộp; báo cáo không dùng lại ảnh AWS của sinh viên trong bài mẫu.
{{% /notice %}}
