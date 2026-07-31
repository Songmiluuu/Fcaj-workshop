---
title: "Đề xuất dự án"
menuTitle: "Proposal"
weight: 2
chapter: false
disableTitle: true
pre: "<b>2.</b>"
---

<h1 class="proposal-hero-title">EDUCLOUD LITE — API GHI DANH, TIẾN ĐỘ, UPLOAD & KIỂM THỬ</h1>

**Thực tập sinh:** Nguyễn Song Minh Luân  
**Chương trình:** First Cloud AI Journey — Amazon Web Services Vietnam Company Limited  
**Thời gian thực tập:** 01/06/2026 – 14/08/2026

## 1. Tổng quan dự án

EduCloud Lite là hệ thống quản lý học tập với khóa học miễn phí, gồm frontend
React/Vite và backend FastAPI. Học viên có thể xem khóa học đã xuất bản, ghi
danh, học nội dung được bảo vệ, lưu tiến độ từng bài, làm bài kiểm tra cuối khóa
và nhận chứng chỉ khi đủ điều kiện. Giảng viên có thể biên soạn khóa học, tải
thumbnail, tài liệu và video; Admin có thể theo dõi dữ liệu và health hệ thống.

Codebase sử dụng kiến trúc AWS tối ưu cho bài demo chi phí thấp: Amplify Hosting
phục vụ frontend, Amazon Cognito quản lý danh tính, FastAPI chạy trên môi trường
Elastic Beanstalk single instance, S3 private lưu tài nguyên khóa học, CloudFront
phân phối media và route API, còn CloudWatch hỗ trợ quan sát vận hành. Supabase
PostgreSQL là database ứng dụng bên ngoài AWS và là nơi xác định role.

Đề xuất này trình bày toàn hệ thống của nhóm để làm rõ ngữ cảnh tích hợp. Nội
dung **không** khẳng định một thực tập sinh xây dựng toàn bộ sản phẩm.

## 2. Bài toán cần giải quyết

Một trang khóa học tĩnh không thể trả lời tin cậy bốn câu hỏi: ai được ghi danh,
học viên đã hoàn thành bài nào, ai được upload file cho khóa học, và API có chạy
đúng sau khi deploy hay không. Nếu thiếu quy tắc backend, hệ thống dễ gặp:

- trùng enrollment hoặc progress do retry và nhấn nút nhiều lần;
- người chưa ghi danh vẫn sửa tiến độ;
- giảng viên upload vào khóa học không thuộc quyền sở hữu;
- video lớn đi qua application server, làm tốn bandwidth hoặc đầy temporary
  storage;
- file không hợp lệ, S3 key chéo khóa học hoặc multipart upload bị bỏ dở;
- test local thành công nhưng không có đủ bằng chứng Postman và CloudWatch trên
  môi trường deploy.

Vì vậy EduCloud cần operation có xác thực, có tính idempotent, object storage
theo phạm vi khóa học, kiểm thử lặp lại được và khả năng quan sát production.

## 3. Mục tiêu và tiêu chí thành công

| Mục tiêu | Tiêu chí nghiệm thu đo được |
| --- | --- |
| Ghi danh an toàn | Chỉ Student được ghi danh; khóa học phải tồn tại, ở trạng thái published và có final assessment đã publish. Gọi lại trả về enrollment cũ; database chỉ cho một dòng trên mỗi user/course. |
| Tiến độ nhất quán | Chỉ Student đã ghi danh được complete bài học và đọc tiến độ khóa học. Mỗi user/lesson có một dòng và API tính số bài cùng phần trăm trực tiếp từ database. |
| Upload có kiểm soát | Chỉ chủ khóa học hoặc Admin được upload. Route trực tiếp cốt lõi kiểm tra extension và size; luồng multipart hỗ trợ kiểm tra thêm video MIME, course key prefix, part number và part trùng. |
| Extension hỗ trợ video lớn | Codebase hiện tại có thêm multipart browser-to-S3 theo part 10 MiB với thao tác complete/abort. Đây là ngữ cảnh tích hợp, không thuộc bảy endpoint cốt lõi được giao. |
| Kiểm thử lặp lại được | Có test tích cực/tiêu cực cho enrollment, progress, upload, authorization và validation trong test plan/Postman; automated test tiếp tục pass. |
| Có bằng chứng vận hành | Kiểm tra sau deploy ghi nhận kết quả request, lỗi, Elastic Beanstalk health và CloudWatch event liên quan mà không làm lộ token hoặc secret. |
| Kiểm soát chi phí | Demo dùng quy mô triển khai nhỏ và có checklist cleanup compute, log, object cùng multipart upload dở dang. |

Code hiện có cung cấp bằng chứng tại
`backend/app/services/enrollment_service.py`, `progress_service.py`,
`s3_service.py`, các file route/model tương ứng, API/Postman artifacts và backend
tests. Ma trận đính kèm tách kết quả automated khỏi Postman manual và kiểm tra
AWS trên môi trường dùng chung để mỗi kết quả được đối chiếu đúng ngữ cảnh.

## 4. Ranh giới phạm vi và trách nhiệm

### 4.1 Phạm vi toàn nhóm

Sản phẩm EduCloud hoàn chỉnh gồm đăng ký/đăng nhập Cognito, role người dùng,
quản lý course/lesson, nội dung học được bảo vệ, assessment, certificate, review,
instructor application, chức năng Admin, giao diện frontend, deployment và các
database model dùng chung.

### 4.2 Phạm vi cá nhân của Nguyễn Song Minh Luân

Ảnh phân công xác định **hướng công việc cốt lõi** của tôi là API Developer —
Enrollment, Progress, Upload & Testing:

- `POST /api/courses/{course_id}/enroll` và `GET /api/my-courses`;
- `POST /api/lessons/{lesson_id}/complete`;
- `GET /api/courses/{course_id}/progress`;
- `POST /api/upload/course-thumbnail`, `POST /api/upload/lesson-material` và
  `POST /api/upload/video`;
- phân quyền Student/enrollment và Instructor-or-Admin/course ownership cho các
  luồng trên;
- kiểm tra input, quy tắc idempotency, database uniqueness và thông báo lỗi cho
  các luồng trên;
- kiểm thử API bằng Postman và kiểm tra log ứng dụng trên CloudWatch.

Codebase nhóm hiện có thêm `DELETE` hoàn tác progress, import/deduplicate
thumbnail, multipart start/part/complete/abort và endpoint Admin đọc log
CloudWatch. Báo cáo có thể rà soát/test các **extension hỗ trợ** này nhưng không
xem chúng là bảy endpoint cốt lõi được giao ban đầu.

Authentication, course/lesson authoring, frontend, database và deployment do
thành viên khác phụ trách là dependency/ngữ cảnh tích hợp, không phải sản phẩm cá
nhân. Nếu sửa lỗi ở ranh giới tích hợp, tôi sẽ ghi riêng thay vì xem đó là tính
năng cốt lõi được giao.

### 4.3 Ngoài phạm vi

Khóa học trả phí, checkout, high availability đa Region ở quy mô production,
certificate PDF sinh tự động ở server, transcoding/DRM, malware scanning và một
observability platform cấp doanh nghiệp không nằm trong phạm vi thực tập.

## 5. Kiến trúc AWS toàn hệ thống

{{< staticimage path="images/architect.jpg" alt="Kiến trúc AWS EduCloud" >}}

| Lớp | Thành phần và trách nhiệm |
| --- | --- |
| Phân phối web | GitHub `main` kích hoạt Amplify Hosting build và phục vụ React/Vite SPA qua HTTPS. |
| Danh tính | Amazon Cognito xử lý đăng ký, xác minh email, đăng nhập và recovery. FastAPI xác minh Cognito identity rồi cấp EduCloud JWT chứa role hiện tại trong PostgreSQL. |
| Điểm vào và routing | CloudFront phân phối tài nguyên từ S3 và chuyển `/api/*` tới origin Elastic Beanstalk. API response không dùng chính sách cache dành cho media. |
| API compute | FastAPI chạy trong Elastic Beanstalk Python single-instance dùng EC2 cho lưu lượng demo thấp. |
| Dữ liệu ứng dụng | Supabase PostgreSQL nằm ngoài AWS account boundary, kết nối TLS và lưu users, courses, lessons, enrollments, progress, assessments, certificates. |
| Object storage | S3 private lưu object dưới `courses/{course_id}/...`. CloudFront Origin Access Control là đường đọc; presigned `UploadPart` URL cấp quyền ghi tạm thời cho video. |
| Cấu hình và quyền | Systems Manager Parameter Store lưu production secret khi được cấu hình. IAM role chỉ cấp quyền S3, CloudWatch, cấu hình và đọc chi phí cần thiết cho backend. |
| Vận hành | Elastic Beanstalk health, CloudWatch logs, Admin health, dung lượng S3 và Cost Explorer tạo tín hiệu troubleshooting và bằng chứng deploy. |

Luồng API cốt lõi như sau: browser đã đăng nhập gửi EduCloud bearer
token tới FastAPI; FastAPI kiểm tra quyền dựa trên PostgreSQL; enrollment/progress
được commit vào PostgreSQL, còn request điều khiển upload tạo thao tác S3 theo
phạm vi course. Là extension hỗ trợ trong codebase, browser có thể gửi byte video
trực tiếp tới S3 rồi trả ETag về FastAPI để complete multipart đúng thứ tự.

## 6. Bảo mật, toàn vẹn dữ liệu và quyền riêng tư

- Lấy `user_id` và role từ token đã xác minh; không nhận target student từ body
  của request enrollment/progress.
- Enforce Student-only cho enrollment/progress và course-owner-or-Admin cho
  upload ở backend, không chỉ ẩn nút trên frontend.
- Giữ unique constraint `(user_id, course_id)` và `(user_id, lesson_id)`; xử lý
  retry/concurrency mà không tạo dòng trùng.
- Chỉ cho ghi danh vào course published có assessment đã publish.
- Kiểm tra extension và giới hạn hiện tại: thumbnail 10 MiB, material 50 MiB,
  video 500 MiB. Multipart chấp nhận MIME MP4, WebM và QuickTime.
- Giới hạn key theo `courses/{course_id}/videos/{filename}` trước khi authorize,
  complete hoặc abort. Presigned URL hiện hết hạn sau một giờ.
- Bật S3 Block Public Access và dùng CloudFront OAC để đọc. Không đưa AWS
  credential, database URL, JWT secret, bearer token hoặc query string của
  presigned URL vào báo cáo/log.
- Chỉ cho CORS từ frontend đã deploy và expose S3 `ETag` đúng nhu cầu multipart.
  Mọi external hop sử dụng HTTPS/TLS.
- Xem cách lưu token trong browser và rate/traffic metric trong process hiện tại
  là giới hạn prototype; production cần session ngắn hạn, shared rate limiting
  và structured audit logging.

## 7. Kế hoạch kiểm thử và giám sát

Ba lớp kiểm thử bổ sung cho nhau:

1. **Automated test:** xác minh enrollment/progress lấy dữ liệu thật từ database,
   tiến độ 50% khi hoàn thành một trong hai bài, từ chối loại file sai, sắp xếp
   multipart part và chặn key thuộc course khác.
2. **Postman/Swagger:** chạy happy path và negative case bằng Student,
   Instructor, Admin; token thiếu, role sai, course chưa publish, chưa enroll,
   file sai, file quá lớn và key chéo course. Export collection/environment đã
   bỏ secret và lưu response evidence.
3. **Kiểm tra sau deploy:** gọi một số API qua public route, kiểm tra side effect
   trong database/S3, xem Elastic Beanstalk health và stream CloudWatch mới nhất,
   rồi đối chiếu timestamp/status code. Không log full Authorization header hay
   presigned URL.

Admin health hiện báo database latency/row count, local hoặc S3 storage,
process-local request total, số 4xx/5xx gần đây, response time trung bình và top
route. Traffic value trong memory bị reset khi backend restart nên CloudWatch là
nguồn lịch sử production lâu dài. Cần theo dõi enrollment conflict, lỗi phân
quyền progress, upload 4xx/5xx, lỗi S3, latency, EC2/Elastic Beanstalk health,
storage growth, incomplete multipart upload và chi phí.

## 8. Kế hoạch mười tuần

Mười giai đoạn công việc được ghi nhận từ 05/06 đến 14/08/2026.

| Tuần | Thời gian | Công việc |
| --- | --- | --- |
| 1 | 05–12/06 | Rà soát yêu cầu FCAJ, workflow EduCloud, ranh giới công việc nhóm và bảy endpoint được giao. |
| 2 | 15–19/06 | Xác định quyền Student và Instructor/Admin, tiêu chí thành công, case lỗi và kết quả kiểm tra cần lưu. |
| 3 | 22–26/06 | Thiết kế API contract, ràng buộc dữ liệu enrollment/progress, validation upload và biến Postman dùng lại. |
| 4 | 29/06–03/07 | Đồng bộ nền tảng FastAPI, authentication dependency, quy ước response, lưu trữ PostgreSQL và cấu hình AWS. |
| 5 | 06–10/07 | Triển khai và kiểm tra enrollment cùng My Courses, gồm xử lý request trùng và giới hạn quyền Student. |
| 6 | 13–17/07 | Triển khai và kiểm tra lesson completion, course progress, upload thumbnail, material và video có phân quyền. |
| 7 | 20–24/07 | Tích hợp API với frontend, authentication và course dùng chung; rà automated regression và chuẩn bị Postman collection theo phạm vi. |
| 8 | 27–31/07 | Chạy Postman, kiểm tra S3/CloudWatch, retest lỗi, hoàn thiện tài liệu và bàn giao báo cáo. |
| 9 | 03–07/08 | Rà soát vận hành, kiểm soát bảo mật, log AWS và các thực hành Well-Architected liên quan đến EduCloud. |
| 10 | 10–14/08 | Tổng hợp kiến thức Generative AI, Agentic AI và AWS; hoàn thiện bản tổng kết cùng lộ trình phát triển. |

## 9. Kế hoạch chi phí và tối ưu

Báo cáo không ghi một con số ước tính như hóa đơn thật. Giá AWS thay đổi theo
Region, usage và thời điểm, vì vậy phần này tập trung vào các lựa chọn triển khai
giúp hạn chế chi phí không cần thiết.

| Nguồn chi phí | Giả định và biện pháp kiểm soát |
| --- | --- |
| Elastic Beanstalk/EC2 | Một single instance cho demo ít traffic; không tạo load balancer hoặc multi-instance fleet khi chưa cần; terminate sau đánh giá nếu được phép. |
| Amplify | SPA nhỏ, kiểm soát số lần build; theo dõi build minute, artifact storage và outbound transfer. |
| S3 | Chỉ lưu media cần thiết; dùng course prefix, xóa object bị thay và lifecycle rule để abort multipart upload dở dang. |
| CloudFront | Cache media có version nhưng không cache enrollment/progress response cá nhân; theo dõi request và data transfer, nhất là video. |
| Cognito | Chỉ có active user quy mô demo; theo dõi usage, không mặc định free allowance tồn tại mãi. |
| CloudWatch | Đặt retention rõ ràng, tránh log quá chi tiết chứa payload lớn hoặc presigned URL. |
| Database bên ngoài | Theo dõi Supabase riêng vì đây không phải AWS charge; dùng gói nhỏ nhất đáp ứng bài nộp. |

Budget alert, việc rà chi phí định kỳ, inventory tài nguyên đang chạy và
checklist cleanup đúng thứ tự là các biện pháp được khuyến nghị cho môi trường
dùng chung.

## 10. Rủi ro và hướng xử lý

| Rủi ro | Ảnh hưởng | Hướng xử lý |
| --- | --- | --- |
| Hai enrollment request đồng thời | Lỗi unique hoặc membership trùng | Giữ unique constraint; nếu request khác commit trước thì rollback transaction lỗi, tải lại enrollment đó và trả về. |
| Progress cũ hoặc sai | Resume sai hoặc xét certificate sai | Lọc theo user xác thực và lesson hiện tại của course; update một user/lesson row; test complete/undo lặp và lesson deletion. |
| Upload trái phép | Ghi đè/lộ nội dung course khác | Check course ownership/Admin ở mọi bước multipart và validate toàn bộ course key prefix. |
| Multipart dở dang | Part rác trên S3 và phát sinh phí | Abort khi client lỗi, thêm S3 lifecycle cleanup và giám sát incomplete upload. |
| S3 CORS không expose `ETag` | Browser không complete được upload | Chỉ cho origin/method/header cần thiết, expose `ETag`, test bằng browser thật. |
| Lộ presigned URL | Quyền ghi tạm thời bị sử dụng trái phép | Dùng expiry ngắn, che query string, không lưu URL trong log và chỉ cấp sau authorization. |
| Monitoring trong process bị reset | Mất lịch sử sau restart/scale-out | Dùng CloudWatch cho log/metric lâu dài; Admin traffic snapshot chỉ hỗ trợ demo. |
| Chi phí cloud tăng | Credit bị dùng sau khi test | Dùng budget, retention/lifecycle, review theo lịch và checklist cleanup cuối kỳ. |

## 11. Sản phẩm bàn giao và hướng phát triển

Sản phẩm cá nhân dự kiến gồm bảy API cốt lõi và quy tắc service/data liên quan,
API contract/Postman artifact cập nhật, automated/manual test evidence, ghi chú
kiểm tra CloudWatch, proposal, worklog và ba bài blog kỹ thuật đã đăng.
Multipart, hoàn tác progress, import thumbnail và Admin log-reader được ghi nhận
là extension hỗ trợ xung quanh các endpoint cốt lõi.

Hướng phát triển tiếp theo là load test enrollment/progress khi có nhiều request
đồng thời, Alembic migration, lưu multipart session để resume, checksum và malware scanning,
lifecycle tự động xóa incomplete upload, correlation ID có cấu trúc, CloudWatch
alarm/dashboard, distributed rate limiting và load/security test ở quy mô
production.
