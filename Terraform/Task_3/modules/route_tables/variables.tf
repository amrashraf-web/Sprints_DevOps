
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "internet_gateway_id" {
  description = "Internet Gateway ID"
  type        = string
}

variable "nat_gateway_id" {
  description = "NAT Gateway ID"
  type        = string
}

variable "pub_subnets" {
  description = "Public Subnet IDs"
  type        = list(string)
}

variable "pvt_subnets" {
  description = "Private Subnet IDs"
  type        = list(string)
}
