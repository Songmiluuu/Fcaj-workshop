# Báo cáo thực tập EduCloud API — Nguyễn Song Minh Luân

Website báo cáo thực tập song ngữ cho chương trình **First Cloud AI Journey**,
tập trung vào phạm vi cá nhân: Enrollment API, Progress API, Upload API, kiểm thử
Postman và kiểm tra log trên Amazon CloudWatch.

## Nội dung đã có

- Đúng 7 nhóm nội dung trong quy định: Worklog, Proposal, Blogs Posted, Events
  Participated, Workshop, Self-Assessment và Sharing and Feedback.
- 10 tuần worklog bao phủ 05/06/2026–14/08/2026; kết quả kiểm thử được cập nhật
  ngày 30/07/2026.
- Bản tiếng Anh và tiếng Việt cho toàn bộ nội dung chính.
- Postman collection, OpenAPI snapshot và test matrix riêng cho phần API được giao.
- Ba bài blog đã đăng và hai bài thu hoạch sự kiện theo thông tin Luân cung cấp.
- GitHub Actions tự build và deploy GitHub Pages.
- Không chứa `.git`/remote/history của repository tham khảo.

## Trạng thái kiểm chứng

- Bảy test node được chọn liên quan đến enrollment, progress, upload và
  CloudWatch: **7 collected, 7 passed**.
- Backend test suite theo README EduCloud:
  **12 tests passing as of July 31, 2026**, source revision `62d80279500c4e11de31e05fd876d50a370b461e`.
- Full suite được chạy trên EduCloud backend sau khi bổ sung bản sửa concurrent
  enrollment, với source ban đầu ở revision `62d80279500c4e11de31e05fd876d50a370b461e`.
- Postman collection trong báo cáo đã được kiểm tra JSON và chạy manual với các
  case tích cực/tiêu cực theo phạm vi.
- Luồng S3 và CloudWatch đã được kiểm tra trên môi trường EduCloud dùng chung;
  báo cáo không công khai token, định danh tài nguyên hay raw log payload.
- Hugo build với base root/project-pages, audit link nội bộ và smoke test Chromium
  cho search, menu mobile, chuyển ngôn ngữ đều đã pass, không có console error.
- Link demo/source trên website được ghi rõ là artifact dùng chung của nhóm
  EduCloud, không phải toàn bộ đóng góp cá nhân.
- Git history của codebase được cung cấp không tự nhận diện Luân là tác giả;
  worklog là kế hoạch dựng lại và cần PR/task/xác nhận mentor trước khi nộp.

## Chạy local

Cài **Hugo Extended 0.134.3**, sau đó:

```powershell
.\preview.ps1
```

Mở <http://localhost:1313>. Để build bản tĩnh:

```powershell
.\build.ps1
```

Nếu máy chặn script theo PowerShell Execution Policy, dùng:

```powershell
powershell -ExecutionPolicy Bypass -File .\build.ps1
```

Output nằm trong `public/` và đã được `.gitignore` loại khỏi commit.

## Đưa lên GitHub Pages

1. Tạo repository GitHub rỗng, ví dụ `fcaj-internship-report`.
2. Mở terminal tại thư mục này và chạy:

```powershell
git init
git branch -M main
git add .
git commit -m "Add FCAJ internship report"
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
git push -u origin main
```

3. Trong GitHub, mở **Settings → Pages → Source** và chọn **GitHub Actions**.
4. Workflow `.github/workflows/hugo.yaml` sẽ build đúng base URL của repository.

## Cấu trúc

- `content/`: nội dung Markdown song ngữ.
- `static/files/`: Postman, OpenAPI, test matrix và sơ đồ Draw.io.
- `static/images/`: ảnh thẻ, logo và sơ đồ kiến trúc.
- `static/css/theme-workshop.css`: giao diện AWS workshop đã tùy biến.
- `layouts/`: shortcode và accessibility override.
- `themes/hugo-theme-learn/`: theme Hugo được vendor kèm license gốc.

## Lưu ý bảo mật

Không commit JWT, password, database URL, access key, presigned URL, AWS account
ID, Cognito ID, private bucket name hoặc log payload chưa che. Chỉ dùng ảnh minh
chứng do Nguyễn Song Minh Luân tự chụp và đã loại dữ liệu nhạy cảm.

Website public có họ tên, điện thoại, email, lớp và ảnh chân dung theo yêu cầu
báo cáo. Cần xác nhận việc chấp nhận để thông tin này có thể được công cụ tìm kiếm
lập chỉ mục trước khi push repository ở chế độ public.
