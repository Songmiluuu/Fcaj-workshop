---
title: "Tổng quan và kiến trúc"
menuTitle: "Tổng quan & kiến trúc"
weight: 1
pre: "<b>5.1.</b>"
---

# Tổng quan và kiến trúc

## Ranh giới trách nhiệm

| Lớp | Hệ thống chung của nhóm | Phần việc được giao cho Luân |
|---|---|---|
| Client | Trang React/Vite và API client | Kiểm tra contract mà Course Detail, My Learning, Learning Page và upload của Instructor sử dụng |
| Identity | Amazon Cognito và đổi sang EduCloud JWT | Yêu cầu current user và kiểm tra role/ownership tại biên API |
| API | FastAPI route và service | Enrollment, progress, upload, Postman test và kiểm tra log |
| Dữ liệu | Supabase PostgreSQL | Giữ toàn vẹn enrollment/progress và tính kết quả từ database |
| Lưu trữ | Amazon S3 private và CloudFront | Validation upload trực tiếp cốt lõi; multipart/abort là extension codebase hỗ trợ |
| Runtime | Elastic Beanstalk/EC2 | Tạo hoạt động request và kiểm tra application log được stream lên CloudWatch |
| Host frontend | AWS Amplify | Chỉ là bối cảnh tích hợp |

## Kiến trúc tập trung vào phần việc

{{<mermaid>}}
flowchart LR
    Student["Trình duyệt Student"] --> React["React client trên Amplify"]
    Instructor["Trình duyệt Instructor"] --> React
    React --> CDN["CloudFront /api behavior"]
    CDN --> API["FastAPI trên Elastic Beanstalk"]
    API --> Auth["Kiểm tra Cognito token"]
    API --> DB["Supabase PostgreSQL"]
    API --> S3["Amazon S3 private"]
    S3 --> CDN
    API --> Logs["CloudWatch Logs"]
    Admin["Trình duyệt Admin"] --> API
{{</mermaid>}}

Báo cáo tập trung vào bốn điểm chuyển giao tin cậy:

1. trình duyệt không đáng tin cậy gửi bearer token đến FastAPI;
2. FastAPI ánh xạ identity và role trước khi đọc/ghi PostgreSQL;
3. request upload hợp lệ nhận thao tác storage theo course hoặc presigned URL S3
   sống ngắn; và
4. môi trường host stream runtime log; codebase hỗ trợ thêm endpoint chỉ dành
   cho Admin để đọc lại.

## Ba nhóm request

### Enrollment

`POST /api/courses/{course_id}/enroll` kiểm tra role Student, course tồn tại,
trạng thái published, final assessment sẵn sàng và enrollment đã có trước khi
insert. Unique constraint `(user_id, course_id)` là lớp bảo vệ ở database.

### Progress

Hai endpoint cốt lõi `POST /api/lessons/{lesson_id}/complete` và
`GET /api/courses/{course_id}/progress` yêu cầu Student đã enroll. Phần trăm được
tính từ progress row, không tin dữ liệu do frontend tự gửi. Route DELETE hoàn tác
trong codebase là extension hỗ trợ.

### Upload

Các route thumbnail, material và video yêu cầu owner của course hoặc Admin.
Backend kiểm tra loại/kích thước. Production lưu object theo
`courses/{course_id}/...` trên S3; codebase hiện có thêm presigned multipart flow
hỗ trợ video lớn.

## Dịch vụ AWS và lý do chọn

- **Amazon S3:** object storage private, bền vững cho tài nguyên khóa học.
- **Amazon CloudFront:** phân phối media có kiểm soát và đường vào API.
- **Amazon CloudWatch:** lưu log ứng dụng và hỗ trợ troubleshooting.
- **Elastic Beanstalk/EC2:** runtime FastAPI được quản lý và tích hợp stream log.
- **Amazon Cognito:** managed identity trước bước authorization của API.
- **AWS Amplify:** build/host frontend React dùng chung.

Supabase PostgreSQL là database managed bên ngoài AWS trong kiến trúc được cung
cấp. Nó lưu application state nhưng không thay thế xác thực Cognito.
