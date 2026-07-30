---
title: "Tuần 2 - Yêu cầu và tiêu chí nghiệm thu"
menuTitle: "Tuần 2"
weight: 2
pre: "<b>1.2.</b>"
---

**Thời gian:** 08/06/2026 - 14/06/2026  
**Trạng thái ngày 30/07:** Kế hoạch dựng lại; đã đối chiếu tiêu chí với codebase được cung cấp

## Mục tiêu

- Xác định business rule và quyền truy cập cho từng API được giao.
- Định nghĩa cả trường hợp thành công lẫn thất bại trước khi triển khai.
- Phân loại nội dung cần test tự động, test thủ công bằng Postman và xác minh
  trực tiếp trên AWS.

## Yêu cầu đã phân tích

| Nhóm | Hành vi bắt buộc |
| --- | --- |
| Enrollment | Chỉ Student được ghi danh; khóa học phải tồn tại, đã publish và có final assessment đã publish; gọi lặp lại không tạo dòng trùng. |
| My Courses | Trả số khóa đang học, tổng bài đã hoàn thành, số khóa hoàn tất và phần trăm từng khóa từ dữ liệu database. |
| Progress | Chỉ Student đã ghi danh được complete lesson hoặc đọc progress; completion là duy nhất theo user và lesson. Guard hoàn tác sau certificate thuộc extension hỗ trợ. |
| Upload | Chỉ chủ khóa học hoặc Admin được upload; từ chối đuôi tệp không hỗ trợ và tệp quá dung lượng; hỗ trợ local khi phát triển và S3 khi triển khai. |
| CloudWatch | Phần cốt lõi đối chiếu request có kiểm soát với application log. Admin reader hỗ trợ phải chặn non-Admin và xử lý lỗi monitoring mà không lộ credential. |

## Ma trận nghiệm thu

| Kịch bản | Kết quả mong đợi |
| --- | --- |
| Student ghi danh khóa học hợp lệ | Thành công và chỉ có một dòng Enrollment |
| Cùng Student ghi danh lại | Trả enrollment hiện có, không sinh dòng trùng |
| Người dùng không phải Student ghi danh | HTTP 403 |
| Khóa học không tồn tại, chưa publish hoặc thiếu assessment đã publish | HTTP 404 hoặc 409 theo trường hợp |
| Student đã ghi danh hoàn thành một trong hai bài | Một bài hoàn thành và tiến độ 50% |
| Student chưa ghi danh cập nhật tiến độ | HTTP 403 |
| Material có phần mở rộng không hỗ trợ | HTTP 415 |
| Tệp vượt giới hạn dung lượng của loại upload | HTTP 413 |
| Người dùng không phải Admin gọi CloudWatch reader hỗ trợ | HTTP 403 |

## Sản phẩm bàn giao

- Ma trận business rule và phân quyền cho nhóm endpoint phụ trách.
- Tiêu chí test positive, negative, boundary và idempotency.
- Phân tách ba mức xác minh: automated test local/mock, Postman thủ công và
  kiểm tra AWS S3/CloudWatch thật.

## Tiêu chí hoàn thành

- Mỗi endpoint thay đổi dữ liệu có quy tắc quyền và ít nhất một negative case:
  **đạt trong thiết kế và code hiện tại**.
- Trường hợp enrollment/progress trùng có ràng buộc ở database: **đạt**.
- Không suy diễn hành vi AWS runtime chỉ từ source code: **đạt ở mức quy tắc
  minh chứng; live verification vẫn là việc tương lai**.

## Minh chứng trong repository

- EduCloud/backend/app/services/enrollment_service.py
- EduCloud/backend/app/services/progress_service.py
- EduCloud/backend/app/routes/upload_routes.py
- EduCloud/backend/app/routes/admin_routes.py
- EduCloud/backend/app/models/enrollment.py
- EduCloud/backend/app/models/progress.py
