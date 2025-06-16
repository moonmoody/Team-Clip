locals {
  instancId = [
    for item in aws_instance.tf_web : item.id
  ]

  depends_on = [aws_instance.tf_web]
}


resource "aws_instance" "tf_web" {
  for_each = {
    "sub3" : var.subId[2],
    "sub4" : var.subId[3]
  }
  ami                         = "ami-09d15abe3396bfe9e"     # 리전에 따른 ami 들어가게 변경 필요.
  instance_type               = "t2.micro"
  associate_public_ip_address = false
  subnet_id                   = each.value
  vpc_security_group_ids      = [var.sgWebId]
  depends_on                  = [var.natGwId]
  # key_name                    = "tf-key"
  user_data                   = <<-EOT
  #!/bin/bash
  sudo yum install -y httpd
  echo "<h1><font color=blue>Terraform Web Server2</font></h1>" > /var/www/html/index.html
  sudo systemctl start httpd
  EOT
  
  tags = {
    # Name = "${var.pjtName}_web_${substr(each.key, 3, 2)}"
    Name = "${var.pjtName}_web"
  }
}
