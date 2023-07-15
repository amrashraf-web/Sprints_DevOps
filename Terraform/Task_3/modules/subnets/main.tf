resource "aws_subnet" "public_subnet_1" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Public_Subnet_1"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Private_Subnet_1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Public_Subnet_2"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Private_Subnet_2"
  }
}

