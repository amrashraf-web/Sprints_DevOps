output "public_target_group_arn" {
  value = aws_lb_target_group.public_target_group.arn
}

output "private_target_group_arn" {
  value = aws_lb_target_group.private_target_group.arn
}
