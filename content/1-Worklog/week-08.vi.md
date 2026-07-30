---
title: "Tuần 8 - Tích hợp frontend và regression tự động"
menuTitle: "Tuần 8"
weight: 8
pre: "<b>1.8.</b>"
---

**Thời gian:** 20/07/2026 - 26/07/2026  
**Trạng thái ngày 30/07:** Có mục tiêu trong codebase; cần xác nhận đóng góp cá nhân

> **Cơ sở ghi nhận:** hành vi tích hợp được xác minh trong source được cung cấp,
> nhưng metadata của repository không tự chứng minh tác giả cá nhân.

## Mục tiêu

- Kết nối nhóm API phụ trách với giao diện người học và giảng viên.
- Xác minh workflow dùng dữ liệu database bằng automated regression test.
- Audit Postman collection trước lần chạy end-to-end cuối.

## Công việc dự kiến và bằng chứng codebase hiện tại

| Công việc | Kết quả đã xác minh |
| --- | --- |
| Lập kế hoạch/rà thao tác enroll tại trang chi tiết khóa học. | Frontend hiện gọi enrollCourse và hiển thị lỗi API cho người học. |
| Lập kế hoạch/rà My Courses trên dashboard Student. | Counter và phần trăm từng khóa hiện dùng typed API response. |
| Lập kế hoạch/rà progress tại trang học. | Trang hiện tải completed_lesson_ids và gọi POST/DELETE khi đổi trạng thái; DELETE là extension. |
| Lập kế hoạch/rà upload service trong luồng soạn khóa học. | Thumbnail và lesson asset hiện dùng FormData, không ép Content-Type JSON sai. |
| Rà regression backend. | Test hiện bao phủ enrollment/progress từ database, từ chối upload, hành vi thumbnail hỗ trợ và phân quyền. |
| Audit Postman collection cũ trong repository nhóm theo API contract. | Collection cũ thiếu My Courses, Progress, multipart video và CloudWatch; collection đã sửa cho báo cáo hiện hợp lệ JSON nhưng chưa chạy. |

## Sản phẩm dự kiến

- Frontend client có kiểu dữ liệu cho response enrollment, progress và upload.
- Workflow enrollment/progress tích hợp trên giao diện người học.
- Automated regression cho các quy tắc dữ liệu và upload chính.
- Danh sách khoảng trống Postman chuyển sang Tuần 9–10 xử lý.

## Tiêu chí xác minh

| Tiêu chí | Kết quả |
| --- | --- |
| Đường dẫn endpoint frontend khớp route backend. | Đạt qua source review |
| Progress UI lấy trạng thái từ completed_lesson_ids của API. | Đạt |
| FormData để trình duyệt tự tạo multipart boundary. | Đạt trong apiClient.ts |
| Workflow enrollment/progress dựa trên database pass automated regression. | Đạt trong lần chạy mục tiêu ngày 30/07 |
| Postman collection bao phủ mọi endpoint được giao và có kết quả thực thi. | Chưa đạt; lên lịch xác minh cuối |

## Minh chứng trong repository

- EduCloud/frontend/src/services/apiClient.ts
- EduCloud/frontend/src/services/enrollmentService.ts
- EduCloud/frontend/src/services/progressService.ts
- EduCloud/frontend/src/services/uploadService.ts
- EduCloud/frontend/src/pages/LearningPage.tsx
- EduCloud/frontend/src/pages/MyLearningPage.tsx
- EduCloud/backend/tests/test_enrollment_progress.py
- EduCloud/backend/tests/test_course_lesson_api.py
- EduCloud/api/postman/EduCloud.postman_collection.json
