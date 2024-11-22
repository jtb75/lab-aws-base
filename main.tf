resource "aws_s3_bucket" "forgithubaction" {
  bucket = "forghaction123fa"
  tags = {
    Name = "Prod"
    Customer = "useless"
  }
}
