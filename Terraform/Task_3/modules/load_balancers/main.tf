resource "aws_lb" "public_load_balancer" {
  name               = "PublicLoadBalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_security_group_id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_listener" "public_lb_listener" {
  load_balancer_arn = aws_lb.public_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.pub_tg
  }
}

resource "aws_lb" "private_load_balancer" {
  name               = "PrivateLoadBalancer"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.private_security_group_id]
  subnets            = var.private_subnet_ids
}

resource "aws_lb_listener" "private_lb_listener" {
  load_balancer_arn = aws_lb.private_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.pvt_tg
  }
}
