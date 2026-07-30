---
title: "Nhật ký công việc"
weight: 1
chapter: false
pre: "<b>1.</b>"
---

Worklog này là **kế hoạch thực hiện 10 giai đoạn được dựng lại** cho phần việc của
**Nguyễn Song Minh Luân** trong dự án EduCloud: API ghi danh, API tiến độ học,
upload tệp lên Amazon S3, kiểm thử API bằng Postman và kiểm tra log CloudWatch.
Các giai đoạn bao quát thời gian thực tập từ **01/06/2026 đến 15/08/2026**;
giai đoạn cuối kéo dài 13 ngày để kiểm thử và bàn giao, không phải một tuần lịch
đúng bảy ngày.

{{% notice warning %}}
Ảnh phân công xác nhận hướng công việc của Luân, nhưng lịch sử Git được cung cấp
không tự xác nhận Luân là tác giả các dòng code được dẫn. Vì vậy, “có trong
codebase” chỉ chứng minh hành vi hệ thống. Trước khi nộp, cần chỉnh ngày/trạng
thái theo hoạt động thực tế và bổ sung PR, commit, task board hoặc xác nhận của
mentor để chứng minh đóng góp cá nhân.
{{% /notice %}}

## Cơ sở xác định trạng thái

Trạng thái dưới đây được chốt tại ngày **30/07/2026**. “Có mục tiêu trong
codebase” nghĩa là hành vi tồn tại trong cây source được cung cấp, không khẳng
định tác giả. Giai đoạn 9 là pha kế hoạch hiện tại và Giai đoạn 10 là việc tương
lai. Bảy test node liên quan đến phần được
giao đạt **7/7**; full suite đạt **26/26 test** trong môi trường
riêng dùng đúng dependency pin. Tuy nhiên, checklist thủ công tại
EduCloud/api/test-plan/test-cases.md vẫn ghi **Not Started**; vì vậy worklog
không khẳng định đã hoàn tất toàn bộ Postman hoặc đã xác minh end-to-end trên
AWS S3/CloudWatch thật.

| Giai đoạn | Thời gian | Trọng tâm | Trạng thái ngày 30/07 | Kết quả chính |
| --- | --- | --- | --- | --- |
| [Tuần 1](week-01/) | 01/06 - 07/06 | Khởi động và phân tích phạm vi được giao | Kế hoạch dựng lại | Bảng phạm vi và checklist minh chứng |
| [Tuần 2](week-02/) | 08/06 - 14/06 | Yêu cầu và tiêu chí nghiệm thu | Kế hoạch dựng lại | Kịch bản API tích cực và tiêu cực |
| [Tuần 3](week-03/) | 15/06 - 21/06 | Thiết kế API, dữ liệu và kiểm thử | Kế hoạch dựng lại | Luồng endpoint, ràng buộc dữ liệu, cấu trúc test |
| [Tuần 4](week-04/) | 22/06 - 28/06 | Nền tảng dữ liệu enrollment/progress | Có mục tiêu trong codebase; chờ xác nhận tác giả | Model Enrollment, Progress và ràng buộc duy nhất |
| [Tuần 5](week-05/) | 29/06 - 05/07 | Nền tảng tích hợp FastAPI | Có mục tiêu trong codebase; chờ xác nhận tác giả | Đăng ký router, cấu hình và quy ước response |
| [Tuần 6](week-06/) | 06/07 - 12/07 | API ghi danh và My Courses | Có mục tiêu trong codebase; chờ xác nhận tác giả | Luồng enroll và dashboard học tập của student |
| [Tuần 7](week-07/) | 13/07 - 19/07 | API tiến độ và upload cơ bản | Có mục tiêu trong codebase; chờ xác nhận tác giả | Luồng complete/progress và upload có kiểm tra |
| [Tuần 8](week-08/) | 20/07 - 26/07 | Tích hợp frontend và regression tự động | Có mục tiêu trong codebase; chờ xác nhận tác giả | Tích hợp service và gia cố bằng test |
| [Tuần 9](week-09/) | 27/07 - 02/08 | Extension hỗ trợ, CloudWatch và xác minh | Pha kế hoạch hiện tại; chờ minh chứng live | Đã rà soát multipart/log viewer; local test pass |
| [Tuần 10](week-10/) | 03/08 - 15/08 | Regression toàn bộ, kiểm tra live và bàn giao | Kế hoạch | Báo cáo Postman, minh chứng AWS, retest lỗi và hồ sơ báo cáo |

## Bảy endpoint cốt lõi được giao

- Enrollment: **POST /api/courses/{course_id}/enroll** và **GET
  /api/my-courses**.
- Progress: **POST /api/lessons/{lesson_id}/complete** và **GET
  /api/courses/{course_id}/progress**.
- Upload: **POST /api/upload/course-thumbnail**, **POST
  /api/upload/lesson-material** và **POST /api/upload/video**.
- Xác minh: chạy ma trận test API bằng Postman, kiểm tra log ứng dụng trên
  CloudWatch và không lưu JWT, AWS key hay thông tin bí mật trong minh chứng.

## Extension hỗ trợ trong codebase

- `DELETE /api/lessons/{lesson_id}/complete` để hoàn tác.
- Import/deduplicate thumbnail từ xa.
- Multipart video start/part/complete/abort.
- Endpoint Admin `GET /api/admin/cloudwatch-logs` để đọc log.

Các extension này chỉ là ngữ cảnh tích hợp/test nếu chưa có bằng chứng mentor/PR
xác nhận chúng thuộc phần triển khai cá nhân của Luân.

## Quy ước minh chứng

Các đường dẫn minh chứng trong worklog là đường dẫn tương đối bên trong thư
mục **EduCloud/**, trỏ đến source code, hợp đồng API, test hoặc template cục
bộ; không sử dụng danh tính hay liên kết workshop của sinh viên khác.
