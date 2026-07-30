---
title: "Tuần 5 - Nền tảng tích hợp FastAPI"
menuTitle: "Tuần 5"
weight: 5
pre: "<b>1.5.</b>"
---

**Thời gian:** 29/06/2026 - 05/07/2026  
**Trạng thái ngày 30/07:** Có mục tiêu trong codebase; cần xác nhận đóng góp cá nhân

> **Cơ sở ghi nhận:** trang này dựng lại công việc dự kiến từ ảnh phân công và
> code được cung cấp. Source chỉ chứng minh hành vi hiện tại, không chứng minh
> ai là tác giả.

## Mục tiêu

- Đăng ký các nhóm API phụ trách dưới cùng prefix **/api**.
- Tập trung cấu hình môi trường cho storage và monitoring.
- Dùng chung quy ước xác thực và response trước khi bổ sung business logic.

## Công việc dự kiến và bằng chứng codebase hiện tại

| Công việc | Kết quả đã xác minh |
| --- | --- |
| Lập kế hoạch đăng ký router enrollment/progress/upload cốt lõi và rà router Admin hỗ trợ. | Module hiện tại dùng settings.API_PREFIX, mặc định là /api. |
| Lập kế hoạch dùng lại get_current_user cho endpoint được bảo vệ. | Route enrollment, progress, upload và CloudWatch hỗ trợ dùng cùng dependency. |
| Lập kế hoạch dùng helper success-response chung. | Response thành công hiện có success, message và data. |
| Lập kế hoạch cấu hình storage theo biến môi trường. | UPLOAD_STORAGE chọn local hoặc S3; local path, bucket, Region và public base URL đều cấu hình được. |
| Lập kế hoạch cờ monitoring và ghi nhận request. | AWS_MONITORING_ENABLED và AWS_CLOUDWATCH_LOG_GROUP là cấu hình ngoài source; middleware ghi route, status và duration. |

## Sản phẩm dự kiến

- Tích hợp route FastAPI cho các nhóm API được giao.
- Nền tảng xác thực và success response dùng chung.
- Cấu hình môi trường cho local upload, S3 và CloudWatch.
- Chỉ mount thư mục upload local khi chạy ở chế độ local.

## Tiêu chí kiểm tra

| Tiêu chí | Kết quả |
| --- | --- |
| Router cốt lõi và hỗ trợ dùng cùng prefix /api. | Có trong codebase được cung cấp |
| Handler được bảo vệ phải lấy current-user context trước business logic. | Đạt |
| Đổi storage mode không cần sửa source code. | Đạt |
| Secret và tên log group riêng của môi trường không nằm trong giá trị commit. | Đạt trong .env.example; giá trị thật phải tiếp tục không commit |

## Minh chứng trong repository

- EduCloud/backend/main.py
- EduCloud/backend/app/config.py
- EduCloud/backend/.env.example
- EduCloud/backend/app/utils/response.py
- EduCloud/backend/app/middleware/auth_middleware.py
- EduCloud/backend/app/services/monitoring_service.py
