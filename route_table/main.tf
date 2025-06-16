resource "aws_eip" "tf_eip" {
  domain = "vpc"
  tags = {
    Name = "${var.pjtName}_eip"
  }
}

resource "aws_nat_gateway" "tf_nat_gw" {
  # count = 1
  allocation_id = aws_eip.tf_eip.id
  subnet_id     = var.subId[0]

  tags = {
    Name = "${var.pjtName}_nat_gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  # depends_on = [aws_internet_gateway.example]
}


resource "aws_route_table" "tf_pub_rt12" {
  vpc_id = var.vpcId

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igwId
  }

  tags = {
    Name = "${var.pjtName}_pub_rt12"
  }
}

resource "aws_route_table" "tf_pri_rt34" {
  vpc_id = var.vpcId

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.tf_nat_gw.id
  }

  depends_on = [aws_nat_gateway.tf_nat_gw]

  tags = {
    Name = "${var.pjtName}_pri_rt34"
  }
}


resource "aws_route_table_association" "tf_pub_rt_ass" {
  # for_each = {
  #   for item in var.subId : item => item
  # }
  for_each = {
    "sub1" : var.subId[0],
    "sub2" : var.subId[1]
  }
  # for_each = toset(slice(var.subId, 0, 2))
  subnet_id      = each.value
  route_table_id = aws_route_table.tf_pub_rt12.id
}

resource "aws_route_table_association" "tf_pri_rt_ass" {
  for_each = {
    "sub3" : var.subId[2],
    "sub4" : var.subId[3]
  }
  # for_each = toset(slice(var.subId, 2, 4))
  subnet_id      = each.value
  route_table_id = aws_route_table.tf_pri_rt34.id
}
