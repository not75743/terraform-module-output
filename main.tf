terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.65.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      env       = "test"
      provision = "terraform"
    }
  }
}

## Network

module "network" {
  source       = "./modules/network"
  cidr_vpc     = "10.10.0.0/16"
  cidr_public1 = "10.10.1.0/24"
  cidr_public2 = "10.10.2.0/24"
  az_public1   = "ap-northeast-1a"
  az_public2   = "ap-northeast-1c"
}

## IAM
module "IAM" {
  source = "./modules/IAM"
}

## EC2
module "ec2" {
  source        = "./modules/ec2"
  vpcid         = module.network.VPCID
  role_name     = module.IAM.iam_role
  ami           = "ami-0d52744d6551d851e"
  instance_type = "t3.micro"
  subnet        = module.network.public1ID
}
