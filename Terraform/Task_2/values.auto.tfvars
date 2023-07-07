region = "us-east-1"

vpc_cidr_block = "10.0.0.0/16"
vpc_name = "Sprints"
route_cidr_block = "0.0.0.0/0"
igw_name = "Sprints-IGW"
nat_gateway_name = "Sprints-NAT"
public_rt_name = "Public-RT"
private_rt_name = "Private-RT"
security_group_name = "Security_Sprints"

subnets = {
  "public" = {
    cidr_block        = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    name              = "Public_Sub_Sprints"
  },
  "private" = {
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    name              = "Private_Sub_Sprints"
  }
}

nat_gateway_subnet = "public"

instances = [
  {
    subnet        = "public"
    instance_type = "t2.micro"
    name          = "Public_Instance"
    package       = "nginx"
    is_public     = true
    name_key      = "amora"
  },
  {
    subnet        = "private"
    instance_type = "t2.micro"
    name          = "Private_Instance"
    package       = "apache2"
    is_public     = false
    name_key      = "amora"
  }
]
