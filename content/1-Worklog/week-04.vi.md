---
title: "Tuần 4 - Nền tảng dữ liệu enrollment và progress"
menuTitle: "Tuần 4"
weight: 4
pre: "<b>1.4.</b>"
---

**Thời gian:** 22/06/2026 - 28/06/2026  
**Trạng thái ngày 30/07:** Có mục tiêu trong codebase; cần xác nhận đóng góp cá nhân

> **Cơ sở ghi nhận:** trang này dựng lại công việc dự kiến từ ảnh phân công và
> code được cung cấp. Source chỉ chứng minh hành vi hiện tại, không chứng minh
> ai là tác giả.

## Mục tiêu

- Xây dựng quy tắc lưu trữ bền vững cho enrollment và tiến độ lesson.
- Bảo vệ tính idempotent ở cả service lẫn database.
- Bổ sung cùng ràng buộc duy nhất cho database phát triển đã tồn tại.

## Công việc dự kiến và bằng chứng codebase hiện tại

| Công việc | Kết quả đã xác minh |
| --- | --- |
| Lập kế hoạch Enrollment gồm user_id, course_id và status. | Model hiện tại có foreign key tới users/courses và unique constraint theo user-course. |
| Lập kế hoạch Progress gồm user_id, course_id, lesson_id và is_completed. | Model hiện tại lưu completion theo người học và chỉ cho một dòng trên mỗi user-lesson. |
| Lập kế hoạch index tương thích cho database cũ. | Hàm migration hiện tại tạo uq_enrollment_user_course và uq_progress_user_lesson khi bảng tồn tại. |
| Lập kế hoạch kiểm tra tương thích lúc ứng dụng khởi động. | Backend hiện gọi ensure_learning_unique_indexes trước khi phục vụ request. |
| Rà soát field frontend cần. | Progress hiện có course, số bài hoàn thành, tổng bài, phần trăm và danh sách lesson ID hoàn thành. |

## Sản phẩm dự kiến

- SQLAlchemy model Enrollment và Progress.
- Bảo vệ tính duy nhất cho database mới lẫn database đã tạo trước đó.
- Response schema nền tảng cho enrollment và progress.

## Tiêu chí kiểm tra

| Tiêu chí | Kết quả |
| --- | --- |
| Một user không thể có hai enrollment cho cùng course. | Có trong model/index hiện tại |
| Một user không thể có hai progress cho cùng lesson. | Có trong model/index hiện tại |
| Progress giữ course_id để tổng hợp theo khóa học hiệu quả. | Có trong model hiện tại |
| Startup áp dụng compatibility index trước khi xử lý API. | Có trong đăng ký main.py |

## Minh chứng trong repository

- EduCloud/backend/app/models/enrollment.py
- EduCloud/backend/app/models/progress.py
- EduCloud/backend/app/database_migrations.py
- EduCloud/backend/app/schemas/enrollment_schema.py
- EduCloud/backend/app/schemas/progress_schema.py
- EduCloud/backend/main.py
