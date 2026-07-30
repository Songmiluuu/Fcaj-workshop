---
title: "API tiến độ"
menuTitle: "API tiến độ"
weight: 5
pre: "<b>5.5.</b>"
---

# API tiến độ

Minh chứng implementation:

- `backend/app/routes/progress_routes.py`
- `backend/app/services/progress_service.py`
- `backend/app/models/progress.py`
- `frontend/src/services/progressService.ts`
- `backend/tests/test_enrollment_progress.py`

## Complete cốt lõi và undo hỗ trợ

```http
POST /api/lessons/7/complete
Authorization: Bearer STUDENT_JWT
```

```json
{
  "success": true,
  "message": "Lesson completed",
  "data": {
    "lesson_id": 7,
    "course_id": 42,
    "is_completed": true,
    "certificate_issued": false,
    "certificate_code": null
  }
}
```

Phân công cốt lõi dùng POST để complete lesson. Codebase được cung cấp có thêm
`DELETE` trên cùng path làm extension undo hỗ trợ. Service:

1. yêu cầu role `student`;
2. tìm lesson hoặc trả 404;
3. kiểm tra đã enroll course của lesson hoặc trả 403;
4. insert/update đúng một progress row;
5. chặn undo bằng 409 sau khi đã có certificate; và
6. để certificate service của hệ thống chung đánh giá điều kiện downstream.

## Đọc tiến độ

```http
GET /api/courses/42/progress
Authorization: Bearer STUDENT_JWT
```

```json
{
  "success": true,
  "message": "Progress loaded",
  "data": {
    "course_id": 42,
    "completed_lessons": 1,
    "total_lessons": 2,
    "percentage": 50,
    "completed_lesson_ids": [7]
  }
}
```

Công thức:

```text
percentage = round(số lesson hoàn thành × 100 / tổng số lesson)
```

Nếu course chưa có lesson, implementation trả 0 thay vì chia cho 0. Completed ID
được lọc để chỉ gồm lesson vẫn thuộc course đang yêu cầu.

## Quy tắc độ tin cậy

- **Server authority:** chỉ progress row đã lưu quyết định kết quả.
- **Idempotency:** complete lặp lại chỉ update một row.
- **Isolation:** user ID luôn lấy từ token, không lấy từ request body.
- **Referential safety:** enrollment được kiểm tra theo course của lesson.
- **Certificate guard:** completion đã cấp certificate không bị làm sai lệch.
- **Deletion safety:** lesson service chung xóa progress phụ thuộc trước khi xóa
  lesson.

## Kiểm thử nghiệm thu

| Case | Thiết lập/thao tác | Kỳ vọng |
|---|---|---|
| PRG-01 | Complete một trong hai lesson | 200 và progress 50% |
| PRG-02 | Complete lại cùng lesson | Một row; response ổn định |
| PRG-03 | Đọc khi chưa enroll | 403 |
| PRG-04 | Complete lesson không tồn tại | 404 |
| PRG-05 (extension) | Undo trước khi có certificate | 200 và `is_completed=false` |
| PRG-06 (extension) | Undo sau certificate | 409 |
| PRG-07 | Course không có lesson | 0/0 và 0% |
| PRG-08 | Token Instructor | 403 |

Folder Postman đính kèm bao phủ complete, read, undo và negative case chưa enroll.
Automated test cũng kiểm tra phép tính 50% cùng tích hợp certificate.
