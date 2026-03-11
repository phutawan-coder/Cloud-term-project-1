resource "aws_lambda_function" "this" {
  function_name = "file-resizer"    

  filename = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  handler = "lambda.lambda_handler"
  runtime = "python3.10"
  architectures = ["arm64"]

  role = var.lambda-iam-role-arn

  layers = [aws_lambda_layer_version.pillow.arn]
}

resource "aws_lambda_layer_version" "pillow" {
  layer_name = "pillow-layer"
  filename = data.archive_file.pillow.output_path
  compatible_runtimes = ["python3.10"]
}

data "archive_file" "zip" {
   type        = "zip"
   source_file = "${path.module}/lambda-file/lambda.py"
   output_path = "${path.module}/lambda.zip"
}

data "archive_file" "pillow" {
  type = "zip"
  source_dir = "${path.module}/layer"
  output_path =  "${path.module}/layer.zip"
}
