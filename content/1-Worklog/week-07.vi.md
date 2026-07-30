---
title: "Tuần 7 - API tiến độ và upload cơ bản"
menuTitle: "Tuần 7"
weight: 7
pre: "<b>1.7.</b>"
---

**Thời gian:** 13/07/2026 - 19/07/2026  
**Trạng thái ngày 30/07:** Có mục tiêu trong codebase; cần xác nhận đóng góp cá nhân

> **Cơ sở ghi nhận:** trang này dựng lại công việc dự kiến từ ảnh phân công và
> code được cung cấp. Source chỉ chứng minh hành vi hiện tại, không chứng minh ai
> là tác giả. DELETE/uncomplete và deduplicate thumbnail là extension hỗ trợ,
> không thuộc bảy endpoint cốt lõi trong ảnh phân công.

## Mục tiêu

- Triển khai API complete lesson và xem progress khóa học.
- Ghi riêng uncomplete lesson là extension hỗ trợ có trong codebase.
- Triển khai upload thumbnail, lesson material và video trực tiếp có validation.
- Giữ khả năng phát triển local đồng thời chuẩn bị đường chuyển sang S3.

## Triển khai cốt lõi dự kiến và hành vi codebase hiện tại

### API Progress (cốt lõi và extension hỗ trợ)

| Endpoint | Hành vi codebase hiện tại |
| --- | --- |
| **POST /api/lessons/{lesson_id}/complete** | Tạo hoặc cập nhật Progress của người học thành completed và kiểm tra điều kiện certificate. |
| **DELETE /api/lessons/{lesson_id}/complete** | Chuyển về incomplete, trừ khi khóa học đã được cấp certificate. |
| **GET /api/courses/{course_id}/progress** | Trả completed_lessons, total_lessons, phần trăm làm tròn và completed_lesson_ids. |

Cả ba thao tác đều yêu cầu role Student. Complete và uncomplete kiểm tra
Enrollment trong khóa chứa lesson; GET progress kiểm tra Enrollment trong course
được yêu cầu.

### API upload cơ bản

| Loại upload | Tệp chấp nhận | Giới hạn |
| --- | --- | --- |
| Thumbnail khóa học | .jpg, .jpeg, .png, .webp | 10 MiB |
| Tài liệu bài học | .pdf, .doc, .docx, .ppt, .pptx, .txt, .zip | 50 MiB |
| Video bài học trực tiếp | .mp4, .webm, .mov | 500 MiB |

Route upload kiểm tra course owner hoặc Admin. save_upload lưu theo đường dẫn
gắn với course và chọn local/S3 bằng UPLOAD_STORAGE. Tên thumbnail dựa trên
hash nội dung để cùng một ảnh được tái sử dụng, không sinh object trùng.

## Sản phẩm dự kiến

- Route/service complete/read-progress cốt lõi; hỗ trợ uncomplete được ghi riêng
  là extension của codebase.
- Endpoint upload thumbnail, material và direct video có validation.
- Local storage fallback với response gồm URL, filename, content_type, size và
  storage mode.
- Request Postman ban đầu cho enrollment và upload.

## Tiêu chí xác minh

| Kịch bản | Kết quả mong đợi | Minh chứng hiện tại |
| --- | --- | --- |
| Student đã enroll hoàn thành một trong hai lesson | completed_lessons = 1 và percentage = 50 | Automated assertion |
| Student chưa enroll | HTTP 403 | Guard rõ ràng ở service |
| Khóa hoàn tất đã cấp certificate | Uncomplete trả HTTP 409 | Conflict guard rõ ràng |
| Material dùng đuôi .exe | HTTP 415 | Automated API test |
| Upload cùng thumbnail hai lần | Cùng URL và chỉ một ảnh được lưu | Automated API test |
| Chạy Postman thủ công | Ghi actual response và status | Chưa hoàn thành |

## Minh chứng trong repository

- EduCloud/backend/app/routes/progress_routes.py
- EduCloud/backend/app/services/progress_service.py
- EduCloud/backend/app/routes/upload_routes.py
- EduCloud/backend/app/services/s3_service.py
- EduCloud/backend/tests/test_enrollment_progress.py
- EduCloud/backend/tests/test_course_lesson_api.py
- EduCloud/api/postman/EduCloud.postman_collection.json
