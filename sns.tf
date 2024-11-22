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
