resource "aws_s3_bucket" "this" {
  bucket = "my-cloud-term-project-1"

  tags = {
    Name = "tp-my-s3-bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "pab" {
  bucket = aws_s3_bucket.this.id

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}
