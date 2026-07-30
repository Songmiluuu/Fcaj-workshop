---
title: "Thiết kế ghi danh có phân quyền và tính idempotent"
menuTitle: "Ghi danh idempotent"
weight: 1
pre: "<b>3.1.</b>"
---

# Thiết kế ghi danh có phân quyền và tính idempotent

> **Trạng thái xuất bản:** Bản nháp nội bộ đã sẵn sàng để nộp/xuất bản. Trang
> này chưa phải bài đăng AWS Study Group public. Chỉ thêm đúng URL và ngày đăng
> sau khi bài thật sự được xuất bản. **URL public: đang chờ — không tự tạo.**

Request lặp là tình huống bình thường trong ứng dụng web. Học viên có thể nhấn
“Bắt đầu khóa học” hai lần, kết nối mobile có thể retry sau timeout, hoặc frontend
gửi lại vì không nhận được response đầu tiên. Nếu mỗi lần ghi danh đều insert một
dòng mới, một thao tác của người dùng có thể tạo membership trùng, sai số trên
dashboard và trạng thái hoàn thành không rõ ràng.

Bài viết này phân tích ranh giới enrollment trong EduCloud Lite. Mục tiêu không
chỉ là chống trùng, mà còn xác định **ai** được ghi danh, **course nào** đủ điều
kiện và **lớp nào** bảo đảm toàn vẹn dữ liệu.

## 1. API contract

Phần enrollment được giao gồm hai endpoint có xác thực:

```http
POST /api/courses/{course_id}/enroll
GET  /api/my-courses
Authorization: Bearer <EduCloud JWT>
```

Client không gửi `user_id`. FastAPI lấy giá trị này từ bearer token đã xác minh
thông qua `get_current_user`. Vì vậy người gọi không thể sửa JSON trên browser để
ghi danh thay tài khoản khác.

`POST .../enroll` áp dụng quy tắc theo thứ tự:

1. role đã xác thực phải là `student`, nếu không trả `403`;
2. course phải tồn tại, nếu không trả `404`;
3. course phải ở trạng thái `published`, nếu không trả `409`;
4. course phải có final assessment đã publish, nếu không trả `409`;
5. nếu `(user_id, course_id)` đã tồn tại thì trả enrollment đó;
6. nếu chưa có thì tạo một active enrollment và commit.

Các kiểm tra nằm trong
`backend/app/services/enrollment_service.py`. Route tại
`backend/app/routes/enrollment_routes.py` chỉ trả enrollment ID, course ID và
status trong response thành công.

## 2. Authentication không đồng nghĩa authorization

Token hợp lệ trả lời “ai gửi request?”, nhưng chưa trả lời “người đó có được làm
thao tác này không?”. EduCloud lưu application role hiện tại trong PostgreSQL và
đưa role vào EduCloud JWT sau bước trao đổi Cognito identity. Service vẫn phải
kiểm tra `role == "student"` trước khi đọc/ghi enrollment.

Điều này quan trọng vì token Instructor hoặc Admin vẫn hợp lệ nhưng không nên bị
biến thành Student enrollment. Đặt rule tại service còn bảo vệ API khi người gọi
bỏ qua giao diện React.

Course state là một business boundary khác. Student không thể tham gia course
draft/hidden bằng cách đoán ID. Yêu cầu assessment đã publish cũng tránh trường
hợp học viên vào một course chưa thể hoàn tất luồng completion của hệ thống.

## 3. Idempotency có nghĩa gì trong trường hợp này?

Với operation này, idempotency nghĩa là gọi lại cùng một request hợp lệ vẫn tạo
cùng một membership state: chỉ một quan hệ Student-course đang active. Code tìm
dòng hiện có trước khi insert:

```python
enrollment = find_enrollment(user_id, course_id)
if enrollment is None:
    enrollment = Enrollment(user_id=user_id, course_id=course_id, status="active")
    save(enrollment)
return enrollment
```

Đây là application-level idempotency và xử lý được retry tuần tự. Tuy nhiên nó
không tự loại bỏ race condition khi hai request đều đọc “chưa có dòng” trước khi
một request commit.

Vì vậy database là lớp bảo vệ cuối. Model `enrollments` có unique constraint trên
`(user_id, course_id)`. Ngay cả khi có concurrency, PostgreSQL không thể lưu hai
membership cho cùng một cặp.

Hướng hardening tiếp theo là xử lý race rõ ràng: dùng PostgreSQL upsert, hoặc bắt
unique-constraint error, rollback, load lại dòng hiện có rồi trả response thành
công bình thường. Cách query-before-insert cộng unique constraint hiện tại bảo vệ
dữ liệu; thay đổi tương lai sẽ giúp response đồng thời cũng graceful.

## 4. Tạo Student dashboard từ database row

`GET /api/my-courses` cũng chỉ dành cho Student. Service join enrollment của
người dùng đã xác thực với course và instructor, sau đó group lesson cùng
completed progress theo course. Với mỗi course, API trả:

- enrollment status;
- số lesson đã hoàn thành và tổng lesson;
- phần trăm tiến độ đã làm tròn;
- assessment có tồn tại, đã pass hoặc đã sẵn sàng làm hay chưa;
- tổng active course, completed lesson và completed course dựa trên certificate.

Các giá trị được tính từ PostgreSQL thay vì số cố định trên frontend. Dashboard
cũng có thể chạy certificate backfill theo hướng idempotent cho completion cũ đủ
điều kiện. Việc cấp certificate vẫn yêu cầu hoàn thành toàn bộ lesson và pass
assessment; chỉ đạt 100% lesson progress chưa được xem là có certificate.

## 5. Ma trận kiểm thử

Test enrollment cần chứng minh cả happy path và các ranh giới:

| Tình huống | Kết quả mong đợi |
| --- | --- |
| Student + course published đủ điều kiện | Trả một active enrollment. |
| Gọi lại cùng request | Trả cùng enrollment; row count vẫn là một. |
| Thiếu/sai bearer token | Lỗi authentication; không tạo dòng. |
| Token Instructor/Admin | `403 Student access required`. |
| Course không tồn tại | `404 Course not found`. |
| Course draft/hidden | `409`; không tạo dòng. |
| Course published nhưng assessment chưa publish | `409`; không tạo dòng. |
| Hai request đồng thời | Tối đa một database row; ghi nhận cách xử lý response. |
| `GET /my-courses` bằng Student | Tổng số khớp enrollment, lesson, progress, assessment và certificate row. |

File `backend/tests/test_enrollment_progress.py` chạy flow service dựa trên
database thật trong test và kiểm tra giá trị dashboard. Postman collection có
request enrollment, còn `api/test-plan/test-cases.md` hiện ghi manual case là
**Not Started**. Báo cáo không được tự đổi thành “Passed” trước khi collection
được chạy thật và lưu response/database evidence.

Khi kiểm tra bản deploy, ghi thời gian test và status code mong đợi, sau đó xem
Elastic Beanstalk health cùng CloudWatch stream liên quan mà không chụp bearer
token. Admin traffic snapshot hiện nằm trong process và reset sau restart, nên
chỉ hỗ trợ demo chứ không thay thế lịch sử CloudWatch lâu dài.

## 6. Bài học thực tế

- Lấy ownership từ authenticated context, không lấy từ request data.
- Xem role và course publication state là rule bắt buộc ở backend.
- Khi retry bình thường, trả resource đã tồn tại.
- Luôn có database unique constraint dù service đã query trước.
- Test failure và side effect, không chỉ kiểm tra `200 OK`.
- Tách lesson progress khỏi course/certificate completion cuối cùng.
- Chỉ ghi nhận Postman/CloudWatch evidence đã chạy thật, không suy ra pass từ code.

## Kết luận

Enrollment đáng tin cậy là một API nhỏ nhưng có nhiều ranh giới quan trọng.
EduCloud kết hợp identity đã xác minh, Student-only authorization, kiểm tra course
readiness, application-level idempotency và database uniqueness. Thiết kế này giữ
một membership cho mỗi học viên/course trong retry bình thường, đồng thời xác
định concurrent upsert handling là bước hardening tiếp theo.

## Tham chiếu implementation

- `EduCloud/backend/app/routes/enrollment_routes.py`
- `EduCloud/backend/app/services/enrollment_service.py`
- `EduCloud/backend/app/models/enrollment.py`
- `EduCloud/backend/tests/test_enrollment_progress.py`
- `EduCloud/api/postman/EduCloud.postman_collection.json`
- `EduCloud/api/test-plan/test-cases.md`

**URL AWS Study Group public:** Chờ bài được xuất bản thật.
