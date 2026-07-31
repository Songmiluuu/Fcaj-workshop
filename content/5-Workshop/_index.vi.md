---
title: "Thực hành API"
menuTitle: "Thực hành"
weight: 5
chapter: true
pre: "<b>5.</b>"
---

# Thực hành độ tin cậy API EduCloud

Phạm vi tôi phụ trách trong project nhóm EduCloud gồm:

- API ghi danh và danh sách khóa học của Student.
- API hoàn thành bài học và tính tiến độ khóa học.
- Tải lên thumbnail, tài liệu và video với phân quyền.
- Kiểm thử tích cực/tiêu cực bằng Postman và kiểm tra log Amazon CloudWatch.

Hệ thống EduCloud chung còn có frontend, xác thực Cognito, quản lý khóa học,
assessment, certificate, trang quản trị, deployment và database do cả nhóm phối
hợp. Các thành phần đó chỉ được nhắc như dependency hoặc ranh giới tích hợp; báo
cáo không nhận toàn bộ là đóng góp cá nhân.

Codebase hiện tại còn mở rộng bảy endpoint cốt lõi bằng hoàn tác progress,
import/deduplicate thumbnail, điều khiển multipart video và Admin log-reader.
Phần thực hành ghi chúng là hành vi hỗ trợ xung quanh phạm vi API được giao.

{{< staticimage path="images/architect.jpg" alt="Kiến trúc AWS tổng thể của EduCloud" >}}

## Kết quả học tập

Sau phần thực hành, người đọc có thể:

1. giải thích luồng ghi danh, tiến độ và tải lên;
2. gọi API với token Student/Instructor/Admin đúng vai trò;
3. kiểm tra phân quyền, idempotency, file validation và phép tính tiến độ;
4. thực hành tải lên trực tiếp cốt lõi và multipart hỗ trợ an toàn;
5. dùng Postman assertion và automated test mà không công khai secret;
6. xác định log ứng dụng nào có thể kiểm tra trên CloudWatch; và
7. dọn dữ liệu kiểm thử cùng multipart upload bị bỏ dở trên S3.

## Bản đồ thực hành

| Phần | Kết quả |
|---|---|
| [5.1 Tổng quan](5.1-overview/) | Hiểu kiến trúc nhóm và ranh giới API của Luân |
| [5.2 Chuẩn bị](5.2-prerequisites/) | Chuẩn bị công cụ, test identity và dữ liệu an toàn |
| [5.3 Hợp đồng và dữ liệu](5.3-contract-data/) | Hiểu model, constraint, response và error |
| [5.4 API ghi danh](5.4-enrollment/) | Ghi danh idempotent và tải danh sách khóa học của tôi |
| [5.5 API tiến độ](5.5-progress/) | Complete/đọc progress và xem luồng undo hỗ trợ |
| [5.6 API tải lên](5.6-upload/) | Kiểm tra tải lên cốt lõi và multipart video hỗ trợ |
| [5.7 Bảo mật và độ tin cậy](5.7-security/) | Kiểm tra role, ownership, key prefix và retry |
| [5.8 Kiểm thử và minh chứng](5.8-validation/) | Chạy Postman/test và kiểm tra CloudWatch |
| [5.9 Dọn dẹp và bàn giao](5.9-cleanup/) | Dọn tài nguyên test và đóng gói minh chứng |

Các hình AWS Console ghi lại cấu hình của môi trường EduCloud dùng chung trong
nhóm. Hình được đặt tại những bước thiết lập có sử dụng cùng tài nguyên nhóm để
tích hợp và kiểm tra.
