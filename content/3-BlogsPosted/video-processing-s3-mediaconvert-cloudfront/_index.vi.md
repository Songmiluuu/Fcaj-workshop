---
title: "TỰ ĐỘNG XỬ LÝ VIDEO BÀI GIẢNG VỚI AMAZON S3, MEDIACONVERT VÀ CLOUDFRONT"
menuTitle: "Xử lý video trên AWS"
weight: 1
pre: "<b>3.1.</b>"
---

# TỰ ĐỘNG XỬ LÝ VIDEO BÀI GIẢNG VỚI AMAZON S3, MEDIACONVERT VÀ CLOUDFRONT

**Trạng thái xuất bản:** Đã đăng.

## BÀI TOÁN KHI XÂY DỰNG NỀN TẢNG HỌC VIDEO

Video do giảng viên tải lên thường có độ phân giải, codec và dung lượng khác
nhau. Nếu phát trực tiếp tệp gốc, người dùng có mạng yếu dễ gặp tình trạng đứng
hình, trong khi thiết bị di động phải tải một video có chất lượng cao hơn mức
cần thiết.

Hệ thống cũng phải giải quyết nhiều vấn đề khác như:

- Tải lên những tệp có dung lượng vài GB.
- Chuyển video thành nhiều mức chất lượng.
- Theo dõi trạng thái xử lý.
- Phân phối video cho nhiều người xem.
- Ngăn người dùng truy cập trực tiếp vào tệp trong S3.

Một kiến trúc serverless có thể sử dụng Amazon S3, AWS Lambda, AWS Elemental
MediaConvert, Amazon EventBridge và Amazon CloudFront để tự động hóa toàn bộ quy
trình.

## KIẾN TRÚC TỔNG QUAN

Luồng xử lý có thể được thiết kế như sau:

**Giảng viên → Presigned URL → S3 Source Bucket → EventBridge → Lambda →
MediaConvert → S3 Output Bucket → CloudFront → Học viên**

Các dịch vụ hỗ trợ:

- Amazon DynamoDB lưu thông tin video và trạng thái xử lý.
- Amazon SNS gửi thông báo khi video hoàn tất hoặc gặp lỗi.
- Amazon CloudWatch lưu log, metric và cảnh báo.
- Amazon Cognito hoặc hệ thống đăng nhập hiện có xác thực người xem.

## TẢI VIDEO TRỰC TIẾP LÊN AMAZON S3

Frontend không nên gửi toàn bộ video qua backend. Cách này làm tăng tải cho
server, dễ gặp timeout và buộc ứng dụng phải xử lý một lượng dữ liệu lớn không
cần thiết.

Thay vào đó, frontend yêu cầu backend tạo một S3 presigned URL. Giảng viên sử
dụng URL này để tải video trực tiếp lên S3 mà không cần được cấp AWS credential.

Luồng xử lý:

1. Frontend gửi tên tệp và thông tin khóa học đến API.
2. Backend kiểm tra quyền của giảng viên.
3. Backend tạo video ID và presigned URL có thời hạn ngắn.
4. Frontend dùng URL để tải video trực tiếp lên S3.

Video được lưu theo cấu trúc:

    source/course-102/video-847219/original.mp4

Đối với video lớn, nên sử dụng multipart upload. Tệp được chia thành nhiều phần
để tải song song và chỉ cần gửi lại phần bị lỗi nếu kết nối mạng gián đoạn.

## KÍCH HOẠT QUÁ TRÌNH TRANSCODING

Sau khi video được tải lên hoàn chỉnh, S3 gửi sự kiện Object Created đến
EventBridge hoặc Lambda.

Lambda đọc bucket, object key, version ID và metadata của video, sau đó tạo một
MediaConvert job.

Nên giới hạn sự kiện theo prefix source/ hoặc sử dụng riêng source bucket và
output bucket. Nếu Lambda cũng theo dõi nơi MediaConvert ghi kết quả, mỗi tệp HLS
mới có thể tiếp tục kích hoạt thêm job và tạo thành vòng lặp.

S3 Event Notifications hoạt động theo cơ chế at-least-once. Cùng một sự kiện có
thể được gửi nhiều lần và thứ tự nhận không được bảo đảm. Vì vậy, Lambda cần
chống xử lý trùng.

Một idempotency key có thể được tạo từ:

    Bucket + Object Key + Version ID

Giá trị này được lưu trong DynamoDB. Nếu sự kiện được gửi lại, Lambda phát hiện
video đã có MediaConvert job và không tạo thêm job thứ hai.

## CHUYỂN VIDEO THÀNH HLS VỚI MEDIACONVERT

AWS Elemental MediaConvert là dịch vụ xử lý video theo mô hình file-based. Dịch
vụ đọc video nguồn, chuyển mã và ghi kết quả vào S3.

Thay vì cấu hình lại từng job, có thể tạo một MediaConvert Job Template gồm các
mức chất lượng như:

- 360p cho mạng yếu và màn hình nhỏ.
- 480p cho thiết bị di động.
- 720p cho chất lượng HD.
- 1080p cho máy tính và màn hình lớn.

MediaConvert tạo một HLS master playlist cùng nhiều rendition có bitrate và độ
phân giải khác nhau. Video cũng được chia thành các segment nhỏ.

Khi phát, video player tự chọn rendition phù hợp với tốc độ mạng. Nếu kết nối
yếu đi, player chuyển xuống chất lượng thấp hơn mà không phải tải lại toàn bộ
video.

MediaConvert còn có thể tạo thumbnail, trích xuất audio, xử lý phụ đề và xuất
thêm MP4 nếu hệ thống cho phép tải video về.

Với thư viện video có nội dung rất khác nhau, có thể sử dụng Automated ABR.
MediaConvert phân tích đầu vào và tự chọn số lượng rendition phù hợp, tránh tạo
thêm mức bitrate không cải thiện đáng kể chất lượng.

Tuy nhiên, Automated ABR thuộc nhóm tính năng xử lý chất lượng cao hơn và có cách
tính phí riêng. Hệ thống cần ưu tiên chi phí ổn định có thể bắt đầu bằng một
bitrate ladder cố định.

## THEO DÕI TRẠNG THÁI XỬ LÝ

MediaConvert gửi sự kiện thay đổi trạng thái đến Amazon EventBridge.

Các trạng thái thường gặp gồm:

- **PROGRESSING:** Job đang xử lý.
- **STATUS_UPDATE:** Cập nhật giai đoạn và phần trăm hoàn thành khi có dữ liệu.
- **COMPLETE:** Tất cả output đã được ghi thành công vào S3.
- **ERROR:** Ít nhất một output gặp lỗi.

Khi nhận COMPLETE, Lambda cập nhật bản ghi video trong DynamoDB:

    Status: READY
    ManifestPath: output/course-102/video-847219/master.m3u8
    Duration: 00:42:18
    AvailableQualities: 360p, 480p, 720p, 1080p

Ứng dụng chỉ hiển thị video cho học viên sau khi trạng thái chuyển sang READY.

Nếu MediaConvert trả về ERROR, EventBridge gửi thông tin error code và message
đến Lambda hoặc SNS. Đội vận hành có thể kiểm tra video đầu vào, codec không được
hỗ trợ, quyền IAM hoặc cấu hình output.

## PHÂN PHỐI VIDEO QUA CLOUDFRONT

Không nên để học viên truy cập trực tiếp S3 URL. S3 Output Bucket được giữ ở chế
độ private và sử dụng làm origin cho CloudFront.

CloudFront lưu các manifest và video segment tại edge location gần người xem.
Khi nhiều học viên xem cùng một bài giảng, nội dung có thể được phục vụ từ cache
thay vì tất cả request đều quay lại S3.

CloudFront Origin Access Control được cấu hình để chỉ distribution được phép đọc
output bucket. Người dùng không thể bỏ qua CloudFront và truy cập trực tiếp vào
S3.

Nên lưu mỗi phiên bản video trong một đường dẫn riêng:

    output/video-847219/v1/master.m3u8
    output/video-847219/v2/master.m3u8

Khi video được cập nhật, hệ thống chuyển database sang đường dẫn v2 thay vì ghi
đè lên v1. Cách này hạn chế trường hợp CloudFront vẫn giữ manifest hoặc segment
cũ trong cache.

## BẢO VỆ VIDEO TRẢ PHÍ

HLS không chỉ có một tệp. Một video gồm manifest và nhiều segment nhỏ, vì vậy
việc ký riêng từng URL sẽ làm quá trình cấp quyền phức tạp hơn.

CloudFront Signed Cookies phù hợp khi người dùng cần truy cập nhiều tệp thuộc
cùng một đường dẫn. Sau khi kiểm tra học viên đã mua hoặc được ghi danh vào khóa
học, backend tạo signed cookies có thời hạn ngắn.

Luồng phát video:

1. Học viên đăng nhập.
2. Backend kiểm tra quyền truy cập khóa học.
3. Backend trả signed cookies.
4. Video player yêu cầu master.m3u8 và các segment qua CloudFront.
5. CloudFront kiểm tra chữ ký và thời hạn trước khi trả nội dung.

Nên sử dụng CloudFront trusted key group. Private key dùng để ký phải nằm trong
backend hoặc AWS Secrets Manager, không được đưa vào frontend.

Signed cookies giúp kiểm soát quyền truy cập nhưng không ngăn tuyệt đối việc quay
màn hình hoặc chia sẻ nội dung sau khi đã tải xuống. Nếu nền tảng có yêu cầu bảo
vệ bản quyền cao hơn, cần bổ sung DRM hoặc watermark theo người dùng.

## TỐI ƯU CHI PHÍ

Chi phí chính của kiến trúc gồm:

- Thời lượng và số lượng output được MediaConvert xử lý.
- Dung lượng lưu trữ video nguồn và video đã chuyển mã trên S3.
- Request và data transfer qua CloudFront.

Mỗi rendition bổ sung làm tăng thời gian transcoding, dung lượng lưu trữ và số
tệp đầu ra. Không phải video nào cũng cần 4K hoặc quá nhiều mức bitrate.

S3 Lifecycle Policy có thể chuyển video nguồn sang lớp lưu trữ rẻ hơn sau khi xử
lý hoàn tất. Các phiên bản output cũ cũng có thể được tự động xóa sau thời gian
rollback.

CloudFront cache policy nên được cấu hình riêng cho manifest và segment. Các
segment đã được tạo thường không thay đổi nên có thể đặt TTL dài hơn, còn
manifest cần TTL phù hợp với cách hệ thống cập nhật phiên bản.

## MỘT SỐ LƯU Ý KHI TRIỂN KHAI

- Source bucket và output bucket nên được tách riêng hoặc sử dụng prefix rõ ràng
  để tránh kích hoạt vòng lặp.
- Lambda phải xử lý idempotency vì sự kiện S3 có thể bị gửi trùng.
- MediaConvert job và S3 bucket nên đặt trong cùng AWS Region.
- IAM role của MediaConvert chỉ nên được đọc source bucket và ghi vào output
  bucket cần thiết.
- Không công khai S3 Output Bucket; chỉ cho phép truy cập thông qua CloudFront
  OAC.
- Presigned URL cần có thời hạn ngắn và object key phải do backend tạo.
- Backend phải kiểm tra quyền trước khi cấp CloudFront signed cookies.
- Cần đặt CloudWatch Alarm cho số MediaConvert job ERROR và thời gian xử lý tăng
  bất thường.
- Không xóa video nguồn ngay sau khi transcode nếu hệ thống vẫn cần khả năng xử
  lý lại bằng cấu hình mới.

## TÀI LIỆU THAM KHẢO

- [Amazon S3 — Uploading objects with presigned URLs](https://docs.aws.amazon.com/AmazonS3/latest/userguide/PresignedUrlUploadObject.html)
- [AWS Elemental MediaConvert — Getting started](https://docs.aws.amazon.com/mediaconvert/latest/ug/getting-started.html)
- [AWS Elemental MediaConvert — Using EventBridge](https://docs.aws.amazon.com/mediaconvert/latest/ug/eventbridge_events.html)
- [AWS Elemental MediaConvert — Automated ABR](https://docs.aws.amazon.com/mediaconvert/latest/ug/auto-abr.html)
- [Amazon CloudFront — Restrict access to an AWS origin](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-origin.html)
- [Amazon CloudFront — Serve private content with signed URLs and signed cookies](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/PrivateContent.html)
