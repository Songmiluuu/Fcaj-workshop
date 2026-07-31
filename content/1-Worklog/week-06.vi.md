---
title: "Tuần 6 - Progress và upload"
menuTitle: "Tuần 6"
weight: 6
pre: "<b>1.6.</b>"
---

# Tuần 6 - Progress và upload

**Thời gian:** 20–26/07/2026

## Công việc

Triển khai và kiểm tra lesson completion, course progress, upload thumbnail,
material và video có phân quyền.

## Progress

- `POST /api/lessons/{lesson_id}/complete` lưu một completion cho Student đã xác
  thực.
- `GET /api/courses/{course_id}/progress` tính phần trăm từ số lesson hoàn thành
  và tổng lesson của course.
- Request complete lặp vẫn an toàn vì cặp user-lesson là duy nhất.
- Request progress khi chưa enroll bị từ chối.

## Upload

| Loại | File hợp lệ | Giới hạn |
|---|---|---:|
| Thumbnail | JPG, JPEG, PNG, WebP | 10 MiB |
| Material | PDF, DOC, DOCX, PPT, PPTX, TXT, ZIP | 50 MiB |
| Video | MP4, WebM, MOV | 500 MiB |

Mỗi upload kiểm tra quyền sở hữu course hoặc role Admin trước khi đọc file.
Object key nằm trong `courses/{course_id}/` để giới hạn lưu trữ và cleanup theo
course.

## Kết quả

Progress được tính ở server và có ràng buộc chống dữ liệu trùng. Route upload
kiểm tra role, quyền sở hữu, loại file, kích thước và object prefix trước khi
chọn local storage hoặc S3.

## Tài liệu kỹ thuật

- `EduCloud/backend/app/routes/progress_routes.py`
- `EduCloud/backend/app/services/progress_service.py`
- `EduCloud/backend/app/routes/upload_routes.py`
- `EduCloud/backend/app/services/s3_service.py`
