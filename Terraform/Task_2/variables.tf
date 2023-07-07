variable "region" {
  description = "AWS region"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
}

variable "route_cidr_block" {
  description = "CIDR block for the Route"
}

variable "vpc_name" {
  description = "Name of the VPC"
}

variable "igw_name" {
  description = "Name of the Internet Gateway"
}

variable "nat_gateway_name" {
  description = "Name of the NAT Gateway"
}

variable "public_rt_name" {
  description = "Name of the public route table"
}

variable "private_rt_name" {
  description = "Name of the private route table"
}

variable "security_group_name" {
  description = "Name of the security group"
}

variable "subnets" {
  description = "Configuration for subnets"

  type = map(object({
    cidr_block        = string
    availability_zone = string
    name              = string
  }))
}

variable "nat_gateway_subnet" {
  description = "Subnet index for NAT Gateway"
}

variable "instances" {
  description = "Configuration for instances"

  type = list(object({
    subnet        = string
    instance_type = string
    name          = string
    package       = string
    is_public     = bool
    name_key      = string
  }))
}

