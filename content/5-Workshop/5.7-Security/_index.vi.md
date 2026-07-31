---
title: "Bảo mật và độ tin cậy"
menuTitle: "Bảo mật & độ tin cậy"
weight: 7
pre: "<b>5.7.</b>"
---

# Bảo mật và độ tin cậy

## Ma trận phân quyền

| Thao tác | Student | Instructor owner | Instructor khác | Admin |
|---|:---:|:---:|:---:|:---:|
| Enroll / My Courses | Cho phép | Từ chối | Từ chối | Từ chối |
| Complete/đọc progress của mình | Cho phép sau enroll | Từ chối | Từ chối | Từ chối |
| Upload vào course sở hữu | Từ chối | Cho phép | Từ chối | Cho phép |
| Đọc log qua Admin API hỗ trợ | Từ chối | Từ chối | Từ chối | Cho phép |

Backend lấy user ID và role từ authenticated context. Enrollment/progress request
body không được phép chỉ định target user ID hoặc role.

## Phòng vệ nhiều lớp

1. **Identity:** kiểm tra upstream Cognito token và phát hành/dùng EduCloud JWT hiện
   tại.
2. **Application role:** yêu cầu Student cho learning state, Admin cho monitoring.
3. **Resource ownership:** yêu cầu course owner hoặc Admin khi upload.
4. **State validation:** course và assessment phải published trước enrollment.
5. **Database constraint:** chặn enrollment/progress row trùng.
6. **Object-key boundary:** key phải thuộc `courses/{course_id}/videos/`.
7. **Input limit:** upload trực tiếp kiểm tra extension và size; multipart hỗ trợ
   kiểm tra thêm MIME, part number, key scope và ETag.
8. **Private storage:** bật S3 Block Public Access và phân phối qua CloudFront origin
   có kiểm soát.
9. **Secret isolation:** production secret nằm ngoài Git/frontend/report.
10. **Log đã che:** chỉ ghi operational context, không ghi bearer token, password,
    presigned URL hay dữ liệu cá nhân.

## Ý định IAM least privilege

Instance role của Elastic Beanstalk chỉ nên truy cập bucket và log group đã chọn.
Policy cụ thể tùy deployment, nhưng resource scope nên dạng:

```text
S3 bucket: arn:aws:s3:::YOUR_BUCKET
S3 objects: arn:aws:s3:::YOUR_BUCKET/courses/*
CloudWatch Logs: log group cụ thể của ứng dụng Elastic Beanstalk
```

Multipart cần quyền create/upload-part/complete/abort; upload thường cần ghi object;
cleanup cần xóa object. Quyền ghi CloudWatch của runtime và quyền đọc của Admin
viewer không được cấp trực tiếp cho browser user.

## Rà soát rủi ro/lỗi

| Rủi ro | Kiểm soát trong code hiện tại | Kết quả kiểm tra |
|---|---|---|
| Student đọc/sửa progress người khác | User ID từ token + enrollment query | Negative case Postman pass |
| Instructor upload sang course khác | Owner/Admin guard | Case Instructor khác pass |
| Thay path để xóa object khác | Kiểm tra prefix trước key/delete | Cross-course case pass |
| Request enroll/progress trùng | Query/update + unique index | Đã xác nhận hành vi retry |
| Extension không hỗ trợ hoặc file trực tiếp quá lớn | Kiểm tra extension/size | Case 415 và 413 pass |
| MIME video multipart không hợp lệ | Multipart MIME allowlist | Case Postman 415 pass |
| Upload lớn mất một part | Retry ba lần + abort | Đã xác nhận abort và cleanup trên S3 |
| Lộ presigned URL | TTL một giờ | Output public đã che dữ liệu |
| S3 bị public | Thiết kế private bucket/OAC | Đã kiểm tra cấu hình môi trường nhóm |
| Không thấy lỗi ứng dụng | Tích hợp CloudWatch log | Đã xác nhận application event được stream |
| Test resource phát sinh phí | Budget, lifecycle, cleanup | Đã rà quy trình cleanup |

## Giới hạn quan trọng

Chỉ đặt `AWS_CLOUDWATCH_LOG_GROUP` mới cho phép ứng dụng đọc group đã cấu hình;
nó không tự bật Elastic Beanstalk log streaming. Tương tự, kiểm tra trong code
không chứng minh bucket policy, CloudFront OAC, CORS, encryption hay lifecycle
rule. Đây là acceptance check của infrastructure, không phải giả định.
