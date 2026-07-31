---
title: "Tuần 5 - Enrollment và My Courses"
menuTitle: "Tuần 5"
weight: 5
pre: "<b>1.5.</b>"
---

# Tuần 5 - Enrollment và My Courses

**Thời gian:** 13–19/07/2026

## Công việc

Triển khai và kiểm tra enrollment cùng My Courses, gồm xử lý request trùng và
giới hạn quyền Student.

## Luồng enrollment

1. Lấy application user từ authentication context.
2. Yêu cầu role Student.
3. Tải course và kiểm tra trạng thái published.
4. Kiểm tra course có final assessment đã publish.
5. Trả enrollment hiện có hoặc tạo một bản ghi mới.

`GET /api/my-courses` tải course đã enroll cùng lesson progress, trạng thái
assessment và certificate phục vụ learner dashboard.

## Kiểm tra

- Student hợp lệ có thể enroll và thấy course trong My Courses.
- Request lặp trả enrollment hiện có, không tạo dữ liệu trùng.
- Thiếu authentication trả 401.
- Token Instructor hoặc Admin trả 403.
- Course không sẵn sàng hoặc chưa publish đầy đủ trả domain error.

## Kết quả

Enrollment xử lý request lặp tại service và được bảo vệ bằng ràng buộc duy nhất
trong database. My Courses đọc trạng thái học tập đã lưu thay vì tin dữ liệu do
client gửi.

## Tài liệu kỹ thuật

- `EduCloud/backend/app/routes/enrollment_routes.py`
- `EduCloud/backend/app/services/enrollment_service.py`
- `EduCloud/backend/app/models/enrollment.py`
- `EduCloud/frontend/src/services/enrollmentService.ts`
