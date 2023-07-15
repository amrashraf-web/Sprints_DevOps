output "public_instance_ips" {
  value = [
    aws_instance.public_instance_1.public_ip,
    aws_instance.public_instance_2.public_ip
  ]
}

output "private_instance_ips" {
  value = [
    aws_instance.private_instance_1.private_ip,
    aws_instance.private_instance_2.private_ip
  ]
}