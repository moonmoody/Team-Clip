resource "aws_vpc" "tf_vpc" {
  cidr_block       = var.vpcCidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.pjtName}_vpc"
  }
}

resource "aws_internet_gateway" "tf_gw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "${var.pjtName}_gw"
  }
}