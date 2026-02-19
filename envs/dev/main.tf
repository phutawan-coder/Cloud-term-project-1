provider "aws" {
  profile = "terraform"
  region = var.aws_region 
}

module "network" {
  source = "../../modules/network/"
}

module "iam" {
  source = "../../modules/iam/" 

  s3-bucket-arn = module.s3.s3-bucket
}

module "app" {
  source = "../../modules/app/" 

  subnet_id = module.network.subnet_id
  security_group_id = module.network.security_group_id
  iam_instance_profile = module.iam.iam_instance_profile
}

module "s3" {
  source = "../../modules/s3/"

}
