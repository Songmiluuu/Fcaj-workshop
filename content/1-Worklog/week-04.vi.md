---
title: "Tuần 4 - Nền tảng FastAPI và lưu trữ"
menuTitle: "Tuần 4"
weight: 4
pre: "<b>1.4.</b>"
---

# Tuần 4 - Nền tảng FastAPI và lưu trữ

**Thời gian:** 06–12/07/2026

## Công việc

Đồng bộ nền tảng FastAPI, authentication dependency, quy ước response, lưu trữ
PostgreSQL và cấu hình AWS.

## Nội dung thực hiện

- Đăng ký router enrollment, progress, upload và monitoring dưới prefix `/api`.
- Dùng authentication dependency chung để kiểm tra identity và role.
- Đặt business rule trong service thay vì xử lý trực tiếp ở route.
- Kiểm tra model enrollment và progress sử dụng PostgreSQL.
- Tập trung cấu hình S3, CloudFront và CloudWatch trong application settings.
- Giữ credential production ngoài source code và biến frontend.

## Kết quả

Các nhóm API được giao sử dụng chung authentication context, quy ước response,
persistence layer và nguồn cấu hình. Cách tổ chức này giảm sai khác giữa môi
trường local và bước tích hợp AWS.

## Tài liệu kỹ thuật

- `EduCloud/backend/main.py`
- `EduCloud/backend/app/config.py`
- `EduCloud/backend/app/database.py`
- `EduCloud/backend/app/utils/response.py`
