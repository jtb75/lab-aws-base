# SNS Topic for CloudTrail
resource "aws_sns_topic" "cloudtrail_topic" {
  name = "cloudtrail-topic"

  kms_master_key_id = aws_kms_key.sns_key.arn
}

# SNS Topic Policy to Allow CloudTrail Publishing
resource "aws_sns_topic_policy" "cloudtrail_topic_policy" {
  arn = aws_sns_topic.cloudtrail_topic.arn

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowCloudTrailPublishing",
        Effect    = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action    = "sns:Publish",
        Resource  = aws_sns_topic.cloudtrail_topic.arn,
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}
