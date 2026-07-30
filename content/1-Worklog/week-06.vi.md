---
title: "Tuần 6 - API Enrollment và My Courses"
menuTitle: "Tuần 6"
weight: 6
pre: "<b>1.6.</b>"
---

**Thời gian:** 06/07/2026 - 12/07/2026  
**Trạng thái ngày 30/07:** Có mục tiêu trong codebase; cần xác nhận đóng góp cá nhân

> **Cơ sở ghi nhận:** trang này dựng lại công việc dự kiến từ ảnh phân công và
> code được cung cấp. Source chỉ chứng minh hành vi hiện tại, không chứng minh
> ai là tác giả.

## Mục tiêu

- Triển khai ghi danh khóa học cho Student đã xác thực.
- Bảo đảm request enroll lặp không gây dữ liệu trùng.
- Tạo response My Courses từ các dòng enrollment, lesson, progress,
  assessment và certificate thật trong database.

## Triển khai dự kiến và hành vi codebase hiện tại

| Endpoint hoặc thành phần | Hành vi codebase hiện tại |
| --- | --- |
| **POST /api/courses/{course_id}/enroll** | Kiểm tra role Student, course tồn tại, trạng thái published và final assessment đã publish; chỉ tạo khi chưa có enrollment. |
| **GET /api/my-courses** | Kiểm tra role Student, trả tổng quan dashboard và tiến độ của từng khóa đã ghi danh. |
| Tổng hợp dashboard | Đếm lesson và progress đã hoàn thành, tính phần trăm làm tròn, trả trạng thái assessment và đếm certificate như khóa hoàn tất. |
| Frontend client | enrollCourse gửi JWT Student; getMyCourses đọc response StudentDashboard có kiểu dữ liệu rõ ràng. |

## Sản phẩm dự kiến

- Route và service enrollment.
- Response dashboard gồm active_courses, lessons_completed,
  completed_courses và danh sách tóm tắt từng khóa.
- Frontend service cho enrollment và My Courses.
- Idempotency nhờ lookup ở service và unique constraint user-course.

## Tiêu chí xác minh

| Kịch bản | Kết quả mong đợi | Minh chứng hiện tại |
| --- | --- | --- |
| Student hợp lệ ghi danh | Tạo và trả Enrollment | Có trong enrollment_service.py |
| Ghi danh lặp | Tái sử dụng dòng hiện có | Service lookup và unique constraint |
| Instructor/Admin gọi endpoint Student | HTTP 403 | Có kiểm tra role rõ ràng |
| Hoàn thành một trong hai lesson | My Courses trả một bài hoàn thành và 50% | Được assert trong test_enrollment_progress.py |
| Course chưa publish hoặc thiếu assessment đã publish | HTTP 409 | Có kiểm tra conflict rõ ràng |

Luồng enrollment/dashboard được bao phủ bởi một trong **7 test node đã chọn và
đều pass ngày 30/07**.

## Minh chứng trong repository

- EduCloud/backend/app/routes/enrollment_routes.py
- EduCloud/backend/app/services/enrollment_service.py
- EduCloud/backend/app/models/enrollment.py
- EduCloud/backend/tests/test_enrollment_progress.py
- EduCloud/frontend/src/services/enrollmentService.ts
- EduCloud/frontend/src/pages/CourseDetailPage.tsx
- EduCloud/frontend/src/pages/MyLearningPage.tsx
