---
title: "Tuần 8 - Kiểm thử xác nhận và bàn giao"
menuTitle: "Tuần 8"
weight: 8
pre: "<b>1.8.</b>"
---

# Tuần 8 - Kiểm thử xác nhận và bàn giao

**Thời gian:** 27–31/07/2026

## Công việc

Chạy Postman, kiểm tra S3/CloudWatch, retest lỗi, hoàn thiện tài liệu và bàn
giao báo cáo.

## Trình tự validation

1. Chạy enrollment và My Courses với request hợp lệ, lặp, thiếu xác thực và sai
   role.
2. Chạy lesson completion và progress với Student đã enroll và chưa enroll.
3. Test thumbnail, material và video hợp lệ lẫn không hợp lệ.
4. Complete và abort hai multipart upload riêng, sau đó kiểm tra cleanup trên
   S3.
5. Gửi một request thành công và một validation error có kiểm soát.
6. Đối chiếu thời gian, route và status của request với event CloudWatch.
7. Chạy lại case fail sau khi sửa defect.

## Gói bàn giao

- Postman collection không chứa token hoặc giá trị môi trường private.
- Kết quả API test có trạng thái cuối và defect note.
- OpenAPI snapshot và API contract.
- Kết quả automated test cho revision source được nộp.
- Worklog, proposal, workshop, self-assessment và feedback song ngữ.
- Known limitation, trạng thái cleanup và ghi chú vận hành.

## Kết quả hoàn tất

- Đã chạy các case Postman tích cực và tiêu cực theo phạm vi.
- Đã kiểm tra direct/multipart upload trên môi trường S3 dùng chung, gồm complete,
  abort, phân quyền và validation.
- Đã đối chiếu hoạt động API có kiểm soát với application event trên CloudWatch.
- Không đưa token, định danh tài nguyên, presigned URL hay raw log payload vào
  file bàn giao public.

## Kiểm tra bảo mật

File public không được chứa bearer token, password, database URL, AWS key,
account identifier, tên bucket private, query string của presigned URL hoặc dữ
liệu người dùng chưa che.
