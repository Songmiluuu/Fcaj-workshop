---
title: "Nhật ký công việc"
menuTitle: "Nhật ký"
weight: 1
chapter: false
pre: "<b>1.</b>"
---

# Nhật ký công việc

Nhật ký gồm mười giai đoạn, từ **05/06 đến 14/08/2026**. Phạm vi phụ trách
gồm bảy endpoint ghi danh, tiến độ và upload, kiểm thử hồi quy bằng Postman, kiểm
tra Amazon S3 và đối chiếu log CloudWatch.

| Tuần | Công việc | Thời gian |
|---|---|---|
| [Tuần 1](week-01/) | Rà soát yêu cầu FCAJ, workflow EduCloud, ranh giới công việc nhóm và bảy endpoint được giao. | 05–12/06 |
| [Tuần 2](week-02/) | Xác định quyền Student và Instructor/Admin, tiêu chí thành công, case lỗi và kết quả kiểm tra cần lưu. | 15–19/06 |
| [Tuần 3](week-03/) | Thiết kế hợp đồng API, ràng buộc dữ liệu ghi danh/tiến độ, kiểm tra upload và biến Postman dùng lại. | 22–26/06 |
| [Tuần 4](week-04/) | Đồng bộ nền tảng FastAPI, authentication dependency, quy ước response, lưu trữ PostgreSQL và cấu hình AWS. | 29/06–03/07 |
| [Tuần 5](week-05/) | Triển khai và kiểm tra ghi danh cùng danh sách khóa học của tôi, gồm xử lý request trùng và giới hạn quyền Student. | 06–10/07 |
| [Tuần 6](week-06/) | Triển khai và kiểm tra hoàn thành bài học, tiến độ khóa học, upload thumbnail, tài liệu và video có phân quyền. | 13–17/07 |
| [Tuần 7](week-07/) | Tích hợp API với frontend, authentication và course dùng chung; rà automated regression và chuẩn bị Postman collection theo phạm vi. | 20–24/07 |
| [Tuần 8](week-08/) | Chạy Postman, kiểm tra S3/CloudWatch, retest lỗi, hoàn thiện tài liệu và bàn giao báo cáo. | 27–31/07 |
| [Tuần 9](week-09/) | Rà soát vận hành EduCloud, kiểm soát bảo mật, log AWS và thực hành Well-Architected. | 03–07/08 |
| [Tuần 10](week-10/) | Tổng hợp kiến thức Generative AI, Agentic AI và AWS; hoàn thiện bản tổng kết cùng lộ trình phát triển. | 10–14/08 |

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
