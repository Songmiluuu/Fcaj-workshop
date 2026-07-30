---
title: "Chuẩn bị và thiết lập an toàn"
menuTitle: "Chuẩn bị"
weight: 2
pre: "<b>5.2.</b>"
---

# Chuẩn bị và thiết lập an toàn

## Công cụ

- Python 3.11 trở lên.
- Git và PowerShell (hoặc terminal tương đương).
- Postman Desktop hoặc CLI/Newman để chạy collection.
- Một bản checkout EduCloud local.
- Supabase PostgreSQL project và Cognito User Pool riêng khi test authentication
  end-to-end.
- AWS sandbox account chỉ dùng cho kiểm tra tích hợp S3/CloudWatch.

Nguồn tài liệu backend đáng tin cậy nhất là Swagger sinh khi chạy tại
`http://127.0.0.1:8001/docs`. File OpenAPI tĩnh đính kèm là snapshot để audit,
không thay thế runtime documentation.

## Chạy backend

Từ repository EduCloud:

```powershell
Set-Location backend
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements-dev.txt
python -m uvicorn main:app --reload --port 8001
```

Tạo `backend/.env` từ file mẫu và chỉ dùng giá trị của chính bạn. Ứng dụng tối
thiểu cần database URL cùng cấu hình JWT/Cognito. Kiểm tra S3 và monitoring còn
dùng các biến dạng:

```dotenv
UPLOAD_STORAGE=s3
AWS_REGION=YOUR_REGION
AWS_S3_BUCKET_NAME=YOUR_PRIVATE_BUCKET
AWS_S3_PUBLIC_BASE_URL=https://YOUR_CLOUDFRONT_DOMAIN
AWS_MONITORING_ENABLED=true
AWS_CLOUDWATCH_LOG_GROUP=YOUR_ELASTIC_BEANSTALK_LOG_GROUP
```

Không đưa giá trị thật vào báo cáo, Git, ví dụ Postman, screenshot hay biến
frontend `VITE_*`.

## Chuẩn bị identity

| Identity | Dùng cho | Điều kiện tối thiểu |
|---|---|---|
| Student | Enrollment và progress | Bearer token hợp lệ; application user có role `student` |
| Instructor | Positive upload test | Là owner của course được chọn |
| Instructor khác | Negative upload test | Không sở hữu course đó |
| Admin | CloudWatch viewer | Bearer token hợp lệ với application role `admin` |

Token được để trống có chủ đích trong Postman collection. Lấy token qua login flow
thật, chỉ dán vào collection variable local và xóa sau khi chạy.

## Chuẩn bị dữ liệu xác định

Tạo hoặc chọn:

1. một course published thuộc Instructor;
2. final assessment đã publish vì enrollment bắt buộc điều kiện này;
3. ít nhất hai lesson để một lần complete tạo phần trăm dễ quan sát;
4. course published thứ hai mà Student chưa enroll;
5. file fixture nhỏ đã loại thông tin cá nhân: PNG, PDF, MP4 và một extension không
   được hỗ trợ; và
6. chưa có certificate khi kiểm tra undo progress.

Lưu ID local thành `course_id`, `lesson_id` và
`not_enrolled_course_id`.

## Import tài liệu đính kèm

- {{< staticlink path="files/EduCloud-API-Testing.postman_collection.json" text="Tải Postman collection theo phạm vi" download="true" >}}
- {{< staticlink path="files/educloud-openapi.yaml" text="Tải OpenAPI snapshot" download="true" >}}
- {{< staticlink path="files/api-test-matrix.md" text="Tải ma trận kiểm thử theo minh chứng" download="true" >}}

## Cổng an toàn trước khi test

- xác nhận đúng AWS account và Region trên console;
- đặt budget alert;
- dùng test bucket/prefix, không sửa object production dùng chung;
- che Authorization header và presigned URL trong output Postman;
- chỉ cấp IAM least privilege;
- kiểm tra retention của CloudWatch log; và
- thống nhất với nhóm trước khi đổi/xóa tài nguyên dùng chung.
