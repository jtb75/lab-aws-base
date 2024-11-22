# CloudTrail Configuration
resource "aws_cloudtrail" "cloudtrail" {
  name                          = "management-events-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true

  event_selector {
    read_write_type           = "WriteOnly"
    include_management_events = true

    # Log data events for the CloudTrail bucket itself
    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::${aws_s3_bucket.cloudtrail_bucket.bucket}/"]
    }
  }

  depends_on = [aws_sns_topic_policy.cloudtrail_topic_policy]
}

# SNS Topic for CloudTrail
resource "aws_sns_topic" "cloudtrail_topic" {
  name = "cloudtrail-topic"
}

# Allow CloudTrail to publish to the SNS Topic
resource "aws_sns_topic_policy" "cloudtrail_topic_policy" {
  arn = aws_sns_topic.cloudtrail_topic.arn

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action   = "sns:Publish",
        Resource = aws_sns_topic.cloudtrail_topic.arn,
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

# Fetch Account Information
data "aws_caller_identity" "current" {}