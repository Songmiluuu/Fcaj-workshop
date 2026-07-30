---
title: "Tự đánh giá"
weight: 6
chapter: false
pre: "<b>6.</b>"
---

# Tự đánh giá

> **Ngày đánh giá: 30/07/2026.** Kỳ thực tập của tôi diễn ra từ 01/06 đến
> 15/08/2026, vì vậy đây là bản tự đánh giá giữa kỳ, không phải khẳng định đã
> hoàn thành toàn bộ công việc cuối kỳ.

## Phạm vi đánh giá

**EduCloud là sản phẩm của nhóm.** Hệ thống có các phần xác thực, quản lý khóa
học và bài học, bài đánh giá, chứng chỉ, quản trị và triển khai do nhiều thành
viên phối hợp thực hiện. Tôi không nhận toàn bộ các tính năng đó là đóng góp cá
nhân.

Ảnh phân công xác định **phạm vi cốt lõi API Enrollment, Progress, Upload và
Testing**:

- `POST /api/courses/{course_id}/enroll` và `GET /api/my-courses`;
- `POST /api/lessons/{lesson_id}/complete` và
  `GET /api/courses/{course_id}/progress`;
- các luồng upload thumbnail, tài liệu bài học và video trực tiếp có kiểm tra
  quyền; và
- kiểm thử regression API bằng Postman cùng kiểm tra log ứng dụng trên Amazon
  CloudWatch.

Codebase nhóm còn có hoàn tác progress, import/deduplicate thumbnail, điều khiển
multipart video và endpoint Admin đọc log. Tôi xem đây là **extension hỗ trợ**,
không phải endpoint cốt lõi ban đầu nếu chưa có bằng chứng mentor/PR.

Repository có route, service, ràng buộc dữ liệu, tích hợp frontend và test tự
động liên quan đến hướng công việc này. Bảy test node liên quan đến enrollment, progress, upload
và CloudWatch đạt **7/7**; full backend suite đạt **26/26 test** trong môi
trường riêng dùng đúng
dependency pin của repository. Tuy nhiên, file test case thủ công cũ trong
repository nhóm vẫn ghi
`Not Started`; minh chứng
Postman Runner, Amazon S3 thật và CloudWatch thật chưa được chụp. Đây vẫn là
công việc của giai đoạn cuối.

{{% notice warning %}}
Các mức dưới đây là bản tự đánh giá tạm thời. Lịch sử Git được cung cấp không tự
quy các phần code được dẫn cho Luân, nên bản cuối phải có PR/commit/task hoặc xác
nhận mentor. Kết quả automated test chỉ xác nhận hành vi code hiện tại.
{{% /notice %}}

## Các tiêu chí đánh giá bắt buộc

Bảng sử dụng đúng ba mức theo quy định báo cáo: **Tốt**, **Khá** và
**Trung bình**.

| STT | Tiêu chí | Mức | Nhận xét dựa trên minh chứng |
| ---: | --- | :---: | --- |
| 1 | **Kiến thức và kỹ năng chuyên môn** | **Khá** | Báo cáo liên kết endpoint cốt lõi với FastAPI route, tách service, ràng buộc SQLAlchemy, kiểm tra role/quyền sở hữu, tính progress và kiểm tra file. Minh chứng triển khai cá nhân và nghiệm thu AWS thật còn thiếu. |
| 2 | **Khả năng học hỏi** | **Khá** | Phần rà soát bao phủ upload trực tiếp, multipart hỗ trợ và cách test S3/CloudWatch bằng client kiểm soát trước khi xác minh live. Cần mentor/task evidence cho tiến trình học thực tế. |
| 3 | **Tính chủ động** | **Khá** | Báo cáo chuyển danh sách endpoint thành quy tắc dữ liệu, case positive/negative, Postman artifact đã sửa, automated check và gap list; phần thực thi và attribution chưa hoàn tất. |
| 4 | **Kỷ luật** | **Khá** | Báo cáo hiện tại giữ source, API contract, worklog và trạng thái test nhất quán, không ghi case chưa chạy thành đã đạt. Luân vẫn cần điền toàn bộ kết quả thủ công và sắp xếp minh chứng cuối kỳ trước 15/08. |
| 5 | **Giao tiếp** | **Khá** | API contract, tài liệu song ngữ, phạm vi endpoint và các việc còn thiếu đã được ghi lại để bàn giao. Chỉ repository chưa đủ chứng minh mức giao tiếp nhóm thường xuyên để tự chấm Tốt; tôi cần cập nhật tiến độ và defect ngắn gọn, đều đặn hơn. |
| 6 | **Teamwork** | **Khá** | API trong hướng được giao tích hợp với authentication, course, lesson, frontend và AWS do các thành viên khác phụ trách. Interface đã được ghi rõ nhưng lần chạy end-to-end liên vai trò và minh chứng bàn giao cuối vẫn chưa hoàn tất. |
| 7 | **Giải quyết vấn đề** | **Khá** | Rà soát code/test bao phủ enrollment/progress trùng, truy cập khi chưa enroll, quyền sở hữu khóa học, extension sai, multipart hỗ trợ và lỗi CloudWatch an toàn. Vẫn cần bằng chứng cá nhân xử lý các vấn đề này. |
| 8 | **Đóng góp cho dự án** | **Khá** | Đóng góp dự kiến là lát cắt bảy endpoint cùng kiểm thử. Codebase và local test chứng minh lát cắt tồn tại; attribution cá nhân và nghiệm thu live vẫn đang chờ. |

## Điểm mạnh

- Codebase được rà soát để backend tính kết quả enrollment/progress và bảo vệ bằng
  phân quyền cùng ràng buộc duy nhất ở database, không tin trạng thái client gửi.
- Test plan trong báo cáo xét cả luồng thành công và lỗi: retry, request trùng,
  truy cập sai quyền, file không hợp lệ và multipart upload bị bỏ dở.
- Hành vi code/test đã xác nhận được tách rõ khỏi kế hoạch hoặc minh chứng AWS
  live chưa có, giúp báo cáo có thể kiểm tra lại.

## Điểm cần cải thiện

- Chạy Postman collection đã sửa cho báo cáo với My Courses, progress, multipart
  upload và Admin CloudWatch; sau đó ghi status, response thực tế và defect cho
  mọi test case.
- Xác minh upload thumbnail, material, video trực tiếp và multipart trên môi
  trường S3 private đã cấu hình, đồng thời chụp minh chứng đã che dữ liệu nhạy
  cảm.
- Đối chiếu request API thành công và lỗi có kiểm soát với đúng CloudWatch log
  group, không để lộ token, credential hoặc query string của presigned URL.
- Cập nhật cho nhóm thường xuyên hơn về tiến độ, thay đổi interface, blocker và
  kết quả regression để việc tích hợp và bàn giao rõ ràng hơn.

## Đánh giá tổng thể tạm thời

Mức **Khá tạm thời tại mốc này** có cơ sở cho phần báo cáo đã được ghi nhận.
Codebase được cung cấp có phần triển khai cốt lõi và targeted regression chứng
minh hành vi phân quyền, toàn vẹn dữ liệu, xử lý lỗi; các dữ kiện đó chưa chứng
minh Luân là tác giả. Để có cơ sở tự đánh giá **Tốt** ở cuối kỳ, cần bổ sung minh
chứng attribution, hoàn tất ma trận Postman, xác minh S3/CloudWatch live, retest
defect và chuẩn bị đủ minh chứng bàn giao trước khi kỳ thực tập kết thúc.
