resource "aws_s3_bucket" "forgithubaction" {
  bucket = "forgithubaction2122"
  tags = {
    Name = "Prod"
    Customer = "useless"
  }
}