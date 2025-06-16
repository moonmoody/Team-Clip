# Web Sg
resource "aws_security_group" "tf_sg_web" {
  name        = "tf_sg_web"
  description = "tf_sg_web"
  vpc_id      = var.vpcId

  tags = {
    Name = "${var.pjtName}_sg_web"
  }
}

resource "aws_vpc_security_group_ingress_rule" "tf_sg_web_ingress" {
  for_each = {
    "icmp" : "-1",
    "http" : "80",
    "https" : "443"
  }
  security_group_id = aws_security_group.tf_sg_web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = each.value
  ip_protocol       = each.key != "icmp" ? "tcp" : each.key   # icmp 이외에는 tcp로 인식시켜야 함.
  to_port           = each.value
}

resource "aws_vpc_security_group_egress_rule" "tf_sg_web_egress" {
  security_group_id = aws_security_group.tf_sg_web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}



# ALB Sg
resource "aws_security_group" "tf_sg_alb" {
  name        = "tf_sg_alb"
  description = "tf_sg_alb"
  vpc_id      = var.vpcId

  tags = {
    Name = "${var.pjtName}_sg_alb"
  }
}

resource "aws_vpc_security_group_ingress_rule" "tf_sg_alb_ingress" {
  for_each = {
    "http" : "80",
    "https" : "443"
  }
  security_group_id = aws_security_group.tf_sg_alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = each.value
  ip_protocol       = "tcp"
  to_port           = each.value
}

resource "aws_vpc_security_group_egress_rule" "tf_sg_alb_egress" {
  security_group_id = aws_security_group.tf_sg_alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}