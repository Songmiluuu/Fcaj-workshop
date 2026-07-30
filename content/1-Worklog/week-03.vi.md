---
title: "Tuần 3 - Thiết kế API, dữ liệu và kiểm thử"
menuTitle: "Tuần 3"
weight: 3
pre: "<b>1.3.</b>"
---

**Thời gian:** 15/06/2026 - 21/06/2026  
**Trạng thái ngày 30/07:** Kế hoạch dựng lại; đã có tài liệu báo cáo, case thủ công chưa chạy

## Mục tiêu

- Xác định trách nhiệm của route, service, model và response cho nhóm API được
  giao.
- Thiết kế một luồng người học end-to-end có thể lặp lại khi test bằng Postman.
- Chuẩn bị test data và biến dùng chung mà không nhúng thông tin bí mật.

## Công việc dự kiến và tài liệu báo cáo

| Công việc | Kết quả |
| --- | --- |
| Ánh xạ luồng API từ FastAPI route đến business service và SQLAlchemy model. | Có thể tách logic enrollment/progress khỏi phần đóng gói HTTP response. |
| Xác định khóa Enrollment là user + course và khóa Progress là user + lesson. | Có chiến lược idempotency rõ ràng cho request lặp. |
| Thiết kế luồng test: xác thực → chọn khóa đã publish → enroll → xem My Courses → hoàn thành lesson → đọc progress. | Xác định thứ tự và dữ liệu tiên quyết khi kiểm thử API. |
| Thiết kế luồng upload thumbnail, material và video. | Xác định multipart field, loại tệp, biên dung lượng và quyền course owner. |
| Rà soát cấu trúc Postman collection và template báo cáo test. | Xác định base_url, token, course_id, lesson_id là biến dùng lại; tách trạng thái thiết kế khỏi trạng thái đã chạy. |

## Sản phẩm bàn giao

- Sơ đồ endpoint-to-layer cho Enrollment, Progress, Upload và CloudWatch.
- Luồng test người học có thể tái sử dụng và checklist test data upload.
- Các test case **TC-007 đến TC-011** cho enrollment, completion, progress,
  upload và CloudWatch.
- Cấu trúc kết quả chuẩn: input, expected result, actual result, status và note.

## Tiêu chí kiểm tra

| Kiểm tra | Kết quả |
| --- | --- |
| API contract liệt kê đầy đủ các nhóm endpoint được giao. | Đạt |
| Test plan có case rõ ràng cho từng nhóm tính năng phụ trách. | Đạt |
| Postman collection là JSON hợp lệ và có biến môi trường dùng lại. | Đạt |
| Chỉ đánh dấu Passed sau khi có minh chứng thực thi. | Đạt ở mức quy trình; toàn bộ checklist vẫn là Not Started |

## Minh chứng trong repository

- EduCloud/api/api-contract.md
- EduCloud/api/postman/EduCloud.postman_collection.json
- EduCloud/api/test-plan/test-cases.md
- EduCloud/api/test-plan/test-report-template.md
- EduCloud/backend/app/schemas/enrollment_schema.py
- EduCloud/backend/app/schemas/progress_schema.py
