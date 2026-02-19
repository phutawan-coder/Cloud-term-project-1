resource "aws_iam_policy" "s3-policy" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
    {
      Effect = "Allow"
      Action = [ "s3:ListBucket" ]
      Resource = [ var.s3-bucket-arn ]
    }]
  })
}

resource "aws_iam_role" "s3-role" {
  name = "s3-role"
  assume_role_policy  = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole" 
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_instance_profile" "ip" {
  role = aws_iam_role.s3-role.name 
}

resource "aws_iam_role_policy_attachment" "pa" {
  role = aws_iam_role.s3-role.name
  policy_arn = aws_iam_policy.s3-policy.arn
}

