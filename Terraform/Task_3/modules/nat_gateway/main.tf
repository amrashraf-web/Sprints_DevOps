
resource "aws_eip" "sprints_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "sprints_nat" {
  allocation_id = aws_eip.sprints_eip.id
  subnet_id     = var.public_subnet_id
  tags = {
    Name = "Sprints-NAT"
  }
}

