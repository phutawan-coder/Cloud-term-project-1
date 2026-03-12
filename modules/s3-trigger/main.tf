resource "aws_lambda_permission" "allow-s3" {
  statement_id = "AllowExecutionFromS3"

  action        = "lambda:InvokeFunction"
  function_name = var.lambda-name
  principal     = "s3.amazonaws.com"

  source_arn = var.bucket-arn
}

resource "aws_s3_bucket_notification" "noti" {
  bucket = var.bucket-name

  lambda_function {
    lambda_function_arn = var.lambda-arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "uploads/"
  }

  depends_on = [aws_lambda_permission.allow-s3]
}
