---
title: "Nhật ký công việc"
menuTitle: "Worklog"
weight: 1
chapter: false
pre: "<b>1.</b>"
---

# Nhật ký công việc

Worklog kỹ thuật gồm tám tuần, từ **15/06 đến 14/08/2026**. Phạm vi phụ trách
gồm bảy endpoint Enrollment, Progress và Upload, regression bằng Postman, kiểm
tra Amazon S3 và đối chiếu log CloudWatch.

| Tuần | Công việc | Thời gian |
|---|---|---|
| [Tuần 1](week-01/) | Rà soát yêu cầu FCAJ, workflow EduCloud, ranh giới công việc nhóm và bảy endpoint được giao. | 15–21/06 |
| [Tuần 2](week-02/) | Xác định quyền Student và Instructor/Admin, tiêu chí thành công, case lỗi và kết quả kiểm tra cần lưu. | 22–28/06 |
| [Tuần 3](week-03/) | Thiết kế API contract, ràng buộc dữ liệu enrollment/progress, validation upload và biến Postman dùng lại. | 29/06–05/07 |
| [Tuần 4](week-04/) | Đồng bộ nền tảng FastAPI, authentication dependency, quy ước response, lưu trữ PostgreSQL và cấu hình AWS. | 06–12/07 |
| [Tuần 5](week-05/) | Triển khai và kiểm tra enrollment cùng My Courses, gồm xử lý request trùng và giới hạn quyền Student. | 13–19/07 |
| [Tuần 6](week-06/) | Triển khai và kiểm tra lesson completion, course progress, upload thumbnail, material và video có phân quyền. | 20–26/07 |
| [Tuần 7](week-07/) | Tích hợp API với frontend, authentication và course dùng chung; rà automated regression và chuẩn bị Postman collection theo phạm vi. | 27–31/07 |
| [Tuần 8](week-08/) | Chạy Postman, kiểm tra S3/CloudWatch, retest lỗi, hoàn thiện tài liệu và bàn giao báo cáo. | 01–14/08 |

## Phạm vi API được giao

- `POST /api/courses/{course_id}/enroll`
- `GET /api/my-courses`
- `POST /api/lessons/{lesson_id}/complete`
- `GET /api/courses/{course_id}/progress`
- `POST /api/upload/course-thumbnail`
- `POST /api/upload/lesson-material`
- `POST /api/upload/video`

Multipart video, hoàn tác progress, xử lý thumbnail từ xa và Admin CloudWatch
reader là các phần hỗ trợ cho quá trình tích hợp và kiểm thử.
