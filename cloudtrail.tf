# CloudTrail Configuration
/*
resource "aws_cloudtrail" "cloudtrail" {
  name                          = "management-events-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
  enable_log_file_validation    = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    # Log data events for the CloudTrail bucket itself
    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::${aws_s3_bucket.cloudtrail_bucket.bucket}/"]
    }
  }

  depends_on = [aws_sns_topic_policy.cloudtrail_topic_policy]
}
*/