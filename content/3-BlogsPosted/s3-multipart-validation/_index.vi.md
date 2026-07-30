---
title: "S3 multipart upload an toàn và kiểm tra sau deploy"
menuTitle: "S3 multipart & kiểm tra"
weight: 3
pre: "<b>3.3.</b>"
---

# S3 multipart upload an toàn và kiểm tra sau deploy

> **Trạng thái xuất bản:** Bản nháp nội bộ đã sẵn sàng để nộp/xuất bản. Trang
> này chưa phải bài đăng AWS Study Group public. Chỉ thêm đúng URL và ngày đăng
> sau khi bài thật sự được xuất bản. **URL public: đang chờ — không tự tạo.**

File của khóa học có workload rất khác nhau. Thumbnail có thể chỉ vài trăm KB,
tài liệu có thể hàng chục MB và video có thể hàng trăm MB. Nếu mọi byte video đều
đi qua một FastAPI/Elastic Beanstalk instance nhỏ, application bandwidth, thời
gian request và ảnh hưởng khi lỗi đều tăng.

EduCloud Lite vì vậy hỗ trợ direct-to-S3 multipart video upload, trong khi quyền
và cách đặt object key vẫn do FastAPI kiểm soát. Bài viết này giải thích control
flow, security check và cách xác minh bằng automated test, Postman/browser cùng
CloudWatch mà không biến test chưa chạy thành kết quả đã đạt.

## 1. Upload surface và ranh giới ownership

Các upload route cốt lõi được giao nằm dưới `/api/upload`:

```text
POST /course-thumbnail
POST /lesson-material
POST /video
```

Codebase được cung cấp còn có các extension hỗ trợ:

```text
POST /course-thumbnail/import
POST /video/multipart/start
POST /video/multipart/part
POST /video/multipart/complete
POST /video/multipart/abort
```

Mỗi route đều load target course và gọi cùng rule course-owner-or-Admin. Token
Instructor hợp lệ vẫn chưa đủ: Instructor không thể đổi `course_id` để upload vào
course của Instructor khác.

Giới hạn và allowlist hiện tại được khai báo rõ:

| Nhóm | Extension/content hợp lệ | Kích thước tối đa |
| --- | --- | ---: |
| Thumbnail | `.jpg`, `.jpeg`, `.png`, `.webp` | 10 MiB |
| Lesson material | `.pdf`, `.doc`, `.docx`, `.ppt`, `.pptx`, `.txt`, `.zip` | 50 MiB |
| Video | `.mp4`, `.webm`, `.mov`; multipart MIME là MP4, WebM hoặc QuickTime | 500 MiB |

Extension không hỗ trợ trả `415`, file quá lớn trả `413`. Tên thumbnail dùng
content-address SHA-256 nên cùng byte sẽ tái sử dụng cùng object name. Các nhóm
khác dùng UUID để tránh phải hash toàn bộ video lớn.

## 2. Luồng multipart control và data

Luồng video kiểu production tách control plane khỏi data plane:

1. Browser gọi `multipart/start` với course ID, filename gốc, MIME type và size.
2. FastAPI kiểm tra course ownership, validate video rồi gọi S3
   `CreateMultipartUpload`.
3. S3 trả `upload_id`; FastAPI trả key dạng
   `courses/{course_id}/videos/{uuid}.{extension}` cùng part size 10 MiB.
4. Với từng part number, browser gọi `multipart/part`. FastAPI kiểm tra lại quyền
   và key scope rồi tạo presigned `UploadPart` URL có hiệu lực một giờ.
5. Browser gửi part byte trực tiếp tới S3 bằng `PUT` và lấy response `ETag`.
6. Browser gửi toàn bộ cặp `{part_number, etag}` tới `multipart/complete`.
   FastAPI từ chối part number trùng, sắp xếp rồi gọi S3
   `CompleteMultipartUpload`.
7. Nếu browser worker lỗi, nó gọi `multipart/abort`; S3 hủy multipart session khi
   abort thành công.

React upload service dùng tối đa ba worker, cắt chunk 10 MiB và retry mỗi part
tối đa ba lần với khoảng đợi exponential ngắn. Nếu backend dùng local thay vì S3
storage, `start` trả strategy `backend` và browser fallback sang `/upload/video`.

## 3. Vì sao phải kiểm tra key?

Presigned URL cấp quyền tạm thời cho một thao tác S3. Trước khi tạo URL, EduCloud
xác minh object key bắt đầu bằng đúng course prefix và chỉ chứa một filename,
không có slash khác:

```text
courses/{authorized_course_id}/videos/{generated_filename}
```

Kiểm tra này lặp lại khi authorize part, complete và abort. Kết hợp với ownership
check, người sở hữu Course 10 không thể đưa key của Course 11 vào request.

Kiến trúc mục tiêu yêu cầu S3 bucket luôn private. CloudFront Origin Access
Control nên là đường đọc; presigned URL là đường ghi tạm thời cho một upload
part. Public delivery base được cấu hình nên là CloudFront domain, không phải URL
S3 public.

Presigned URL phải được xem là secret trong thời gian còn hiệu lực. Không đưa
query string của URL vào screenshot, Postman export, application log hoặc Git.
AWS credential phải chỉ nằm ở Elastic Beanstalk instance role và không được đi
vào React bundle. Trạng thái bucket, OAC và instance role cuối cùng vẫn cần minh
chứng live account đã che dữ liệu nhạy cảm.

## 4. Yêu cầu CORS giữa browser và S3

Browser phải được phép gửi `PUT` từ frontend origin đã deploy tới S3 bucket và
đọc response `ETag`; nếu không, byte có thể upload thành công nhưng browser không
tạo được complete request.

Do đó bucket CORS nên giới hạn đúng frontend origin, method `PUT`, request header
cần thiết và exposed `ETag`. Final deployment không cần wildcard origin. S3 Block
Public Access và CloudFront OAC bucket policy là lớp riêng với CORS và phải tiếp
tục được bật.

## 5. Chiến lược xác minh

### 5.1 Automated evidence đã có trong repository

`backend/tests/test_course_lesson_api.py` bao phủ:

- upload material/video ở local;
- từ chối material `.exe` không hỗ trợ;
- thumbnail trùng byte tái sử dụng một content-addressed file;
- multipart start, part authorization, completion đã sắp thứ tự và URL trả về;
- từ chối video key thuộc course khác.

Các test mock AWS call khi phù hợp. Chúng chứng minh application behavior chứ
không chứng minh IAM, S3 CORS, bucket policy hoặc CloudFront configuration của
live account.

### 5.2 Chạy Postman và browser

Dùng Postman cho API control plane và negative case:

1. xác thực bằng course owner, đặt biến `base_url`, `token`, `course_id` đã che
   thông tin nhạy cảm;
2. upload thumbnail/material hợp lệ và kiểm tra response metadata;
3. lặp với extension cấm, thiếu token, role sai và course của Instructor khác;
4. gọi multipart `start`, rồi xin part URL cho key vừa nhận;
5. thử key nằm dưới course khác và xác nhận `400 Invalid video object key`;
6. xác nhận `complete` từ chối duplicate part number;
7. xóa token và presigned URL trước khi export bằng chứng.

Dùng flow React/browser thật cho end-to-end chunk transfer vì code này cắt file,
chạy concurrent worker, đọc S3 `ETag` và tự abort khi lỗi. Kiểm tra object cuối
nằm dưới đúng course prefix, đọc được qua CloudFront path đã cấu hình, trong khi
public bucket access trực tiếp vẫn bị chặn.

Legacy team collection tại
`EduCloud/api/postman/EduCloud.postman_collection.json` khởi đầu với basic upload
request và không chứng minh multipart flow đã được chạy. Collection theo phạm vi
báo cáo đã sửa là JSON hợp lệ và khớp các route được rà soát, nhưng cũng chưa được
execute. TC-010 và TC-011 trong legacy `api/test-plan/test-cases.md` hiện là
**Not Started**; chỉ được đổi Pass/Fail sau khi chạy thật và lưu output.

### 5.3 Kiểm tra CloudWatch và health

Với mỗi deployed test, ghi UTC timestamp, route template, expected status và test
ID không nhạy cảm. Sau đó kiểm tra:

- Elastic Beanstalk environment/instance health;
- API 4xx/5xx gần đây và average response time trong Admin health;
- active CloudWatch log stream gần thời điểm test;
- S3 object count/size cùng course prefix dự kiến; và
- Cost Explorer/Budgets sau test data transfer lớn.

Admin endpoint `GET /api/admin/cloudwatch-logs` đọc event mới nhất từ active
stream trong log group đã cấu hình. Automated test của nó kiểm tra việc chọn
stream mới nhất và thứ tự event. Môi trường deploy vẫn phải bật CloudWatch
ingestion và IAM read permission. Request counter hiện nằm trong process, còn
`app/utils/logger.py` vẫn đánh dấu full CloudWatch logging configuration là việc
cần làm tiếp; vì vậy báo cáo không được khẳng định có request tracing hoàn chỉnh
nếu structured log chưa thực sự tồn tại.

## 6. Xử lý lỗi và rủi ro còn lại

| Lỗi | Cách xử lý hiện tại | Hướng hardening |
| --- | --- | --- |
| Part upload lỗi tạm thời | Browser retry tối đa ba lần rồi xin abort. | Lưu upload session để resume sau reload. |
| Đóng browser trước abort | Multipart part có thể còn trên S3. | Thêm S3 lifecycle rule abort incomplete multipart upload. |
| Key sai course | FastAPI trả `400` trước khi presign/complete. | Lưu server-side ownership/session record làm ràng buộc bổ sung. |
| Part trùng khi complete | FastAPI từ chối duplicate part number. | Kiểm tra part liên tục và session metadata đã ghi nhận. |
| Declared size khác final object | Payload được range-validate nhưng completion tin metadata client. | `HEAD` object sau complete và kiểm tra size/checksum trước khi lưu URL. |
| File độc hại nhưng đúng extension | Extension/MIME check không phải malware inspection. | Thêm checksum, content inspection, quarantine và malware scanning. |
| Presigned URL xuất hiện trong log | Có thể lộ quyền ghi tạm thời. | Redact query string và chỉ log field nằm trong allowlist. |

## Kết luận

Multipart upload an toàn không chỉ là tạo presigned URL. EduCloud giữ course
ownership, type/size check, object-key scope, part validation, completion và
abort control tại FastAPI, trong khi browser truyền video byte trực tiếp vào S3
private. Automated test kiểm tra rule chính của application; vẫn cần bằng chứng
Postman/browser, S3, Elastic Beanstalk và CloudWatch để chứng minh cấu hình deploy.

## Tham chiếu implementation

- `EduCloud/backend/app/routes/upload_routes.py`
- `EduCloud/backend/app/services/s3_service.py`
- `EduCloud/frontend/src/services/uploadService.ts`
- `EduCloud/backend/tests/test_course_lesson_api.py`
- `EduCloud/backend/app/services/monitoring_service.py`
- `EduCloud/backend/tests/test_monitoring.py`
- `EduCloud/api/test-plan/test-cases.md`

**URL AWS Study Group public:** Chờ bài được xuất bản thật.
