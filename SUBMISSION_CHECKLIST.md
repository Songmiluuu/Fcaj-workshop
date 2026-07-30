# Checklist trước khi nộp

Khung kỹ thuật và nội dung có thể đối chiếu từ codebase đã được chuẩn bị. Các mục
dưới đây cần dữ liệu thực tế của Nguyễn Song Minh Luân và không thể lấy từ bài mẫu.

## Bắt buộc bổ sung/xác nhận

- [ ] Đối chiếu worklog với công việc Luân thực sự làm và bổ sung PR, commit,
      task board hoặc xác nhận mentor; Git history hiện tại không tự nhận diện
      Luân là tác giả các dòng code được dẫn.
- [ ] Xác nhận chấp nhận công khai/index họ tên, số điện thoại, email, lớp và ảnh
      chân dung trên GitHub Pages; nếu không, xóa/che các trường trước khi push.
- [ ] Chạy `static/files/EduCloud-API-Testing.postman_collection.json` với token
      local hợp lệ; export Runner result sau khi xóa token.
- [ ] Chụp response enrollment/progress positive và negative đã che dữ liệu.
- [ ] Chụp object S3 của thumbnail/material/video, trạng thái private và kết quả
      multipart complete/abort bằng AWS account của Luân.
- [ ] Chụp CloudWatch event khớp timestamp của request test; che account, ARN,
      token, request body và dữ liệu người dùng.
- [ ] Bổ sung ít nhất một metric/alarm CloudWatch có ngưỡng, kết quả mong đợi và
      kết quả đo được; hiện báo cáo mới có kế hoạch log.
- [ ] Bổ sung ngân sách/ước tính từ AWS Pricing Calculator và chi phí thực tế từ
      Cost Explorer (đã che account); hiện chưa có số tiền được Luân xác nhận.
- [x] Đã xác nhận hai sự kiện thực sự tham dự và hoàn thiện cảm nhận: FCAJ
      Community Day theo hình thức online và FCAJ x Agentic AI Build Week 2026.
- [ ] Bổ sung ảnh/video minh chứng sự kiện do Luân sở hữu nếu hồ sơ bắt buộc phải
      có ảnh; che badge, QR code và dữ liệu cá nhân của người khác.
- [x] Đã thay mục Blogs Posted bằng đúng ba bài kỹ thuật Luân xác nhận đã đăng.
- [ ] Bổ sung URL public và ngày đăng thật của cả ba bài vào
      `content/3-BlogsPosted/`; tài liệu đầu vào hiện không chứa hai thông tin này.
- [ ] Kiểm tra link demo/source của nhóm trong `config.toml` và trang chủ; thay bằng
      repository/URL chính thức nếu nhóm dùng địa chỉ khác.
- [ ] Xin mentor xác nhận việc dùng worklog 10 giai đoạn (giai đoạn cuối 13 ngày),
      vì PDF mẫu mô tả Week 1–12.
- [ ] Xác nhận kỳ 01/06–15/08 (76 ngày, ngắn hơn 3 tháng) có đáp ứng điều kiện
      hành chính hay cần gia hạn/giấy xác nhận riêng.
- [ ] Bổ sung bằng chứng đủ 10 buổi làm việc tại văn phòng nếu hồ sơ xin mộc yêu
      cầu (lịch, check-in hoặc xác nhận mentor đã che dữ liệu nhạy cảm).

## Kiểm tra kỹ thuật cuối

- [x] Chạy 7 test node liên quan trực tiếp đến enrollment, progress, upload và
      CloudWatch trên source hiện tại: 7/7 pass ngày 30/07/2026.
- [x] Chạy full backend suite trong môi trường sạch từ `requirements-dev.txt`
      (`bcrypt==4.0.1`): 26/26 pass ngày 30/07/2026.
- [x] Build Hugo Extended 0.134.3 không warning/error với base `/` và base dạng
      GitHub Project Pages; audit link nội bộ không có đích hỏng hoặc link thoát
      project prefix (30/07/2026).
- [x] Mở `/` và `/vi/` bằng headless Chromium ở viewport mobile; search/clear,
      menu, chuyển ngôn ngữ và năm link tải trên trang chủ đều hoạt động, không có
      console/page error (30/07/2026).
- [x] Kiểm tra `YOUR_*` chỉ còn ở lệnh Git mẫu trong README và ví dụ cấu hình
      workshop; không còn placeholder trong phần blog hoặc sự kiện.
- [x] Quét source report không thấy secret, credential file, account/resource ID
      thật hoặc đường dẫn workstation; Postman để trống token/upload ID.
- [ ] Bật GitHub Pages bằng GitHub Actions và mở URL public trên điện thoại.
- [ ] Kiểm tra cleanup/cost; không xóa resource demo dùng chung khi chưa được phép.

## Điều kiện hành chính trong PDF

Nếu cần xác nhận/mộc thực tập, PDF còn nêu các điều kiện: project cá nhân hoàn
thành, báo cáo theo template, tối thiểu 3 tháng, 10 buổi tại văn phòng và 3 blog
AWS Study Group. Thời gian 01/06–15/08 ngắn hơn 3 tháng, nên cần hỏi lại đơn vị phụ
trách về điều kiện này.
