output "public_ip" {
  value = [for instance in aws_instance.instances : instance.public_ip]
}

output "private_ip" {
  value = [for instance in aws_instance.instances : instance.private_ip]
}