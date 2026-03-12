output "s3-bucket-arn" {
  value = aws_s3_bucket.this.arn
}

output "s3-bucket-name" {
  value = aws_s3_bucket.this.id
}

