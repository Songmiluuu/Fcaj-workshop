---
title: "Tuần 2 - Phân quyền và tiêu chí nghiệm thu"
menuTitle: "Tuần 2"
weight: 2
pre: "<b>1.2.</b>"
---

# Tuần 2 - Phân quyền và tiêu chí nghiệm thu

**Thời gian:** 22–28/06/2026

## Công việc

Xác định quyền Student và Instructor/Admin, tiêu chí thành công, case lỗi và
kết quả kiểm tra cần lưu.

## Quy tắc phân quyền

| Thao tác | Role được phép | Điều kiện chính |
|---|---|---|
| Enroll và tải My Courses | Student | Application user đã xác thực |
| Complete lesson và đọc progress | Student | Đã enroll course được chọn |
| Upload media cho course | Instructor sở hữu course hoặc Admin | Course tồn tại |
| Đọc log ứng dụng | Admin | Monitoring bật và log group đã cấu hình |

## Case nghiệm thu

- Enrollment chỉ thành công với course đã publish và có final assessment đã
  publish.
- Request enroll lặp không tạo thêm bản ghi trong database.
- Progress được tính từ các bản ghi lesson completion đã lưu.
- Upload từ chối extension không hỗ trợ, file quá kích thước và người không sở
  hữu course.
- CloudWatch trả lỗi có kiểm soát khi monitoring tắt hoặc cấu hình sai.

## Kết quả

Các case thành công, phân quyền, validation và lỗi được xác định trước khi triển
khai API. Kết quả test sử dụng HTTP status, response body, trạng thái database,
object metadata và timestamp log tùy theo từng luồng.

## Tài liệu kỹ thuật

- `EduCloud/backend/app/dependencies.py`
- `EduCloud/backend/app/services/enrollment_service.py`
- `EduCloud/backend/app/services/progress_service.py`
- `EduCloud/backend/app/services/s3_service.py`
