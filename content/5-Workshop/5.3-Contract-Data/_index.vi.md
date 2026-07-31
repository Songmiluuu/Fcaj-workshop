---
title: "API contract và toàn vẹn dữ liệu"
menuTitle: "Contract & dữ liệu"
weight: 3
pre: "<b>5.3.</b>"
---

# API contract và toàn vẹn dữ liệu

## Bảy endpoint cốt lõi được giao

| Method | Path | Người gọi | Kết quả thành công chính |
|---|---|---|---|
| `POST` | `/api/courses/{course_id}/enroll` | Student | Enrollment active đã có hoặc mới |
| `GET` | `/api/my-courses` | Student | Counter và course lấy từ database |
| `POST` | `/api/lessons/{lesson_id}/complete` | Student đã enroll | Lưu completion; có thể trả kết quả certificate |
| `GET` | `/api/courses/{course_id}/progress` | Student đã enroll | Số completed/total/percentage/lesson ID |
| `POST` | `/api/upload/course-thumbnail` | Owner Instructor/Admin | Metadata và URL file |
| `POST` | `/api/upload/lesson-material` | Owner Instructor/Admin | Metadata và URL file |
| `POST` | `/api/upload/video` | Owner Instructor/Admin | Metadata và URL upload trực tiếp |

## Extension hỗ trợ trong codebase

| Method | Path | Người gọi | Kết quả thành công chính |
|---|---|---|---|
| `DELETE` | `/api/lessons/{lesson_id}/complete` | Student đã enroll | Đánh dấu lesson chưa hoàn thành |
| `POST` | `/api/upload/course-thumbnail/import` | Owner Instructor/Admin | Metadata thumbnail đã import/deduplicate |
| `POST` | `/api/upload/video/multipart/start` | Owner Instructor/Admin | S3 key, upload ID, part size |
| `POST` | `/api/upload/video/multipart/part` | Owner Instructor/Admin | Presigned URL sống một giờ |
| `POST` | `/api/upload/video/multipart/complete` | Owner Instructor/Admin | URL S3/CloudFront cuối |
| `POST` | `/api/upload/video/multipart/abort` | Owner Instructor/Admin | Hủy multipart upload |
| `GET` | `/api/admin/cloudwatch-logs` | Admin | Log event gần đây đã cấu hình |

Phân công ban đầu liệt kê bảy endpoint lõi. Nhóm extension được ghi riêng vì
chúng ảnh hưởng đến tích hợp và kiểm thử.

## Quan hệ dữ liệu

{{<mermaid>}}
erDiagram
    USERS ||--o{ ENROLLMENTS : enrolls
    COURSES ||--o{ ENROLLMENTS : contains
    COURSES ||--o{ LESSONS : has
    USERS ||--o{ PROGRESS : records
    COURSES ||--o{ PROGRESS : groups
    LESSONS ||--o{ PROGRESS : completes
    USERS ||--o{ CERTIFICATES : earns
    COURSES ||--o{ CERTIFICATES : awards
{{</mermaid>}}

Hai invariant tại database bảo vệ khi retry:

- `UNIQUE(user_id, course_id)` trên `enrollments`;
- `UNIQUE(user_id, lesson_id)` trên `progress`.

Service query trước khi insert/update để trả response idempotent dễ hiểu; constraint
vẫn cần thiết khi request chạy đồng thời.

## Response envelope chuẩn

Route thành công dùng dạng:

```json
{
  "success": true,
  "message": "Progress loaded",
  "data": {}
}
```

Client phải dùng HTTP status và `success`, sau đó kiểm tra `data` theo từng
route. Không suy luận thành công chỉ từ chuỗi message.

## Error contract

| Status | Ý nghĩa trong phạm vi | Ví dụ |
|---:|---|---|
| 400 | Multipart input không an toàn | Key không khớp `courses/{course_id}/videos/` |
| 401 | Thiếu/sai bearer token | Không có Authorization header |
| 403 | Đã xác thực nhưng không có quyền | Student chưa enroll; Instructor không phải owner |
| 404 | Resource không tồn tại | Course hoặc lesson ID sai |
| 409 | State hiện tại chặn chuyển đổi | Course draft; assessment chưa sẵn sàng; certificate chặn undo |
| 413 | File vượt giới hạn | Material lớn hơn 50 MiB |
| 415 | Không hỗ trợ loại file/content type | Upload `.exe` |
| 422 | FastAPI validation thất bại | Thiếu form field hoặc part number sai |
| 502 | AWS/storage dependency lỗi | Không thể start/complete upload S3 |

Không để stack trace, thông tin bucket/database, token hay presigned URL xuất hiện
trong public log.

## Chuyển đổi trạng thái

```text
course published + assessment published
                |
                v
active enrollment
                |
                v
progress từng lesson ----> hoàn thành mọi lesson
                                  |
                                  v
                         vượt qua final assessment
                                  |
                                  v
                         certificate bất biến
```

Chỉ hoàn thành lesson chưa chứng minh đã vượt qua final assessment. Việc cấp
certificate là integration downstream của hệ thống chung.
