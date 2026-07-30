---
title: "Tuần 9 - S3 multipart, CloudWatch và xác minh"
menuTitle: "Tuần 9"
weight: 9
pre: "<b>1.9.</b>"
---

**Thời gian:** 27/07/2026 - 02/08/2026  
**Trạng thái ngày 30/07:** Pha kế hoạch hiện tại; đã test hành vi codebase, còn thiếu minh chứng live

> **Cơ sở ghi nhận:** route điều khiển multipart và endpoint đọc log Admin là
> extension hỗ trợ có trong codebase, không phải endpoint cốt lõi của ảnh phân
> công. Source chỉ chứng minh hành vi hệ thống; tác giả cá nhân cần PR/task/xác
> nhận mentor của Luân.

## Mục tiêu

- Tăng độ tin cậy khi upload video lớn bằng multipart trực tiếp từ browser lên
  S3.
- Cung cấp log CloudWatch gần nhất cho người dùng Admin hợp lệ.
- Chạy lại targeted automated suite và xác định phần minh chứng thủ công còn
  thiếu.

## Hành vi codebase đã xác minh đến ngày 30/07

### Công việc S3 upload

- Codebase cung cấp endpoint start, cấp quyền từng part, complete các part đã sắp thứ tự
  và abort upload chưa hoàn tất.
- Code giới hạn key video trong **courses/{course_id}/videos/** và từ chối key thuộc
  course khác.
- Code chỉ nhận video MP4, WebM, QuickTime; giới hạn size khai báo 500 MiB.
- Code dùng part 10 MiB và presigned URL có hiệu lực một giờ.
- Frontend worker dùng tối đa ba upload song song, tối đa ba lần thử cho
  mỗi part và tự abort sau lỗi.
- **POST /api/upload/video** vẫn là fallback qua backend khi storage mode
  không phải S3.

### Công việc CloudWatch

- Codebase có endpoint chỉ dành cho Admin **GET
  /api/admin/cloudwatch-logs**.
- Service đọc stream hoạt động mới nhất của log group đã cấu hình, chỉ lấy event trong
  24 giờ gần nhất, sắp mới nhất trước và giới hạn tối đa 200 event.
- Service trả thông báo an toàn khi monitoring tắt, thiếu log group hoặc AWS Logs
  client lỗi.

### Xác minh tự động

Đã chạy lệnh sau trên môi trường local ngày **30/07/2026**:

    python -m pytest -p no:cacheprovider <bảy node ID đã chọn>

Kết quả: **7 test được thu thập, 7 test pass**. Danh sách node ID chính xác và
output nằm ở phần kiểm thử workshop.

Đã dùng thêm môi trường sạch cài từ `backend/requirements-dev.txt` để chạy toàn
bộ backend suite: **26 test được thu thập, 26 test pass**. Kết quả đã loại đường
dẫn cá nhân được đính kèm tại phần kiểm thử workshop.

## Trạng thái sản phẩm hiện tại

| Sản phẩm | Trạng thái | Giới hạn của minh chứng |
| --- | --- | --- |
| Backend S3 multipart | Có trong codebase; mock API test pass | Chưa chứng minh bucket thật hoặc tác giả cá nhân |
| Frontend chunk/retry/abort | Có trong codebase; đã source review | Còn thiếu browser-to-S3 thật và attribution |
| CloudWatch log reader | Có trong codebase; fake-client test pass | Còn thiếu log group thật và attribution |
| Postman collection riêng cho báo cáo | Đã tạo và kiểm tra JSON | Vẫn thiếu minh chứng chạy thực tế |
| Minh chứng Postman cũ trong repository nhóm | Chưa hoàn tất | `test-cases.md` còn Not Started và collection cũ thiếu request được giao |

## Việc còn lại từ 31/07 đến 02/08

- Import Postman collection đã sửa cho báo cáo và chỉ đặt biến môi trường local,
  không commit giá trị nhạy cảm.
- Chạy các case local positive/negative, ghi actual response nhưng không lộ
  token.
- Chuẩn bị checklist live S3 và CloudWatch cho Giai đoạn 10.
- Ghi defect phát hiện từ manual test và retest sau khi sửa.

## Tiêu chí kiểm tra

| Tiêu chí | Kết quả ngày 30/07 |
| --- | --- |
| Multipart completion sắp part theo part number. | Automated test pass |
| Key video ngoài course đang chọn bị từ chối HTTP 400. | Automated test pass |
| CloudWatch reader bỏ stream cũ và trả event mới nhất trước. | Fake-client test pass |
| Các node enrollment/progress/upload/monitoring đã chọn đều xanh. | 7/7 pass |
| Full backend suite xanh với dependency pin. | 26/26 pass |
| Có minh chứng object S3 thật và event CloudWatch thật. | Chờ thực hiện |
| Báo cáo Postman toàn bộ có actual result. | Chờ thực hiện |

## Minh chứng trong repository

- EduCloud/backend/app/routes/upload_routes.py
- EduCloud/backend/app/services/s3_service.py
- EduCloud/frontend/src/services/uploadService.ts
- EduCloud/backend/app/routes/admin_routes.py
- EduCloud/backend/app/services/monitoring_service.py
- EduCloud/backend/tests/test_course_lesson_api.py
- EduCloud/backend/tests/test_monitoring.py
- EduCloud/api/postman/EduCloud.postman_collection.json
- EduCloud/api/test-plan/test-cases.md
