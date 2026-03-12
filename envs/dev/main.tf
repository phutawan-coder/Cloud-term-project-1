provider "aws" {
  profile = "terraform"
  region  = var.aws_region
}

module "network" {
  source = "../../modules/network/"
}

module "iam" {
  source = "../../modules/iam/"

  s3-bucket-arn = module.s3.s3-bucket-arn
  dynamodb-arn  = module.db.table-arn
}

module "app" {
  source = "../../modules/app/"

  subnet_id            = module.network.subnet_id
  security_group_id    = module.network.security_group_id
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

  lambda-file         = "lambda-file/"
  lambda-iam-role-arn = module.iam.lambda-role-arn
}

module "s3-trigger" {
  source = "../../modules/s3-trigger/"

  bucket-arn  = module.s3.s3-bucket-arn
  bucket-name = module.s3.s3-bucket-name
  lambda-arn  = module.lambda-func.lambda_arn
  lambda-name = module.lambda-func.lambda_name
}

module "alb" {
  source = "../../modules/alb/"

  vpc_id          = module.network.vpc_id
  public_subnet   = module.network.subnet_id
  public_subnet_2 = module.network.subnet_id_2
  alb_sg          = module.network.security_group_id_alb
}

module "auto-scaling" {
  source = "../../modules/auto-scaling/"

  public_subnet   = module.network.subnet_id
  public_subnet_2 = module.network.subnet_id_2
  app_tg          = module.alb.app_tg
  app_lt          = module.ec2-template.app_lt

}

module "ec2-template" {
  source = "../../modules/ec2-template/"

  ec2_sg  = module.network.security_group_id
  profile = module.iam.iam-instance-profile
}
