---
title: "FCAJ x Agentic AI Build Week 2026 — Hackathon Awards & Project Showcase"
menuTitle: "AABW 2026"
weight: 2
pre: "<b>4.2.</b>"
---

## Tổng quan sự kiện

Ngày 25/07/2026, tôi tham gia **FCAJ x Agentic AI Build Week 2026 — Hackathon
Awards & Project Showcase**. Thay vì chỉ giới thiệu kết quả cuối cùng, các đội còn
chia sẻ cách chọn bài toán, phân chia vai trò, điều chỉnh phạm vi và hoàn thiện
demo trong thời gian của một hackathon. Tôi theo dõi sự kiện với mục tiêu tìm
hiểu điều gì giúp một ý tưởng Agentic AI trở thành sản phẩm có thể trình diễn,
đo lường và giải thích được.

| Nội dung | Thông tin |
|---|---|
| Sự kiện | FCAJ x Agentic AI Build Week 2026 — Hackathon Awards & Project Showcase |
| Ngày | 25/07/2026 |
| Địa điểm | Văn phòng AWS, tầng 26, Bitexco Tower, số 02 đường Hải Triều, phường Sài Gòn, Thành phố Hồ Chí Minh |
| Đơn vị tổ chức | First Cloud AI Journey (FCAJ), Amazon Web Services (AWS) và cộng đồng Agentic AI Build Week |
| Hình thức tham gia | Người tham dự |

## Các dự án được trình bày

Điểm thú vị của phần showcase là bốn đội giải quyết bốn loại vấn đề khác nhau,
nhưng đều phải chứng minh agent sử dụng dữ liệu và công cụ như thế nào:

- **3KA — S.H.E.P.H.E.R.D** kết hợp YOLO và ByteTrack để phát hiện, theo dõi dòng
  người; Amazon SageMaker đảm nhiệm workload mô hình, còn Amazon Bedrock
  AgentCore và Strands Agents hỗ trợ lớp agent. Dashboard React biến kết quả
  phân tích thành thông tin phục vụ nhận biết ùn tắc, nguy cơ và phương án ứng
  phó. Qua dự án này, tôi thấy một hệ thống thị giác không chỉ phụ thuộc vào mô
  hình mà còn phụ thuộc chất lượng dữ liệu, vị trí camera, độ ổn định của
  tracking, độ trễ và phương án dự phòng.
- **OneTeam — KFC Bot Agent** xây dựng luồng đặt hàng hội thoại trên các kênh quen
  thuộc như Zalo và WhatsApp. Cách tách adapter theo kênh khỏi tool đặt hàng và
  logic nghiệp vụ cho thấy một thiết kế module tốt có thể tái sử dụng phần cốt
  lõi khi bổ sung kênh mới. Agent vẫn cần kiểm tra kết quả sau khi gọi tool, thay
  vì xem câu trả lời của mô hình là giao dịch đã hoàn tất.
- **Plan V — Solution Architect Professional Native App** nhận yêu cầu bằng ngôn
  ngữ tự nhiên rồi tạo bản kiến trúc ban đầu, sơ đồ draw.io có thể chỉnh sửa
  bằng biểu tượng AWS chính thức và ước tính chi phí tham khảo cho Region
  `ap-southeast-1`. Phần tôi đánh giá cao là ứng dụng công khai các giả định và
  yêu cầu còn thiếu, để Solution Architect tiếp tục phản biện thay vì tiếp nhận
  một đáp án đóng.
- **SignalScout** tiếp cận Agentic AI từ góc độ hỗ trợ quyết định. Nền tảng thu
  thập tín hiệu thị trường hoặc tổ chức, so sánh kịch bản và đề xuất hướng hành
  động dựa trên bằng chứng. Kiến trúc dự án đặt lớp AI bên cạnh các thành phần
  định danh, lưu trữ, bảo mật, audit và monitoring, cho thấy một sản phẩm AI vẫn
  phải tuân theo các yêu cầu vận hành như mọi hệ thống production khác.

## Bài học tôi rút ra

Sau khi so sánh bốn phần trình diễn, tôi rút ra bốn bài học:

1. **Thu hẹp phạm vi là một quyết định kỹ thuật.** Một luồng nhỏ nhưng hoàn chỉnh
   từ đầu vào, lập kế hoạch, gọi tool đến kiểm chứng kết quả có giá trị hơn nhiều
   tính năng chưa nối được với nhau.
2. **Agent cần ranh giới rõ ràng.** Mục tiêu, dữ liệu được phép dùng, tool được
   phép gọi và điều kiện cần con người xác nhận phải được quy định cụ thể. Model
   chỉ là một thành phần của hệ thống.
3. **Đo lường là một phần của sản phẩm.** Độ trễ, chi phí cho mỗi giao dịch, tỷ
   lệ thành công, khả năng truy vết và chất lượng quyết định giúp đánh giá giải
   pháp rõ hơn số lượng dịch vụ AWS xuất hiện trong sơ đồ.
4. **Demo tốt phải giải thích được quyết định.** Tôi cần bắt đầu từ vấn đề của
   người dùng, sau đó nêu trách nhiệm của từng thành phần, những giả định đang
   dùng và cách hệ thống phản ứng khi một bước thất bại.

Điều này thay đổi cách tôi nhìn một prototype Agentic AI: ngoài câu trả lời cuối,
tôi phải quan tâm đường đi của dữ liệu, quyền của tool, bằng chứng kiểm chứng,
log vận hành, chi phí và điểm dừng để con người tiếp quản.

## Liên hệ với công việc EduCloud

Các bài học từ sự kiện liên quan trực tiếp đến phạm vi tôi phụ trách trong EduCloud:
đăng ký khóa học, theo dõi tiến độ, tải tệp và kiểm thử API. Tôi chuyển chúng
thành các hành động cụ thể:

1. Hoàn thiện một hành trình có thể truy vết từ `POST
   /api/courses/{id}/enroll`, `GET /api/my-courses`, `POST
   /api/lessons/{id}/complete` đến `GET /api/courses/{id}/progress`, thay vì chỉ
   demo từng endpoint riêng lẻ.
2. Xem upload API là ranh giới bảo mật giữa ứng dụng và Amazon S3: kiểm tra đầu
   vào, xác minh quyền theo khóa học, giữ object ở chế độ private, xử lý rõ
   multipart upload bị gián đoạn và không đặt credential trong repository.
3. Dùng Postman để bao phủ cả happy path lẫn request không hợp lệ, rồi nối kết quả
   quan sát được với log CloudWatch. Mỗi kết luận trong workshop cần có response,
   trạng thái dữ liệu hoặc log làm bằng chứng.
4. Khi trình bày kiến trúc EduCloud, ghi rõ giả định, luồng dữ liệu, ranh giới
   trách nhiệm và chi phí của các dịch vụ thực sự sử dụng. Sơ đồ phải hỗ trợ
   người xem kiểm tra thiết kế, không chỉ đóng vai trò minh họa.

Sau sự kiện, tôi hiểu rằng một phần trình diễn thuyết phục không nằm ở số lượng
tính năng mà ở khả năng chạy ổn định, giải thích được và có bằng chứng cho luồng
cốt lõi. Đây là nguyên tắc tôi áp dụng để giữ workshop EduCloud đúng với phạm vi
công việc được giao.
