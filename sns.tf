# KMS Key for SNS Topic Encryption with Automatic Rotation
resource "aws_kms_key" "sns_key" {
  description             = "KMS key for SNS Topic encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

# KMS Key Alias for Management
resource "aws_kms_alias" "sns_key_alias" {
  name          = "alias/sns-cloudtrail-key"
  target_key_id = aws_kms_key.sns_key.id
}

# SNS Topic for CloudTrail with Server-Side Encryption
resource "aws_sns_topic" "cloudtrail_topic" {
  name = "cloudtrail-topic"

  kms_master_key_id = aws_kms_key.sns_key.arn
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

