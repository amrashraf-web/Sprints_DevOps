resource "aws_lb_target_group" "public_target_group" {
  name     = "Target-Public"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}


resource "aws_lb_target_group" "private_target_group" {
  name     = "Target-Private"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}


