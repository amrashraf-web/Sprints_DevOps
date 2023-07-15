variable "public_subnet_ids" {
  description = "Public Subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private Subnet IDs"
  type        = list(string)
}

variable "public_security_group_id" {
  description = "Public Security Group ID"
  type        = string
}

variable "private_security_group_id" {
  description = "Private Security Group ID"
  type        = string
}

variable "private_load_balancer_dns" {}
variable "pub_tg_rg" {}
variable "pvt_tg_rg" {}
