terraform {
  backend "s3"{
  bucket = "tf-state-124jk123"
  key = "terrraform.tfstate"
  region = "us-east-2"
  }
}