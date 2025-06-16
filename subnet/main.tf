locals {
  valCidr = {
    "ap-northeast-2" = {
          "172.16.1.0/24" : "ap-northeast-2a",
          "172.16.2.0/24" : "ap-northeast-2c",
          "172.16.3.0/24" : "ap-northeast-2a",
          "172.16.4.0/24" : "ap-northeast-2c"
      },
      "ap-southeast-2" = {
          "172.17.1.0/24" : "ap-southeast-1a",
          "172.17.2.0/24" : "ap-southeast-1c",
          "172.17.3.0/24" : "ap-southeast-1a",
          "172.17.4.0/24" : "ap-southeast-1c"
      }
  }
}

locals {
  subnetId = [
    for item in aws_subnet.tf_sn : item.id
  ]
  depends_on = [aws_subnet.tf_sn]
}


resource "aws_subnet" "tf_sn" {
  # for_each = {
  #   for cidr, zone in local.valCidr : cidr => zone
  # }
  for_each = {
    for cidr, zone in local.valCidr[var.region] : cidr => zone
  }
  vpc_id     = var.vpcId
  cidr_block = each.key
  availability_zone = each.value

  tags = {
    Name = "${var.pjtName}_sn_${each.key}"
  }
}