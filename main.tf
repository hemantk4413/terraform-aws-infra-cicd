terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.36.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source      = "./module/vpc"
  vpc_name    = "${var.env}-vpc"
  vpc_cidr    = var.vpc_cidr
  subnet_cidr = var.subnet_cidr
}

module "sg" {
  source  = "./module/sg"
  sg_name = "${var.env}-sg"
  vpc_id  = module.vpc.vpc_id
}

module "ec2_instance" {
  source        = "./module/ec2"
  name          = "${var.env}-server"
  instance_type = var.instance_type
}

module "demo_bucket" {
  source = "./module/s3"
  env    = var.env
}

module "terraform_user" {
  source     = "./module/iam"
  user_name  = var.user_name
  group_name = var.group_name
}
