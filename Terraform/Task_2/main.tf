# VPC resource
resource "aws_vpc" "sprints_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

# Subnet resource
resource "aws_subnet" "subnets" {
  for_each = var.subnets

  vpc_id          = aws_vpc.sprints_vpc.id
  cidr_block      = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name = each.value.name
  }
}

# Internet Gateway resource
resource "aws_internet_gateway" "sprints_igw" {
  vpc_id = aws_vpc.sprints_vpc.id

  tags = {
    Name = var.igw_name
  }
}

# Elastic IP resource
resource "aws_eip" "sprints_eip" {
  domain = "vpc"
}
# NAT Gateway resource
resource "aws_nat_gateway" "sprints_nat" {
  allocation_id = aws_eip.sprints_eip.id
  subnet_id     = aws_subnet.subnets[var.nat_gateway_subnet].id

  tags = {
    Name = var.nat_gateway_name
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.sprints_vpc.id

  dynamic "route" {
    for_each = [var.route_cidr_block]

    content {
      cidr_block = route.value
      gateway_id = aws_internet_gateway.sprints_igw.id
    }
  }

  tags = {
    Name = var.public_rt_name
  }
}

# Route Table for Private Subnet
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.sprints_vpc.id

  dynamic "route" {
    for_each = [var.route_cidr_block]

    content {
      cidr_block = route.value
      gateway_id = aws_nat_gateway.sprints_nat.id
    }
  }

  tags = {
    Name = var.private_rt_name
  }
}

# Route Table Association for Public Subnet
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.subnets["public"].id
  route_table_id = aws_route_table.public_route_table.id
}

# Route Table Association for Private Subnet
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.subnets["private"].id
  route_table_id = aws_route_table.private_route_table.id
}



# Security Group resource
resource "aws_security_group" "sprints_sg" {
  name        = var.security_group_name
  description = "Security group for instances in Sprints VPC"

  vpc_id = aws_vpc.sprints_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.route_cidr_block]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.route_cidr_block]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.route_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.route_cidr_block]
  }
}
# Search for the Ubuntu AMI ID

data "aws_ami" "ubuntu" {
    most_recent = true
 
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
 
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
 
    filter {
        name   = "architecture"
        values = ["x86_64"]
    }
 
    owners = ["099720109477"]
}

# EC2 instance resource
resource "aws_instance" "instances" {
  for_each = { for instance in var.instances : instance.name => instance }

  subnet_id                  = aws_subnet.subnets[each.value.subnet].id
  vpc_security_group_ids     = [aws_security_group.sprints_sg.id]
  ami                        = data.aws_ami.ubuntu.id
  instance_type              = each.value.instance_type
  associate_public_ip_address = each.value.is_public
  key_name                   = each.value.name_key
  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y ${each.value.package}
    sudo systemctl enable ${each.value.package}
    sudo systemctl start ${each.value.package}
  EOF

  tags = {
    Name = each.value.name
  }

}