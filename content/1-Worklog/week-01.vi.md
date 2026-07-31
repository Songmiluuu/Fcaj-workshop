---
title: "Tuần 1 - Rà soát yêu cầu và phạm vi"
menuTitle: "Tuần 1"
weight: 1
pre: "<b>1.1.</b>"
---

# Tuần 1 - Rà soát yêu cầu và phạm vi

**Thời gian:** 05–12/06/2026

## Công việc

Rà soát yêu cầu FCAJ, workflow EduCloud, ranh giới công việc nhóm và bảy
endpoint được giao.

## Nội dung thực hiện

- Kiểm tra cấu trúc báo cáo thực tập và phạm vi kỹ thuật cần hoàn thành.
- Theo dõi luồng Student từ enrollment, My Courses, complete lesson đến course
  progress.
- Theo dõi luồng Instructor upload thumbnail, tài liệu bài học và video.
- Xác định các phụ thuộc vào authentication, trạng thái course, lesson,
  assessment, PostgreSQL, S3 và CloudWatch.
- Tách bảy endpoint được giao khỏi các chức năng hỗ trợ của ứng dụng chung.

## Kết quả

Phạm vi phụ trách được giới hạn ở Enrollment, Progress, Upload, API regression
và kiểm tra log ứng dụng. Authentication, course authoring, assessment,
certificate, cấu trúc frontend và AWS deployment là các điểm tích hợp chung.

## Tài liệu kỹ thuật

- `EduCloud/api/api-contract.md`
- `EduCloud/backend/app/routes/enrollment_routes.py`
- `EduCloud/backend/app/routes/progress_routes.py`
- `EduCloud/backend/app/routes/upload_routes.py`
