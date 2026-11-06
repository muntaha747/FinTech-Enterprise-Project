provider "aws" {
  region = "us-east-1"
}

module "instance" {
  source        = "../modules/instance"
  instance_type = "t3.micro"              #We have to also defined the instance type in the root module as well, otherwise it will use the default value from the module.
  ami_id        = "ami-0d97d7f07b25dd693" #We have to also defined the AMI ID in the root module as well, otherwise it will use the default value from the module.
}

module "eip" {
  source      = "../modules/eip"
  instance_id = module.instance.instanceid
}

module "iam_user" {
  source     = "../modules/iam-user"
  user_names = var.iam-user-names
}