---
title: "API tải lên và Amazon S3"
menuTitle: "API tải lên"
weight: 6
pre: "<b>5.6.</b>"
---

# API tải lên và Amazon S3

Source liên quan:

- `backend/app/routes/upload_routes.py`
- `backend/app/services/s3_service.py`
- `backend/app/services/remote_image_service.py`
- `frontend/src/services/uploadService.ts`
- `backend/tests/test_course_lesson_api.py`

Ba endpoint tải lên trực tiếp thuộc phạm vi cốt lõi. Import/deduplicate thumbnail
từ xa và điều khiển multipart video là hành vi hỗ trợ trong codebase hiện tại,
được tách khỏi nhóm endpoint cốt lõi.

## Ma trận validation

| Loại | Extension/content được phép | Tối đa | Object prefix |
|---|---|---:|---|
| Thumbnail | JPG, JPEG, PNG, WebP | 10 MiB | `courses/{course_id}/thumbnails/` |
| Material | PDF, DOC, DOCX, PPT, PPTX, TXT, ZIP | 50 MiB | `courses/{course_id}/materials/` |
| Video | MP4, WebM, MOV | 500 MiB | `courses/{course_id}/videos/` |

Mỗi route đều tải course trước và yêu cầu Instructor owner hoặc Admin. Việc sửa
form phía client không thể bỏ qua kiểm tra server này.

## Tải lên trực tiếp

Cả ba loại nhận `multipart/form-data` gồm `course_id` và `file`.

```http
POST /api/upload/lesson-material
Authorization: Bearer INSTRUCTOR_JWT
Content-Type: multipart/form-data

course_id=42
file=@lesson-notes.pdf
```

Service kiểm tra extension/kích thước, chọn local/S3 theo cấu hình và trả URL, tên
file gốc, content type, số byte và storage strategy.

Tên thumbnail dùng SHA-256 theo nội dung. Cùng byte thumbnail sẽ tái sử dụng object
key. Material và video dùng UUID để không phải đọc file lớn chỉ nhằm tính hash.

## Phần mở rộng hỗ trợ: tải video multipart

{{<mermaid>}}
sequenceDiagram
    participant UI as React client
    participant API as FastAPI
    participant S3 as Amazon S3
    UI->>API: POST multipart/start
    API->>S3: CreateMultipartUpload
    S3-->>API: upload_id
    API-->>UI: key, upload_id, part_size 10 MiB
    loop từng part, tối đa 3 worker
        UI->>API: POST multipart/part
        API-->>UI: presigned URL sống 1 giờ
        UI->>S3: PUT binary part
        S3-->>UI: ETag
    end
    UI->>API: POST multipart/complete + danh sách part/ETag
    API->>S3: CompleteMultipartUpload
    S3-->>API: thành công
    API-->>UI: delivery URL
{{</mermaid>}}

React client retry một part lỗi tối đa ba lần và chạy nhiều nhất ba part đồng
thời. Nếu hàm tải lên throw hoặc lỗi sau retry, catch path gọi `multipart/abort`.
Hàm không nhận hoặc truyền `AbortSignal`, và UI hiện không có thao tác hủy do
người dùng kích hoạt.

API từ chối:

- key nằm ngoài `courses/{course_id}/videos/`;
- key còn path segment sau generated filename;
- extension hoặc MIME type không hỗ trợ;
- part number trùng;
- part number ngoài 1–10.000;
- ETag/upload ID rỗng; và
- declared size lớn hơn 500 MiB.

## Lưu trữ và phân phối

Trong production, `save_upload` gửi file vào private S3 bucket đã cấu hình. URL
trả về dùng `AWS_S3_PUBLIC_BASE_URL`, thường là CloudFront distribution. Điều này
không làm bucket public; bucket policy và Origin Access Control thuộc shared
infrastructure và phải được kiểm tra riêng.

Môi trường dùng chung của nhóm đặt application upload bucket cùng Region
Singapore với deployment. Tên bucket đã được che trong báo cáo public.

{{< staticimage path="images/workshop/06-s3-shared-buckets-redacted.png" alt="Danh sách S3 bucket đã che tên trong môi trường EduCloud dùng chung" >}}

Khi attachment của lesson được thay/xóa, cleanup theo best effort và chỉ chấp nhận
URL quay về prefix của đúng course owner. S3 lỗi tạm thời được ghi log nhưng không
rollback database update.

## Kiểm tra bằng Postman

1. Chọn file hợp lệ, nhỏ cho từng direct route.
2. Assert 200, URL không rỗng, đúng size và `storage in [local, s3]`.
3. Upload lại cùng thumbnail và so sánh URL/object name.
4. Dùng file không hỗ trợ để assert 415.
5. Dùng token Instructor không phải owner để assert 403.
6. Với multipart: start → xin part URL → PUT part trực tiếp → lấy ETag → complete.
7. Dùng request abort riêng cho multipart thứ hai và xác nhận S3 không còn
   incomplete upload. Đây là kiểm tra API route, không phải nút hủy trên UI.
8. Che token, presigned URL, bucket/account ID và ETag trước khi đăng screenshot.

Automated test mock S3 để kiểm tra giao thức multipart. Lần chạy tích hợp cuối
trên môi trường dùng chung của nhóm đã xác nhận luồng upload S3, kiểm tra quyền,
multipart complete/abort và phân phối media theo cấu hình.
