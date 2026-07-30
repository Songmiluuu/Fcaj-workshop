---
title: "Tuần 1 - Khởi động và phân tích phạm vi được giao"
menuTitle: "Tuần 1"
weight: 1
pre: "<b>1.1.</b>"
---

**Thời gian:** 01/06/2026 - 07/06/2026  
**Trạng thái ngày 30/07:** Kế hoạch dựng lại; đã chuẩn bị tài liệu báo cáo

## Mục tiêu

- Ghi nhận thời gian thực tập chính thức, hiểu yêu cầu của project, báo cáo và
  minh chứng theo tuần.
- Chuyển vai trò “Enrollment/Progress/Upload + Testing” thành các đầu việc cụ
  thể trong EduCloud.
- Xác định các phụ thuộc vào xác thực, khóa học, bài học, lưu trữ và giám sát
  AWS trước khi lập trình.

## Công việc dự kiến và tài liệu báo cáo

| Công việc | Kết quả |
| --- | --- |
| Rà soát phạm vi project, tách phần phụ trách khỏi Course/Lesson và Auth. | Xác định năm nhóm: enrollment, progress, upload, kiểm thử Postman và kiểm tra log CloudWatch. |
| Đối chiếu các nhóm API bắt buộc trong contract. | Có danh sách endpoint ban đầu và ranh giới quyền Student, Instructor/Admin, Admin-only. |
| Đọc quy ước response thành công/lỗi và yêu cầu minh chứng. | Lập checklist gồm request, expected response, actual response, trạng thái và minh chứng đã che dữ liệu nhạy cảm. |
| Chia thời gian thực tập thành mười giai đoạn kết thúc ngày 15/08. | Có trình tự từ yêu cầu, triển khai, kiểm thử đến bàn giao. |

## Sản phẩm bàn giao

- Ma trận phạm vi công việc gắn với từng nhóm endpoint EduCloud.
- Kế hoạch mười giai đoạn bao quát **01/06/2026–15/08/2026**.
- Quy tắc minh chứng: source code chứng minh tính năng tồn tại; kết quả Postman
  thủ công và AWS thật phải có minh chứng chạy riêng.

## Tiêu chí hoàn thành

| Tiêu chí | Kết quả |
| --- | --- |
| Mỗi nhóm việc được giao ánh xạ tới ít nhất một API hoặc tài liệu test. | Đạt |
| Mười giai đoạn bao quát toàn bộ kỳ thực tập, không hở ngày. | Đạt |
| Không đưa password, JWT, AWS key hay cấu hình riêng tư vào minh chứng. | Đạt ở mức quy tắc báo cáo |

## Minh chứng trong repository

- EduCloud/api/api-contract.md
- EduCloud/api/test-plan/test-cases.md
- EduCloud/api/test-plan/test-report-template.md
- EduCloud/README.md
