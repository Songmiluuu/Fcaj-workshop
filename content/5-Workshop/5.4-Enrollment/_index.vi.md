---
title: "API ghi danh"
menuTitle: "API ghi danh"
weight: 4
pre: "<b>5.4.</b>"
---

# API ghi danh

Minh chứng implementation:

- `backend/app/routes/enrollment_routes.py`
- `backend/app/services/enrollment_service.py`
- `backend/app/models/enrollment.py`
- `backend/app/database_migrations.py`
- `frontend/src/services/enrollmentService.ts`

## Ghi danh khóa học

```http
POST /api/courses/42/enroll
Authorization: Bearer STUDENT_JWT
```

Response thành công dùng envelope chung:

```json
{
  "success": true,
  "message": "Course enrolled",
  "data": {
    "id": 91,
    "course_id": 42,
    "status": "active"
  }
}
```

### Thứ tự quyết định của server

{{<mermaid>}}
flowchart TD
    A["Request đã xác thực"] --> B{"role == student?"}
    B -- Không --> X403["403 Student access required"]
    B -- Có --> C{"course tồn tại?"}
    C -- Không --> X404["404 Course not found"]
    C -- Có --> D{"course published?"}
    D -- Không --> X409A["409 Not open for enrollment"]
    D -- Có --> E{"final assessment published?"}
    E -- Không --> X409B["409 Assessment not ready"]
    E -- Có --> F{"đã có enrollment?"}
    F -- Có --> R["Trả enrollment hiện hữu"]
    F -- Không --> I["Insert active enrollment"]
    I --> R
{{</mermaid>}}

Thứ tự này không tạo quyền truy cập content draft và trả domain error rõ ràng.
Nhánh trả record hiện hữu giúp retry thông thường có tính idempotent. Unique index
user/course tại database vẫn bắt buộc khi request đồng thời.

## Tải My Courses

```http
GET /api/my-courses
Authorization: Bearer STUDENT_JWT
```

Service join enrollment, course và instructor, sau đó tính lesson count, progress
đã complete, assessment state và certificate count.

```json
{
  "success": true,
  "message": "My courses loaded",
  "data": {
    "active_courses": 1,
    "lessons_completed": 1,
    "completed_courses": 0,
    "courses": [
      {
        "id": 42,
        "title": "AWS Foundations",
        "instructor": "Instructor Test",
        "status": "active",
        "completed_lessons": 1,
        "total_lessons": 2,
        "percentage": 50,
        "assessment_required": true,
        "assessment_passed": false,
        "ready_for_assessment": false
      }
    ]
  }
}
```

Client phải xem các giá trị này là dữ liệu chuẩn từ server, không cache enrollment
hay phần trăm tự tạo ở local.

## Kiểm thử nghiệm thu

| Case | Token/dữ liệu | Kỳ vọng |
|---|---|---|
| ENR-01 | Student + course đủ điều kiện | 200 và enrollment active |
| ENR-02 | Lặp ENR-01 | 200 và cùng enrollment ID |
| ENR-03 | Không token | 401 |
| ENR-04 | Token Instructor | 403 |
| ENR-05 | Course không tồn tại | 404 |
| ENR-06 | Course draft/hidden | 409 |
| ENR-07 | Assessment chưa publish | 409 |
| ENR-08 | Student gọi My Courses | Counter và course array từ DB |

Chạy bốn case đầu trực tiếp trong folder Postman **1. Enrollment**. Với case trạng
thái 404/409, chuẩn bị database fixture riêng thay vì sửa course production chung.
