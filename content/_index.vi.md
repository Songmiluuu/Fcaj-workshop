---
title: "Báo cáo thực tập"
weight: 1
chapter: false
---

<div class="internship-profile">
<h1>BÁO CÁO THỰC TẬP</h1>
<div class="student-information">
<h2>Thông tin sinh viên</h2>
<div class="student-information-lines">
<div class="student-detail-row"><strong>Họ và tên:</strong> Nguyễn Song Minh Luân</div>
<div class="student-detail-row"><strong>Số điện thoại:</strong> <a href="tel:+84976055827">0976 055 827</a></div>
<div class="student-detail-row"><strong>Email:</strong> <a href="mailto:luan.nguyensongminh@hcmut.edu.vn">luan.nguyensongminh@hcmut.edu.vn</a></div>
<div class="student-detail-row"><strong>Trường Đại học:</strong> Trường Đại học Bách khoa – Đại học Quốc gia TP.HCM (HCMUT)</div>
<div class="student-detail-row"><strong>Chuyên ngành:</strong> Khoa học Máy tính</div>
<div class="student-detail-row"><strong>Lớp:</strong> CC23KHM3</div>
<div class="student-detail-row"><strong>Công ty thực tập:</strong> Công ty TNHH Amazon Web Services Việt Nam</div>
<div class="student-detail-row"><strong>Vị trí thực tập:</strong> Thực tập sinh dự án — First Cloud AI Journey</div>
<div class="student-detail-row"><strong>Thời gian thực tập:</strong> 01/06/2026 – 15/08/2026</div>
</div>
</div>

<div class="student-photo" aria-label="Ảnh chân dung Nguyễn Song Minh Luân">
<img src="../images/profile/nguyen-song-minh-luan.jpg" alt="Ảnh chân dung Nguyễn Song Minh Luân" width="512" height="709" onload="this.parentElement.classList.add('has-photo')">
<div class="student-photo-placeholder">
<i class="fas fa-user" aria-hidden="true"></i>
<strong>Ảnh chân dung Nguyễn Song Minh Luân</strong>
</div>
</div>

<div class="contribution-card">
<span class="contribution-eyebrow">PHẠM VI CÁ NHÂN</span>
<h2>API ghi danh, tiến độ, upload và kiểm thử</h2>
<p>Trong project nhóm EduCloud, hướng được phân công là backend API cho phép Student ghi danh khóa học đã publish, xem khóa đã đăng ký, đánh dấu hoàn thành bài học và tính tiến độ; đồng thời cho phép Instructor có quyền upload thumbnail, tài liệu và video. Phạm vi còn gồm kiểm thử API bằng Postman và kiểm tra log trên Amazon CloudWatch.</p>
<div class="endpoint-chips" aria-label="Các API chính trong phạm vi">
<code>POST /api/courses/{id}/enroll</code>
<code>GET /api/my-courses</code>
<code>POST /api/lessons/{id}/complete</code>
<code>GET /api/courses/{id}/progress</code>
<code>POST /api/upload/*</code>
</div>
</div>

<div class="report-contents">
<h2>Nội dung báo cáo</h2>
<ol>
<li><a href="1-worklog/">Worklog</a></li>
<li><a href="2-proposal/">Proposal</a></li>
<li><a href="3-blogsposted/">Blogs Posted</a></li>
<li><a href="4-eventparticipated/">Events Participated</a></li>
<li><a href="5-workshop/">Workshop</a></li>
<li><a href="6-self-evaluation/">Self-Assessment</a></li>
<li><a href="7-feedback/">Sharing and Feedback</a></li>
</ol>
</div>

<div class="project-demo-access">
<h2>Project và tài liệu đính kèm</h2>
<ul>
<li><strong>Demo của nhóm:</strong> <a href="https://main.djk00b5qbck73.amplifyapp.com/courses" target="_blank" rel="noopener noreferrer">Mở EduCloud Lite</a></li>
<li><strong>Mã nguồn của nhóm:</strong> <a href="https://github.com/Funacius/EduCloud" target="_blank" rel="noopener noreferrer">Funacius/EduCloud</a></li>
<li><strong>Postman collection theo phạm vi:</strong> <a href="../files/EduCloud-API-Testing.postman_collection.json" download>Tải JSON</a></li>
<li><strong>OpenAPI tham khảo:</strong> <a href="../files/educloud-openapi.yaml" download>Tải YAML</a></li>
<li><strong>Ma trận kiểm thử API:</strong> <a href="../files/api-test-matrix.md" download>Tải Markdown</a></li>
<li><strong>Kết quả pytest theo phạm vi:</strong> <a href="../files/targeted-pytest-result.txt" download>7/7 test node pass</a></li>
<li><strong>Kết quả full pytest:</strong> <a href="../files/full-pytest-result.txt" download>28/28 pass</a></li>
</ul>
<p>Website demo và repository là sản phẩm chung của nhóm. Báo cáo trình bày phần API và kiểm thử được giao.</p>
</div>
</div>
