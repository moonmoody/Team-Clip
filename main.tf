terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.75.1"
    }
  }
}

provider "aws" {
  region = var.region
}


locals {
  multiRegion = {
    "ap-northeast-2" : "172.16.0.0/16",
    "ap-southeast-2" : "172.17.0.0/16"
  }
}

# locals {
#   vpcCidr = [
#     "172.16.0.0/16"
#   ]
# }


variable "pjtName" {
  type        = string
  description = "프로젝트 이름?: "
}

variable "region" {
  type = string
  # default     = "ap-northeast-2"
  description = "사용할 리전?[ap-northeast-2 / ap-southeast-2]: "
}

module "vpc" {
  source  = "./vpc"
  region  = var.region
  pjtName = var.pjtName
  vpcCidr = contains(keys(local.multiRegion), var.region) ? local.multiRegion[var.region] : error("[${var.region}] 은 local.multiRegion에 정의되어 있지 않습니다.")
}

module "subnet" {
  source = "./subnet"
  # region = "ap-northeast-2"
  region  = var.region
  pjtName = var.pjtName
  vpcId   = module.vpc.vpcId
}

module "rt" {
  source = "./route_table"
  # region = "ap-northeast-2"
  region  = var.region
  pjtName = var.pjtName
  vpcId   = module.vpc.vpcId
  igwId   = module.vpc.igwId
  subId   = module.subnet.subId
}

module "sg" {
  source = "./security_group"
  # region = "ap-northeast-2"
  region  = var.region
  pjtName = var.pjtName
  vpcId   = module.vpc.vpcId
}

module "ec2" {
  source = "./instance"
  # region = "ap-northeast-2"
  region  = var.region
  pjtName = var.pjtName
  subId   = module.subnet.subId
  sgWebId = module.sg.sgWebId
  natGwId = module.rt.natGwId
}

module "lb" {
  source = "./load_balancer"
  # region = "ap-northeast-2"
  region     = var.region
  pjtName    = var.pjtName
  subId      = module.subnet.subId
  sgAlbId    = module.sg.sgAlbId
  vpcId      = module.vpc.vpcId
  instanceId = module.ec2.instanceId

}

