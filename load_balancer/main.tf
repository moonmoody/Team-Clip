# Taget Group
resource "aws_lb_target_group" "tf_tg" {
  name     = "tf-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpcId
}

# Target Group attachment
resource "aws_lb_target_group_attachment" "tf_tg_att" {
  for_each = {
    for key, val in var.instanceId : key => val
  }
  target_group_arn = aws_lb_target_group.tf_tg.arn
  target_id        = each.value
  port             = 80

  depends_on = [var.instanceId]
}

# ALB Listener
resource "aws_lb_listener" "tf_alb_lb" {
  load_balancer_arn = aws_lb.tf_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf_tg.arn
  }

  depends_on = [aws_lb_target_group.tf_tg]
}

# Application Load Balancer
resource "aws_lb" "tf_alb" {
  name               = "tf-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sgAlbId]
  subnets = [
    var.subId[0],
    var.subId[1]
  ]

  enable_deletion_protection = false

  depends_on = [aws_lb_target_group.tf_tg]

  tags = {
    Name = "${var.pjtName}_alb"
  }
}



