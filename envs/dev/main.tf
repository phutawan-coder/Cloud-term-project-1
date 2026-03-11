provider "aws" {
  profile = "terraform"
  region = var.aws_region 
}

module "network" {
  source = "../../modules/network/"
}

module "iam" {
  source = "../../modules/iam/" 
  
  s3-bucket-arn = module.s3.s3-bucket-arn
  dynamodb-arn = module.db.table-arn
}

module "app" {
  source = "../../modules/app/" 

  subnet_id = module.network.subnet_id
  security_group_id = module.network.security_group_id
  iam_instance_profile = module.iam.iam-instance-profile
}

module "s3" {
  source = "../../modules/s3/"
}

module "db" {
  source = "../../modules/dynamodb/" 
}

module "lambda-func" {
  source = "../../modules/lambda/"

  lambda-file = "lambda-file/"
  lambda-iam-role-arn = module.iam.lambda-role-arn
}

module "s3-trigger" {
  source = "../../modules/s3-trigger/" 

  bucket-arn = module.s3.s3-bucket-arn
  bucket-name = module.s3.s3-bucket-name
  lambda-arn = module.lambda-func.lambda_arn
  lambda-name = module.lambda-func.lambda_name
}
