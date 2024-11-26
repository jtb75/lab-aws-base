module "wiz" {
  source             = "https://s3-us-east-2.amazonaws.com/wizio-public/deployment-v2/aws/wiz-aws-native-terraform-terraform-module.zip"
  external-id        = "b1af0ff4-f15b-46f0-aa77-d928f254babe"
  data-scanning      = true
  lightsail-scanning = true
  eks-scanning       = true
  remote-arn         = "arn:aws:iam::197171649850:role/prod-us20-AssumeRoleDelegator"
}

module "aws_cloud_events" {
  source = "https://downloads.wiz.io/customer-files/aws/wiz-aws-cloud-events-terraform-module.zip"

  cloudtrail_arn        = aws_cloudtrail.cloudtrail.arn
  cloudtrail_bucket_arn = aws_s3_bucket.cloudtrail_bucket.arn
  #cloudtrail_kms_arn    = "<CLOUDTRAIL_KMS_ARN>"

  use_existing_sns_topic       = true
  sns_topic_arn                = aws_sns_topic.cloudtrail_topic.arn
  sns_topic_encryption_enabled = true
  sns_topic_encryption_key_arn = aws_kms_key.sns_key.arn

  wiz_access_role_arn = module.wiz.role_arn
}

output "bucket_name" {
    value = module.aws_cloud_events.bucket_name
}

output "bucket_account" {
    value = module.aws_cloud_events.bucket_account
}
