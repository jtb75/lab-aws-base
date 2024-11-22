# KMS Key for SNS Topic Encryption with CloudTrail Access
resource "aws_kms_key" "sns_key" {
  description             = "KMS key for SNS Topic encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Allow CloudTrail to use the key
      {
        Sid       = "AllowCloudTrailToUseKey",
        Effect    = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action    = [
          "kms:GenerateDataKey*",
          "kms:Decrypt"
        ],
        Resource  = "*",
        Condition = {
          StringEquals = {
            "kms:ViaService" = "sns.${var.aws_region}.amazonaws.com"
          }
        }
      },
      # Allow the account root user full access
      {
        Sid       = "EnableRootAccountAccess",
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action    = "kms:*",
        Resource  = "*"
      }
    ]
  })
}

resource "aws_kms_alias" "sns_key_alias" {
  name          = "alias/sns-cloudtrail-key"
  target_key_id = aws_kms_key.sns_key.id
}

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
