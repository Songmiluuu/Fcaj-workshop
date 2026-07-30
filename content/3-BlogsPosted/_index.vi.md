---
title: "Bản nháp blog kỹ thuật"
weight: 3
chapter: false
pre: "<b>3.</b>"
---

Ba bài dưới đây là bản nháp nội bộ đã sẵn sàng để nộp/xuất bản, được viết theo
phạm vi EduCloud của Nguyễn Song Minh Luân và bằng chứng trong codebase local.

Bằng chứng repository xác nhận hành vi kỹ thuật, không tự xác nhận tác giả cá
nhân. Trước khi đăng, Luân cần chỉnh mọi câu ngôi thứ nhất theo công việc thực tế
và bằng chứng mentor/PR. Blog 3 chủ động phân tích extension codebase nằm ngoài
bảy endpoint cốt lõi được giao.

> **Trạng thái xuất bản:** Chưa đăng công khai. Sau khi bài thật sự được đăng
> qua kênh AWS Study Group theo yêu cầu, bổ sung đúng URL public và ngày đăng tại
> đây. Route nội bộ của workshop không phải bằng chứng đã xuất bản và không được
> tự tạo link public.

<h2 class="blog-list-title"><a href="enrollment-idempotency/">Blog 1 — Thiết kế ghi danh có phân quyền và tính idempotent</a></h2>

Cách EduCloud lấy danh tính Student từ token đã xác minh, kiểm tra điều kiện khóa
học, trả enrollment hiện có khi retry và dùng unique constraint ở database làm
ranh giới toàn vẹn cuối cùng.

**URL AWS Study Group public:** Chờ bài được xuất bản thật.

<h2 class="blog-list-title"><a href="progress-consistency/">Blog 2 — Giữ tiến độ bài học nhất quán khi request lặp</a></h2>

Cách một state trên mỗi user/lesson, enrollment guard, phần trăm tính từ database
và ranh giới certificate giúp progress có kết quả ổn định.

**URL AWS Study Group public:** Chờ bài được xuất bản thật.

<h2 class="blog-list-title"><a href="s3-multipart-validation/">Blog 3 — S3 multipart upload an toàn và kiểm tra sau deploy</a></h2>

Cách FastAPI phân quyền upload theo course, browser gửi part trực tiếp vào S3
private, đồng thời dùng Postman, automated test, health data và CloudWatch mà
không ghi sai test chưa chạy thành đã pass.

**URL AWS Study Group public:** Chờ bài được xuất bản thật.
