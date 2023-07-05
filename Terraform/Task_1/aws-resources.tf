# 1- Create the VPC
resource "aws_vpc" "sprints_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Sprints_VPC"
  }
}


# 2 - Create the Internet Gateway for the VPC

resource "aws_internet_gateway" "sprints_igw" {
  vpc_id = aws_vpc.sprints_vpc.id
  tags = {
    Name = "Sprints_IGW"
  }
}

# 3 - Create a subnet inside the VPC.

resource "aws_subnet" "sprints_subnet" {
  vpc_id                  = aws_vpc.sprints_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Sprints_Subnet"
  }
}

# 4 - Create a route table for the VPC and associate it with the Internet Gateway

resource "aws_route_table" "sprints_route_table" {
  vpc_id = aws_vpc.sprints_vpc.id
}

resource "aws_route" "sprints_route" {
  route_table_id         = aws_route_table.sprints_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.sprints_igw.id
}

resource "aws_route_table_association" "sprints_subnet_association" {
  subnet_id      = aws_subnet.sprints_subnet.id
  route_table_id = aws_route_table.sprints_route_table.id
}

# 5 - Search for the Ubuntu AMI ID

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


# 6 - Create a security group to allow HTTP and HTTPS traffic.

resource "aws_security_group" "sprints_security_group" {
  vpc_id = aws_vpc.sprints_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
            from_port   = 22
            to_port     = 22
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# 7 - Create an EC2 instance connected to the previously created resources

resource "aws_instance" "sprints_ec2_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id     = aws_subnet.sprints_subnet.id
  security_groups  = [aws_security_group.sprints_security_group.id]
  availability_zone = "us-east-1a"
  user_data = "${file("script.sh")}"
  tags = {
      Name = "MyEc2_Sprints"
  }
}


