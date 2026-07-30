---
title: "Tuần 10 - Regression toàn bộ, kiểm tra live và bàn giao"
menuTitle: "Tuần 10"
weight: 10
pre: "<b>1.10.</b>"
---

**Thời gian:** 03/08/2026 - 15/08/2026  
**Trạng thái ngày 30/07:** Kế hoạch tương lai; chưa khẳng định hoàn thành

## Mục tiêu

- Chạy toàn bộ API regression bằng Postman và ghi actual result.
- Xác minh upload trên môi trường S3/CloudFront đã cấu hình.
- Đối chiếu hoạt động API có kiểm soát với log CloudWatch.
- Đóng defect, làm sạch minh chứng và bàn giao API cùng báo cáo.

## Kế hoạch thực hiện

| Thời gian | Công việc dự kiến | Kết quả mong đợi |
| --- | --- | --- |
| 03/08 - 04/08 | Bổ sung Postman request cho My Courses, complete/uncomplete, course progress, multipart video và Admin CloudWatch; thêm xử lý xác thực dùng lại. | Collection import được, không hard-code secret |
| 05/08 - 07/08 | Chạy TC-001–TC-011 và các case negative/boundary phụ trách trên API local. | Actual response, HTTP status, Passed/Failed và defect note cho mọi dòng |
| 08/08 - 10/08 | Test thumbnail, PDF/material, direct fallback và multipart video bằng tài khoản Instructor/Admin hợp lệ trên AWS. | Minh chứng S3 object path/URL, size/type và các case unauthorized/invalid bị từ chối |
| 11/08 - 12/08 | Gửi request thành công và lỗi an toàn có kiểm soát; gọi Admin log API, đối chiếu timestamp, route, status với CloudWatch. | Minh chứng log group/event đã che dữ liệu nhạy cảm |
| 13/08 - 14/08 | Sửa lỗi trong phạm vi, chạy lại case Postman fail và targeted pytest suite. | Không còn defect critical chưa xử lý trong phần phụ trách |
| 15/08 | Hoàn thiện worklog, test report, ảnh minh chứng, giới hạn đã biết và handover note. | Hồ sơ sẵn sàng nộp |

## Phạm vi test bắt buộc

### Enrollment và progress

- Enroll thành công, enroll lặp, sai role, course không tồn tại/chưa publish và
  course chưa có assessment đã publish.
- Tổng số My Courses và phần trăm từng khóa.
- Complete, complete lặp, uncomplete, chưa enroll và khóa certificate.

### Upload

- Ảnh, PDF/material và video hợp lệ.
- Sai extension, quá size, không phải owner, multipart key sai, part number
  trùng, upload lỗi/abort và complete thành công.
- Xác nhận object trả về nằm trong prefix course đã chọn và chỉ truy cập qua
  cấu hình phân phối dự kiến.

### CloudWatch và regression

- Admin thành công, non-Admin HTTP 403, monitoring tắt, log group thiếu/sai và
  thứ tự event gần nhất.
- Chạy lại automated test sau khi xử lý lỗi manual.

## Tiêu chí kết thúc

| Tiêu chí | Minh chứng bắt buộc |
| --- | --- |
| Mọi endpoint được giao có trong Postman collection. | Collection export có variables và scripts |
| Mọi manual case có actual result và trạng thái cuối. | Test report hoàn chỉnh, không còn dòng Not Started |
| S3 upload chạy với resource đã cấu hình thật. | Object metadata/path và API response đã làm sạch |
| Hoạt động ứng dụng xuất hiện đúng CloudWatch log group. | Event có timestamp và đã bỏ dữ liệu nhạy cảm |
| Targeted automated suite tiếp tục xanh. | Output lệnh chạy cuối |
| Minh chứng không chứa JWT, password, AWS key, query string presigned hay dữ liệu cá nhân riêng tư. | Rà soát minh chứng lần cuối |

## Đường dẫn minh chứng hiện có và dự kiến

- Collection hiện có: EduCloud/api/postman/EduCloud.postman_collection.json
- Checklist hiện có: EduCloud/api/test-plan/test-cases.md
- Template báo cáo: EduCloud/api/test-plan/test-report-template.md
- Hướng dẫn AWS: EduCloud/docs/EduCloud-Build-Deployment-Guide.md
- Sản phẩm dự kiến: test report đã điền và ảnh S3/CloudWatch đã che dữ liệu
  nhạy cảm, đính kèm báo cáo thực tập

