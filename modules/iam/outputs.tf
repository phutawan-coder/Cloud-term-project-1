output "iam-instance-profile" {
  value = aws_iam_instance_profile.ip.name
}

output "lambda-role-arn" {
  value = aws_iam_role.lambda_role.arn
}
