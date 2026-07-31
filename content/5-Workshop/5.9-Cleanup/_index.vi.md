---
title: "Dọn dẹp và bàn giao"
menuTitle: "Dọn dẹp & bàn giao"
weight: 9
pre: "<b>5.9.</b>"
---

# Dọn dẹp và bàn giao

Mỗi lượt kiểm thử kết thúc bằng bước kiểm tra cleanup. Không xóa tài nguyên dùng
chung nếu owner và nhóm chưa xác nhận chính xác target.

## Trước cleanup

- Export kết quả Postman Runner sau khi xóa token local.
- Lưu screenshot S3/CloudWatch đã che.
- Ghi riêng AWS account alias, Region, mục đích và owner của resource.
- Xác định rõ resource sandbox cá nhân hay demo EduCloud dùng chung.
- Giữ source commit/test command gắn với minh chứng.

## Application data

Dùng application API hoặc database script có kiểm soát để chỉ xóa course/user test
có tên riêng biệt. Kiểm tra record enrollment, progress, assessment và certificate
phụ thuộc. Không chạy SQL delete phạm vi rộng trên dữ liệu dùng chung.

## S3 multipart và object

1. Abort mọi upload cố ý để dở.
2. Kiểm tra màn hình **Multipart uploads** hoặc liệt kê bằng AWS CLI.
3. Chỉ xóa test prefix riêng sau khi xác nhận bucket/key tuyệt đối.
4. Xác nhận lifecycle rule abort multipart cũ.
5. Chỉ invalidate CloudFront nếu test đã thay shared cached path.

Ví dụ inventory chỉ đọc:

```powershell
aws s3api list-multipart-uploads `
  --bucket YOUR_TEST_BUCKET `
  --region YOUR_REGION
```

Không đưa output vào báo cáo public nếu có tên riêng theo account hay upload ID.

## Tài nguyên AWS

Với **deployment sandbox cá nhân**, xóa theo thứ tự phụ thuộc:

1. test object và incomplete multipart upload;
2. CloudFront distribution/OAC sau khi disable;
3. S3 bucket sau khi empty;
4. Elastic Beanstalk environment/application và EC2 resource sinh ra;
5. Amplify test application;
6. Cognito test user/client/pool;
7. Parameter Store test parameter;
8. CloudWatch alarm, dashboard, test log group sau khi export minh chứng; và
9. budget/test IAM policy không còn dùng.

Với **demo nhóm dùng chung**, giữ resource chạy và bàn giao checklist cleanup cho
resource owner.

## Hướng dẫn troubleshooting

| Hiện tượng | Cần kiểm tra |
|---|---|
| Enrollment trả 409 | Course status và final assessment đã publish |
| Progress trả 403 | Student role, token user và enrollment của course chứa lesson |
| Upload trả 403 | Course ID và quyền sở hữu của Instructor |
| Upload trả 413/415 | Giới hạn size, extension và video MIME type |
| Multipart part trả 400 | Prefix chính xác `courses/{course_id}/videos/` |
| Complete lỗi ở S3 | Part number/ETag đã upload, part trùng, IAM permission |
| Media URL trả 403 | Private bucket/OAC policy, CloudFront origin/path, object key |
| Trang CloudWatch trống | Monitoring flag, đúng log group/Region, EB log streaming, cửa sổ 24 giờ |
| Frontend khác Postman | Base URL, JWT, CORS và client state bị cache |

## Gói bàn giao cuối

- Source báo cáo Hugo và GitHub Pages workflow.
- Worklog mười tuần, proposal, workshop,
  self-evaluation và feedback song ngữ.
- Postman collection, OpenAPI snapshot và test matrix theo phạm vi.
- Command/kết quả `pytest` cho revision source được nộp.
- Kết quả Postman/S3/CloudWatch đã làm sạch và các hình cấu hình có liên quan.
- Ba URL blog public thật và minh chứng sự kiện đã xác nhận.
- Known limitation, danh sách owner, trạng thái cost/cleanup và next action.

Bàn giao chỉ hoàn tất khi người khác tái lập được kiểm tra API mà không cần nhận
token, password hay access key riêng.
