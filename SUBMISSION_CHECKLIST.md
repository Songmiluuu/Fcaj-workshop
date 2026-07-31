# Checklist trước khi nộp

Khung kỹ thuật và nội dung có thể đối chiếu từ codebase đã được chuẩn bị. Những
mục còn mở cần dữ liệu thực tế của Nguyễn Song Minh Luân, không dùng dữ liệu từ
bài mẫu.

## Bắt buộc bổ sung/xác nhận

- [ ] Đối chiếu worklog với công việc Luân thực sự làm và bổ sung PR, commit,
      task board hoặc xác nhận mentor; Git history hiện tại không tự nhận diện
      Luân là tác giả các dòng code được dẫn.
- [ ] Xác nhận chấp nhận công khai/index họ tên, số điện thoại, email, lớp và ảnh
      chân dung trên GitHub Pages; nếu không, xóa/che các trường trước khi push.
- [x] Đã chạy `static/files/EduCloud-API-Testing.postman_collection.json` với
      token local hợp lệ và xác nhận các case tích cực/tiêu cực theo phạm vi.
- [x] Đã kiểm tra response enrollment/progress positive và negative; không công
      khai token hoặc dữ liệu người dùng trong báo cáo.
- [x] Đã kiểm tra thumbnail/material/video, trạng thái private và multipart
      complete/abort trên môi trường AWS dùng chung của nhóm.
- [x] Đã đối chiếu request test với application event trong CloudWatch; raw log,
      account, ARN, token và request body không được đưa vào báo cáo public.
- [ ] Bổ sung ít nhất một metric/alarm CloudWatch có ngưỡng, kết quả mong đợi và
      kết quả đo được; hiện báo cáo mới có kế hoạch log.
- [x] Đã xác nhận hai sự kiện thực sự tham dự và hoàn thiện cảm nhận: FCAJ
      Community Day theo hình thức online và FCAJ x Agentic AI Build Week 2026.
- [ ] Bổ sung ảnh/video minh chứng sự kiện do Luân sở hữu nếu hồ sơ bắt buộc phải
      có ảnh; che badge, QR code và dữ liệu cá nhân của người khác.
- [x] Đã thay mục Blogs Posted bằng đúng ba bài kỹ thuật Luân xác nhận đã đăng.
- [ ] Bổ sung URL public và ngày đăng thật của cả ba bài vào
      `content/3-BlogsPosted/`; tài liệu đầu vào hiện không chứa hai thông tin này.
- [ ] Kiểm tra link demo/source của nhóm trong `config.toml` và trang chủ; thay bằng
      repository/URL chính thức nếu nhóm dùng địa chỉ khác.
- [ ] Xin mentor xác nhận lịch worklog 10 tuần từ 05/06 đến 14/08 phù hợp với
      phạm vi và thời gian thực tập.
- [ ] Xác nhận kỳ thực tập 01/06–14/08 có đáp ứng điều kiện
      hành chính hay cần gia hạn/giấy xác nhận riêng.
- [ ] Bổ sung bằng chứng đủ 10 buổi làm việc tại văn phòng nếu hồ sơ xin mộc yêu
      cầu (lịch, check-in hoặc xác nhận mentor đã che dữ liệu nhạy cảm).

## Kiểm tra kỹ thuật cuối

- [x] Chạy 7 test node liên quan trực tiếp đến enrollment, progress, upload và
      CloudWatch trên source hiện tại: 7/7 pass ngày 30/07/2026.
- [x] Chạy full backend suite trong môi trường sạch từ `requirements-dev.txt`
      (`bcrypt==4.0.1`): 28/28 pass ngày 31/07/2026 sau khi thêm regression test
      cho concurrent enrollment.
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
AWS Study Group. Thời gian 01/06–14/08 ngắn hơn 3 tháng, nên cần hỏi lại đơn vị phụ
trách về điều kiện này.
