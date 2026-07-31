---
title: "Automating Lecture Video Processing with Amazon S3, MediaConvert, and CloudFront"
menuTitle: "Video Pipeline on AWS"
weight: 1
pre: "<b>3.1.</b>"
---

# Automating Lecture Video Processing with Amazon S3, MediaConvert, and CloudFront

## THE CHALLENGE OF BUILDING A VIDEO LEARNING PLATFORM

Videos uploaded by instructors often differ in resolution, codec, and file size.
If the original file is streamed directly, users on weak networks can experience
buffering, while mobile devices may have to download video at a higher quality
than they need.

The system must also address several other challenges:

- Upload files that are several gigabytes in size.
- Convert videos into multiple quality levels.
- Track processing status.
- Distribute video to many viewers.
- Prevent users from accessing files in S3 directly.

A serverless architecture can use Amazon S3, AWS Lambda, AWS Elemental
MediaConvert, Amazon EventBridge, and Amazon CloudFront to automate the complete
workflow.

## ARCHITECTURE OVERVIEW

The processing flow can be designed as follows:

**Instructor → Presigned URL → S3 Source Bucket → EventBridge → Lambda →
MediaConvert → S3 Output Bucket → CloudFront → Learner**

Supporting services include:

- Amazon DynamoDB stores video information and processing status.
- Amazon SNS sends notifications when processing completes or fails.
- Amazon CloudWatch stores logs and metrics and provides alarms.
- Amazon Cognito or the existing sign-in system authenticates viewers.

## UPLOADING VIDEO DIRECTLY TO AMAZON S3

The frontend should not send an entire video through the backend. Doing so
increases server load, makes timeouts more likely, and forces the application to
process a large volume of data unnecessarily.

Instead, the frontend asks the backend to create an S3 presigned URL. The
instructor uses this URL to upload the video directly to S3 without receiving AWS
credentials.

The flow is:

1. The frontend sends the file name and course information to the API.
2. The backend verifies the instructor's permissions.
3. The backend creates a video ID and a short-lived presigned URL.
4. The frontend uses the URL to upload the video directly to S3.

The video can be stored under a structure such as:

    source/course-102/video-847219/original.mp4

Multipart upload should be used for large videos. The file is divided into parts
that can be uploaded in parallel, and only a failed part needs to be sent again
when the network connection is interrupted.

## TRIGGERING THE TRANSCODING PROCESS

After the video upload is complete, S3 sends an Object Created event to
EventBridge or Lambda.

Lambda reads the video's bucket, object key, version ID, and metadata, then
creates a MediaConvert job.

The event should be limited to the source/ prefix, or the source and output
buckets should be separated. If Lambda also watches the location where
MediaConvert writes its results, every new HLS file could trigger another job
and create an event loop.

S3 Event Notifications use at-least-once delivery. The same event can be
delivered more than once, and delivery order is not guaranteed. Lambda must
therefore prevent duplicate processing.

An idempotency key can be created from:

    Bucket + Object Key + Version ID

This value is stored in DynamoDB. If the event is delivered again, Lambda can
detect that the video already has a MediaConvert job and avoid creating a second
one.

## CONVERTING VIDEO TO HLS WITH MEDIACONVERT

AWS Elemental MediaConvert is a file-based video processing service. It reads
the source video, transcodes it, and writes the result to S3.

Instead of configuring every job separately, a MediaConvert Job Template can
define quality levels such as:

- 360p for weak networks and small screens.
- 480p for mobile devices.
- 720p for HD quality.
- 1080p for computers and large displays.

MediaConvert creates an HLS master playlist and multiple renditions with
different bitrates and resolutions. It also divides the video into small
segments.

During playback, the player automatically selects the rendition appropriate for
the current network speed. If the connection becomes weaker, the player can
switch to a lower quality without downloading the entire video again.

MediaConvert can also generate thumbnails, extract audio, process subtitles, and
produce an additional MP4 when the system permits video downloads.

For a library whose videos vary greatly, Automated ABR can be used.
MediaConvert analyzes the input and selects a suitable number of renditions,
avoiding bitrate levels that do not materially improve quality.

However, Automated ABR belongs to a higher-quality processing tier with its own
pricing model. A system that prioritizes predictable cost can start with a fixed
bitrate ladder.

## TRACKING PROCESSING STATUS

MediaConvert sends status-change events to Amazon EventBridge.

Common statuses include:

- **PROGRESSING:** The job is being processed.
- **STATUS_UPDATE:** The current phase and completion percentage are reported
  when available.
- **COMPLETE:** Every output has been written successfully to S3.
- **ERROR:** At least one output has failed.

When COMPLETE is received, Lambda updates the video record in DynamoDB:

    Status: READY
    ManifestPath: output/course-102/video-847219/master.m3u8
    Duration: 00:42:18
    AvailableQualities: 360p, 480p, 720p, 1080p

The application displays the video to learners only after its status changes to
READY.

If MediaConvert returns ERROR, EventBridge sends the error code and message to
Lambda or SNS. The operations team can inspect the input video, unsupported
codec, IAM permissions, or output configuration.

## DISTRIBUTING VIDEO THROUGH CLOUDFRONT

Learners should not access an S3 URL directly. The S3 output bucket remains
private and is used as a CloudFront origin.

CloudFront caches manifests and video segments at edge locations near viewers.
When many learners watch the same lesson, the content can be served from cache
instead of every request returning to S3.

CloudFront Origin Access Control is configured so that only the distribution can
read the output bucket. Users cannot bypass CloudFront and access S3 directly.

Each video version should be stored under a separate path:

    output/video-847219/v1/master.m3u8
    output/video-847219/v2/master.m3u8

When a video is updated, the database is switched to the v2 path instead of
overwriting v1. This reduces the risk that CloudFront continues serving an old
manifest or segment from its cache.

## PROTECTING PAID VIDEO

HLS is not a single file. A video consists of a manifest and many small
segments, so signing each URL separately makes authorization more complicated.

CloudFront signed cookies are suitable when a user needs access to many files
under the same path. After confirming that a learner has purchased or enrolled
in the course, the backend creates short-lived signed cookies.

The playback flow is:

1. The learner signs in.
2. The backend verifies course access.
3. The backend returns signed cookies.
4. The video player requests master.m3u8 and its segments through CloudFront.
5. CloudFront verifies the signature and expiration before returning content.

A CloudFront trusted key group should be used. The private signing key must stay
in the backend or AWS Secrets Manager and must never be placed in the frontend.

Signed cookies control access, but they cannot completely prevent screen
recording or redistribution after content has been downloaded. A platform with
stronger copyright requirements needs additional DRM or per-user watermarking.

## OPTIMIZING COST

The architecture's main cost drivers are:

- The duration and number of outputs processed by MediaConvert.
- Storage for source and transcoded videos in S3.
- Requests and data transfer through CloudFront.

Every additional rendition increases transcoding time, storage, and the number
of output files. Not every video needs 4K or a large number of bitrate levels.

An S3 Lifecycle Policy can transition source videos to a less expensive storage
class after processing. Old output versions can also be deleted automatically
after the rollback period.

CloudFront cache policies should be configured separately for manifests and
segments. Generated segments generally do not change and can have a longer TTL,
while manifest TTL should match the system's version-update strategy.

## IMPLEMENTATION CONSIDERATIONS

- Separate the source and output buckets, or use clear prefixes, to prevent event
  loops.
- Lambda must implement idempotency because S3 events can be delivered more than
  once.
- Keep the MediaConvert job and S3 bucket in the same AWS Region.
- The MediaConvert IAM role should read only the required source bucket and
  write only to the required output bucket.
- Do not make the S3 output bucket public; permit access only through CloudFront
  OAC.
- Keep presigned URLs short-lived and let the backend generate object keys.
- Verify authorization before issuing CloudFront signed cookies.
- Create CloudWatch alarms for MediaConvert ERROR jobs and abnormal processing
  times.
- Do not immediately delete the source video if the system may need to process
  it again with a new configuration.

## REFERENCES

- [Amazon S3 — Uploading objects with presigned URLs](https://docs.aws.amazon.com/AmazonS3/latest/userguide/PresignedUrlUploadObject.html)
- [AWS Elemental MediaConvert — Getting started](https://docs.aws.amazon.com/mediaconvert/latest/ug/getting-started.html)
- [AWS Elemental MediaConvert — Using EventBridge](https://docs.aws.amazon.com/mediaconvert/latest/ug/eventbridge_events.html)
- [AWS Elemental MediaConvert — Automated ABR](https://docs.aws.amazon.com/mediaconvert/latest/ug/auto-abr.html)
- [Amazon CloudFront — Restrict access to an AWS origin](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-origin.html)
- [Amazon CloudFront — Serve private content with signed URLs and signed cookies](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/PrivateContent.html)
