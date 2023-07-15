output "public_load_balancer_dns" {
  value = module.load_balancers.public_load_balancer_dns
}

output "public_instance_ips" {
  value = module.ec2_instances.public_instance_ips
}


output "all_ips" {
  value = flatten([
    [for ip in module.ec2_instances.public_instance_ips : "public-ip${index(module.ec2_instances.public_instance_ips, ip)+1} ${ip}"],
    [for ip in module.ec2_instances.private_instance_ips : "private-ip${index(module.ec2_instances.private_instance_ips, ip)+1} ${ip}"]
  ])
}
