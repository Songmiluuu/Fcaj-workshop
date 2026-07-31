---
title: "Tuần 7 - Tích hợp và kiểm thử hồi quy"
menuTitle: "Tuần 7"
weight: 7
pre: "<b>1.7.</b>"
---

# Tuần 7 - Tích hợp và kiểm thử hồi quy

**Thời gian:** 20–24/07/2026

## Công việc

Tích hợp API với frontend, authentication và course dùng chung; rà automated
regression và chuẩn bị Postman collection.

## Tích hợp

- Kết nối kết quả enrollment với learner dashboard.
- Kết nối response completion và progress với trạng thái học tập của course.
- Kết nối upload của Instructor với quyền sở hữu course và trường media.
- Dùng login flow và thông tin role chung cho các route được giao.
- Rà multipart video và Admin log reader như các luồng tích hợp hỗ trợ.

## Regression

Bảy test được chọn cho enrollment, progress, upload validation, multipart và
CloudWatch đạt **7/7** ngày 30/07. Báo cáo được đồng bộ với README của repository
EduCloud, nơi ghi nhận **12/12** backend test pass tính đến ngày 31/07.

Postman collection có luồng API, biến theo role,
assertion cho response, request multipart và request Admin CloudWatch.

## Kết quả

Các API được giao đã kết nối với component dùng chung và được kiểm tra bằng
automated regression. Postman collection sẵn sàng cho lần chạy local và AWS
cuối.

## Tài liệu kỹ thuật

- `EduCloud/frontend/src/services/enrollmentService.ts`
- `EduCloud/frontend/src/services/progressService.ts`
- `EduCloud/frontend/src/services/uploadService.ts`
- `nopbai/static/files/EduCloud-API-Testing.postman_collection.json`
- `nopbai/static/files/targeted-pytest-result.txt`
- `nopbai/static/files/full-pytest-result.txt`
