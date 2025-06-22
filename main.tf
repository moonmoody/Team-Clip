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

