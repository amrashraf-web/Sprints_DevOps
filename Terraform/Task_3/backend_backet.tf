resource "aws_s3_bucket" "my_bucket" {
  bucket = "amr-ashraf-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.my_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "dynamodb" {
  name           = "dynamodb"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    bucket = "amr-ashraf-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "dynamodb"
    encrypt = true
  }
}