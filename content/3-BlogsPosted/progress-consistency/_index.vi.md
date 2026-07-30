---
title: "Giữ tiến độ bài học nhất quán khi request lặp"
menuTitle: "Tiến độ nhất quán"
weight: 2
pre: "<b>3.2.</b>"
---

# Giữ tiến độ bài học nhất quán khi request lặp

> **Trạng thái xuất bản:** Bản nháp nội bộ đã sẵn sàng để nộp/xuất bản. Trang
> này chưa phải bài đăng AWS Study Group public. Chỉ thêm đúng URL và ngày đăng
> sau khi bài thật sự được xuất bản. **URL public: đang chờ — không tự tạo.**

Progress tracking nhìn giống một tính năng Boolean: lesson đã hoàn thành hoặc
chưa. Trên thực tế, nó liên quan đến authentication, enrollment, cấu trúc course,
dashboard aggregation, assessment và certificate. Retry hoặc frontend state cũ
có thể làm dữ liệu không nhất quán nếu backend không sở hữu toàn bộ rule.

Bài viết này trình bày progress model của EduCloud Lite và cách kiểm thử để chứng
minh state có kết quả dự đoán được.

## 1. Progress API

Hai endpoint cốt lõi được giao gồm:

```http
POST   /api/lessons/{lesson_id}/complete
GET    /api/courses/{course_id}/progress
Authorization: Bearer <EduCloud JWT>
```

POST đặt `is_completed=true`; GET trả tiến độ của Student đã xác thực trong một
course. Caller không được tự chọn `user_id` trong body. Codebase được cung cấp có
thêm `DELETE /api/lessons/{lesson_id}/complete` để hoàn tác; bài viết xem đây là
extension hỗ trợ thay vì endpoint cốt lõi được giao.

Trước khi ghi, `progress_service.py` xác minh:

1. role đã xác thực là `student`;
2. lesson tồn tại; và
3. Student có enrollment trong course chứa lesson đó.

Endpoint đọc áp dụng cùng ranh giới Student và enrollment cho course được yêu
cầu. Vì vậy một người đã đăng nhập nhưng không liên quan không thể xem progress
riêng tư hoặc sửa lesson chỉ bằng cách đoán ID.

## 2. Một canonical state cho mỗi user và lesson

Bảng `progress` lưu `user_id`, `course_id`, `lesson_id` và `is_completed`. Unique
constraint trên `(user_id, lesson_id)` bảo đảm chỉ có một state chính thức cho
cùng học viên và lesson.

Service dùng pattern update-or-create:

```python
progress = find_progress(user_id, lesson_id)
if progress is None:
    progress = Progress(
        user_id=user_id,
        course_id=lesson.course_id,
        lesson_id=lesson_id,
        is_completed=completed,
    )
else:
    progress.is_completed = completed
commit()
```

Do đó hai request “complete” tuần tự không tạo hai completed record; chúng cùng
hội tụ về `true`. Hai request “undo” hội tụ về `false`. Tương tự enrollment,
database upsert hoặc xử lý unique conflict rõ ràng sẽ làm race condition insert
đồng thời graceful hơn; unique constraint hiện vẫn là lớp bảo vệ dữ liệu cuối.

## 3. Tính phần trăm thay vì lưu riêng

EduCloud không lưu một percentage độc lập có thể lệch khỏi lesson state.
`GET .../progress` lấy danh sách lesson ID hiện tại của course, rồi đếm các
progress row hoàn thành thuộc đúng user, course và tập lesson đó.

```text
percentage = round(completed_lessons × 100 / total_lessons)
```

Nếu course chưa có lesson, kết quả là `0`. Response chứa `completed_lessons`,
`total_lessons`, `percentage` và `completed_lesson_ids`, giúp frontend hiển thị
progress bar cùng marker hoàn thành từ một server snapshot.

Việc lọc theo lesson ID hiện tại rất quan trọng. Progress row cũ không được làm
tăng percentage sau khi curriculum thay đổi. Luồng xóa lesson trong codebase còn
xóa dependent progress trước khi xóa lesson, tạo thêm một lớp cleanup.

## 4. Lesson progress không phải final completion

Hoàn thành mọi lesson có thể mở final assessment, nhưng chưa tự chứng minh course
đã hoàn tất. Việc cấp certificate trong EduCloud yêu cầu:

- có ít nhất một lesson và mọi lesson hiện tại đều complete;
- có final assessment đã publish;
- cùng Student đã có assessment attempt pass; và
- chưa có certificate cho user/course đó.

Khi đủ điều kiện, certificate creation có tính idempotent và enrollment status
chuyển thành `completed`. Khi certificate đã tồn tại, progress service từ chối
undo lesson bằng `409`, giữ ý nghĩa của completion record đã cấp.

Đây là product decision, không phải quy tắc chung cho mọi LMS. Điểm kỹ thuật quan
trọng là API diễn đạt rule rõ và test boundary, thay vì giao cho frontend tự xử lý.

## 5. Các tình huống cần test

| Tình huống | Kết quả mong đợi |
| --- | --- |
| Student đã enroll complete lesson | Một row có `is_completed=true`. |
| Lặp cùng request | State và row count không đổi. |
| Student undo lesson | Row hiện có chuyển thành `false`. |
| Student chưa enroll | `403`; không mutate progress. |
| Instructor/Admin gọi progress API | `403 Student access required`. |
| Lesson không tồn tại | `404 Lesson not found`. |
| Complete một trong hai lesson | `completed_lessons=1`, `total_lessons=2`, `percentage=50`. |
| Row cũ trỏ lesson không còn thuộc course | Không được tính vào percentage hiện tại. |
| Undo sau khi certificate được cấp | `409`; completion có certificate giữ nguyên. |
| Complete toàn bộ lesson nhưng chưa pass assessment | Lesson percentage có thể là 100 nhưng chưa cấp certificate mới. |

`backend/tests/test_enrollment_progress.py` hiện thực ví dụ hai lesson: sau khi
complete một lesson, test assert 50%, một active course và chưa có completed
course. Sau đó test complete lesson thứ hai, nộp assessment pass rồi kiểm tra
certificate và enrollment completed. Điều này bảo vệ sự khác biệt giữa lesson
progress và final completion.

Manual test plan có progress case nhưng hiện vẫn ghi **Not Started**. Trước khi
báo cáo pass, cần chạy flow Student bằng token thật trong Postman/Swagger, lưu
response và database state tương ứng, rồi lặp một số request trên deployed API.

## 6. Monitoring và troubleshooting

Khi progress request lỗi, ghi timestamp, route template, response status và ghi
chú correlation đã che thông tin nhạy cảm. Các nhóm lỗi hữu ích:

- `401`: thiếu hoặc sai token;
- `403`: sai role hoặc chưa enrollment;
- `404`: lesson không tồn tại;
- `409`: cố undo completion đã có certificate; và
- `5xx`: lỗi application/database ngoài dự kiến.

EduCloud health service theo dõi success, 4xx, 5xx gần đây, response time trung
bình và top route trong process memory; Admin CloudWatch reader đọc event gần
đây từ active Elastic Beanstalk log stream. In-memory value reset khi restart và
không chia sẻ giữa instance, vì vậy production cần structured CloudWatch log,
alarm và correlation ID. Không đưa token hoặc dữ liệu Student vào log/ảnh chụp.

## 7. Hướng hardening

- Thay query-then-insert bằng PostgreSQL upsert an toàn theo transaction.
- Thêm request correlation ID và structured audit event chỉ chứa ID, không chứa
  dữ liệu cá nhân.
- Thêm API-level concurrent retry test, không chỉ sequential service test.
- Dùng versioned schema migration cho progress constraint và cleanup rule.
- Xác định policy khi curriculum thay đổi: thêm lesson mới có mở lại course đã
  cấp certificate hay không.
- Chuyển traffic metric sang shared durable backend nếu API chạy nhiều process.

## Kết luận

Progress nhất quán đến từ một server-owned state trên mỗi user/lesson,
authorization gắn với enrollment, percentage tính từ database row hiện tại và
ranh giới rõ giữa lesson completion với certification. EduCloud đã xây nền tảng
đó và ghi rõ các cải tiến concurrency/observability còn cần cho production.

## Tham chiếu implementation

- `EduCloud/backend/app/routes/progress_routes.py`
- `EduCloud/backend/app/services/progress_service.py`
- `EduCloud/backend/app/models/progress.py`
- `EduCloud/backend/app/services/certificate_service.py`
- `EduCloud/backend/app/services/enrollment_service.py`
- `EduCloud/backend/tests/test_enrollment_progress.py`

**URL AWS Study Group public:** Chờ bài được xuất bản thật.
