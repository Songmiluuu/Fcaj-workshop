---
title: "Tuần 9 - Rà soát vận hành và bảo mật"
menuTitle: "Tuần 9"
weight: 9
pre: "<b>1.9.</b>"
---

# Tuần 9 - Rà soát vận hành và bảo mật

**Thời gian:** 03–07/08/2026

## Công việc

Rà soát các vấn đề vận hành và bảo mật của môi trường EduCloud, gồm phân quyền,
logging, bảo vệ dữ liệu lưu trữ và các thực hành AWS Well-Architected.

## Nội dung thực hiện

- Kiểm tra lại role guard ở backend cho các thao tác của Student, Instructor và
  Admin.
- Rà mô hình S3 private, course object prefix, giới hạn upload và cách xử lý
  multipart upload chưa hoàn tất.
- Đối chiếu application event với luồng log CloudWatch; bảo đảm minh chứng công
  khai không chứa token, account identifier, presigned URL hoặc raw log riêng tư.
- Xem lại các biện pháp về reliability, security, operational excellence,
  performance và cost trong môi trường demo hiện tại.

## Kết quả

Checklist vận hành và bảo mật bao phủ phân quyền, lưu trữ protected, xử lý log,
deployment health và trách nhiệm cleanup.

