---
title: "Kiểm thử, Postman và CloudWatch"
menuTitle: "Kiểm thử & minh chứng"
weight: 8
pre: "<b>5.8.</b>"
---

# Kiểm thử, Postman và CloudWatch

Việc kiểm tra được tách thành ba mức minh chứng để không trình bày mock AWS client
như bằng chứng của deployment thật.

## Mức 1 — automated backend test

Đã chọn bảy test node liên quan đến phần được giao và hành vi hỗ trợ trong
codebase, rồi chạy vào **30/07/2026**:

```powershell
Set-Location EduCloud/backend
python -m pytest -p no:cacheprovider `
  tests/test_enrollment_progress.py::test_enrollment_progress_and_dashboard_use_database_rows `
  tests/test_course_lesson_api.py::test_instructor_can_upload_lesson_files `
  tests/test_course_lesson_api.py::test_upload_rejects_unsupported_file_type `
  tests/test_course_lesson_api.py::test_duplicate_thumbnail_upload_reuses_the_same_object `
  tests/test_course_lesson_api.py::test_instructor_can_complete_presigned_video_upload `
  tests/test_course_lesson_api.py::test_video_multipart_rejects_another_course_key `
  tests/test_monitoring.py::test_cloudwatch_logs_reads_tail_of_latest_active_stream
```

Kết quả: **7 collected, 7 passed**.

{{< staticlink path="files/targeted-pytest-result.txt" text="Tải kết quả test đã loại đường dẫn cá nhân" download="true" >}}

Coverage liên quan gồm:

- lưu enrollment/progress và phép tính 50%;
- phục hồi xung đột enrollment đồng thời mà không che lỗi database khác;
- tích hợp dashboard, assessment và certificate;
- upload material/video local;
- từ chối loại file không hỗ trợ;
- deduplicate thumbnail;
- sắp xếp part và complete multipart bằng S3 client mock;
- từ chối multipart key của course khác; và
- hành vi đọc CloudWatch log bằng monitoring client giả.

Kết quả chứng minh logic xác định trong test environment. Nó **không** chứng minh
cấu hình Cognito, S3, CloudFront, IAM, Elastic Beanstalk hoặc CloudWatch thật.

Lần chạy chẩn đoán đầu tiên phát hiện dependency trên môi trường global bị lệch:
bcrypt 5.0.0 trong khi repository pin bcrypt 4.0.1 để tương thích passlib 1.7.4.
Sau khi cài `requirements-dev.txt` vào môi trường riêng, toàn backend thu thập 28
test và **cả 28 đều pass**. Hai regression test mới kiểm tra nhánh phục hồi khi
enrollment đồng thời và bảo đảm lỗi integrity không liên quan vẫn được ném ra.

{{< staticlink path="files/full-pytest-result.txt" text="Tải kết quả full suite đã loại đường dẫn cá nhân" download="true" >}}

## Mức 2 — Postman regression theo phạm vi

Import collection và chỉ điền biến local:

- {{< staticlink path="files/EduCloud-API-Testing.postman_collection.json" text="Postman collection EduCloud theo phạm vi" download="true" >}}
- {{< staticlink path="files/api-test-matrix.md" text="Ma trận kiểm thử và minh chứng" download="true" >}}

Thứ tự đề xuất:

1. chạy FastAPI và xác nhận `GET /docs`;
2. đặt `student_token`, `instructor_token`, `admin_token` cùng fixture ID;
3. chạy enrollment positive, lặp/idempotency, không token và sai role;
4. chạy complete → get progress → undo → negative chưa enroll;
5. chạy các direct upload hợp lệ có trong collection; tự tạo và chạy riêng các
   case file sai, quá dung lượng và không phải owner trong ma trận vì chúng chưa
   có trong collection đính kèm;
6. chuyển sang S3 sandbox và chạy multipart start/part/complete;
7. dùng request abort riêng cho multipart thứ hai và kiểm tra cleanup; bước này
   kiểm tra API abort, không phải luồng người dùng bấm hủy trên UI;
8. gọi endpoint CloudWatch của Admin; và
9. export Runner report sau khi xóa token value.

Với các request có sẵn, collection có assertion cho status, response envelope,
ID, khoảng progress, upload metadata và CloudWatch success. Các negative upload
case riêng gồm file sai, quá dung lượng, không phải owner và cleanup multipart
cũng đã được chạy theo ma trận kiểm thử.

## Mức 3 — xác minh AWS thật

### S3/CloudFront

Xác minh rằng:

- object trả về nằm đúng course prefix;
- Block Public Access vẫn bật;
- truy cập S3 anonymous trực tiếp bị từ chối;
- phân phối qua CloudFront URL hoạt động;
- content type và size đúng;
- multipart complete không còn trạng thái in-progress; và
- abort/lifecycle không để orphan part.

### CloudWatch

Code cung cấp `GET /api/admin/cloudwatch-logs`. Service đọc tối đa mười stream
gần đây, lọc event trong 24 giờ và trả event mới nhất trước. Cần:

```dotenv
AWS_MONITORING_ENABLED=true
AWS_CLOUDWATCH_LOG_GROUP=YOUR_LOG_GROUP
```

Phải bật Elastic Beanstalk log streaming bên ngoài application. Tạo một scoped
request thành công và một validation error an toàn, lưu timestamp rồi tìm access/
application log tương ứng. Sau đó xác nhận non-Admin nhận 403 khi gọi log endpoint.

Lần kiểm tra trên môi trường dùng chung đã xác nhận upload S3 đúng course prefix,
multipart complete/abort, status và phân quyền trong Postman, cùng application
event trong CloudWatch log group đã cấu hình. Token, định danh tài nguyên,
presigned URL và raw log payload không được đưa vào báo cáo public.

## Triển khai frontend dùng chung

Các hình ghi lại cấu hình Amplify mà nhóm EduCloud sử dụng.

{{< staticimage path="images/workshop/08-amplify-deployed.png" alt="Kết quả triển khai Amplify dùng chung của EduCloud" >}}

{{< staticimage path="images/workshop/08b-amplify-spa-rewrite.png" alt="Cấu hình rewrite cho single-page application của EduCloud" >}}

## Trạng thái minh chứng hiện tại

| Minh chứng | Trạng thái ngày 31/07/2026 |
|---|---|
| Audit implementation path theo phạm vi | Hoàn tất |
| Test node đã chọn cho phạm vi được giao/hành vi hỗ trợ | 7/7 pass |
| Full backend test trong môi trường đúng dependency pin | 28/28 pass |
| Postman collection đã sửa cho báo cáo | Đã chạy manual case tích cực và tiêu cực |
| OpenAPI snapshot theo phạm vi | Đã tạo; Swagger runtime vẫn là nguồn chuẩn |
| Kiểm tra S3 và CloudWatch live | Đã hoàn tất trên môi trường dùng chung của nhóm |
| Cấu hình AWS Console | Đã thêm ảnh cấu hình dùng chung tại bước liên quan |

{{% notice warning %}}
Không công khai bearer token, password, database URL, AWS key, presigned URL,
account ID, Cognito ID, tên private bucket hay log payload chưa che.
{{% /notice %}}
