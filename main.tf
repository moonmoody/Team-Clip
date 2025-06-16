terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.75.1"
    }
  }
}

provider "aws" {
  region = var.region_name
}

variable "region_name" {}
variable "pjt_name" {}
variable "vpc_cidr_block" {}
variable "subnets" {}
variable "sn_cidr_block" {}
variable "ami" {}


resource "aws_vpc" "tf_vpc" {
  cidr_block = var.vpc_cidr_block

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.pjt_name}_vpc"
  }
}

resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "${var.pjt_name}_igw"
  }
}

//퍼블릭 서브넷 생성
resource "aws_subnet" "tf_sn" {
  for_each          = var.subnets
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = each.key
  availability_zone = each.value
  tags = {
    Name = "${var.pjt_name}_${each.key}_sn"
  }
}


resource "aws_eip" "tf_eip" {
  domain = "vpc"
  tags = {
    Name = "${var.pjt_name}_eip"
  }
}

resource "aws_nat_gateway" "tf_nat_gw" {
  allocation_id = aws_eip.tf_eip.id
  subnet_id     = aws_subnet.tf_sn[var.subnets[0].key].id

  tags = {
    Name = "${var.pjt_name}_nat_gw"
  }
}

// 수정 연습 !!!

// 수정 test 2222 -dck-