---
title: "FCAJ x Agentic AI Build Week 2026 — Hackathon Awards & Project Showcase"
menuTitle: "AABW 2026"
weight: 2
pre: "<b>4.2.</b>"
---

## Tổng quan sự kiện

Ngày 25/07/2026, tôi tham gia **FCAJ x Agentic AI Build Week 2026 — Hackathon Awards & Project Showcase**. Chương trình giới thiệu các dự án Agentic AI thực tế cùng hành trình kỹ thuật phía sau, từ thu hẹp phạm vi, lựa chọn kiến trúc và điều chỉnh sau những lần thử chưa thành công đến chuẩn bị một bản trình diễn hoạt động ổn định trong thời gian giới hạn.

| Nội dung | Thông tin |
|---|---|
| Sự kiện | FCAJ x Agentic AI Build Week 2026 — Hackathon Awards & Project Showcase |
| Ngày | 25/07/2026 |
| Địa điểm | Văn phòng AWS, tầng 26, Bitexco Tower, số 02 đường Hải Triều, phường Sài Gòn, Thành phố Hồ Chí Minh |
| Đơn vị tổ chức | First Cloud AI Journey (FCAJ), Amazon Web Services (AWS) và cộng đồng Agentic AI Build Week |
| Hình thức tham gia | Người tham dự |

## Các dự án được trình bày

Sự kiện giới thiệu bốn dự án ứng dụng Agentic AI vào những bài toán rất khác nhau:

- **3KA — S.H.E.P.H.E.R.D** sử dụng YOLO và ByteTrack để nhận diện, theo dõi đám đông; kết hợp Amazon SageMaker, Amazon Bedrock AgentCore, Strands Agents và dashboard React. Dự án minh họa cách dữ liệu hình ảnh có thể hỗ trợ đánh giá tình trạng tập trung đông người, phát hiện nguy cơ và ra quyết định ứng phó.
- **OneTeam — KFC Bot Agent** trình diễn tác nhân hội thoại phục vụ đặt hàng trên các kênh như Zalo và WhatsApp. Việc tách adapter của từng kênh khỏi công cụ dùng chung và logic nghiệp vụ giúp hệ thống dễ mở rộng mà không phải thiết kế lại toàn bộ quy trình.
- **Plan V — Solution Architect Professional Native App** chuyển yêu cầu bằng ngôn ngữ tự nhiên thành bản kiến trúc ban đầu, sơ đồ draw.io có thể chỉnh sửa với bộ biểu tượng AWS chính thức và ước tính chi phí định hướng cho Region `ap-southeast-1`. Ứng dụng còn nêu rõ giả định và thông tin còn thiếu để người dùng tiếp tục rà soát.
- **SignalScout** trình bày nền tảng hỗ trợ quyết định dựa trên bằng chứng, có khả năng phát hiện tín hiệu thị trường và tổ chức, phân tích kịch bản và đề xuất hướng hành động. Kiến trúc của dự án cho thấy cách kết hợp khối lượng công việc AI với các lớp định danh, lưu trữ, bảo mật, kiểm toán và giám sát trên AWS.

## Bài học tôi rút ra

Bài học quan trọng nhất đối với tôi là một AI agent không chỉ là mô hình tạo ra câu trả lời. Để trở thành một giải pháp đáng tin cậy, hệ thống còn cần mục tiêu rõ ràng, công cụ được kiểm soát, bước kiểm chứng kết quả, khả năng quan sát và con người chịu trách nhiệm đối với những quyết định quan trọng.

Tôi cũng học được rằng nên đánh giá một bản thử nghiệm qua mức độ hoàn chỉnh của luồng cốt lõi, thay vì số lượng tính năng hoặc dịch vụ đám mây được sử dụng. Một kịch bản nhỏ nhưng chạy xuyên suốt từ đầu vào đến kết quả đã kiểm chứng sẽ thuyết phục hơn một thiết kế rộng nhưng còn thiếu các mắt xích quan trọng. Vì vậy, kiến trúc, bảo mật, độ trễ, chi phí vận hành, giám sát và cách xử lý lỗi cần được cân nhắc ngay trong quá trình thiết kế sản phẩm.

## Liên hệ với công việc EduCloud

Những bài học trên liên quan trực tiếp đến phạm vi tôi phụ trách trong EduCloud: đăng ký khóa học, theo dõi tiến độ, tải tệp và kiểm thử API. Tôi sử dụng ba tiêu chí sau để định hướng công việc:

1. Trình diễn một hành trình học tập có thể truy vết qua `POST /api/courses/{id}/enroll`, `GET /api/my-courses`, `POST /api/lessons/{id}/complete` và `GET /api/courses/{id}/progress`.
2. Xem nhóm API upload là ranh giới giữa ứng dụng và Amazon S3, với bước kiểm tra đầu vào, lưu trữ riêng tư, xử lý lỗi rõ ràng và thông tin xác thực được đặt ngoài repository.
3. Bao phủ cả yêu cầu thành công và dữ liệu không hợp lệ trong Postman, sau đó đối chiếu hành vi quan sát được của API với log CloudWatch thay vì chỉ kiểm tra từng thành phần riêng lẻ.

Sau khi tham gia sự kiện, tôi hiểu rõ hơn rằng một phần trình diễn kỹ thuật tốt cần được xây dựng quanh các quyết định có thể giải thích và một luồng end-to-end ổn định. Góc nhìn này giúp tôi giữ workshop EduCloud đúng trọng tâm công việc được giao, đồng thời trình bày rõ hơn vai trò của từng API, bài kiểm thử và dịch vụ AWS.
