---
title: "Tuần 3 - Thiết kế hợp đồng API và dữ liệu"
menuTitle: "Tuần 3"
weight: 3
pre: "<b>1.3.</b>"
---

# Tuần 3 - Thiết kế hợp đồng API và dữ liệu

**Thời gian:** 22–26/06/2026

## Công việc

Thiết kế API contract, ràng buộc dữ liệu enrollment/progress, validation upload
và biến Postman dùng lại.

## Thiết kế API và dữ liệu

- Chuẩn hóa response thành công với `success`, `message` và `data`.
- Lấy user từ authentication context, không nhận target user ID trong request
  body.
- Giới hạn một bản ghi enrollment cho mỗi cặp user-course.
- Giới hạn một bản ghi progress cho mỗi cặp user-lesson.
- Quy định S3 prefix theo course cho thumbnail, material và video.
- Xác định extension và giới hạn kích thước riêng cho từng loại upload.

## Thiết kế Postman

Collection dùng biến môi trường cho `base_url`, token theo role, `course_id`,
`lesson_id`, `upload_id`, object key và ETag. Script chỉ lưu ID khi response
thành công để các case lỗi không làm hỏng luồng test chính.

## Kết quả

Route contract, quy tắc lưu dữ liệu, giới hạn upload và biến test dùng lại được
đồng bộ trước khi bắt đầu tích hợp.

## Tài liệu kỹ thuật

- `EduCloud/api/openapi.yaml`
- `EduCloud/backend/app/models/enrollment.py`
- `EduCloud/backend/app/models/progress.py`
- `EduCloud/api/postman/EduCloud.postman_collection.json`
